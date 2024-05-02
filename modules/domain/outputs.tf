output "address" {
  value       = data.external.address.result["address"]
  description = "IP Address of the node"
}

output "address_ipv6" {
  value       = proxmox_virtual_environment_vm.node.ipv6_addresses[1][0]
  description = "IP Address IPV6 of the node"
}

output "name" {
  value       = proxmox_virtual_environment_vm.node.name
  description = "Name of the node"
}
