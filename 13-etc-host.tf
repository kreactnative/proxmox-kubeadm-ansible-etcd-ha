resource "ansible_playbook" "master_etc_host" {
  count                   = length(module.master_domain)
  playbook                = "ansible/utils/host.yaml"
  name                    = module.master_domain[count.index].address
  replayable              = false
  ignore_playbook_failure = false
  extra_vars = {
    private_key      = file("~/.ssh/id_rsa")
    ansible_ssh_user = var.user
    hostName         = module.master_domain[count.index].name
    ip4              = module.master_domain[count.index].address
    ip6              = module.master_domain[count.index].address_ipv6
  }
  depends_on = [
    ansible_playbook.master_ping
  ]
}
resource "ansible_playbook" "worker_etc_host" {
  count                   = length(module.worker_domain)
  playbook                = "ansible/utils/host.yaml"
  name                    = module.worker_domain[count.index].address
  replayable              = false
  ignore_playbook_failure = false
  extra_vars = {
    private_key      = file("~/.ssh/id_rsa")
    ansible_ssh_user = var.user
    hostName         = module.worker_domain[count.index].name
    ip4              = module.worker_domain[count.index].address
    ip6              = module.worker_domain[count.index].address_ipv6
  }
  depends_on = [
    ansible_playbook.worker_ping
  ]
}
resource "ansible_playbook" "etcd_etc_host" {
  count                   = length(module.etcd_domain)
  playbook                = "ansible/utils/host.yaml"
  name                    = module.etcd_domain[count.index].address
  replayable              = false
  ignore_playbook_failure = false
  extra_vars = {
    private_key      = file("~/.ssh/id_rsa")
    ansible_ssh_user = var.user
    hostName         = module.etcd_domain[count.index].name
    ip4              = module.etcd_domain[count.index].address
    ip6              = module.etcd_domain[count.index].address_ipv6
  }
  depends_on = [
    ansible_playbook.etcd_ping
  ]
}

resource "ansible_playbook" "load_balancer_etc_host" {
  count                   = length(module.elb_domain)
  playbook                = "ansible/utils/host.yaml"
  name                    = module.elb_domain[count.index].address
  replayable              = false
  ignore_playbook_failure = false
  extra_vars = {
    private_key      = file("~/.ssh/id_rsa")
    ansible_ssh_user = var.user
    hostName         = module.elb_domain[count.index].name
    ip4              = module.elb_domain[count.index].address
    ip6              = module.elb_domain[count.index].address_ipv6
  }
  depends_on = [
    ansible_playbook.load_balancer_ping
  ]
}
