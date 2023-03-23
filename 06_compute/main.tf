terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      School  = var.school
      Project = var.project
    }
  }
}

module "network" {
  source  = "./modules/network"
  region  = var.region
  project = var.project
}

module "compute" {
  source  = "./modules/compute"
  project = var.project
  vpc_id  = module.network.vpc_id
}
