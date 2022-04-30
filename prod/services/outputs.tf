output "solr_public_ip" {
  description = "Solr public IP "
  value = aws_instance.solr.0.public_ip
}

output "solr_public_dns" {
  description = "Solr public DNS "
  value = aws_instance.solr.0.public_dns
}

output "solr_private_ip" {
  description = "Solr private IPs "
  value = aws_instance.solr.*.private_ip
}

output "zookeeper_public_ip" {
  description = "Zookeeper public IP "
  value = aws_instance.zookeeper.0.public_ip
}

output "zookeeper_public_dns" {
  description = "Zookeeper public DNS "
  value = aws_instance.zookeeper.0.public_dns
}

output "zookeeper_private_ip" {
  description = "Zookeeper private IPs "
  value = aws_instance.zookeeper.*.private_ip
}

# Some sanity checking to make sure we are in the right account - very important if you use multiple accounts
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}
