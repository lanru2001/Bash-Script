#!/bin/bash

set -x 
echo $IAM_ROLE
aws sts assume-role --role-arn "$IAM_ROLE" --role-session-name TF_Gitlab_ACCEESS --region us-east-1 >> creds.json   
export AWS_ACCESS_KEY_ID=$(jq -r '.Credentials.AccessKeyId' creds.json)  
export AWS_SECRET_ACCESS_KEY=$(jq -r '.Credentials.SecretAccessKey' creds.json)   
export AWS_SESSION_TOKEN=$(jq -r '.Credentials.SessionToken' creds.json)

# Set the timezone to CST
export TZ=America/Chicago

# Define the EKS cluster and node group names
EKS_CLUSTER_NAME="$EKS_CLUSTER_NAME"
EKS_NODE_GROUP_NAME="$EKS_NODE_GROUP_NAME"
AWS_DEFAULT_REGION="$AWS_DEFAULT_REGION"

# Set the minimum and maximum sizes for the node group
MIN_SIZE=1
MAX_SIZE=3

# Get the current hour in the CST timezone
CURRENT_HOUR=$(date +%H)

# If the current hour is between 9pm and 9am, set the node group size to 1
if (( CURRENT_HOUR >= 21 || CURRENT_HOUR < 9 )); then

  echo "$(date): Scaling node group to $MIN_SIZE"
  aws eks --region $AWS_DEFAULT_REGION update-kubeconfig --name $EKS_CLUSTER_NAME 
  aws eks update-nodegroup-config --cluster-name $EKS_CLUSTER_NAME --nodegroup-name $EKS_NODE_GROUP_NAME --scaling-config minSize=$MIN_SIZE,maxSize=$MAX_SIZE,desiredSize=$MIN_SIZE --region $AWS_DEFAULT_REGION

else
    # Otherwise, set the node group size to 3
    echo "$(date): Scaling node group to $MAX_SIZE"
    aws eks --region $AWS_DEFAULT_REGION update-kubeconfig --name $EKS_CLUSTER_NAME
    aws eks update-nodegroup-config --cluster-name $EKS_CLUSTER_NAME --nodegroup-name $EKS_NODE_GROUP_NAME --scaling-config minSize=$MAX_SIZE,maxSize=$MAX_SIZE,desiredSize=$MAX_SIZE  --region $AWS_DEFAULT_REGION

fi

echo "Script Complete, Exiting"
exit 0
