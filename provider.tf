terraform {
  required_version = "> 1.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 6.15.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }

  backend "s3" {
    bucket       = "trez-platform-tf-state"
    key          = "staging/state/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = "us-east-1"
}