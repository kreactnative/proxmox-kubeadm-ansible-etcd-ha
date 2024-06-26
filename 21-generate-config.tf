resource "local_file" "cluster_config" {
  depends_on = [
    ansible_playbook.load_balancer_etc_host
  ]
  content = templatefile("${path.root}/templates/config.tmpl",
    {
      loadbalancer_ip     = module.elb_domain[0].address,
      current_master_ip   = module.master_domain[0].address,
      current_master_ipv6 = module.master_domain[0].address_ipv6,
      node_etcds = zipmap(
        tolist(module.etcd_domain[*].address), tolist(module.etcd_domain[*].address)
      )
    }
  )
  filename = "ansible/k8s/files/cluster.yaml"
}

resource "local_file" "helm_ciliun_config" {
  depends_on = [
    local_file.cluster_config
  ]
  content = templatefile("${path.root}/templates/helm-cni-lb.tmpl",
    {
      loadbalancer_ip = module.elb_domain[0].address
    }
  )
  filename = "ansible/k8s/files/helm-cni-lb.sh"
}

resource "local_file" "haproxy_config" {
  depends_on = [
    local_file.helm_ciliun_config
    ]
  content = templatefile("${path.root}/templates/haproxy.tmpl",
    {
      node_map_masters = zipmap(
        tolist(module.master_domain[*].address), tolist(module.master_domain[*].name)
      ),
    }
  )
  filename = "ansible/haproxy/files/haproxy.cfg"
}

resource "docker_image" "etcd" {
  name = "harbor.socket9.com/etcd-cluster-gen/v${var.ETCD_COUNT}"
}

resource "docker_container" "generate_etcd_config" {
  depends_on = [
    local_file.haproxy_config
  ]
  image      = docker_image.etcd.image_id
  name       = "etcd-generate"
  privileged = true
  tty        = true
  rm         = true
  attach     = false
  env        = [for k, v in module.etcd_domain : "ETCD${index(module.etcd_domain, v) + 1}_IP=${v.address}"]
  volumes {
    container_path = "/app/certificate"
    host_path      = "${abspath(path.module)}/ansible/etcd/files"
  }
}
