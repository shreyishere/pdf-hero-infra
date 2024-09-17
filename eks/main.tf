# VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "pdf-hero-eks-vpc"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.azs.names
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  tags = {
    Name                                         = "pdf-hero-vpc"
    Terraform                                    = "true"
    "kubernetes.io/cluster/pdf-hero-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    Name                                         = "pdf-hero-public-subnet"
    "kubernetes.io/cluster/pdf-hero-eks-cluster" = "shared"
    "kubernetes.io/role/elb"                     = 1
  }

  private_subnet_tags = {
    Name                                         = "pdf-hero-private-subnet"
    "kubernetes.io/cluster/pdf-hero-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"            = 1
  }
}

# EKS
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "pdf-hero-eks-cluster"
  cluster_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    nodes = {
      min_size       = 1
      max_size       = 3
      desired_size   = 2
      instance_types = ["t2.small"]
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}