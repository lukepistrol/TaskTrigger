#!/bin/bash

export LC_ALL=en_US.UTF-8

SCHEME="TaskTrigger"

# Get the destination from the first argument
DESTINATION=$1

if [ -z "$DESTINATION" ]; then
	echo "Missing argument: destination"
	echo "Usage: $0 <destination>"
	echo "destination: [iOS|macOS|watchOS|tvOS|visionOS]"
	exit 1
fi

set -o pipefail && xcodebuild clean build -scheme $SCHEME \
	-destination "generic/platform=$DESTINATION" | xcpretty
