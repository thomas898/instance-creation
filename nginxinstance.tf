provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "ap-south-1"
}


resource "aws_instance" "nginxinstance" {
  ami                    = "${var.nginxinstance_ami_id}"
  instance_type          = "${var.nginxinstance_instance_type}"
  key_name               = "${var.key_pair_name}"
  vpc_security_group_ids  = ["${aws_security_group.nginxinstance_sg.id}"]
  user_data              = "${data.template_file.nginxinstance_userdata.rendered}"
  iam_instance_profile   = "${aws_iam_instance_profile.nginxinstance_instance_profile.name}"
  associate_public_ip_address= true

  tags {
    Name        = "${var.env}-${var.service}-nginx"
    env         = "${var.env}"
    service     = "${var.service}"
    
  }

  subnet_id = "${var.nginxinstance_subnet_id}"
}

data "template_file" "nginxinstance_userdata" {
  template = "${file("${path.module}/templates/nginxinstance_userdata.sh.tpl")}"

  vars {

    env           = "${var.env}"
    service       = "${var.service}"
    
  }

}


resource "aws_security_group" "nginxinstance_sg" {
  name        = "nginxinstance_sg"
  description = "Allow  inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress = [{
    description = "http from everywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    description = "SSH from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  },
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nginxinstance_sg"
  }
}



resource "aws_iam_role" "nginxinstance_instance_role" {
  name = "${var.env}-${var.service}-role"
    assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
  {
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "ec2.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
  }
]
}
EOF
  

  
}

resource "aws_iam_policy_attachment" "nginxinstance_amazon_ecr_access" {
  name       = "amazon-ecr-access"
  roles      = ["${aws_iam_role.nginxinstance_instance_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "nginxinstance_instance_profile" {
  name  = "${var.env}-${var.service}-profile"
  roles = ["${aws_iam_role.nginxinstance_instance_role.name}"]
}





