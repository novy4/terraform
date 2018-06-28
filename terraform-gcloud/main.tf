variable "gloud_key" { default = "key.json" }
variable "proj_name" { default = "turnkey-channel-" }
variable "region" { default = "europe-west1" }
variable "region_zone" { default = "europe-west1-b" }
variable "ssh_user" { default = "novy"}
variable "public_key_path" { default = "~/.ssh/id_rsa.pub" }
variable "private_key_path" { default = "~/.ssh/id_rsa" }

#PROVIDER

provider  "google" {
	credentials = "${var.gloud_key}"
	project = "${var.proj_name}"
	region = "${var.region}"
}

#RESOURCES

resource "google_compute_instance" "nginx" {
	boot_disk = {
		initialize_params {
			image = "centos-7"
			size = "20"
		}
	}

	zone = "${var.region_zone}"
	#count = 2
	tags = ["nginx"]
	machine_type = "n1-standard-1"
	name = "nginx"

	network_interface = {
		network = "default"

		access_config = {

		}
	}

	metadata {
		ssh-keys = "${var.ssh_user}:${file(var.public_key_path)}"
	}
	connection {
		type = "ssh"
		user = "${var.ssh_user}"
		private_key = "${file(var.private_key_path)}"
	}
	provisioner "remote-exec" {
		inline = [
			"sudo yum install nginx -y",
			"sudo service nginx start"

		]
	}
}

resource "google_compute_firewall" "default" {
	name = "nginx"
	network = "default"

	allow {
		protocol = "tcp"
		ports = ["80", "443"]
	}
	source_ranges = ["0.0.0.0/0"]
	target_tags = ["nginx"]
}

output "gce_public_adress" {
	value = "${google_compute_instance.nginx.network_interface.0.access_config.0.assigned_nat_ip}"
}
