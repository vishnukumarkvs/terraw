provider "aws" {
  region  = "us-east-1"
  alias   = "virginia"
  profile = "default"
}

provider "aws" {
  region  = "ap-south-1"
  alias   = "mumbai"
  profile = "default"
}

provider "aws" {
  region  = "eu-north-1"
  alias   = "stockholm"
  profile = "default"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
      # configuration_aliases = [aws.virginia, aws.mumbai, aws.stockholm]
    }
  }

  backend "s3" {
    bucket = "terraw-state"
    key    = "macmini"
    region = "us-east-1"
  }
}
