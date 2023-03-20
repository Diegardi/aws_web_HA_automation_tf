variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "stage" {
  description = "stage"
  type        = string
  default     = "sandbox-poc"
}

variable "training_vpc" {
  description = "VPC for POC training DG"
  type        = string
  default     = "10.0.0.0/16"
}

variable "ami_id" {
  description = "ami id"
  type        = string
  default     = "ami-0022f774911c1d690"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}