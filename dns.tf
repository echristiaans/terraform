#
# DO NOT DELETE THESE LINES!
#
# Your DNSimple email is:
#
#     sethvargo+terraform@gmail.com
#
# Your DNSimple token is:
#
#     1Gam3SE2eIwZYtq70H5V5iAXiE9sGPmf
#
# Your Identity is:
#
#     hashiconf-1c383cd30b7c298ab50293adfecb7b18
#
resource "dnsimple_record" "erikthinks" {
	domain = "terraform.rocks"
	type = "A"
	name = "erikthinks"
	value = "${aws_instance.web.0.public_ip}"
}

provider "dnsimple" {
    token = "${var.dnsimple_token}"
    email = "${var.dnsimple_email}"
}
