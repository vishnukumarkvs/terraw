module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  name               = "${var.name}-vpc"
  cidr               = var.vpc_cidr
  azs                = var.azs
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  enable_nat_gateway = var.enable_nat_gateway
  enable_vpn_gateway = var.enable_vpn_gateway
  tags               = var.tags
}

module "sg" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "${var.name}-sg"
  description = "Security group for ${var.name}"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = module.vpc.vpc_cidr_block
      description = "Allow all traffic from VPC CIDR"
    }
  ]
}

# Generate a random suffix
resource "random_id" "suffix" {
  byte_length = 4
}

# Create key pair using the module
module "key_pair" {
  source             = "terraform-aws-modules/key-pair/aws"
  key_name           = "${var.name}-key-${random_id.suffix.hex}"
  create_private_key = true
}

# Save the private key locally
resource "local_file" "private_key" {
  content         = module.key_pair.private_key_pem
  filename        = "${path.module}/${module.key_pair.key_pair_name}.pem"
  file_permission = "0400"
}

# EC2 instance in public subnet
resource "aws_instance" "public_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [module.sg.security_group_id]
  associate_public_ip_address = true
  key_name                    = module.key_pair.key_pair_name

  tags = {
    Name = "${var.name}-public-instance"
  }
}

# Elastic IP for the EC2 instance
resource "aws_eip" "instance_eip" {
  domain   = "vpc"
  instance = aws_instance.public_instance.id

  tags = {
    Name = "${var.name}-eip"
  }

  depends_on = [module.vpc.igw_id]
}


