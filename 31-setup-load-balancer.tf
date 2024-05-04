resource "ansible_playbook" "setup_load_balancer" {
  count                   = length(module.elb_domain)
  playbook                = "ansible/haproxy/install_haproxy.yaml"
  name                    = module.elb_domain[count.index].address
  replayable              = false
  ignore_playbook_failure = false
  extra_vars = {
    private_key      = file("~/.ssh/id_rsa")
    ansible_ssh_user = var.user
    root_path        = path.cwd
  }
  depends_on = [
    docker_container.generate_etcd_config,
    ansible_playbook.load_balancer_ping
  ]
}
resource "ansible_playbook" "setup_load_balancer_firewall" {
  count                   = length(module.elb_domain)
  playbook                = "ansible/firewall/enable_elb_firewall.yaml"
  name                    = module.elb_domain[count.index].address
  replayable              = true
  ignore_playbook_failure = false
  extra_vars = {
    private_key      = file("~/.ssh/id_rsa")
    ansible_ssh_user = var.user
  }
  depends_on = [
    ansible_playbook.setup_load_balancer
  ]
}
