#!/bin/bash
#===============================================================================
#
#          FILE: RenewDHCP_On_WiFi_Network.sh
# 
#         USAGE: ./postinstall.sh 
# 
#   DESCRIPTION: Renew DHCP on your Wi-FI Network 
# 
#       OPTIONS: Add this script to offline scripts to renew DHCP in case Wi-Fi doesn't resolves the IP Address.
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Kavan (K1) Joshi, kavan.joshi@jamf.com
#  ORGANIZATION: Jamf
#       CREATED: 09/18/2022 15:53
#      REVISION: (1) 09/28/2022 11:50
#===============================================================================

# set -o nounset                              # Treat unset variables as an error


wifiStatus=$(networksetup -getairportpower $(system_profiler SPAirPortDataType | awk -F: '/Interfaces:/{getline; print $1;}') | awk '{ print $NF }' )
wifiHardware=$( system_profiler SPAirPortDataType | awk -F: '/Interfaces:/{getline; print $1;}' | xargs )

if [ "$wifiStatus" == "Off" ]; then
    ipconfig set $wifiHardware DHCP 
else
    exit 0;
fi
