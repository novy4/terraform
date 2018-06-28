### VARIABLES ###
variable "aws_access_key" { default = "AKIAJQKE7XXXXXXXX" }
variable "aws_secret_key" { default = "MS7/T0fULyUylcbwW+h1F4JXXXXXXXXXXXXXXX" }
variable "private_key_path" { default = "~/.ssh/id_rsa" }
variable "key_name" { default = "novy1" }
variable "network_address_space" { default = "10.1.0.0/16" }
variable "subnet1_address_space" { default = "10.1.0.0/24" }
variable "subnet2_address_space" { default = "10.1.1.0/24" }
### PROVIDERS ###
provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region     = "us-east-1"
}
### KEY PAIRS ###
resource "aws_key_pair" "novy1" {
    key_name   = "${var.key_name}"
    public_key = "${file("~/.ssh/id_rsa.pub")}"
}
### ZONES ###
data "aws_availability_zones" "available" {}
### OUTPUTS ###
output "aws_elb_public_dns" {
  value = "${aws_elb.web.dns_name}"
}
