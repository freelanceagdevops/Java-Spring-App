output "cluster_id" {
  value = aws_eks_cluster.javaspring.id
}

output "node_group_id" {
  value = aws_eks_node_group.javaspring.id
}

output "vpc_id" {
  value = aws_vpc.javaspring_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.javaspring_subnet[*].id
}
