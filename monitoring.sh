#!/bin/bash
echo -ne "#Architecture: "; uname -a

echo -ne "#CPU physical : "; grep -c ^processor /proc/cpuinfo

echo -ne "#vCPU : "; cat /proc/cpuinfo | grep processor | wc -l

echo -ne "#Memory Usage: "; free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'

echo -ne "#Disk Usage: "; df -h | awk '$NF=="/"{printf "%d/%dGB (%s)\n", $3,$2,$5}'

echo -ne "#CPU load: "; mpstat | grep all | awk '{printf "%.2f%%\n", 100-$13}'

echo -ne "#Last boot: "; who -b | awk '{printf $3" "$4"\n"}'

echo -ne "#LVM use: "; if cat /etc/fstab | grep -q "/dev/mapper/"; then echo "yes"; else echo "no"; fi

echo -ne "#Connections TCP : "; cat /proc/net/tcp | wc -l | awk '{print $1-1}' | tr '\n' ' ' && echo "ESTABLISHED"

echo -ne "#User log: "; w | wc -l | awk '{print$1-2}'

echo -ne "#Network: "; echo -n "IP " && ip route list | grep link | awk '{printf "%s", $9}' | tr -d ' ' && echo -n " (" && ip link show | grep link/ether | awk '{print $2}' | tr -d '\n' && echo ")";

echo -ne "#Sudo : "; ls /var/log/sudo/00/00 | wc -l | tr '\n' ' ' && echo "cmd"
printf "\n"