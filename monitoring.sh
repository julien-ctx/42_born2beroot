#!/bin/bash
slash=$(echo /)
percent=$(echo %)
mb=$(echo MB)
gb=$(echo GB)
arc=$(uname -a)
cpu=$(lscpu | grep "CPU(s):" | grep -wv "node0 CPU(s)" | awk '{print $2}')
vcpu=$(cat /proc/cpuinfo | grep processor | wc -l)
memused=$(free -m | grep Mem | awk '{print $3}')
memtotal=$(free -m | grep Mem | awk '{print $2}')
percentage=$(echo "scale=2; $((memused)) * 100 / $((memtotal))" | bc -l)
disktotal=$(df -h | grep root | awk '{print $2}' | tr -d 'G')
diskavailable=$(df -h | grep root | awk '{print $3}' | tr -d 'G')
diskpercent=$(df -h | grep root | awk '{print $5}')
cpuload=$(top -bn1 | grep load | awk '{print $10}' | tr -d ',')
lastboot=$(who -b | awk '{print $3" "$4}')
lvm=$(lsblk | grep lvm | awk '{if ($1) {print "yes";exit} else {print "no"} }')
connexions=$(cat /proc/net/sockstat | grep TCP | awk '{print $3}')
users=$(who | wc -l)
ip=$(hostname -I)
mac=$(ip a | grep link/ether | awk '{print $2}')
sudo=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
wall -n "#Architecture: $arc
#CPU physical: $cpu
#vCPU: $vcpu
#Memory Usage: $memused$slash$memtotal$mb ($percentage$percent)
#Disk Usage: $diskavailable$slash$disktotal$gb ($diskpercent)
#CPU load: $cpuload$percent
#Last boot: $lastboot
#LVM use: $lvm
#Connexions TCP: $connexions ESTABLISHED
#User log: $users
#Network: IP $ip($mac)
#Sudo: $sudo cmd"
