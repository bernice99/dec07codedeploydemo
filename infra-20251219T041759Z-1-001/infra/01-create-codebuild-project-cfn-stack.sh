#!/bin/bash

# Default stack name
DEFAULT_STACK_NAME="codebuild-python-hello-world"
DEFAULT_CFN_STACK_NAME="codebuild-template.yml"

# Get stack name from first argument, or use default
STACK_NAME="${1:-$DEFAULT_STACK_NAME}"

# Get template file from second argument, or use default
TEMPLATE_FILE="${2:-$DEFAULT_CFN_STACK_NAME}"

echo "Creating CloudFormation stack: $STACK_NAME"
echo "Using template file: $TEMPLATE_FILE"

# Run CloudFormation create-stack command
aws cloudformation create-stack \
  --stack-name "$STACK_NAME" \
  --template-body "file://$TEMPLATE_FILE" \
  --capabilities CAPABILITY_NAMED_IAM \
  --region eu-west-2

# Wait for the stack creation to complete
echo "Waiting for stack creation to complete..."
aws cloudformation wait stack-create-complete --stack-name "$STACK_NAME"

echo "Stack $STACK_NAME created successfully!"

