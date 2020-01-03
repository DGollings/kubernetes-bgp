
resource "null_resource" "setup_linkerd" {
  connection {
    user    = "root"
    host    = packet_device.k8s_controller.access_public_ipv4
    timeout = "30m"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/install-linkerd.sh"
    destination = "/tmp/install-linkerd.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/*.sh",
      "/tmp/install-linkerd.sh 2>&1 | tee -a /var/log/linkerd_installation"
    ]
  }
  depends_on = [null_resource.setup_worker]
}
