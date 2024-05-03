resource "null_resource" "config_master_vm" {
  depends_on = [module.master_domain]
  count      = length(module.master_domain)
  provisioner "remote-exec" {
    connection {
      host        = module.master_domain[0].address
      user        = var.user
      private_key = file("~/.ssh/id_rsa")
    }
    inline = ["echo ${module.master_domain[0].address} 'connected!'"]
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -u ${var.user}  -i ${module.master_domain[count.index].address}, --private-key '~/.ssh/id_rsa' ansible/utils/ping.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh -c -e  \"echo '${module.master_domain[count.index].address_ipv6} ${module.master_domain[count.index].name}' | sudo tee -a /etc/hosts\"",
      "sudo sh -c -e  \"echo '${module.master_domain[count.index].address} ${module.master_domain[count.index].name}' | sudo tee -a /etc/hosts\"",
    ]
    connection {
      type        = "ssh"
      user        = var.user
      host        = module.master_domain[count.index].address
      private_key = file("~/.ssh/id_rsa")
      timeout     = "20s"
    }
  }
}
resource "null_resource" "config_worker_vm" {
  depends_on = [module.worker_domain]
  count      = length(module.worker_domain)
  provisioner "remote-exec" {
    connection {
      host        = module.worker_domain[0].address
      user        = var.user
      private_key = file("~/.ssh/id_rsa")
    }
    inline = ["echo ${module.worker_domain[0].address} 'connected!'"]
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -u ${var.user}  -i ${module.worker_domain[count.index].address}, --private-key '~/.ssh/id_rsa' ansible/utils/ping.yaml"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo sh -c -e  \"echo '${module.worker_domain[count.index].address_ipv6} ${module.worker_domain[count.index].name}'| sudo tee -a /etc/hosts\"",
      "sudo sh -c -e  \"echo '${module.worker_domain[count.index].address} ${module.worker_domain[count.index].name}'| sudo tee -a /etc/hosts\"",
    ]
    connection {
      type        = "ssh"
      user        = var.user
      host        = module.worker_domain[count.index].address
      private_key = file("~/.ssh/id_rsa")
      timeout     = "20s"
    }
  }
}
resource "null_resource" "config_etcd_vm" {
  depends_on = [module.etcd_domain]
  count      = length(module.etcd_domain)
  provisioner "remote-exec" {
    connection {
      host        = module.etcd_domain[0].address
      user        = var.user
      private_key = file("~/.ssh/id_rsa")
    }
    inline = ["echo ${module.etcd_domain[0].address} 'connected!'"]
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -u ${var.user}  -i ${module.etcd_domain[count.index].address}, --private-key '~/.ssh/id_rsa' ansible/utils/ping.yaml"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo sh -c -e \"echo '${module.etcd_domain[count.index].address_ipv6} ${module.etcd_domain[count.index].name}' | sudo tee -a /etc/hosts\"",
      "sudo sh -c -e \"echo '${module.etcd_domain[count.index].address} ${module.etcd_domain[count.index].name}' | sudo tee -a /etc/hosts\""
    ]
    connection {
      type        = "ssh"
      user        = var.user
      host        = module.etcd_domain[count.index].address
      private_key = file("~/.ssh/id_rsa")
      timeout     = "20s"
    }
  }
}

resource "null_resource" "config_load_balancer_vm" {
  depends_on = [module.elb_domain]
  count      = length(module.elb_domain)
  provisioner "remote-exec" {
    connection {
      host        = module.elb_domain[0].address
      user        = var.user
      private_key = file("~/.ssh/id_rsa")
    }
    inline = ["echo ${module.elb_domain[0].address} 'connected!'"]
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -u ${var.user}  -i ${module.elb_domain[count.index].address}, --private-key '~/.ssh/id_rsa' ansible/utils/ping.yaml"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo sh -c -e \"echo '${module.elb_domain[count.index].address_ipv6} ${module.elb_domain[count.index].name}' | sudo tee -a /etc/hosts\"",
      "sudo sh -c -e \"echo '${module.elb_domain[count.index].address} ${module.elb_domain[count.index].name}' | sudo tee -a /etc/hosts\""
    ]
    connection {
      type        = "ssh"
      user        = var.user
      host        = module.elb_domain[count.index].address
      private_key = file("~/.ssh/id_rsa")
      timeout     = "20s"
    }
  }
}
