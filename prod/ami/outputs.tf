output "solr_cluster_instances" {
  description = "Solar cluster instances "
  value = data.aws_instances.solrcuster.*
}
