# Key pair for SSH login

resource "aws_key_pair" "my_key" {
  key_name = "terraform-key"
  public_key = file("/home/asad/terraform-key.pub")

}

#Default VPC
resource "aws_default_vpc" "default" {
}
# Security Group

resource "aws_security_group" "my_security_group" {
  name        = "automate-sg"
  description = "Security group created by Terraform"
  vpc_id      = aws_default_vpc.default.id
  # Inbound rule (SSH)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH open"
  }

  # Outbound rule (All traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All access open outbound"
  }

  tags = {
    Name = "automate-sg"
  }
}
resource "aws_instance" "my_ec2" {
  ami                         = "ami-0cf8ec67f4b13b491"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.my_key.key_name
  vpc_security_group_ids      = [aws_security_group.my_security_group.id]

    tags = {
    Name = "Terraform-EC2-Dev"
  }

}









