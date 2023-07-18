#!/bin/sh

# Specify the URL of the MAC-to-vendor JSON file
MAC_VENDOR_URL="https://raw.githubusercontent.com/DattoCorn/DattoNetworkTools/main/VendorList.json"

# Retrieve the MAC-to-vendor JSON file
MAC_VENDOR_FILE=$(curl -s "$MAC_VENDOR_URL")

# Print the custom column headers
printf "----------------------Simp Tool V1------------------------\n"
printf "%-15s %-17s %-12s %-15s\n" "IP Address" "HW Address" "Link" "Vendor"
printf "---------------------------------------------------------\n"

# Function to lookup the vendor name based on MAC address
get_vendor_name() {
  local mac_address="$1"
  local vendor_name="Unknown"

  # Lookup the vendor in the MAC-to-vendor JSON file
  if [ -n "$MAC_VENDOR_FILE" ]; then
    vendor_name=$(echo "$MAC_VENDOR_FILE" | jq -r ".[\"$mac_address\"]")
    if [ "$vendor_name" = "null" ]; then
      vendor_name="Unknown"
    fi
  fi

  echo "$vendor_name"
}

# Retrieve the ARP table
ARP_TABLE=$(cat /proc/net/arp)

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
