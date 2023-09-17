#!/bin/bash

export LC_ALL=en_US.UTF-8

SCHEME="TaskTrigger"
DESTINATION="generic/platform=iOS"

set -o pipefail && xcodebuild clean docbuild -scheme $SCHEME \
    -destination $DESTINATION \
    OTHER_DOCC_FLAGS="--transform-for-static-hosting --hosting-base-path $SCHEME --output-path ./docs" | xcpretty
