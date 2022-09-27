#!/bin/bash
#===============================================================================
#
#          FILE: Set_SSID_Priority.sh
# 
#         USAGE: ./postinstall.sh 
# 
#   DESCRIPTION: Sets your desired Wi-Fi on Priority every time the system restarts. 
# 
#       OPTIONS: Modify the orgName, ssidName, wifiProtocol and index to complete your workflow
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Kavan (K1) Joshi, kavan.joshi@jamf.com
#  ORGANIZATION: Jamf
#       CREATED: 09/18/2022 15:53
#      REVISION: (1) 09/28/2022 09:06 
#===============================================================================

# set -o nounset                              # Treat unset variables as an error


orgName="<Your Organization Name will go here>"
ssidName="<Your SSID Name will go here>"
wifiProtocol="<Your Wi-Fi Protocol will go here>" 
index="<Your preferred list index>" # Starts from 0, that means for top priority use index as 0.  


cat << "EOF" > /Library/Scripts/"$orgName"_SSIDPref.sh
#!/bin/bash

wifiHardware=$( system_profiler SPAirPortDataType | awk -F: '/Interfaces:/{getline; print $1;}' | xargs )
networksetup -removepreferredwirelessnetwork $wifiHardware "$ssidName"
networksetup -addpreferredwirelessnetworkatindex $wifiHardware "$ssidName" 0 $wifiProtocol
EOF


# Usage: networksetup -addpreferredwirelessnetworkatindex <device name> <network> <index> <security type> [password]
# 	Add wireless network named <network> to preferred list for <device name> at <index>.
# 	For security type, use OPEN for none, WPA for WPA Personal, WPAE for WPA Enterprise, 
# 	WPA2 for WPA2 Personal, WPA2E for WPA2 Enterprise, WEP for plain WEP, and 8021XWEP for 802.1X WEP.
# 	If a password is included, it gets stored in the keychain.


chmod 755 /Library/Scripts/"$orgName"_SSIDPref.sh
chown root:wheel /Library/Scripts/"$orgName"_SSIDPref.sh

cat << EOF > /Library/LaunchDaemons/com."$orgName".SSIDPref.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>Label</key>
<string>com."$orgName".SSIDPref</string>
<key>ProgramArguments</key>
<array>
<string>sh</string>
<string>-c</string>
<string>/Library/Scripts/"$orgName"_SSIDPref.sh</string>
</array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

chmod 644 /Library/LaunchDaemons/com."$orgName".SSIDPref.plist
chown root:wheel /Library/LaunchDaemons/com."$orgName".SSIDPref.plist

launchctl bootstrap system /Library/LaunchDaemons/com."$orgName".SSIDPref.plist
