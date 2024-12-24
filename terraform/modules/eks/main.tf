module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  eks_managed_node_groups = {
    node = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m5.xlarge"]

      min_size     = 1
      max_size     = 1
      desired_size = 1

      key_name = "Java-Spring-App"  # Reference the existing key pair directly

      user_data = <<-EOT
        #!/bin/bash
        yum update -y
        yum install -y curl

        curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sudo bash
        sudo chmod +x /usr/local/bin/helm
        helm version
      EOT
    }
  }
}
