#!/bin/bash

# Enable strict mode for better error handling
set -euo pipefail

# Get the IP address of the container
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Replace the placeholder in the template with the actual IP address
sed "s/{{ADVERTISE_ADDRESS}}/$IP_ADDRESS/" /etc/gitlab-runner/config.toml.template > /etc/gitlab-runner/config.toml

echo "Updated config.toml with IP address: $IP_ADDRESS"
echo "Executing command: $@"

# Execute the passed command, replace the shell with the command
exec "$@"
