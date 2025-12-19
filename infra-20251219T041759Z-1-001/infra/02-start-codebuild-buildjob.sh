#!/bin/bash

# Default project name
DEFAULT_PROJECT_NAME="python-hello-world-demo"

# Use first argument as project name if provided, otherwise use default
PROJECT_NAME="${1:-$DEFAULT_PROJECT_NAME}"

echo "Starting CodeBuild for project: $PROJECT_NAME"

# Start the build
aws codebuild start-build  \
	--output table     \
	--project-name "$PROJECT_NAME" 

# --buildspec-override relative-path/to/my/custom/buildspec.yml OR use s3://my-bucket/path-to/buildspec.yml
