variable "my_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}
variable "my_iam_role" {
  description = "The name of the IAM role"
  type        = string
}
variable "my_ami" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string

}

variable "my_instnace_type" {
  description = "The instance type for the EC2 instance"
  type        = string
}

variable "my_subnet_id" {
  description = "enter any default subnet id"
}

variable "my_vpc_id" {
  description = "Enter your vpc id:"
}
