#!/usr/bin/env bash

set -e

LOCAL_FIREBASE_PATH="${SRCROOT}/ArtAtGVSU/GoogleService-Info.plist"
SAMPLE_FIREBASE_PATH="${SRCROOT}/GoogleService-Info-sample.plist"

if [ ! -f "$LOCAL_FIREBASE_PATH" ]; then
    echo "Copying mock GoogleService-Info.plist"
    echo $(<${SAMPLE_FIREBASE_PATH}) > "${LOCAL_FIREBASE_PATH}"
    exit 0
fi
