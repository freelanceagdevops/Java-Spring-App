resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
}

resource "aws_route_table_association" "subnet_1_association" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "subnet_2_association" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "subnet_3_association" {
  subnet_id      = aws_subnet.subnet_3.id
  route_table_id = aws_route_table.main.id
}

resource "aws_subnet" "subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-south-1c"
  map_public_ip_on_launch = true
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "eks-cluster"
  cluster_version = "1.31"

  cluster_endpoint_public_access = true
  
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id     = aws_vpc.main.id
  subnet_ids = [
    aws_subnet.subnet_1.id, 
    aws_subnet.subnet_2.id, 
    aws_subnet.subnet_3.id
  ]

  eks_managed_node_groups = {
    node = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m5.xlarge"]

      min_size     = 1
      max_size     = 1
      desired_size = 1

    }
  }
}

resource "null_resource" "helm_deploy" {
  provisioner "local-exec" {
    command = <<EOT
      # Check if Helm is installed, and install it if not
      if ! command -v helm &> /dev/null
      then
        echo "Helm not found. Installing Helm..."
        curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sudo bash
        
        # Ensure Helm is installed in /usr/local/bin
        HELM_PATH=/usr/local/bin/helm
        if [ ! -f "$HELM_PATH" ]; then
          echo "Error: Helm was not installed properly at $HELM_PATH"
          exit 1
        fi
      fi

      # Ensure Helm binary is executable (use sudo to change permissions)
      sudo chmod +x /usr/local/bin/helm

      # Explicitly add /usr/local/bin to PATH to ensure helm is found
      export PATH=$PATH:/usr/local/bin

      # Update kubeconfig for the EKS cluster
      aws eks update-kubeconfig --region ap-south-1 --name eks-cluster

      # Use full path for helm to avoid PATH issues
      /usr/local/bin/helm dependency update ./helm &&
      /usr/local/bin/helm upgrade --install java-spring-app ./helm --namespace default --create-namespace
    EOT
  }

  depends_on = [module.eks]
}
