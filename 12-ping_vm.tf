resource "ansible_playbook" "master_ping" {
  count                   = length(module.master_domain)
  playbook                = "ansible/utils/ping.yaml"
  name                    = module.master_domain[count.index].address
  replayable              = false
  ignore_playbook_failure = true
  extra_vars = {
    private_key      = file("~/.ssh/id_rsa")
    ansible_ssh_user = var.user
  }
  depends_on = [
    module.master_domain
  ]
}
resource "ansible_playbook" "worker_ping" {
  count                   = length(module.worker_domain)
  playbook                = "ansible/utils/ping.yaml"
  name                    = module.worker_domain[count.index].address
  replayable              = false
  ignore_playbook_failure = true
  extra_vars = {
    private_key      = file("~/.ssh/id_rsa")
    ansible_ssh_user = var.user
  }
  depends_on = [
    module.worker_domain
  ]
}
resource "ansible_playbook" "etcd_ping" {
  count                   = length(module.etcd_domain)
  playbook                = "ansible/utils/ping.yaml"
  name                    = module.etcd_domain[count.index].address
  replayable              = false
  ignore_playbook_failure = true
  extra_vars = {
    private_key      = file("~/.ssh/id_rsa")
    ansible_ssh_user = var.user
  }
  depends_on = [
    module.etcd_domain
  ]
}

resource "ansible_playbook" "load_balancer_ping" {
  count                   = length(module.elb_domain)
  playbook                = "ansible/utils/ping.yaml"
  name                    = module.elb_domain[count.index].address
  replayable              = false
  ignore_playbook_failure = true
  extra_vars = {
    private_key      = file("~/.ssh/id_rsa")
    ansible_ssh_user = var.user
  }
  depends_on = [
    module.elb_domain
  ]
}
