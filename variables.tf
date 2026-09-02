variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}
variable "availability_zone" {
  description = "Availability Zone"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
}
variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
}
variable "bastion_ssh_cidr" {
  description = "CIDR allowed to SSH to bastion"
  type        = string
}

variable "app_port" {
  description = "Application port"
  type        = number
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}
variable "key_name" {
  description = "EC2 SSH key pair name"
  type        = string
}
variable "second_availability_zone" {
  description = "Second Availability Zone"
  type        = string
}

variable "db_username" {
  description = "RDS database username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "RDS database password"
  type        = string
  sensitive   = true
}

variable "second_private_subnet_cidr" {
  description = "CIDR block for second private subnet"
  type        = string
}
