#!/bin/bash

# List EC2 instances across all AWS regions
REGIONS=$(aws ec2 describe-regions --region us-east-1 --query "Regions[].RegionName" --output text --profile webmaster-trendylead)

echo "Scanning all AWS regions for EC2 instances..."
echo "------------------------------------------------"

for region in $REGIONS; do
  echo "Checking region: $region"
  INSTANCES=$(aws ec2 describe-instances \
    --region $region \
    --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,Placement.AvailabilityZone,Tags[?Key==`Name`].Value|[0],LaunchTime]' \
    --output text \
    --profile xxx)
  
  if [ -n "$INSTANCES" ]; then
    echo "Found instances in $region:"
    echo "$INSTANCES" | while read -r id type state az name launch; do
      echo "  ID: $id, Type: $type, State: $state, Name: ${name:-Unnamed}, AZ: $az, Launched: $launch"
    done
    echo ""
  fi
done

echo "------------------------------------------------"
echo "Scan complete."
