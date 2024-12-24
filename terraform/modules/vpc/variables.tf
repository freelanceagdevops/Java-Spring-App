variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "subnet_1_cidr" {
  description = "The CIDR block for Subnet 1"
  type        = string
}

variable "subnet_2_cidr" {
  description = "The CIDR block for Subnet 2"
  type        = string
}

variable "subnet_3_cidr" {
  description = "The CIDR block for Subnet 3"
  type        = string
}

variable "subnet_1_az" {
  description = "The availability zone for Subnet 1"
  type        = string
}

variable "subnet_2_az" {
  description = "The availability zone for Subnet 2"
  type        = string
}

variable "subnet_3_az" {
  description = "The availability zone for Subnet 3"
  type        = string
}
