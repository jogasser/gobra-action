#!/bin/bash

export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export RESET='\033[0m' # No Color


if [ -n "$INPUT_PROJECTLOCATION" ]; then
    export PROJECT_LOCATION="$GITHUB_WORKSPACE/$INPUT_PROJECTLOCATION"
else
    REPOSITORY_NAME=$(echo "$GITHUB_REPOSITORY" | awk -F / '{print $2}' | sed -e "s/:refs//")
    export PROJECT_LOCATION="$GITHUB_WORKSPACE/$REPOSITORY_NAME"
fi
export PACKAGE_LOCATION="$PROJECT_LOCATION/$INPUT_PACKAGELOCATION"
export GOBRA_JAR="/gobra/gobra.jar"

echo $GITHUB_WORKSPACE/*

echo "Verification for project in $PROJECT_LOCATION started"
echo $PROJECT_LOCATION/*

echo "Verifying packages located in $PACKAGE_LOCATION"
echo $PACKAGE_LOCATION/*

START_TIME=$SECONDS
EXIT_CODE=0

if timeout "$INPUT_GLOBALTIMEOUT" /gobra/verifyPackages.sh; then
    echo -e "${GREEN}Verification completed successfully in${RESET}"
else
    EXIT_CODE=$?
    if [ $EXIT_CODE -eq 124 ]; then
	echo -e "${RED}Verification timed out globally${RESET}"
    else
	echo -e "${RED}There are verification errors${RESET}"
    fi
fi

TIME_PASSED=$[ $SECONDS-$START_TIME ]

NUMBER_OF_PACKAGES_VERIFIED=$(cat output_num_packages)
NUMBER_OF_FAILED_PACKAGE_VERIFICATIONS=$(cat output_num_failed_packages)
NUMBER_OF_TIMEOUT_PACKAGE_VERIFICATIONS=$(cat output_num_timeout_packages)

echo "::set-output name=time::$TIME_PASSED"
echo "::set-output name=numberOfPackages::$NUMBER_OF_PACKAGES_VERIFIED"
echo "::set-output name=numberOfFailedPackages::$NUMBER_OF_FAILED_PACKAGE_VERIFICATIONS"
echo "::set-output name=numberOfTimedoutPackages::$NUMBER_OF_TIMEOUT_PACKAGE_VERIFICATIONS"
echo "::set-output name=numberOfMethods::0" # TODO: implement
echo "::set-output name=numberOfAssumptions::0" # TODO: implement
echo "::set-output name=numberOfDependingMethods::0" # TODO: implement

exit $EXIT_CODE
