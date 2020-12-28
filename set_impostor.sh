#!/bin/bash
set -euo pipefail

REGION_INFO_FILE=~/.steam/steam/steamapps/compatdata/945360/pfx/drive_c/users/steamuser/AppData/LocalLow/Innersloth/Among\ Us/regionInfo.dat
DEFAULT_SERVER=hlz.mn
DEFAULT_PORT=22023
PROMPT_SERVER=n
CONFIRM_SERVER=y

echoe() {
	echo $@ >&1
	exit 1
}

echod() {
	if true
		then
		echo $@
	fi
}

echon() {
	echo -n $@
}

check_valid_bool() {
	[ "$1" = "y" ] || [ "$1" = "n" ]
}

check_ip() {
	# see https://stackoverflow.com/a/5284410
	IP_REGEX='^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}$'
	
	echo "$1" | grep -qP "$IP_REGEX"
}

nibble_to_hex() {
	case "$1" in
	0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9)
		echon "$1"
		;;
	10)
		echon "a"
		;;
	11)
		echon "b"
		;;
	12)
		echon "c"
		;;
	13)
		echon "d"
		;;
	14)
		echon "e"
		;;
	15)
		echon "f"
		;;
	*)
		echoe "Unknown nibble $i"
		;;
	esac
}

byte_to_hex() {
	nibble_to_hex $(("$1" / 16))
	nibble_to_hex $(("$1" % 16))
}

echo_byte() {
	BYTE="$(byte_to_hex $1)"
	echon -e '\x'"$BYTE"
}

if ! [ -d "$(dirname "$REGION_INFO_FILE")" ]
	then
	echoe "Region info file directory $(dirname "$REGION_INFO_FILE") not found"
fi

if [ "$(uname -m)" != "x86_64" ]
	then
	echoe "Architecture is not x86_64, erroring out -- This script was not tested for other architectures, especially not architectures with other Endianness"
fi

if ! check_valid_bool "$PROMPT_SERVER"
	then
	echoe "Invalid value for PROMPT_SERVER"
fi

if ! check_valid_bool "$CONFIRM_SERVER"
        then
        echoe "Invalid value for CONFIRM_SERVER"
fi

if [ "$PROMPT_SERVER" = "y" ]
	then
	read -p "Enter server name [${DEFAULT_SERVER}]: " SERVER
	read -p "Enter port [${DEFAULT_PORT}]: " PORT
else
	SERVER=""
	PORT=""
fi

if [ -z "$SERVER" ]
	then
	SERVER=$DEFAULT_SERVER
fi
if [ -z "$PORT" ]
	then
	PORT=$DEFAULT_PORT
fi

if check_ip "$SERVER"
	then
	IP_ADDR="$SERVER"
else
	IP_ADDR="$(dig +short "$SERVER" | tail -n 1)"
fi

if ! check_ip "$IP_ADDR"
	then
	echoe "Invalid IP address $IP_ADDR"
fi

IFS=. read IP_ADDR1 IP_ADDR2 IP_ADDR3 IP_ADDR4 <<< "$IP_ADDR"
IP_ADDR="${IP_ADDR1}.${IP_ADDR2}.${IP_ADDR3}.${IP_ADDR4}"
(
	echon -e "\x00\x00\x00\x00\x08Impostor"
	echo_byte "${#IP_ADDR}"
	echon "$IP_ADDR"
	echon -e "\x01\x00\x00\x00"
	echon -e "\x11Impostor-Master-1"
	echo_byte $IP_ADDR1
	echo_byte $IP_ADDR2
	echo_byte $IP_ADDR3
	echo_byte $IP_ADDR4
	echo_byte $(($PORT % 256))
	echo_byte $(($PORT / 256))
	echon -e "\x00\x00\x00\x00"
) >"$REGION_INFO_FILE"

if [ "$CONFIRM_SERVER" = "y" ]
	then
	echo "Selected server $SERVER, IP $IP_ADDR, press Enter to continue."
	read
fi
