#!/bin/bash
AMI_ID="ami-09a2f74ce8538e414"      # Replace with your region's AMI ID
INSTANCE_TYPE="t3.micro"
KEY_NAME="key"
SECURITY_GROUP="sg-0aae9f08f1510741c"

# List of server names to create
INSTANCES=("mongo-db" "catalogue" "frontend" "redis")

for NAME in "${INSTANCES[@]}"; 
do
  echo "Launching $NAME..."

  INSTANCE_ID=$(aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --count 1 \
    --instance-type "$INSTANCE_TYPE" \
    --key-name "$KEY_NAME" \
    --security-group-ids "$SECURITY_GROUP" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$NAME}]" \
    --query 'Instances[0].InstanceId' \
    --output text)

  echo "Created $NAME with ID: $INSTANCE_ID"
done
