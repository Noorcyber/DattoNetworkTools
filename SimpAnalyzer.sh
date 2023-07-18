#!/bin/sh

# Specify the MAC address patterns to match (first 6 characters) and their corresponding names
MAC_PATTERN1="f8:d9:b8"
MAC_PATTERN2="ac:86:74"
MAC_NAME1="Datto Devices"
MAC_NAME2="Vendor 2 Devices"

# Specify the MAC address patterns for Tuya Devices
TUYA_MAC_PATTERN1="10:5a:17"
TUYA_MAC_PATTERN2="10:d5:61"
TUYA_MAC_PATTERN3="18:69:d8"
TUYA_MAC_PATTERN4="1c:90:ff"
TUYA_MAC_PATTERN5="38:1f:8d"
TUYA_MAC_PATTERN6="50:8a:06"
TUYA_MAC_PATTERN7="68:57:2d"
TUYA_MAC_PATTERN8="70:89:76"
TUYA_MAC_PATTERN9="7c:f6:66"
TUYA_MAC_PATTERN10="84:e3:42"
TUYA_MAC_PATTERN11="a0:92:08"
TUYA_MAC_PATTERN12="cc:8c:bf"
TUYA_MAC_PATTERN13="d4:a6:51"
TUYA_MAC_PATTERN14="d8:1f:12"
TUYA_MAC_PATTERN15="fc:67:1f"
TUYA_MAC_NAME="Tuya Devices"

# Retrieve the ARP table
ARP_TABLE=$(cat /proc/net/arp)

# Print the custom column headers
printf "----------------------Simp Tool V1------------------------\n"
printf "%-15s %-17s %-12s %-15s\n" "IP Address" "HW Address" "Link" "Vendor"
printf "---------------------------------------------------------\n"

# Iterate over each line in the ARP table
echo "$ARP_TABLE" | while read -r line
do
  IP_ADDRESS=$(echo "$line" | awk '{print $1}')
  MAC_ADDRESS=$(echo "$line" | awk '{print $4}')
  DEVICE=$(echo "$line" | awk '{print $6}')
  
  # Extract the first 6 characters of the MAC address
  MAC_PREFIX=$(echo "$MAC_ADDRESS" | cut -d ":" -f 1-3)
  
  # Check if the MAC address matches the specified patterns
  MATCHED="N/A"
  VENDOR_NAME="Unknown"
  
  if [ "$MAC_PREFIX" = "$MAC_PATTERN1" ] || [ "$MAC_PREFIX" = "$MAC_PATTERN2" ]; then
    MATCHED="Matched"
    VENDOR_NAME="$MAC_NAME1"
  fi
  
  if [ "$MAC_PREFIX" = "$TUYA_MAC_PATTERN1" ] || [ "$MAC_PREFIX" = "$TUYA_MAC_PATTERN2" ] || \
     [ "$MAC_PREFIX" = "$TUYA_MAC_PATTERN3" ] || [ "$MAC_PREFIX" = "$TUYA_MAC_PATTERN4" ] || \
     [ "$MAC_PREFIX" = "$TUYA_MAC_PATTERN5" ] || [ "$MAC_PREFIX" = "$TUYA_MAC_PATTERN6" ] || \
     [ "$MAC_PREFIX" = "$TUYA_MAC_PATTERN7" ] || [ "$MAC_PREFIX" = "$TUYA_MAC_PATTERN8" ] || \
     [ "$MAC_PREFIX" = "$TUYA_MAC_PATTERN9" ] || [ "$MAC_PREFIX" = "$TUYA_MAC_PATTERN10" ] || \
     [ "$MAC_PREFIX" = "$TUYA_MAC_PATTERN11" ] || [ "$MAC_PREFIX" = "$TUYA_MAC_PATTERN12" ] || \
     [ "$MAC_PREFIX" = "$TUYA_MAC_PATTERN13" ] || [ "$MAC_PREFIX" = "$TUYA_MAC_PATTERN14" ] || \
     [ "$MAC_PREFIX" = "$TUYA_MAC_PATTERN15" ]; then
    MATCHED="Matched"
    VENDOR_NAME="$TUYA_MAC_NAME"
  fi
  
  # Output the custom formatted information for matched MAC address prefixes
  printf "%-15s %-17s %-12s %-15s\n" "$IP_ADDRESS" "$MAC_ADDRESS" "$DEVICE" "$VENDOR_NAME"
done
