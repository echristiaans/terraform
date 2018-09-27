resource "aws_security_group" "sgwebportsfromany" {
	name = "sgwebportsfromany"
	description = "Enable Web Ports Ingress"
	vpc_id = "${data.aws_vpc.vpc1.id}"

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	ingress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_security_group" "sgsshfromaegon" {
	name = "sgsshfromaegon"
	description = "Enable SSH Ingress from Aegon"
	vpc_id = "${data.aws_vpc.vpc1.id}"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["198.39.100.45/32"]
	}
}

resource "aws_security_group" "sgrdpfromaegon" {
	name = "sgrdpfromaegon"
	description = "Enable RDP Ingress from Aegon"
	vpc_id = "${data.aws_vpc.vpc1.id}"

	ingress {
		from_port = 3389
		to_port = 3389
		protocol = "tcp"
		cidr_blocks = ["198.39.100.45/32"]
	}
}

resource "aws_security_group" "sgwithoutegress" {
	name = "sgwithoutegress"
	description = "Limits security group egress traffic"
	vpc_id = "${data.aws_vpc.vpc1.id}"

	egress {
		from_port = 0
		to_port = 0
		protocol = -1
		cidr_blocks = ["127.0.0.1/32"]
	}
}

resource "aws_security_group" "sgsqlfromworkspace" {
	name = "sgsqlfromworkspace"
	description = "Enable SQL access from Aegon Workspace"
	vpc_id = "${data.aws_vpc.vpc1.id}"

	ingress {
		from_port = 1433
		to_port = 1433
		protocol = "tcp"
		cidr_blocks = ["10.37.104.0/23"]
	}
}
