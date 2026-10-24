output "deployed_vm_ip" {
  value       = module.compute.vm_private_ip
  description = "Private IP of the instantiated server tier"
}
