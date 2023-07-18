#!/bin/sh

# Specify the MAC address patterns to match (first 6 characters) and their corresponding names
MAC_PATTERN1="f8:d9:b8"
MAC_NAME1="Datto Devices"

# Retrieve the ARP table
ARP_TABLE=$(cat /proc/net/arp)

# Print the custom column headers
printf "%-15s %-17s %-12s %-15s\n" "IP Address" "HW Address" "Device" "MAC Name"
printf "---------------------------------------------------------\n"

# Iterate over each line in the ARP table
echo "$ARP_TABLE" | while read -r line
do
  IP_ADDRESS=$(echo "$line" | awk '{print $1}')
  MAC_ADDRESS=$(echo "$line" | awk '{print $4}')
  DEVICE=$(echo "$line" | awk '{print $6}')
  
  # Extract the first 6 characters of the MAC address
  MAC_PREFIX=$(echo "$MAC_ADDRESS" | cut -d ":" -f 1-3)
  
  # Check if the MAC address prefix matches the pattern
  MATCHED="N/A"
  MAC_NAME="Tuya Devices"
  if [ "$MAC_PREFIX" = "$MAC_PATTERN1" ]; then
    MATCHED="Matched"
    MAC_NAME="$MAC_NAME1"
  fi
  
  # Output the custom formatted information for matched MAC address prefixes
  if [ "$MATCHED" = "Matched" ]; then
    printf "%-15s %-17s %-12s %-15s\n" "$IP_ADDRESS" "$MAC_ADDRESS" "$DEVICE" "$MAC_NAME"
  else
    printf "%-15s %-17s %-12s %-15s\n" "$IP_ADDRESS" "$MAC_ADDRESS" "$DEVICE" "$MAC_NAME"
  fi
done
