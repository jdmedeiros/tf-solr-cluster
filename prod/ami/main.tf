data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "jdmedeiros-solr-tfstate"
    key = "prod/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_instances" "solrcuster" {
  filter {
    name   = "instance.group-name"
    values = var.solr_cluster_sg
  }
  count    = length(data.aws_instances.solrcuster.ids)
}
