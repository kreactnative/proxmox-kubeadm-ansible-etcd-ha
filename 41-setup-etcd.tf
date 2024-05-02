resource "null_resource" "ansible_etcd" {
  depends_on = [module.etcd_domain, docker_container.generate_etcd_config]
  count      = var.ETCD_COUNT

  provisioner "remote-exec" {
    connection {
      host        = module.etcd_domain[count.index].address
      user        = var.user
      private_key = file("~/.ssh/id_rsa")
    }
    inline = ["echo ${module.etcd_domain[count.index].address} 'connected!'"]
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${module.etcd_domain[count.index].address}, --private-key '~/.ssh/id_rsa' ansible/etcd/install_etcd.yaml --extra-vars 'index=${count.index + 1} root_path=${path.cwd}'"
  }
}