module "master_domain" {
  source         = "./modules/domain"
  count          = var.MASTER_COUNT
  name           = format("a-master-%s", count.index + 1)
  memory         = var.master_config.memory
  vcpus          = var.master_config.vcpus
  sockets        = var.master_config.sockets
  autostart      = var.autostart
  default_bridge = var.DEFAULT_BRIDGE
  target_node    = var.TARGET_NODE
  ssh_key        = var.ssh_key
  user           = var.user
}

module "worker_domain" {
  source         = "./modules/domain"
  count          = var.WORKER_COUNT
  name           = format("a-worker-%s", count.index + 1)
  memory         = var.worker_config.memory
  vcpus          = var.worker_config.vcpus
  sockets        = var.worker_config.sockets
  autostart      = var.autostart
  default_bridge = var.DEFAULT_BRIDGE
  target_node    = var.TARGET_NODE
  ssh_key        = var.ssh_key
  user           = var.user
}

module "etcd_domain" {
  source         = "./modules/domain"
  count          = var.ETCD_COUNT
  name           = format("etcd-0%s", count.index + 1)
  memory         = var.etcd_config.memory
  vcpus          = var.etcd_config.vcpus
  sockets        = var.etcd_config.sockets
  autostart      = var.autostart
  default_bridge = var.DEFAULT_BRIDGE
  target_node    = var.TARGET_NODE
  ssh_key        = var.ssh_key
  user           = var.user
}

module "elb_domain" {
  source         = "./modules/domain"
  count          = 1
  name           = "a-load-balancer"
  memory         = var.elb_config.memory
  vcpus          = var.elb_config.vcpus
  sockets        = var.elb_config.sockets
  autostart      = var.autostart
  default_bridge = var.DEFAULT_BRIDGE
  target_node    = var.TARGET_NODE
  ssh_key        = var.ssh_key
  user           = var.user
}
