provider "packet" {
  auth_token = var.auth_token
}

# run once only
# resource "packet_project" "kubenet" {
#   name = "k8s-bgp"

#   bgp_config {
#     deployment_type = "local"
#     asn             = 65000
#   }
# }

data "packet_project" "kubenet" {
  name = "k8s-bgp"
}

variable "facilities" {
  default = ["ewr1"]
}

variable "worker_count" {
  default = 2
}

variable "controller_plan" {
  description = "Set the Packet server type for the controller"
  default     = "t1.small.x86"
}

variable "worker_plan" {
  description = "Set the Packet server type for the workers"
  default     = "t1.small.x86"
}

// General template used to install docker on Ubuntu 16.04
data "template_file" "install_docker" {
  template = "${file("${path.module}/templates/install-docker.sh.tpl")}"

  vars = {
    docker_version = var.docker_version
  }
}

data "template_file" "install_kubernetes" {
  template = "${file("${path.module}/templates/setup-kube.sh.tpl")}"

  vars = {
    kubernetes_version = var.kubernetes_version
  }
}
