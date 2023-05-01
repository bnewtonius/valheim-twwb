terraform {
  required_version = ">= 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.47"
    }
  }

  backend "s3" {
    # Update the remote backend below to support your environment
    bucket         = "bnewtonius-demo-tfstate"
    key            = "bnewtonius/bnewtonius-demo/us-east-2/terraform.tfstate"
    region         = "us-east-2"
    profile        = "armory-io"
    dynamodb_table = "app-state"
    encrypt        = true
  }
}

provider "aws" {
  region    = var.region
  profile   = "armory-io"
}

################################################################################
# Common Locals
################################################################################

locals {
  name        = "${var.project}"
  region      = "${var.region}"
  environment = "nonprod"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
}

################################################################################
# Common Data
################################################################################

data "aws_availability_zones" "available" {}