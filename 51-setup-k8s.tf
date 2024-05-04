resource "ansible_playbook" "setup_master" {
  count                   = length(module.master_domain)
  playbook                = "ansible/k8s/install_k8s.yaml"
  name                    = module.master_domain[count.index].address
  replayable              = false
  ignore_playbook_failure = false
  extra_vars = {
    private_key      = file("~/.ssh/id_rsa")
    ansible_ssh_user = var.user
  }
  depends_on = [
    ansible_playbook.master_etc_host
  ]
}
resource "ansible_playbook" "setup_worker" {
  count                   = length(module.worker_domain)
  playbook                = "ansible/k8s/install_k8s.yaml"
  name                    = module.worker_domain[count.index].address
  replayable              = false
  ignore_playbook_failure = false
  extra_vars = {
    private_key      = file("~/.ssh/id_rsa")
    ansible_ssh_user = var.user
  }
  depends_on = [
    ansible_playbook.worker_etc_host
  ]
}

resource "ansible_playbook" "setup_master_firewall" {
  count                   = length(module.master_domain)
  playbook                = "ansible/firewall/enable_k8s_firewall.yaml"
  name                    = module.master_domain[count.index].address
  replayable              = true
  ignore_playbook_failure = false
  extra_vars = {
    private_key      = file("~/.ssh/id_rsa")
    ansible_ssh_user = var.user
  }
  depends_on = [
    ansible_playbook.master_etc_host
  ]
}
resource "ansible_playbook" "setup_worker_firewall" {
  count                   = length(module.worker_domain)
  playbook                = "ansible/firewall/enable_k8s_firewall.yaml"
  name                    = module.worker_domain[count.index].address
  replayable              = true
  ignore_playbook_failure = false
  extra_vars = {
    private_key      = file("~/.ssh/id_rsa")
    ansible_ssh_user = var.user
  }
  depends_on = [
    ansible_playbook.worker_etc_host
  ]
}
