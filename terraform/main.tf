module "vpc" {
  source          = "./modules/vpc"
  cidr_block      = "10.0.0.0/16"
  subnet_1_cidr   = "10.0.1.0/24"
  subnet_2_cidr   = "10.0.2.0/24"
  subnet_3_cidr   = "10.0.3.0/24"
  subnet_1_az     = "ap-south-1a"
  subnet_2_az     = "ap-south-1b"
  subnet_3_az     = "ap-south-1c"
}

module "eks" {
  source                          = "./modules/eks"
  cluster_name                    = "eks-cluster"
  cluster_version                 = "1.31"
  cluster_endpoint_public_access  = true
  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.subnet_ids
}
