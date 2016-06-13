#
# DO NOT DELETE THESE LINES!
#
# Your subnet ID is:
#
#     subnet-99a58be2
#
# Your security group ID is:
#
#     sg-8e08dfe6
#
# Your AMI ID is:
#
#     ami-74ee001b
#
# Your Identity is:
#
#     hashiconf-1c383cd30b7c298ab50293adfecb7b18
#
# Your AccessKeyID and SecretAccessKey are:
#
#     AKIAJLFXKSJEYKCAZRQA
#     g/VwQWlfz4XN/P5bAPY1+KHgbz3l8lLW7lBC9MiR
#
resource "aws_instance" "web" {
	ami = "ami-74ee001b"
	instance_type = "t2.micro"
	subnet_id = "subnet-99a58be2"
	vpc_security_group_ids = ["sg-8e08dfe6"]
	count = "2"
	tags {
		Identity="hashiconf-1c383cd30b7c298ab50293adfecb7b18"
		Purpose="HashiConf 2016 test plan"
		Creator="Erik Christiaans"
	}
}

output "public_ip" {
	value="${join(", ", aws_instance.web.*.public_ip)}"
}

output "public_dns" {
	value="${join(", ", aws_instance.web.*.public_dns)}"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}
