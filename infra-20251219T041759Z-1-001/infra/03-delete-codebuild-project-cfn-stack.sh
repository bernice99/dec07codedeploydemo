#!/bin/bash

# Default stack name
DEFAULT_STACK_NAME="codebuild-python-hello-world"

# Get stack name from first argument, or use default
STACK_NAME="${1:-$DEFAULT_STACK_NAME}"

echo "Deleting CloudFormation stack: $STACK_NAME"

# Run CloudFormation delete-stack command
aws cloudformation delete-stack --stack-name "$STACK_NAME" --region eu-west-2

# Wait for the stack deletion to complete
echo "Waiting for stack deletion to complete..."
aws cloudformation wait stack-delete-complete --stack-name "$STACK_NAME"

echo "Stack $STACK_NAME has been deleted successfully!"

