#!/bin/sh
# Spoofs an attwifi access point for 3DS nintendo zone connections.
# args: spoof-attwifi.sh $csv_file $line_num
# it should let you get streetpasses from guys using the same MAC.
#
# Damn it, Krieger, write better code!

# This version auto-cycles through a specified range for any CSV file.

# if less than 3 params, check to see if 1st param is file.  If it is, cat the file.
# if it isn't, exit.
if [ "$#" -le 2 ]; then
	echo "args: spoof-attwifi.sh \$csv_file \$line_num \$last_line"
	csv_file=$1
	if [[ -f $csv_file ]]; then
		echo "Your current csv file: "
		cat -n $csv_file
	else
		echo "Specified csv file isn't a valid file"
	fi
	exit 1
fi

# Because this changes the MAC address, you need to run this as root.
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user" 2>&1
  exit 1
fi

csv_file=$1
line_num=$2
last_num=$3

# check validity of line number specified
if ! [[ "$line_num" =~ ^[0-9]+$ ]] || [[ "$line_num" -eq 0 ]] || [[ "$line_num" -gt `wc -l $csv_file | cut -d ' ' -f1` ]] ; then
	echo "invalid first line number, assuming first number of line"
	line_num=1
fi
if ! [[ "$last_num" =~ ^[0-9]+$ ]] || [[ "$last_num" -eq 0 ]] || [[ "$last_num" -gt `wc -l $csv_file | cut -d ' ' -f1` ]] ; then
        echo "invalid last line number, assuming last line number"
		last_num=`wc -l $csv_file | cut -f1 -d ' '`
fi
if [[ "$line_num" -gt "$last_num" ]] || [[ "$last_num" -lt "$line_num" ]]; then
	echo "Invalid range from $line_num to $last_num."
	exit 1
fi
line=$line_num
echo "MAC addresses used:"
while [[ $line -le $last_num ]]
do	
	mac=`sed -n ${line}p $csv_file | cut -d , -f 1`
	echo `sed -n ${line}p $csv_file | cut -d , -f 2 ` $mac
	line=$((line + 1))
done
echo "Continue?"
select yn in "Yes" "No"; do
	case $yn in
		Yes )	
			line=$line_num
			while [[ $line -le $last_num ]]
			do
				mac=`sed -n ${line}p $csv_file | cut -d , -f 1`
				ifconfig wlan0 down; 
				ifconfig wlan0 hw ether $mac; 
				ifconfig wlan0 up;
				hostapd hostapd-minimal.conf &
				sleep 60
				echo "Killing hostapd and cycling..."
				pkill -f "hostapd" 
				sleep 10
				line=$((line + 1))
			done
			exit 0;;
		No )	echo "Cancelled."
			exit 0;;
	esac
done
