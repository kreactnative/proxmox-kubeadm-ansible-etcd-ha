resource "null_resource" "ansible_elb" {
  depends_on = [module.elb_domain,local_file.haproxy_config, null_resource.config_load_balancer_vm]

  provisioner "remote-exec" {
    connection {
      host        = module.elb_domain[0].address
      user        = var.user
      private_key = file("~/.ssh/id_rsa")
    }
    inline = ["echo ${module.elb_domain[0].address} 'connected!'"]
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -u ${var.user}  -i ${module.elb_domain[0].address}, --private-key '~/.ssh/id_rsa' ansible/monitoring/install_os_utils.yaml"
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -u ${var.user}  -i ${module.elb_domain[0].address}, --private-key '~/.ssh/id_rsa' ansible/haproxy/install_haproxy.yaml --extra-vars \"root_path=${path.cwd}\""
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -u ${var.user}  -i ${module.elb_domain[0].address}, --private-key '~/.ssh/id_rsa' ansible/firewall/enable_elb_firewall.yaml"
  }
}