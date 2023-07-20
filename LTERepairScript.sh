#!/bin/sh

# Step 1
modemstatus --verbose
if [ $? -ne 0 ]; then
    # Step 2
    ping -I lte0 8.8.8.8 -c 3
    if [ $? -ne 0 ]; then
        # Step 3, 4 and 5
        lsusb
        modemreboot
        modemreconnect

        # Step 6
        ping -I lte0 8.8.8.8 -c 3
        if [ $? -ne 0 ]; then
            # Step 7
            model=$(cat /etc/datto/model)
            if [ "$model" = "VZ5" ] || [ "$model" = "VZ6" ]; then
                sequans-gpio-reset
            fi

            # Step 8
            modemreconnect

            # Step 9
            ping -I lte0 8.8.8.8 -c 3
            if [ $? -ne 0 ]; then
                # Step 10
                /etc/init.d/dna-modemmanager stop

                # Step 11
                pymm &
                sleep 60
                kill $!

                # Step 12
                /etc/init.d/dna-modemmanager start

                # Step 13
                ping -I lte0 8.8.8.8 -c 3
                if [ $? -ne 0 ]; then
                    echo "Ping failed"
                else
                    echo "Ping succeeded"
                fi
            fi
        fi
    fi
fi

