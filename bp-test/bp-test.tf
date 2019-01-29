##################################################################################
# VARIABLES
##################################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}

variable "key_name" {
  default = "default"
}

variable "vpc_id" {
  default = "vpc-95d018f3"
}

variable "vpc_cidr" {
  default = "172.31.0.0/16"
}

##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #
# resource "aws_internet_gateway" "igw" {
#   vpc_id = "${var.vpc_id}"

# }

# ROUTING #
# resource "aws_route_table" "rtb" {
#   vpc_id = "${var.vpc_id}"

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = "${aws_internet_gateway.igw.id}"
#   }
# }

# SECURITY GROUPS #
resource "aws_security_group" "bp-test-sg" {
  name        = "bp_test_sg"
  vpc_id      = "${var.vpc_id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # RDP access from anywhere
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # Lambda access from the VPC
  ingress {
    from_port   = 8181
    to_port     = 8181
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# INSTANCES #
resource "aws_instance" "example" {
  ami           = "ami-0c96d9489fa933423"
  instance_type = "t2.medium"
  vpc_security_group_ids = ["${aws_security_group.bp-test-sg.id}"]
  key_name      = "${var.key_name}"

  connection {
    user        = "ec2-user"
    private_key = "${file(var.private_key_path)}"
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo yum install nginx -y",
  #     "sudo service nginx start",
  #     "echo '<html><head><title>Blue Team Server</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">Blue Team</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html"
  #   ]
  # }
}
