#!/bin/bash
# Start the submission reminder application

# Check if required files exist
if [ ! -f "./config/config.env" ] || [ ! -f "./modules/functions.sh" ] || [ ! -f "./assets/submissions.txt" ]; then
    echo "Error: Missing required files!"
    exit 1
fi

# Source config and functions
source "./config/config.env"
source "./modules/functions.sh"

# Ensure necessary variables are set
if [ -z "$ASSIGNMENT" ] || [ -z "$DAYS_REMAINING" ]; then
    echo "Error: Missing required environment variables!"
    exit 1
fi

echo "===================================="
echo "Starting Submission Reminder App"
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING"
echo "===================================="

# Execute reminder script
./app/reminder.sh
