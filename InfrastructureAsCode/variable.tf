variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

# Update with latest AMI ID
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-XXXXXXXX" 
}

# Define a variable for the EC2 instance type

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

# Define a variable for the SSH key pair name (It should be created in AWS)
variable "key_pair" {
  description = "SSH Key Pair Name"
  type        = string
}

# Define a variable for the deployment environment
variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  default     = "dev"
}
