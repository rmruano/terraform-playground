variable "aws_region" {
  description = "The AWS region to deploy your instance"
  default     = "eu-west-2"
}
variable "aws_region_az_1" {
  description = ""
  default     = "eu-west-2a"
}
variable "aws_region_az_2" {
  description = ""
  default     = "eu-west-2b"
}
variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "172.16.0.0/16"
}
variable "cidr_subnet_1" {
  description = "CIDR block for the first subnet"
  default     = "172.16.10.0/24"
}
variable "cidr_subnet_2" {
  description = "CIDR block for the second subnet"
  default     = "172.16.20.0/24"
}
variable "name" {
  description = "The common prefix for all names"
  default     = "tf-vpc-lb-sample"
}
variable "keypair_name" {
  description = "The aws keypair name to use, it must exist on the region"
  sensitive   = true
}