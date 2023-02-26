resource "k3d-cluster" "demo" {
  connection {
    user        = "k3d"
    type        = "ssh"
    private_key = file("~/.ssh/id_rsa")
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "hostname",
      "lsb_release -a",
    ]
  }
}
