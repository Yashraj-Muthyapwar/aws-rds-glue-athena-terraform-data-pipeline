variable "project" {
  type        = string
  description = "Project name"
}

variable "region" {
  type        = string
  description = "AWS Region"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "db_sg_id" {
  type        = string
  description = "Security group ID for RDS"
}

variable "source_host" {
  type        = string
  description = "RDS host"
}

variable "source_port" {
  type        = number
  description = "RDS port"
  default     = 3306
}

variable "source_database" {
  type        = string
  description = "RDS database name"
  default     = "classicmodels"
}

variable "source_username" {
  type        = string
  description = "RDS username"
  # Set via TF_VAR_source_username environment variable
}

variable "source_password" {
  type        = string
  description = "RDS password"
  sensitive   = true
  # Set via TF_VAR_source_password environment variable
}

variable "public_subnet_a_id" {
  type        = string
  description = "Public subnet A ID"
}

variable "public_subnet_b_id" {
  type        = string
  description = "Public subnet B ID"
}

variable "kinesis_stream_arn" {
  type        = string
  description = "Source Kinesis data stream ARN"
  # Set via TF_VAR_kinesis_stream_arn environment variable
}

variable "inference_api_url" {
  type        = string
  description = "URL of the Lambda inference API"
  # Set via TF_VAR_inference_api_url environment variable
}

variable "data_lake_bucket" {
  type        = string
  description = "S3 bucket for data lake"
}

variable "scripts_bucket" {
  type        = string
  description = "S3 bucket for Glue scripts"
}

variable "recommendations_bucket" {
  type        = string
  description = "S3 bucket for recommendations output"
}
