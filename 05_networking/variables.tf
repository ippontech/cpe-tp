variable "region" {
  type        = string
  description = "The region used to deploy resources"
  default     = "us-east-1"
}

variable "school" {
  type        = string
  description = "The school name"
  default     = "cpe"
}

variable "project" {
  type        = string
  description = "The project name"
  default     = "05_networking"
}
