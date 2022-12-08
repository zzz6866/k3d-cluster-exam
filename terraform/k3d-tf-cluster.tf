resource "null_resource" "k3d-cluster" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    user        = "k3d"
    host        = "k3d-cluster"
    type        = "ssh"
    private_key = file("~/.ssh/id_rsa")
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "echo asdfasdf",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "ps -ef | tail -n 10",
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
