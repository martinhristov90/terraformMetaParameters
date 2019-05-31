variable "instanceCount" {}

provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "web" {
    ami = "ami-0444fa3496fb4fab2"
    instance_type = "t2.micro"
    # Defining how many the resource to be reproduced. 
    count = "${var.instanceCount}"

    subnet_id = "subnet-2f591701"
    vpc_security_group_ids = [
        "sg-3ddbcb64"
    ]

    tags {
        "name" = "MYMACHINE-${count.index + 1}"

    }
}
# Showing the list of public ip address of the created resources.
output "public_ip" {
  value = "${aws_instance.web.*.public_ip}"
}

