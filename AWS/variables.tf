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

variable "aws_account_id" {
	description = "the AWS account number"
	default = ""
}
variable "environment" {
	description = "The type of environment"
	default = "dev"
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

variable "KMSAccessArns" {
	description = "ARN's that have access to certain resources"
	type = "map"
	default = {
		"dev" = ["arn:aws:iam::333221462033:role/UENTAWSNLBISMIGRATIONSACCELERATOR01", "arn:aws:iam::333221462033:role/Packer-Role", "arn:aws:iam::333221462033:role/DevBox-Role", "arn:aws:iam::333221462033:user/SVC-BAMBOO-BISMIGRATIONSDEV"]
	}
}

variable "KMSDenyArns" {
	description = "ARN's that are denied access to certain resources"
	type = "map"
	default = {
		"dev" = ["arn:aws:iam::333221462033:role/UENTAWSWEBSUP"]
  }
}

variable "euwest1_amis" {
	description "The list of amis to use"
	type = "map"
	default = {
		"centos7" = "ami-6e28b517"
		"rhel7" = "ami-05698d485c833cd78"
		"amzn" = "ami-05c6315766e0a386e"
	}
}
