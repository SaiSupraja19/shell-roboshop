#!/bin/bash
AMI_ID="ami-09a2f74ce8538e414"       
INSTANCE_TYPE="t3.micro"             
KEY_NAME="key"            
SECURITY_GROUP_ID="sg-0123456789abcdef0" 
INSTANCE_NAME="Shell-Roboshop"

echo "Launching EC2 instance in $REGION..."

# Create the EC2 instance and capture the Instance ID
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --count 1 \
    --instance-type "$INSTANCE_TYPE" \
    --key-name "$KEY_NAME" \
    --security-group-ids "$SECURITY_GROUP_ID" \
    --tag-specifications "Tags=[{Key=Name,Value=$INSTANCE_NAME}]" \
    --query 'Instances[0].InstanceId' \
    --output text)
