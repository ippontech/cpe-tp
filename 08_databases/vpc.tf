module "vpc" {
  source  = "../modules/vpc"
  project = var.project
  region  = var.region
}
