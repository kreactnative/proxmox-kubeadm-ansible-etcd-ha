resource "null_resource" "test_create_master_vm" {
  depends_on = [module.master_domain]
  count      = length(module.master_domain)
  provisioner "remote-exec" {
    inline = [
      "sudo hostname",
      "cat /etc/hosts",
      "date"
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
resource "null_resource" "test_create_worker_vm" {
  depends_on = [module.worker_domain]
  count      = length(module.worker_domain)
  provisioner "remote-exec" {
    inline = [
      "sudo hostname",
      "cat /etc/hosts",
      "date"
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
resource "null_resource" "test_create_etcd_vm" {
  depends_on = [module.etcd_domain]
  count      = length(module.etcd_domain)
  provisioner "remote-exec" {
    inline = [
      "sudo hostname",
      "cat /etc/hosts",
      "date"
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
