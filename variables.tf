variable "nginxinstance_ami_id" {
  default ="ami-042b34111b1289ccd"
}
variable "nginxinstance_instance_type" {
  default ="t3a.medium"
}
variable "key_pair_name" {
  default ="keyname"
}
variable "vpc_id" {
  default ="vpcid"
}

variable "env" {
  default ="dev"
}

variable "service" {
  default="nginxinstance"
}


variable "nginxinstance_subnet_id" {
  default="pub-subnet-id"
}



