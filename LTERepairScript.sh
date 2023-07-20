#!/bin/sh

# Function to echo and then run a command
run_cmd() {
    echo "Running: $1"
    eval $1
    local status=$?
    if [ $status -eq 0 ]; then
        echo "$1 - Success"
    else
        echo "$1 - Failed"
    fi
    echo "----------------------------------------------------"
    return $status
}

# Step 1
run_cmd "modemstatus --verbose"

# Step 2
run_cmd "ping -I lte0 8.8.8.8 -c 3"

if [ $? -ne 0 ]; then
    # Steps 3, 4, and 5
    run_cmd "lsusb"
    run_cmd "modemreboot"
    run_cmd "modemreconnect"

    # Step 6
    run_cmd "ping -I lte0 8.8.8.8 -c 3"

    if [ $? -ne 0 ]; then
        # Step 7
        model=$(cat /etc/datto/model)
        if [ "$model" = "VZ5" ] || [ "$model" = "VZ6" ]; then
            run_cmd "sequans-gpio-reset"
        fi

        # Step 8
        run_cmd "modemreconnect"

        # Step 9
        run_cmd "ping -I lte0 8.8.8.8 -c 3"

        if [ $? -ne 0 ]; then
            # Step 10
            run_cmd "/etc/init.d/dna-modemmanager stop"

            # Step 11
            echo "Running: pymm"
            pymm &
            sleep 60
            kill $!
            echo "pymm - Completed"
            echo "----------------------------------------------------"

            # Step 12
            run_cmd "/etc/init.d/dna-modemmanager start"

            # Step 13
            run_cmd "ping -I lte0 8.8.8.8 -c 3"
        fi
    fi
fi
