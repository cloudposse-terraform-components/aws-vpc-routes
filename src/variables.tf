variable "region" {
  type        = string
  description = "AWS Region"
}

variable "route_table_ids" {
  type        = list(string)
  description = "List of route table IDs"
  default     = []
}

variable "routes" {
  type = list(object({
    destination = object({
      cidr_block = string
    })
    target = object({
      type  = string
      value = optional(string, "")
    })
  }))

  description = <<-EOF
  A list of route objects to add to route tables. Each route object has a destination and a target.
  EOF
  default     = []

  validation {
    condition = alltrue([
      for route in var.routes : contains(["transit_gateway_id", "nat_gateway_id", "vpc_peering_connection_id", "network_interface_id"], route.target.type)
    ])
    error_message = "Target type must be transit_gateway_id, nat_gateway_id, vpc_peering_connection_id or network_interface_id"
  }
}
