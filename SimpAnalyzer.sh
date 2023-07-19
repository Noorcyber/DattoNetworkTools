#!/bin/sh

# Define the MAC-to-vendor mapping
declare -A MAC_VENDORS=(
  ["10:5a:17"]="Tuya Devices"
  ["10:d5:61"]="Tuya Devices"
  ["18:69:d8"]="Tuya Devices"
  ["1c:90:ff"]="Tuya Devices"
  ["38:1f:8d"]="Tuya Devices"
  ["50:8a:06"]="Tuya Devices"
  ["68:57:2d"]="Tuya Devices"
  ["70:89:76"]="Tuya Devices"
  ["7c:f6:66"]="Tuya Devices"
  ["84:e3:42"]="Tuya Devices"
  ["a0:92:08"]="Tuya Devices"
  ["cc:8c:bf"]="Tuya Devices"
  ["d4:a6:51"]="Tuya Devices"
  ["d8:1f:12"]="Tuya Devices"
  ["fc:67:1f"]="Tuya Devices"
  ["f8:d9:b8"]="Datto Devices"
  ["ac:86:74"]="Datto Devices"
)

# Retrieve the ARP table
ARP_TABLE=$(cat /proc/net/arp)

# Print the custom column headers
printf "----------------------Simp Tool V1.3------------------------\n"
printf "%-15s %-17s %-12s %-15s\n" "IP Address" "HW Address" "Link" "Vendor"
printf "---------------------------------------------------------\n"

# Function to lookup the vendor name based on MAC address
get_vendor_name() {
  local mac_address="$1"
  local vendor_name=${MAC_VENDORS[$mac_address]}
  if [ -z "$vendor_name" ]; then
    vendor_name="Unknown"
  fi
  echo "$vendor_name"
}

# Iterate over each line in the ARP table
echo "$ARP_TABLE" | while read -r line
do
  IP_ADDRESS=$(echo "$line" | awk '{print $1}')
  MAC_ADDRESS=$(echo "$line" | awk '{print $4}')
  DEVICE=$(echo "$line" | awk '{print $6}')

  # Get the vendor name based on MAC address
  VENDOR_NAME=$(get_vendor_name "$MAC_ADDRESS")

  # Output the custom formatted information
  printf "%-15s %-17s %-12s %-15s\n" "$IP_ADDRESS" "$MAC_ADDRESS" "$DEVICE" "$VENDOR_NAME"
done
