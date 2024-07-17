#create a security group using terraform security group module
module "security_group" {
    source  = "terraform-aws-modules/security-group/aws"

    name = "my-jump-sg"
    description = "Security group for my jump instances"
    vpc_id = module.vpc.vpc_id
    ingress_cidr_blocks = ["0.0.0.0/0"]
    ingress_rules = ["http-80-tcp", "https-443-tcp","ssh-tcp"]
    egress_rules = ["all-all"]
}



#create security group using terraform security group module for the private subnet PHP instance
module "security_group_php" {
    source  = "terraform-aws-modules/security-group/aws"

    name = "my-php-sg"
    description = "Security group for my php instances"
    vpc_id = module.vpc.vpc_id
    ingress_cidr_blocks = [module.vpc.vpc_cidr_block]

    ingress_rules = ["http-80-tcp", "ssh-tcp"]
    egress_rules = ["all-all"]

}