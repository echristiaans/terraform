variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
	default = "eu-central-1"
}
variable "aws_key_path" {}
variable "aws_key_name" {}

variable "ubuntu_amis" {
    description = "Ubuntu AMIs by region"
    default = {
        eu-central-1 = "ami-7c412f13" # ubuntu 16.04 LTS
    }
}

variable "windows_amis" {
	description = "Windows Server 2016 AMIs by region"
	default = {
			eu-central-1 = "ami-b5530b5e" # ubuntu 16.04 LTS
	}
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.20.10.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.20.20.0/24"
}
