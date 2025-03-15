#!/bin/bash

# Define thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

# Get current date and time for logs (for terminal output)
DATE=$(date "+%Y-%m-%d %H:%M:%S")

# Function to check CPU usage
check_cpu() {
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
        echo "$DATE - ALERT: High CPU usage: $CPU_USAGE%" 
    else
        echo "$DATE - CPU usage: $CPU_USAGE%"
    fi
}

# Function to check memory usage
check_memory() {
    MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    if (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then
        echo "$DATE - ALERT: High memory usage: $MEM_USAGE%" 
    else
        echo "$DATE - Memory usage: $MEM_USAGE%"
    fi
}

# Function to check disk usage
check_disk() {
    DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
    if [ $DISK_USAGE -gt $DISK_THRESHOLD ]; then
        echo "$DATE - ALERT: High disk usage: $DISK_USAGE%" 
    else
        echo "$DATE - Disk usage: $DISK_USAGE%"
    fi
}

# Function to check network activity (simplified)
check_network() {
    INCOMING=$(ifstat -i eth0 1 1 | awk 'NR==3 {print $1}')
    OUTGOING=$(ifstat -i eth0 1 1 | awk 'NR==3 {print $2}')
    echo "$DATE - Incoming: $INCOMING KB/s, Outgoing: $OUTGOING KB/s"
}

# Function to check running processes for high CPU usage
check_processes() {
    TOP_PROCESSES=$(ps aux --sort=-%cpu | head -n 6)
    echo "$DATE - High CPU processes:"
    echo "$TOP_PROCESSES"
}

# Run all checks and display them in the terminal
clear
echo "System Health Check - $DATE"
echo "==============================="
check_cpu
check_memory
check_disk
check_network
check_processes


# Wait for user input before closing
echo "Press [Enter] to exit..."
read
