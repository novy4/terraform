### LOAD BALANCER ###
resource "aws_elb" "web" {
    name = "nginx-elb"
    subnets = ["${aws_subnet.blue.id}", "${aws_subnet.green.id}"]
    security_groups = ["${aws_security_group.elb-sg.id}"]
    instances = ["${aws_instance.nginx1.id}", "${aws_instance.nginx2.id}"]

    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }
}