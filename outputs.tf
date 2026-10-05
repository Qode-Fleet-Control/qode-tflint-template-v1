output "instance_names" {
  description = "Generated instance names."
  value       = local.instance_names
}

output "inventory_path" {
  description = "Path of the inventory file."
  value       = local_file.inventory.filename
}
