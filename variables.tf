variable "name_prefix" {
  description = "Prefix of every generated name."
  type        = string
  default     = "fleet"
}

variable "instance_count" {
  description = "How many named instances to generate."
  type        = number
  default     = 2

  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 10
    error_message = "The instance_count must be between 1 and 10."
  }
}

variable "labels" {
  description = "Labels written into the inventory file."
  type        = map(string)
  default     = {}
}

variable "inventory_path" {
  description = "Where the inventory file is written."
  type        = string
  default     = "out/inventory.json"
}
