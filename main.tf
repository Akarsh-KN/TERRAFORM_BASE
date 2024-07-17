
# Create a VPC
# resource "aws_vpc" "demo-vpc" {
#   cidr_block = "10.0.0.0/16"

#   tags = {
#     "Name" = "demo-vpc"
#   }
# }


# Create a new ssh key pair
# resource "tls_private_key" "name" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }


# Create a aws_key_pair
resource "aws_key_pair" "my-key-pair" {  
    key_name = "example-key-pair" 
    public_key = file("./keys/id_rsa.pub")

    tags = {
        Name = "my-key-pair"
        }
}


# Create an ec2 instance
resource "aws_instance" "example1" {
  ami           = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
  key_name = aws_key_pair.my-key-pair.key_name

  security_groups = [module.security_group.security_group_id]

#how to use my vpc module here?
  subnet_id = module.vpc.public_subnets[0]

  associate_public_ip_address = true


  tags = {
    Name = "example"}

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ip_address.txt"
  }
}


# Output the public IP of the instance
output "instance_public_ip" {
  value = aws_instance.example1.public_ip
}


#create ubuntu instance in private subnet
resource "aws_instance" "php-instance" {
  ami           = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
  key_name = aws_key_pair.my-key-pair.key_name

  security_groups = [module.security_group_php.security_group_id]

  subnet_id = module.vpc.private_subnets[0]

  associate_public_ip_address = false

  tags = {  
    Name = "php-instance" 
  }
}



# output the private ip of the instance
output "instance_private_ip" {
  value = aws_instance.php-instance.private_ip
}