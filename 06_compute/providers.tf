provider "aws" {
  region = var.region
  default_tags {
    tags = {
      project = var.project
      school  = var.school
    }
  }
}

provider "random" {
}

provider "archive" {
}
