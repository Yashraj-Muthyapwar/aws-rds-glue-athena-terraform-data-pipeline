#!/bin/bash

set -e

export de_project="de-c1w2"
export AWS_DEFAULT_REGION="us-east-1"

# Set DB_USERNAME and DB_PASSWORD as environment variables before running
# export DB_USERNAME=your_username
# export DB_PASSWORD=your_password
if [[ -z "$DB_USERNAME" || -z "$DB_PASSWORD" ]]; then
  echo "Error: DB_USERNAME and DB_PASSWORD must be set as environment variables."
  exit 1
fi

export VPC_ID=$(aws rds describe-db-instances --db-instance-identifier $de_project-rds --output text --query "DBInstances[].DBSubnetGroup.VpcId")

echo "export TF_VAR_project=$de_project" >> $HOME/.bashrc
echo "export TF_VAR_region=$AWS_DEFAULT_REGION" >> $HOME/.bashrc
echo "export TF_VAR_vpc_id=$VPC_ID" >> $HOME/.bashrc
echo "export TF_VAR_public_subnet_a_id=$(aws ec2 describe-subnets --filters "Name=tag:aws:cloudformation:logical-id,Values=PublicSubnetA" "Name=vpc-id,Values=$VPC_ID" --output text --query "Subnets[].SubnetId")" >> $HOME/.bashrc
echo "export TF_VAR_db_sg_id=$(aws rds describe-db-instances --db-instance-identifier $de_project-rds --output text --query "DBInstances[].VpcSecurityGroups[].VpcSecurityGroupId")" >> $HOME/.bashrc
echo "export TF_VAR_host=$(aws rds describe-db-instances --db-instance-identifier $de_project-rds --output text --query "DBInstances[].Endpoint.Address")" >> $HOME/.bashrc
echo "export TF_VAR_port=3306" >> $HOME/.bashrc
echo "export TF_VAR_database="classicmodels"" >> $HOME/.bashrc
echo "export TF_VAR_username="$DB_USERNAME"" >> $HOME/.bashrc
echo "export TF_VAR_password="$DB_PASSWORD"" >> $HOME/.bashrc
echo "export TF_VAR_data_lake_bucket=$de_project-$(aws sts get-caller-identity --query 'Account' --output text)-$AWS_DEFAULT_REGION-datalake" >> $HOME/.bashrc
echo "export TF_VAR_scripts_bucket=$de_project-$(aws sts get-caller-identity --query 'Account' --output text)-$AWS_DEFAULT_REGION-scripts" >> $HOME/.bashrc

source $HOME/.bashrc

aws s3 cp ./terraform/assets/glue_job.py s3://$TF_VAR_scripts_bucket/glue_job.py
echo "Glue script has been set in the bucket"

script_dir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
sed -i "s//$TF_VAR_project-$(aws sts get-caller-identity --query 'Account' --output text)-us-east-1-terraform-state/g" "$script_dir/../terraform/backend.tf"

echo "Defined Terraform variables"
