terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.25.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "vocareum"
}
