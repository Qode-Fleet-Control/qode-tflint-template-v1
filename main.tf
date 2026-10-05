resource "random_pet" "instance" {
  count = var.instance_count

  prefix = var.name_prefix
  length = 2
}

locals {
  instance_names = [for pet in random_pet.instance : pet.id]
}

resource "local_file" "inventory" {
  filename        = var.inventory_path
  file_permission = "0644"
  content = jsonencode({
    instances = local.instance_names
    labels    = var.labels
  })
}
