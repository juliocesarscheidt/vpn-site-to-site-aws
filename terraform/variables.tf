variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "sa-east-1"
}

variable "aws_instance_size" {
  type        = string
  description = "AWS instance size"
  default     = "t2.micro"
}

variable "aws_key_name" {
  type        = string
  description = "AWS SSH key name"
  default     = "ssh_key"
}
