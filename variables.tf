variable "dynamo_table_name" {
  type        = string
  description = "The name of the DynamoDB table that will handle state locking."
}

variable "bucket_name" {
  type        = string
  description = "The name of the bucket that will store the remote state for the remote state."
}
variable "logging_bucket_name" {
  description = "The name of S3 logging bucket name"
  type        = string
}

variable "account_id" {
  type        = string
  description = "AWS Account ID"
}
variable "environment" {
  description = "Provide appropriate environment name"
  type        = string

  validation {
    condition = contains([
      "dev",
      "development",
      "uat",
      "production",
      "prod",
      "sandbox",
      "transit"
    ], var.environment)

    error_message = "The environment value is not valid. Valid values are dev/development/uat/prod/production/sandbox."
  }
}

variable "tag_application" {
  description = "Application tag"
  type        = string

}

variable "tag_team" {
  description = "Team tag"
  type        = string

}


locals {
  common_tags = {
    Application = var.tag_application
    Team        = var.tag_team
    environment = var.environment
  }
}
