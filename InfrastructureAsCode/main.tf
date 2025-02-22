provider "aws" {
    region = var.aws_region
}

#Terraform s3 backend for storing state file
terraform {
    backend "s3" {
        bucket         = "your-s3-bucket-name"
        key            = "path/to/your/terraform.tfstate"
        region         = var.aws_region
        encrypt        = true
    }
}

# Create a security group resource block
resource "aws_security_group" "web_sg" {
    name_prefix = "web-sg-"

    # Allowing inbound traffic on port 80 for HTTP
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allowing inbound traffic on port 22 for SSH
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allowing outbound traffic to all ports
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Create an EC2 instance resource block
resource "aws_instance" "web" {
    ami           = var.ami_id
    instance_type = var.instance_type
    security_groups = [aws_security_group.web_sg.name]
    key_name      = var.key_pair

    # user_data script to install Nginx
    user_data = <<-EOF
                            #!/bin/bash
                            apt update -y
                            apt install nginx -y
                            echo "Deployed via Terraform" > /var/www/html/index.html
                            systemctl enable nginx
                            systemctl start nginx
                            EOF

    tags = {
        Name = "web-instance-${var.environment}"
    }
}

# Output the private IP address of the EC2 instance
output "instance_private_ip" {
    value = aws_instance.web.private_ip
}
