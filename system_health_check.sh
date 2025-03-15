#!/bin/bash

# Define thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

# Define package dependencies
REQUIRED_PACKAGES="lm-sensors bc"

# Function to check if required packages are installed
check_packages() {
    for PACKAGE in $REQUIRED_PACKAGES; do
        if ! dpkg -l | grep -q $PACKAGE; then
            echo "Package $PACKAGE is not installed. Installing..."
            sudo apt-get update
            sudo apt-get install -y $PACKAGE
        fi
    done
}

# Get current date and time for logs (for terminal output)
DATE=$(date "+%Y-%m-%d %H:%M:%S")

# Function to check CPU usage
check_cpu() {
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    if [ -z "$CPU_USAGE" ]; then
        CPU_USAGE="N/A"
    elif (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | awk '{if($1 > 80) print "true"; else print "false"}') == "true" )); then
        CPU_USAGE="ALERT: High ($CPU_USAGE%)"
    else
        CPU_USAGE="$CPU_USAGE%"
    fi
}

# Function to check memory usage
check_memory() {
    MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    if [ -z "$MEM_USAGE" ]; then
        MEM_USAGE="N/A"
    elif (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | awk '{if($1 > 80) print "true"; else print "false"}') == "true" )); then
        MEM_USAGE="ALERT: High ($MEM_USAGE%)"
    else
        MEM_USAGE="$MEM_USAGE%"
    fi
}

# Function to check disk usage
check_disk() {
    DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
    if [ -z "$DISK_USAGE" ]; then
        DISK_USAGE="N/A"
    elif [ $DISK_USAGE -gt $DISK_THRESHOLD ]; then
        DISK_USAGE="ALERT: High ($DISK_USAGE%)"
    else
        DISK_USAGE="$DISK_USAGE%"
    fi
}

# Function to check network activity using /proc/net/dev
check_network() {
    INCOMING=$(cat /proc/net/dev | grep eth0 | awk '{print $2}')
    OUTGOING=$(cat /proc/net/dev | grep eth0 | awk '{print $10}')
    
    if [ -z "$INCOMING" ] || [ -z "$OUTGOING" ]; then
        INCOMING="N/A"
        OUTGOING="N/A"
    else
        INCOMING="$((INCOMING / 1024)) KB/s"
        OUTGOING="$((OUTGOING / 1024)) KB/s"
    fi
}

# Function to check running processes for high CPU usage
check_processes() {
    TOP_PROCESSES=$(ps aux --sort=-%cpu | head -n 6)
    if [ -z "$TOP_PROCESSES" ]; then
        TOP_PROCESSES="N/A"
    else
        TOP_PROCESSES=$(echo "$TOP_PROCESSES" | awk '{print $1, $3, $11}' | column -t)
    fi
}

# Function to get CPU temperature using sensors command
check_temperature() {
    TEMPERATURE=$(sensors | grep -i 'Core 0' | awk '{print $3}')
    if [ -z "$TEMPERATURE" ]; then
        TEMPERATURE="N/A"
    fi
}

# Function to display a formatted table
display_table() {
    clear
    echo "==============================="
    echo "System Health Check - $DATE"
    echo "==============================="
    echo "| %-25s | %-20s |" "Component" "Status"
    echo "|---------------------------|----------------------|"
    printf "| %-25s | %-20s |\n" "CPU Usage" "$CPU_USAGE"
    printf "| %-25s | %-20s |\n" "Memory Usage" "$MEM_USAGE"
    printf "| %-25s | %-20s |\n" "Disk Usage" "$DISK_USAGE"
    printf "| %-25s | %-20s |\n" "Network Incoming" "$INCOMING"
    printf "| %-25s | %-20s |\n" "Network Outgoing" "$OUTGOING"
    printf "| %-25s | %-20s |\n" "CPU Temperature" "$TEMPERATURE"
    echo "|---------------------------|----------------------|"
    echo "Top 5 High CPU Processes"
    echo "----------------------------"
    if [ "$TOP_PROCESSES" == "N/A" ]; then
        echo "No processes found."
    else
        echo "$TOP_PROCESSES"
    fi
}

# Run package check and installation if necessary
check_packages

# Run all checks and display them in a formatted table
check_cpu
check_memory
check_disk
check_network
check_processes
check_temperature

# Display the table with all results
display_table

# Wait for user input before closing
echo "Press [Enter] to exit..."
read
