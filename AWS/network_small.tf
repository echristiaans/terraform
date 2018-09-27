resource "aws_vpc" "vpc1" {
	cidr_block = "10.20.0.0/16"
	enable_dns_support = true
	enable_dns_hostnames = true
	tags {
		name="ascode.nl default VPC"
		Purpose="The basis of everything AWS"
		Creator="Erik Christiaans"
	}
}

resource "aws_internet_gateway" "igw1" {
    vpc_id = "${aws_vpc.vpc1.id}"
}

resource "aws_eip" "eip1" {
	vpc = true
}

resource "aws_nat_gateway" "ngw1" {
  allocation_id = "${aws_eip.eip1.id}"
  subnet_id     = "${aws_subnet.eu-central-1a-public.id}"

  tags {
    Name = "NAT Gateway 1"
  }
}
/*
  Public Subnet
*/
resource "aws_subnet" "eu-central-1a-public" {
    vpc_id = "${aws_vpc.vpc1.id}"

    #cidr_block = "${var.public_subnet_cidr}"
		cidr_block = "10.20.10.0/24"
    availability_zone = "eu-central-1a"
		map_public_ip_on_launch = false

		depends_on = ["aws_internet_gateway.igw1"]

    tags {
        Name = "Public Subnet 1"
    }
}

resource "aws_route_table" "eu-central-1a-public" {
    vpc_id = "${aws_vpc.vpc1.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw1.id}"
    }

    tags {
        Name = "Public Routetable"
    }
}

resource "aws_route_table_association" "eu-central-1a-public" {
    subnet_id = "${aws_subnet.eu-central-1a-public.id}"
    route_table_id = "${aws_route_table.eu-central-1a-public.id}"
}

/*
  Private Subnet
*/
resource "aws_subnet" "eu-central-1a-private" {
    vpc_id = "${aws_vpc.vpc1.id}"

    #cidr_block = "${var.private_subnet_cidr}"
		cidr_block = "10.20.20.0/24"
		availability_zone = "eu-central-1a"
		map_public_ip_on_launch = false

			depends_on = ["aws_nat_gateway.ngw1"]

    tags {
        Name = "Private Subnet 1"
    }
}

resource "aws_route_table" "eu-central-1a-private" {
    vpc_id = "${aws_vpc.vpc1.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.ngw1.id}"
    }

    tags {
        Name = "Private Routetable"
    }
}

resource "aws_route_table_association" "eu-central-1a-private" {
    subnet_id = "${aws_subnet.eu-central-1a-private.id}"
    route_table_id = "${aws_route_table.eu-central-1a-private.id}"
}

resource "aws_security_group" "sgwebportsfromany" {
	name = "sgwebportsfromany"
	description = "Enable Web Ports Ingress"
	vpc_id = "${aws_vpc.vpc1.id}"

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
	vpc_id = "${aws_vpc.vpc1.id}"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["198.39.100.45/32"]
	}
}

resource "aws_security_group" "sgsshfromhome" {
	name = "sgsshfromhome"
	description = "Enable SSH Ingress from Home"
	vpc_id = "${aws_vpc.vpc1.id}"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["217.100.96.50/32"]
	}
}

resource "aws_security_group" "sgrdpfromaegon" {
	name = "sgrdpfromaegon"
	description = "Enable RDP Ingress from Aegon"
	vpc_id = "${aws_vpc.vpc1.id}"

	ingress {
		from_port = 3389
		to_port = 3389
		protocol = "tcp"
		cidr_blocks = ["198.39.100.45/32"]
	}
}

resource "aws_security_group" "sgrdpfromhome" {
	name = "sgrdpfromhome"
	description = "Enable RDP Ingress from Home"
	vpc_id = "${aws_vpc.vpc1.id}"

	ingress {
		from_port = 3389
		to_port = 3389
		protocol = "tcp"
		cidr_blocks = ["217.100.96.50/32"]
	}
}

resource "aws_security_group" "sgsshfrombastion" {
	name = "sgsshfrombastion"
	description = "Enable SSH Ingress from Bastion"
	vpc_id = "${aws_vpc.vpc1.id}"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["10.20.10.10/32"]
	}
}

resource "aws_security_group" "sgsqlfromwebservers" {
	name = "sgsqlfromwebservers"
	description = "Enable SQL Server ports from specified servers"
	vpc_id = "${aws_vpc.vpc1.id}"

	ingress {
		from_port = 1433
		to_port = 1433
		protocol = "tcp"
		cidr_blocks = ["10.20.20.100/32"]
	}
}

resource "aws_security_group" "sgwithoutegress" {
	name = "sgwithoutegress"
	description = "Limits security group egress traffic"
	vpc_id = "${aws_vpc.vpc1.id}"

	egress {
		from_port = 0
		to_port = 0
		protocol = -1
		cidr_blocks = ["127.0.0.1/32"]
	}
}
/*
	output "vpc_id" {
	value="${join(", ", aws_vpc.vpc1.id)}"
}
*/
