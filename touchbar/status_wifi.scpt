set device to do shell script "networksetup -listallhardwareports | awk '$3==\"Wi-Fi\" {getline;print}' | awk '{print $2}'"

set power to do shell script "networksetup -getairportpower " & device & " | awk '{print $4}'"

return {power, power}
