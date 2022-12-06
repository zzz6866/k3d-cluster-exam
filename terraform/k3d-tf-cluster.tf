provider "k3d" {
  # example configuration here

  connection {
    user        = "ubuntu"
    type        = "ssh"
    private_key = file("~/.ssh/id_rsa")
    timeout     = "2m"
  }
}

resource "k3d_cluster" "k3d-tf-cluster" {
  name    = "k3d-tf-cluster"
  servers = 1
  agents  = 2

  kube_api {
#    host      = "my.domain"
    host_ip   = "127.0.0.1"
    host_port = 6445
  }

  image   = "rancher/k3s:v1.24.4-k3s1"
  network = "k3d-tf-network"
  token   = "superSecretToken"

  volume {
    source      = "/my/host/path"
    destination = "/path/in/node"
    node_filters = [
      "server[0]",
      "agent[*]",
    ]
  }

  port {
    host_port      = 8080
    container_port = 80
    node_filters = [
      "loadbalancer",
    ]
  }

  label {
    key   = "foo"
    value = "bar"
    node_filters = [
      "agent[1]",
    ]
  }

  env {
    key   = "bar"
    value = "baz"
    node_filters = [
      "server[0]",
    ]
  }

#  registries {
#    create = {
#      name      = "my-registry"
#      host      = "my-registry.local"
#      image     = "docker.io/some/registry"
#      host_port = "5001"
#    }
#    use = [
#      "k3d-myotherregistry:5000"
#    ]
#    config = <<EOF
#mirrors:
#  "my.company.registry":
#    endpoint:
#      - http://my.company.registry:5000
#EOF
#  }

  k3d {
    disable_load_balancer = false
    disable_image_volume  = false
  }

#  k3s {
#    extra_args = [{
#      arg          = "--tls-san=my.host.domain",
#      node_filters = ["agent"]
#    }]
#  }

  kubeconfig {
    update_default_kubeconfig = true
    switch_current_context    = true
  }

  runtime {
    gpu_request = "all"
  }
}

resource "k3d_node" "k3d-tf-node" {
  name = "k3d-tf-node"

  cluster = "k3d-tf-cluster"
  image   = "rancher/k3s:v1.24.4-k3s1"
  memory  = "512M"
  role    = "agent"
}