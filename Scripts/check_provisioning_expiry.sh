#!/bin/sh

#  script.sh
#  RunScriptTest
#
#  Created by Chris Mash on 03/11/2020.
#  

#set -x # log all commands

DAYS_TO_WARN_WITHIN=30
DAYS_TO_ERROR_WITHIN=7

# Build the path to the profile based on the platform being built
if [[ $SUPPORTED_PLATFORMS == "macosx" ]]
then
    REL_PROFILE_PATH=Contents/embedded.provisionprofile
else
    REL_PROFILE_PATH=embedded.mobileprovision
fi

ABS_PROFILE_PATH=$TARGET_BUILD_DIR/$PRODUCT_NAME.app/$REL_PROFILE_PATH

# Extract the <ExpirationDate> value
PROFILE_EXPIRATION_LINE=`awk '/ExpirationDate/{getline; print}' $ABS_PROFILE_PATH`
PROFILE_EXPIRATION=""
REGEX=">(.*)<"
if [[ $PROFILE_EXPIRATION_LINE =~ $REGEX ]]
then
    # Found the expiration date
    PROFILE_EXPIRATION=${BASH_REMATCH[1]}

    # Check how far away the expiry is
    NOW_EPOCH=$(date +%s)
    UTC_FORMAT="%Y-%m-%dT%H:%M:%SZ"
    EXPIRY_EPOCH=$(date -j -f "$UTC_FORMAT" "$PROFILE_EXPIRATION" +%s)
    SECS_TO_EXPIRY=$(($EXPIRY_EPOCH-$NOW_EPOCH))
    DAYS_TO_EXPIRY=$(($SECS_TO_EXPIRY/(60*60*24)))

    # Check if it's within the specified number of days to warn/error on
    if [ $DAYS_TO_EXPIRY -le $DAYS_TO_ERROR_WITHIN ];
    then
        echo "error: Provisioning profile expires in $DAYS_TO_EXPIRY days"
        exit 1
    elif [ $DAYS_TO_EXPIRY -le $DAYS_TO_WARN_WITHIN ];
    then
        echo "warning: Provisioning profile expires in $DAYS_TO_EXPIRY days"
    else
        echo "Provisioning profile expires in $DAYS_TO_EXPIRY days"
    fi

fi
