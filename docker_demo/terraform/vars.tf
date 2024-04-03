variable "environment" {
  type        = string
  description = "Deployment Environment Name"
}

variable "image" {
  type        = string
  description = "Image URI"
}

variable "vpc_id" {
  type        = string
  description = "Deployment VPC ID"
  default     = "vpc-0a6ee76d7249f835a"
}
