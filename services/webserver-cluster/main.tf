data "aws_availability_zones" "all_az" {}

data "terraform_remote_state" "mysql_rds" {
    backend = "s3"

    config = {
        bucket  = "${var.remote-state-s3-bucket}"
        region  = "ap-south-1"
        key     = "${var.s3-key-name}"
    }
}

data "template_file" "user_data" {
    template = "${file("${path.module}/user-data.sh")}"

    vars = {
        db_address = "${data.terraform_remote_state.mysql_rds.outputs.mysql_endpoint}"
        db_port = "${data.terraform_remote_state.mysql_rds.outputs.mysql_port}"
        server_port = "${var.server_port}"
    }
}

resource "aws_launch_configuration" "terraform-lc" {
    image_id = "ami-0e8710d48cc4ea8dd"
    instance_type = "${var.ec2_instance_type}"
    security_groups = ["${aws_security_group.terraform-ec2.id}"]

    user_data = "${data.template_file.user_data.rendered}"
    
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_security_group" "terraform-ec2" {
    name = "${var.environment_name}-ec2-sg"
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_security_group_rule" "allow_httpd_inbound" {
    type = "ingress"
    security_group_id = "${aws_security_group.terraform-ec2.id}"
    
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["${var.cidr_range}"]
}

resource aws_autoscaling_group "terraform-asg" {
    launch_configuration = "${aws_launch_configuration.terraform-lc.id}"
    availability_zones = "${data.aws_availability_zones.all_az.names}"

    load_balancers = ["${aws_elb.terraform-elb.name}"]
    health_check_type = "ELB"

    min_size = "${var.min_cluster-size}"
    max_size = "${var.max_cluster-size}"

    tag {
        key = "Name"
        value = "${var.environment_name}-asg"
        propagate_at_launch = true
    }
}


resource "aws_elb" "terraform-elb" {
    name = "${var.environment_name}-elb"
    availability_zones = "${data.aws_availability_zones.all_az.names}"
    security_groups = ["${aws_security_group.terraform-elb-sg.id}"]

    listener {
        lb_port = "${var.elb_port}"
        lb_protocol = "http"
        instance_port = "${var.server_port}"
        instance_protocol = "http"
    }
    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        interval = 15
        target = "HTTP:${var.server_port}/"
    }

}

resource "aws_security_group" "terraform-elb-sg" {
    name = "${var.environment_name}-elb-sg"
}

resource "aws_security_group_rule" "elb_inbound" {
    type = "ingress"
    security_group_id = "${aws_security_group.terraform-elb-sg.id}"
        
    from_port = "${var.elb_port}"
    to_port = "${var.elb_port}"
    protocol = "tcp"
    cidr_blocks = ["${var.cidr_range}"]
}

resource "aws_security_group_rule" "elb_outbound" {
    type = "egress"
    security_group_id = "${aws_security_group.terraform-elb-sg.id}"

    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.cidr_range}"]
}