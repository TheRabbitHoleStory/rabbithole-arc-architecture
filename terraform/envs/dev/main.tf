terraform {
  backend "s3" {
    bucket         = "rabbithole-tfstate-408278014840"
    key            = "envs/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "rabbithole-tf-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"

  default_tags {
    tags = {
      Application = "RabbitHoleARC"
      Environment = "dev"
      Owner       = "CTO"
    }
  }
}

module "network" {
  source      = "../../modules/network"
  vpc_cidr    = "10.10.0.0/16"
  environment = "dev"
}
