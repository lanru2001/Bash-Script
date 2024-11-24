
# You can use the following code snippet to remove all version objects from an S3 bucket without deleting or removing the objects themselves using AWS CLI and a Bash script:
# Replace `"your-bucket-name"` with the actual name of your S3 bucket. This script will list all version objects in the bucket, extract their version IDs, and then loop through each version ID to delete it without deleting the object.
# Please note that you will need to have `jq` installed on your system to work with JSON output and parsing. You can install it using your package manager if it's not already installed.


#!/bin/bash

# Set your bucket name
bucket_name="your-bucket-name"

# List all versions of objects in the bucket
versions=$(aws s3api list-object-versions --bucket $bucket_name --output json)

# Extract the version IDs of each object
version_ids=$(echo $versions | jq -r '.Versions[].VersionId')

# Loop through each version ID and delete it without deleting the object
for version_id in $version_ids
do
aws s3api delete-object --bucket $bucket_name --key "placeholder-key" --version-id $version_id
done
