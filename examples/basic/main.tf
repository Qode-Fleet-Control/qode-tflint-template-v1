# The module, called the way a consumer would. tflint lints this call too
# (call_module_type = "local" in .tflint.hcl).

module "inventory" {
  source = "../.."

  name_prefix    = "example"
  instance_count = 3
  labels = {
    team = "platform"
  }
  inventory_path = "${path.root}/out/inventory.json"
}
