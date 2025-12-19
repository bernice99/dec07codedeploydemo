#!/bin/bash

# Usage: 01-verify-codedeploy-running.sh [REGION]

DEFAULT_REGION="us-east-1"
INSTALL_SCRIPT="./install-codedeploy-agents.sh"

REGION="${1:-$DEFAULT_REGION}"

echo "Checking for AWS CodeDeploy Agent on Amazon Linux 2023..."
echo "--------------------------------------------------------"

# 1. Check if codedeploy-agent binary exists
if ! command -v codedeploy-agent >/dev/null 2>&1; then
    echo "CodeDeploy agent is NOT installed."

    # Check if install script exists
    if [ ! -f "$INSTALL_SCRIPT" ]; then
        echo "Install script not found: $INSTALL_SCRIPT"
        exit 1
    fi

    echo "Running install script: $INSTALL_SCRIPT $REGION"
    bash "$INSTALL_SCRIPT" "$REGION"

else
    echo "CodeDeploy agent binary found."
fi

# 2. Check systemd service
if systemctl list-unit-files | grep -q codedeploy-agent.service; then
    echo "CodeDeploy service is installed."
else
    echo "CodeDeploy service is NOT registered with systemd."
    exit 1
fi

# 3. Check if running
if systemctl is-active --quiet codedeploy-agent; then
    echo "CodeDeploy agent is RUNNING."
else
    echo "CodeDeploy agent is installed but NOT running. Starting it..."
    sudo systemctl start codedeploy-agent

    if systemctl is-active --quiet codedeploy-agent; then
        echo "CodeDeploy agent started."
    else
        echo "Failed to start CodeDeploy agent."
        exit 1
    fi
fi

# 4. Deployment directory
# This is a clean install but eventually once deployments are made the following directories will exist
#/opt/codedeploy-agent/deployment-root/
#└── <deployment-id>/                        # Unique ID for this deployment
#    ├── deployment-archive/                # Extracted application bundle
#    │   └── ...                            # Your actual application files
#    │
#    ├── deployment-instructions/           # Auto-generated instructions created from AppSpec
#    │   ├── before_install                 # Parsed hook order
#    │   ├── install                        # Parsed hook order
#    │   ├── after_install                  # Parsed hook order
#    │   ├── application_start              # Parsed hook order
#    │   ├── application_stop               # Parsed hook order
#    │   └── validate_service               # Parsed hook order
#    │
#    ├── logs/                              # Logs for this specific deployment
#    │   └── script.log                     # Output from your lifecycle hook scripts
#    │
#    ├── scripts/                           # Your actual scripts from the AppSpec bundle
#    │   ├── before_install                 # Copied from your bundle
#    │   ├── install                        # Copied from your bundle
#    │   ├── after_install                  # Copied from your bundle
#    │   ├── application_start              # Copied from your bundle
#    │   └── application_stop               # Copied from your bundle
#    │
#    ├── deployment-config.json             # Deployment settings + metadata
#    ├── host-agent-runner.params.json      # Parameters used internally by the agent
#    └── bundle.tar                         # Original bundle downloaded from S3/GitHub

DEPLOY_DIR="/opt/codedeploy-agent"

if [ -d "$DEPLOY_DIR" ]; then
    echo
    echo "Listing contents of $DEPLOY_DIR:"
    echo "--------------------------------------------------------"
    ls -al "$DEPLOY_DIR"
else
    echo "Directory $DEPLOY_DIR does not exist."
    exit 1
fi

echo "Commands you might like ..."

echo "systemctl status codedeploy-agent"
echo "cd /opt/codedeploy-agent"

echo "Done."
