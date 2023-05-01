
variable "vpc_name" {
  default = "base-vpc"
}

locals {
  tags = {
    "kubernetes.io/cluster/${var.project}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.project}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
    "Tier"                                        = "public"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.project}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
    "Tier"                                        = "private"
  }
  database_subnet_tags = {
    "Tier"                                        = "database"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.70.0"

  name = var.vpc_name
  cidr = var.cidr
  azs  = data.aws_availability_zones.available.names
  ## Allow a limited number of "public" addresses.  NOMINALLY we'd use an ALB or two or ingress controllers vs. lots of individual public addresses
  public_subnets = [
    #Given a /20 this would allow 256 addresses PER subnet so a total of 728 addresses
    cidrsubnet(var.cidr, 4, 1),
    cidrsubnet(var.cidr, 4, 2),
    cidrsubnet(var.cidr, 4, 3)
  ]
  private_subnets = [
    #Given a /20 this would allow 512 addresses PER subnet so a total of over 1500 addresses
    cidrsubnet(var.cidr, 3, 3),
    cidrsubnet(var.cidr, 3, 4),
    cidrsubnet(var.cidr, 3, 5)]
  # Allow for redis/elasticache/rds/etc.
  database_subnets = [
    #Given a /20 this would allow 512 addresses PER subnet so a total of over 1500 addresses
    cidrsubnet(var.cidr, 4, 13),
    cidrsubnet(var.cidr, 4, 14),
    cidrsubnet(var.cidr, 4, 15)
  ]
  enable_nat_gateway   = true
##  With this defaut is false, will create one for the maximum length of subnets. So with 3 db subnets, 3 private, you'd get 3 nat gateways.  With 4 db subnets, 3 private, you'd get 4 nat gateways
  single_nat_gateway   = false
  enable_dns_hostnames = true
  enable_s3_endpoint = true
  #enable_ssm_endpoint = true

  tags = merge(local.tags,var.tags)

  public_subnet_tags = merge(local.public_subnet_tags,var.tags)

  private_subnet_tags = merge(local.private_subnet_tags,var.tags)
  database_subnet_tags = merge(local.database_subnet_tags,var.tags)
}

/*
This should wipe out any default rules and force to avoid using the default security group
*/
resource "aws_default_security_group" "sg_default" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Name = "DO_NOT_USE"
  }
}