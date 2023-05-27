#!/bin/bash
PREFIX="${1:-NOT_SET}"
INTERFACE="$2"
SUBNET="$3"
HOST="$4" 
VAR="^([0-9]|[0-9]{2}|1[0-9]{2}|2[0-4][0-9]|2[0-5]{2})$"
VAR1="^([1-2]|[0-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|2[0-5][0-5])\.([0-9]|[0-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|2[0-5][0-5])$"

if [[ "$(id -u)" != 0 ]]; then
        echo "Запустите программу от суперпользователя"
        exit 1
else
[[ ! $PREFIX =~ $VAR1 ]] && { echo "Ошибка ввода префикса"; exit 1;}
#[[ ! $SUBNET =~ $VAR ]] && { echo "Ошибка ввода подсети"; exit 1; }
#[[ ! $HOST =~ $VAR ]] && { echo "Ошибка вода хоста"; exit 1; }
[[ "$PREFIX" = "NOT_SET" ]] && { echo "$PREFIX must be passed as first positional argument"; exit 1; }
if [[ -z "$INTERFACE" ]]; then
echo "\$INTERFACE must be passed as second positional argument"
    exit 1
fi

if [[ -z "$SUBNET" ]] && [[ -z "$HOST" ]]; then
for SUBNET in {1..255} 
do
        for HOST in {1..255}
        do
          echo "[*] IP : ${PREFIX}.${SUBNET}.${HOST}"
          arping -c 3 -i "$INTERFACE" "${PREFIX}.${SUBNET}.${HOST}" 2> /dev/null
        done
done
elif [[ -z "$HOST" ]]; then
        [[ ! $SUBNET =~ $VAR ]] && { echo "Ошибка ввода подсети"; exit 1; }
        for HOST in {1..255}
        do
          echo "[*] IP: ${PREFIX}.${SUBNET}.${HOST}"
          arping -c 3 -i "$INTERFACE" "${PREFIX}.${SUBNET}.${HOST}" 2> /dev/null
        done
else
        [[ ! $HOST =~ $VAR ]] && { echo "Ошибка вода хоста"; exit 1; }
        [[ ! $SUBNET =~ $VAR ]] && { echo "Ошибка ввода подсети"; exit 1; }
        echo "[*] IP: ${PREFIX}.${SUBNET}.${HOST}"
        arping -c 3 -i "$INTERFACE" "${PREFIX}.${SUBNET}.${HOST}" 2> /dev/null  
#fi
fi
fi
