resource "template_file" "user_data" {
  template = "templates/linux_user_data.tpl"
  vars {
    aws_region = "${var.aws_region}"
    resource_name = "${self.resource_name}"
  }
}
resource "aws_instance" "ac-lnx-t01" {
	ami = "${lookup(var.euwest1_amis, "amzn")}"
	availability_zone = "eu-west-1a"
	instance_type = "t2.small"
  key_name = "${var.aws_key_name}"
  vpc_security_group_ids = ["${aws_security_group.sgsshfromaegon.id}"]
  subnet_id = "${aws_subnet.eu-west-1a-private.id}"
  associate_public_ip_address = false
  user_data  = "${data.template_file.user_data.rendered}"

  provisioner "file" {
    source      = "conf/myapp.conf"
    destination = "/etc/myapp.conf"
  }
  root_block_device {

  }
  tags {
		name="ac-lnx-t01"
		Purpose="Test Linux instance"
		Creator="Erik Christiaans"
	}
}
