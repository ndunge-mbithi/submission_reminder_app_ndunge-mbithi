#!/bin/bash
# Source environment variables and helper functions
source "$PWD/config/config.env"
source "$PWD/modules/functions.sh"

# Path to submissions file
submissions_file="$PWD/assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions "$submissions_file"
