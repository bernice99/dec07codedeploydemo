#!/bin/bash

echo "You are executing codedeploy lifecycle event hook: $LIFECYCLE_EVENT"
echo

echo "you are in current working directoty :"
pwd
echo

echo "Checking system resources ..."
df -h

echo "checking if python is installed ..."
echo

if command -v python3 &> /dev/null
then
	echo "Python 3 is installed."
	PYTHON_CMD="python3"
elif command -v python &> /dev/null
then
	echo "Python (legacy) is installed."
	PYTHON_CMD="python"
else
	echo "ERROR: Python (python3 or python) is not installed on this server." >&2
	exit 1
fi

echo "Python check complete."
echo
