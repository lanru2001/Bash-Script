#!/bin/bash

#Pull ACCOUNT ACCESS_KEY and SECRET_KEY from Git lab Variables
#Find the vars with the right creds in gitlab
AWS_ACCOUNT="${ACCOUNT}"
ACCESS_KEY_VAR="${AWS_ACCOUNT}_ACCESS_KEY"
SECRET_KEY_VAR="${AWS_ACCOUNT}_SECRET_KEY"

export AWS_ACCESS_KEY_ID=${!ACCESS_KEY_VAR}
export AWS_SECRET_ACCESS_KEY=${!SECRET_KEY_VAR}
export AWS_DEFAULT_REGION=$AWS_REGION

DATE=`date +"%Y-%m-%d"`
EXPIRE_DAYS=30
EXPIRE_DATE=`date +"%Y-%m-%d" -d "+$EXPIRE_DAYS days"`


if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "AWS_SECRET_ACCESS_KEY" ] || [ -z "$AWS_DEFAULT_REGION" ]
then
	echo "Error: Variables not set correctly"
	exit 1
fi

echo "Creating snapshots for $AWS_DEFAULT_REGION"

#Grab all EC2 instanes with Snapshot=True
INSTANCES=`aws ec2 describe-instances --filters Name=tag:Snapshot,Values="True" | jq '.Reservations[]["Instances"][]["InstanceId"]' | sed "s/\"//g"`

if [ -z "$INSTANCES" ]
then
	echo "No instances found to snapshot"
	exit 1
fi

for INSTANCE in $INSTANCES
do

        INSTANCE_NAME=`aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE" | jq '.Tags[] | select(.Key=="Name")' | jq '.Value' | sed "s/\"//g"`
        VOLUMES=`aws ec2 describe-instances --instance-ids $INSTANCE | jq '.Reservations[]["Instances"][]["BlockDeviceMappings"][]["Ebs"]["VolumeId"]' | sed "s/\"//g"`

        for VOLUME in $VOLUMES
        do
                echo "Snapshotting $VOLUME on HOST $INSTANCE"
                SNAPRESULT=`aws ec2 create-snapshot --volume-id $VOLUME --description "$INSTANCE_NAME -- $VOLUME -- $DATE"`
                echo $SNAPRESULT

                #Tag With Expiration DAYS
                SNAP_ID=`echo $SNAPRESULT | jq .SnapshotId | sed "s/\"//g"`
                aws ec2 create-tags --resources $SNAP_ID --tags Key="Expires",Value="$EXPIRE_DATE"
        done


done


echo "Waiting for Snapshots to Complete"
sleep 30

#Find all Snapshot with Expires Tag
SNAPSHOTS=`aws ec2 describe-snapshots --filters Name=tag-key,Values="Expires" | jq '.Snapshots[]["SnapshotId"]' | sed "s/\"//g"`
for SNAPSHOT in $SNAPSHOTS
do
        echo "Checking $SNAPSHOT for Expiration"
        EXPIRES_CHECK=`aws ec2 describe-snapshots --snapshot-ids $SNAPSHOT | jq '.Snapshots[].Tags[] | select(.Key=="Expires")' | jq '.Value' | sed "s/\"//g"`

        echo "Checking if $DATE is newer than $EXPIRES_CHECK on $SNAPSHOT"

        #If EXPIRES is OLDER than date, Delete
        if [[ "$DATE" > "$EXPIRES_CHECK" ]]
        then
                echo "Deleting Snapshot $SNAPSHOT"
                aws ec2 delete-snapshot --snapshot-id $SNAPSHOT
        fi
done

echo "Script Complete, Exiting"
exit 0
