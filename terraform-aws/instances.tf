resource "aws_instance" "nginx1" {
    ami                    = "ami-c58c1dd3"
    instance_type          = "t2.micro"
    subnet_id              = "${aws_subnet.blue.id}"
    vpc_security_group_ids = ["${aws_security_group.nginx.id}"]
    key_name               =  "${aws_key_pair.novy1.id}"

    connection {
        user        = "ec2-user"
        private_key = "${file(var.private_key_path)}"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo yum install nginx -y",
            "sudo service nginx start",
            "echo '<html><head><title>Blue Team Server</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"28px;\">Blue Team</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html"
        ]
    }  
}

resource "aws_instance" "nginx2" {
    ami                    = "ami-c58c1dd3"
    instance_type          = "t2.micro"
    subnet_id              = "${aws_subnet.green.id}"
    vpc_security_group_ids = ["${aws_security_group.nginx.id}"]
    key_name               = "${aws_key_pair.novy1.id}"

    connection {
        user = "ec2-user"
        private_key = "${file(var.private_key_path)}"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo yum install nginx -y",
            "sudo service nginx start",
            "echo '<html><head><title>Green Team Server</title></head><body style=\"background-color:#77A032\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"28px;\">Green Team</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html"
        ]
    }
}