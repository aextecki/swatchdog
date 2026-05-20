#!/bin/bash 

# ==============================================================================
# Script Name:  swatchdog.sh
# Description:  User-Friendly Intelligent Automated Process Recovery Agent
# Usage:        ./swatchdog.sh <service_nickname>
# Author:       Alex Mortel
# ==============================================================================

# Safety Check: Ensure the user provided at least one argument
if [[ $# -lt 1 ]]; then
        echo "Usage Error!"
        echo "Correct Usage: $0 <service_nickname>"
        echo "Available Friendly Nicknames: ssh, web, database"
        exit 1
fi

# Grab the first argument and drop it to lowercase for safety
NICKNAME=$(echo "$1" | tr '[:upper:]' '[:lower:]')

# 3. The Translation Layer: Map friendly names to system realities
case "$NICKNAME" in
        "ssh" | "sshd" | "secure-shell")
                PROCESS_NAME="sshd"
                SERVICE_NAME="ssh"
                DISPLAY_NAME="Secure Shell (SSH)"
                ;;
        "web" | "apache" | "apache2")
                PROCESS_NAME="apache2"
                SERVICE_NAME="apache2"
                DISPLAY_NAME="Apache Web Server"
                ;;
        "database" | "mysql" | "mariadb")
                PROCESS_NAME="mariadbd"
                SERVICE_NAME="mariadb"
                DISPLAY_NAME="MariaDB Database Server"
                ;;
        *)
                # Fallback: If they pass something unknown, we try to use it directly
                PROCESS_NAME="$1"
                SERVICE_NAME="$1"
                DISPLAY_NAME="$1"
                echo "!Unknown nickname. Attempting a blind direct-match for [$1]..."
                ;;
esac

echo "Checking the status of: $DISPLAY_NAME..."

# Core Monitoring and Self-Healing Logic
if pgrep -x "$PROCESS_NAME" > /dev/null; then 
        echo "OK: $DISPLAY_NAME is running perfectly."
        exit 0
else 
        echo "ALERT: $DISPLAY_NAME process is dead or missing!"
        echo "Initiating Service Recovery..."

        echo "-> Enabling system service ($SERVICE_NAME)..."
        sudo systemctl enable "$SERVICE_NAME" >/dev/null 2>&1

        echo "-> Resetting failed service counters..."
        sudo systemctl reset-failed "$SERVICE_NAME" >/dev/null 2>&1

        echo "-> Executing: sudo systemctl restart $SERVICE_NAME"
        sudo systemctl restart "$SERVICE_NAME"
        sleep 3

        # Double-check using the mapped process name
        if pgrep -x "$PROCESS_NAME" > /dev/null; then
                echo "RECOVERY SUCCESSFUL: $DISPLAY_NAME has been safely restored online!"
        else 
                echo "RECOVERY FAILED: Service config is broken. Manual Intervention required!"
                exit 1
        fi
fi
