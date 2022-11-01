#!/bin/bash

INSTANCE_START_TIME=$(aws ec2 describe-instances --filter Name=instance-state-name,Values=running --output table --query "Reservations[].Instances[].{Name: Tags[?Key == 'Name'].Value | [0], Id: InstanceId, State: State.Name, Type: InstanceType, Start: LaunchTime}" | grep "DEV_Adam_Stegienko_TED" | cut -d "|" -f4 | cut -d "T" -f 2 | cut -d "." -f1 | cut -d "+" -f1)
NOW=$(date +"%T")
INSTANCE_ID=$(aws ec2 describe-instances --filter Name=instance-state-name,Values=running --output table --query "Reservations[].Instances[].{Name: Tags[?Key == 'Name'].Value | [0], Id: InstanceId, State: State.Name, Type: InstanceType, Start: LaunchTime}" | grep "DEV_Adam_Stegienko_TED" | cut -d "|" -f2)

IFS=: read h m s <<<"$INSTANCE_START_TIME"
SECONDS_THEN=$((10#$s+10#$m*60+10#$h*3600))

IFS=: read h m s <<<"$NOW"
SECONDS_NOW=$((10#$s+10#$m*60+10#$h*3600))

DELTA_SECONDS=$((${SECONDS_NOW}-${SECONDS_THEN}))
DELTA_MINUTES=$((($DELTA_SECONDS / 60)-1))

if [ $DELTA_MINUTES -ge 15 ] || [ $DELTA_MINUTES -le -16 ]; then
    echo "${INSTANCE_ID} is older than 15 minutes so it is going to be deleted"
    aws ec2 terminate-instances --instance-ids ${INSTANCE_ID}
    echo "${INSTANCE_ID} deleted."
else
    echo "No test instance is going to be deleted as of now."
fi

echo $NOW
echo $INSTANCE_START_TIME