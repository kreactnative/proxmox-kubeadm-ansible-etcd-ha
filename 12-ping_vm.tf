resource "ansible_playbook" "master_ping" {
  count                   = length(module.master_domain)
  playbook                = "ansible/utils/upgrade.yaml"
  name                    = module.master_domain[count.index].address
  replayable              = false
  ignore_playbook_failure = false
  extra_vars = {
    private_key      = file("~/.ssh/id_rsa")
    ansible_ssh_user = var.user
  }
  depends_on = [
    module.master_domain,
    module.elb_domain,
    module.worker_domain,
    module.etcd_domain
  ]
}
resource "ansible_playbook" "worker_ping" {
  count                   = length(module.worker_domain)
  playbook                = "ansible/utils/upgrade.yaml"
  name                    = module.worker_domain[count.index].address
  replayable              = false
  ignore_playbook_failure = false
  extra_vars = {
    private_key      = file("~/.ssh/id_rsa")
    ansible_ssh_user = var.user
  }
  depends_on = [
    ansible_playbook.master_ping
  ]
}
resource "ansible_playbook" "etcd_ping" {
  count                   = length(module.etcd_domain)
  playbook                = "ansible/utils/upgrade.yaml"
  name                    = module.etcd_domain[count.index].address
  replayable              = false
  ignore_playbook_failure = false
  extra_vars = {
    private_key      = file("~/.ssh/id_rsa")
    ansible_ssh_user = var.user
  }
  depends_on = [
    ansible_playbook.worker_ping
  ]
}

resource "ansible_playbook" "load_balancer_ping" {
  count                   = length(module.elb_domain)
  playbook                = "ansible/utils/upgrade.yaml"
  name                    = module.elb_domain[count.index].address
  replayable              = false
  ignore_playbook_failure = false
  extra_vars = {
    private_key      = file("~/.ssh/id_rsa")
    ansible_ssh_user = var.user
  }
  depends_on = [
    ansible_playbook.etcd_ping
  ]
}
