resource "null_resource" "cluster_create" {
  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    user        = "k3d"
    host        = "k3d-cluster"
    type        = "ssh"
    private_key = file("~/.ssh/id_rsa")
    timeout     = "2m"
  }

  for_each = toset(var.k3d_cluster_name)
  provisioner "remote-exec" {
    inline = [
      "k3d cluster create ${each.key} \\",
      "--agents ${var.agent_count} \\",
      "--servers ${var.server_count} \\",
      "--api-port ${var.k3d_cluster_ip}:${var.k3d_cluster_port} \\",
      "--port ${var.k3d_host_lb_port}:${var.k3d_cluster_lb_port}@loadbalancer \\",
      "--image rancher/k3s:${var.k3s_version}",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "k3d cluster list #${each.key}",
    ]
  }

  #  provisioner "file" {
  #    source      = "script.sh"
  #    destination = "/tmp/script.sh"
  #  }
  #
  #  provisioner "remote-exec" {
  #    inline = [
  #      "chmod +x /tmp/script.sh",
  #      "/tmp/script.sh args",
  #    ]
  #  }
}

resource "null_resource" "cluster_delete" {
  connection {
    user        = "k3d"
    host        = "k3d-cluster"
    type        = "ssh"
    private_key = file("~/.ssh/id_rsa")
    timeout     = "2m"
  }

  for_each = toset(var.k3d_cluster_name)
  provisioner "remote-exec" {
    inline = ["k3d cluster delete ${each.key}"]
    when    = destroy
  }
}

#data "docker_network" "cluster_create" {
#  for_each = toset(var.k3d_cluster_name)
#  depends_on = [
#    null_resource.cluster_create
#  ]
#  name = "k3d-${each.key}"
#}
