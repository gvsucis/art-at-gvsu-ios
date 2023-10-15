#!/usr/bin/env bash

set -e

# DERIVED_PATH=${BUILT_PRODUCTS_DIR}/../DerivedSources

LOCAL_FIREBASE_PATH="${SRCROOT}/ArtAtGVSU/GoogleService-Info.plist"
SAMPLE_FIREBASE_PATH="${SRCROOT}/GoogleService-Info-sample.plist"
# FIREBASE_OUTPUT_PATH="${DERIVED_PATH}/GoogleService-Info.plist"

if [ ! -f "$LOCAL_FIREBASE_PATH" ]; then
    echo "Copying mock GoogleService-Info.plist"
    echo $(<${SAMPLE_FIREBASE_PATH}) > "${LOCAL_FIREBASE_PATH}"
    exit 0
fi
