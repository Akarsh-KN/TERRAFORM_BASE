
# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "example-vpc"
  }
}


# Create a new ssh key pair
# resource "tls_private_key" "name" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }


# Create a aws_key_pair
resource "aws_key_pair" "example" {  
    key_name = "example-key-pair" 
    public_key = file("./keys/id_rsa.pub")

    tags = {
        Name = "example-key-pair"
        }
}


# Create an ec2 instance
resource "aws_instance" "example" {
  ami           = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
  key_name = aws_key_pair.example.key_name

  tags = {
    Name = "example"}

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ip_address.txt"
  }
}


# Output the public IP of the instance
output "instance_public_ip" {
  value = aws_instance.example.public_ip
}