### VPCs ###
resource "aws_vpc" "vpc" {
    cidr_block = "${var.network_address_space}"
    enable_dns_hostnames = "true"  
}
### SUBNETS ###
resource "aws_subnet" "blue" {
    cidr_block              = "${var.subnet1_address_space}"
    vpc_id                  = "${aws_vpc.vpc.id}"
    map_public_ip_on_launch = "true"
    availability_zone       = "${data.aws_availability_zones.available.names[0]}"
}

resource "aws_subnet" "green" {
    cidr_block              = "${var.subnet2_address_space}"
    vpc_id                  = "${aws_vpc.vpc.id}"
    map_public_ip_on_launch = "true"
    availability_zone       = "${data.aws_availability_zones.available.names[1]}"
}
### INTERNET GATEWAYS ###
resource "aws_internet_gateway" "inet" {
    vpc_id = "${aws_vpc.vpc.id}"
}
### ROUTE TABLES ###
resource "aws_route_table" "rtb" {
    vpc_id = "${aws_vpc.vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.inet.id}"
    }
}
resource "aws_route_table_association" "rta_subnet1" {
    subnet_id      = "${aws_subnet.blue.id}"
    route_table_id = "${aws_route_table.rtb.id}"
}
resource "aws_route_table_association" "rta_subnet2" {
    subnet_id      = "${aws_subnet.green.id}"
    route_table_id = "${aws_route_table.rtb.id}"
}
### SECURITY GROUPS ###
resource "aws_security_group" "nginx" {
    name   = "tf-workshop"
    vpc_id = "${aws_vpc.vpc.id}"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_security_group" "elb-sg" {
name = "nginx_elb_sg"
vpc_id = "${aws_vpc.vpc.id}"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
