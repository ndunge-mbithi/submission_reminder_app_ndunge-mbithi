#!/bin/bash
# Script to create a submission reminder environment for any user.

# Prompt user for their name
read -p "Welcome, what is your name? " Name

# Ensure Name is not empty
if [[ -z "$Name" ]]; then
    echo "Error: Name cannot be empty!"
    exit 1
fi

echo "DEBUG: User's name is: $Name"

# Define base directory
BASE_DIR="./submission_reminder_$Name"

# Create required directories
mkdir -p "$BASE_DIR/app" "$BASE_DIR/modules" "$BASE_DIR/assets" "$BASE_DIR/config"

# Create necessary files
touch "$BASE_DIR/app/reminder.sh"
touch "$BASE_DIR/modules/functions.sh"
touch "$BASE_DIR/assets/submissions.txt"
touch "$BASE_DIR/config/config.env"
touch "$BASE_DIR/startup.sh"

# Set permissions
chmod +x "$BASE_DIR/app/reminder.sh"
chmod +x "$BASE_DIR/modules/functions.sh"
chmod +x "$BASE_DIR/startup.sh"

# Populate files with initial content
cat <<EOF > "$BASE_DIR/app/reminder.sh"
#!/bin/bash
# Source environment variables and helper functions
source "\$PWD/config/config.env"
source "\$PWD/modules/functions.sh"

# Path to submissions file
submissions_file="\$PWD/assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: \$ASSIGNMENT"
echo "Days remaining to submit: \$DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions "\$submissions_file"
EOF

cat <<EOF > "$BASE_DIR/modules/functions.sh"
#!/bin/bash
# Function to check submissions
function check_submissions {
    local submissions_file=\$1
    echo "Checking submissions in \$submissions_file"

    while IFS=, read -r student assignment status; do
        student=\$(echo "\$student" | xargs)
        assignment=\$(echo "\$assignment" | xargs)
        status=\$(echo "\$status" | xargs)

        if [[ "\$assignment" == "\$ASSIGNMENT" && "\$status" == "not submitted" ]]; then
            echo "Reminder: \$student has not submitted the \$ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "\$submissions_file")
}
EOF

cat <<EOF > "$BASE_DIR/assets/submissions.txt"
student,assignment,submission status
Chinemerem,Shell Navigation,not submitted
Chiagoziem,Git,submitted
Divine,Shell Navigation,not submitted
Anissa,Shell Basics,submitted
Kwame,Git,submitted
Mutheu,Shell Basics,submitted
Katheke,Shell Navigation,not submitted
Mutanu,Git,submitted
Mbithi,Git,not submitted
Deidre,Git,submitted
EOF

cat <<EOF > "$BASE_DIR/config/config.env"
# Configuration file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

cat <<EOF > "$BASE_DIR/startup.sh"
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
if [ -z "\$ASSIGNMENT" ] || [ -z "\$DAYS_REMAINING" ]; then
    echo "Error: Missing required environment variables!"
    exit 1
fi

echo "===================================="
echo "Starting Submission Reminder App"
echo "Assignment: \$ASSIGNMENT"
echo "Days remaining to submit: \$DAYS_REMAINING"
echo "===================================="

# Execute reminder script
./app/reminder.sh
EOF

echo "Setup complete! To run, navigate to $BASE_DIR and execute: ./startup.sh"


