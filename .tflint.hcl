# TFLint configuration. `tflint --init` installs the plugins below; `tflint --recursive`
# lints the module at the root and every directory under it (examples/ included).
# Rule reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/main/docs/rules/README.md

config {
  # Lint the module calls in examples/ too: values passed into local modules are checked.
  call_module_type = "local"
}

# The Terraform language ruleset, pinned rather than the copy bundled with tflint, with
# every rule on ("all"): naming conventions, documented and typed variables/outputs,
# required_version / required_providers, unused declarations, standard module structure ...
plugin "terraform" {
  enabled = true
  preset  = "all"
  version = "0.15.0"
  source  = "github.com/terraform-linters/tflint-ruleset-terraform"
}

# Cloud rulesets catch provider-specific mistakes (invalid instance types, regions ...).
# Add the one you use, e.g.:
#
# plugin "aws" {
#   enabled = true
#   version = "0.45.0"
#   source  = "github.com/terraform-linters/tflint-ruleset-aws"
# }
