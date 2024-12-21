provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "javaspring_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "javaspring-vpc"
  }
}

resource "aws_subnet" "javaspring_subnet" {
  count = 2
  vpc_id                  = aws_vpc.javaspring_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.javaspring_vpc.cidr_block, 8, count.index)
  availability_zone       = element(["ap-south-1a", "ap-south-1b"], count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "javaspring-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "javaspring_igw" {
  vpc_id = aws_vpc.javaspring_vpc.id

  tags = {
    Name = "javaspring-igw"
  }
}

resource "aws_route_table" "javaspring_route_table" {
  vpc_id = aws_vpc.javaspring_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.javaspring_igw.id
  }

  tags = {
    Name = "javaspring-route-table"
  }
}

resource "aws_route_table_association" "a" {
  count          = 2
  subnet_id      = aws_subnet.javaspring_subnet[count.index].id
  route_table_id = aws_route_table.javaspring_route_table.id
}

resource "aws_security_group" "javaspring_cluster_sg" {
  vpc_id = aws_vpc.javaspring_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "javaspring-cluster-sg"
  }
}

resource "aws_security_group" "javaspring_node_sg" {
  vpc_id = aws_vpc.javaspring_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "javaspring-node-sg"
  }
}

resource "aws_eks_cluster" "javaspring" {
  name     = "javaspring-cluster"
  role_arn = aws_iam_role.javaspring_cluster_role.arn

  vpc_config {
    subnet_ids         = aws_subnet.javaspring_subnet[*].id
    security_group_ids = [aws_security_group.javaspring_cluster_sg.id]
  }
}

resource "aws_eks_node_group" "javaspring" {
  cluster_name    = aws_eks_cluster.javaspring.name
  node_group_name = "javaspring-node-group"
  node_role_arn   = aws_iam_role.javaspring_node_group_role.arn
  subnet_ids      = aws_subnet.javaspring_subnet[*].id

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  remote_access {
    ec2_ssh_key = var.ssh_key_name
    source_security_group_ids = [aws_security_group.javaspring_node_sg.id]
  }
}

resource "aws_iam_role" "javaspring_cluster_role" {
  name = "javaspring-cluster-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "javaspring_cluster_role_policy" {
  role       = aws_iam_role.javaspring_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "javaspring_node_group_role" {
  name = "javaspring-node-group-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "javaspring_node_group_role_policy" {
  role       = aws_iam_role.javaspring_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "javaspring_node_group_cni_policy" {
  role       = aws_iam_role.javaspring_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "javaspring_node_group_registry_policy" {
  role       = aws_iam_role.javaspring_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
