resource "ansible_playbook" "setup_etcd" {
  count                   = length(module.etcd_domain)
  playbook                = "ansible/etcd/install_etcd.yaml"
  name                    = module.etcd_domain[count.index].address
  replayable              = false
  ignore_playbook_failure = false
  extra_vars = {
    private_key      = file("~/.ssh/id_rsa")
    ansible_ssh_user = var.user
    ansible_ssh_user = var.user
    index            = count.index + 1
    root_path        = path.cwd
  }
  depends_on = [
    ansible_playbook.etcd_etc_host
  ]
}

resource "ansible_playbook" "setup_etcd_firewall" {
  count                   = length(module.etcd_domain)
  playbook                = "ansible/firewall/enable_etcd_firewall.yaml"
  name                    = module.etcd_domain[count.index].address
  replayable              = true
  ignore_playbook_failure = false
  extra_vars = {
    private_key      = file("~/.ssh/id_rsa")
    ansible_ssh_user = var.user
  }
  depends_on = [
    ansible_playbook.setup_etcd
  ]
}
