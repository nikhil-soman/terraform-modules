variable "remote-state-s3-bucket" {
    description = "The name of the S3 bucket to which the remote terraform state files are saved"
}

variable "s3-key-name" {
    description = "The name of the Key for remote state S3 bucket"
}

variable "ec2_instance_type" {
    description = "The instance type of the EC2 instance to be used in the Launch configuration"
}

variable "environment_name" {
    description = "The name of the Environment"
}

variable "min_cluster-size" {
    description = "The minimum size of the EC2 cluster"
}

variable "max_cluster-size" {
    description = "The maximum size of the EC2 cluster"
}

variable "server_port" {
    description = "The port of the web server"
}

variable "cidr_range" {
    description = "The CIDR rage from which the incoming traffic should be allowed"
}

variable "elb_port" {
    description = "The port of the ELB"
}