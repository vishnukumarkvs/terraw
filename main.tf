module "ec2_mumbai" {
  source = "./modules/ec2-public"

  # Pass required variables to the module
  name          = "peach-red-bot"
  azs           = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  ami_id        = "ami-002f6e91abff6eb96"
  instance_type = "t2.micro"

  # Specify the AWS provider for this module
  providers = {
    aws = aws.mumbai
  }
}
