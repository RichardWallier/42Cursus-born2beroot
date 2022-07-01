ARCHITECTURE=$(uname -a)
CPU_PHYSICAL=$(grep "physical id" /proc/cpuinfo | uniq | wc -l)
CPU_VIRTUAL=$(grep "processor" /proc/cpuinfo | uniq | wc -l)
MEM_TOTAL=$(free -m | grep Mem | awk '{print $2}')
MEM_USAGE=$(free -m | grep Mem | awk '{print $3}')
MEM_PERCENT=$(free | grep Mem | awk '{printf("%.2f"), $3/$2*100}')
DISK_TOTAL=$(df -Bg | grep '/dev/' | grep -v 'boot$' | awk '{TOTAL_DISK += $2} END {print TOTAL_DISK}')
DISK_USAGE=$(df -Bm | grep "/dev/" | grep -v "boot$" | awk '{DISK_USED += $3} END {print DISK_USED}')
DISK_PERCENT=$(df -Bm | grep "/dev/" | grep -v "boot$" | awk '{DISK_USED += $3} {TOTAL_DISK += $2} END {printf("%.2f"), DISK_USED/TOTAL_DISK*100}')
CPU_LOAD=$(top -bn1 | grep "%Cpu" | awk '{printf("%.1f"), $2 + $4}')
LAST_BOOT=$(who -b | awk '{print $3 " " $4}')
LVM_USE="no"
if (lsblk | grep "lvm" | wc -l)
then
	LVM_USE="yes"
else
	LVM_USE="no"
fi
TCP_CONNECTIONS=$(cat /proc/net/sockstat | grep "TCP" | awk '{printf $3}')
USER_LOG=$(who | awk '{print $1}' | wc -l)
MAC_ADDRESS=$(ip a | grep link/ether| awk '{print $2}')
IP_ADDRESS=$(hostname -I | awk '{print $1}')
SUDO_COUNT=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "	#Architecture: ${ARCHITECTURE}
	#CPU physical : ${CPU_PHYSICAL}
	#vCPU: ${CPU_VIRTUAL}
	#Memory Usage: ${MEM_USAGE}/${MEM_TOTAL}MB (${MEM_PERCENT}%)
	#Disk Usage: ${DISK_USAGE}/${DISK_TOTAL}Gb (${DISK_PERCENT}%)
	#CPU load: ${CPU_LOAD}
	#Last boot: ${LAST_BOOT}
	#LVM use: ${LVM_USE}
	#Connections TCP : ${TCP_CONNECTIONS}
	#User log: ${USER_LOG}
	#Network: IP ${IP_ADDRESS} (${MAC_ADDRESS})
	#Sudo : ${SUDO_COUNT}"
