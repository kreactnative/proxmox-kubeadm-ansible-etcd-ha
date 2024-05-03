### Terraform
```
# ssh key
ssh_key = "changeme"
# Valid values are intel/amd
system_type = "intel"
user        = "rocky"

# Hypervisor config
PROXMOX_API_ENDPOINT = "https://192.168.1.6:8006/api2/json"
PROXMOX_USERNAME     = "root"
PROXMOX_PASSWORD     = "changeme"
PROXMOX_IP           = "192.168.1.6"
DEFAULT_BRIDGE       = "vmbr0"
TARGET_NODE          = "pve"

# vm config
autostart = true

# Cluster config
MASTER_COUNT = 2
WORKER_COUNT = 2
ETCD_COUNT   = 2

master_config = {
  memory  = "8192"
  vcpus   = 4
  sockets = 1
}
worker_config = {
  memory  = "8192"
  vcpus   = 4
  sockets = 1
}
etcd_config = {
  memory  = "2048"
  vcpus   = 2
  sockets = 1
}
elb_config = {
  memory  = "2048"
  vcpus   = 2
  sockets = 1
}

```