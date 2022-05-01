terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.25.0"
    }
    cloudinit = {
      source = "hashicorp/cloudinit"
      version = ">= 2.1.0"
    }
  }
  backend "s3" {
    bucket = "jdmedeiros-solr-tfstate"
    key = "prod/services/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "jdmedeiros-solr-tfstate-lock"
    encrypt = true
    profile = "vocareum"
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "vocareum"
}
