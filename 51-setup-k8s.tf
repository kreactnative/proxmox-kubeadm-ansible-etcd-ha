resource "null_resource" "ansible_master" {
  depends_on = [module.master_domain, null_resource.config_master_vm]
  count      = var.MASTER_COUNT

  provisioner "remote-exec" {
    connection {
      host        = module.master_domain[count.index].address
      user        = var.user
      private_key = file("~/.ssh/id_rsa")
    }
    inline = ["echo ${module.master_domain[count.index].address} 'connected!'"]
  }

  provisioner "local-exec" {
    command = "ansible-playbook  -i ${module.master_domain[count.index].address}, --private-key '~/.ssh/id_rsa' ansible/monitoring/install_os_utils.yaml"
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${module.master_domain[count.index].address}, --private-key '~/.ssh/id_rsa' ansible/k8s/install_k8s.yaml"
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${module.master_domain[count.index].address}, --private-key '~/.ssh/id_rsa' ansible/firewall/enable_k8s_firewall.yaml"
  }
}

resource "null_resource" "ansible_worker" {
  depends_on = [module.worker_domain, null_resource.config_worker_vm]
  count      = var.WORKER_COUNT

  provisioner "remote-exec" {
    connection {
      host        = module.worker_domain[count.index].address
      user        = var.user
      private_key = file("~/.ssh/id_rsa")
    }
    inline = ["echo ${module.worker_domain[count.index].address} 'connected!'"]
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${module.worker_domain[count.index].address}, --private-key '~/.ssh/id_rsa' ansible/monitoring/install_os_utils.yaml"
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${module.worker_domain[count.index].address}, --private-key '~/.ssh/id_rsa' ansible/k8s/install_k8s.yaml"
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${module.worker_domain[count.index].address}, --private-key '~/.ssh/id_rsa' ansible/firewall/enable_k8s_firewall.yaml"
  }
}
