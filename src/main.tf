locals {
  enabled = module.this.enabled
}

resource "aws_route" "this" {
  for_each = local.enabled ? {
    for pair in setproduct(var.route_table_ids, var.routes) : "${pair[0]}-${pair[1].destination.cidr_block}" => {
      route_table_id         = pair[0]
      destination_cidr_block = pair[1].destination.cidr_block
      target                 = pair[1].target
    }
  } : {}

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.destination_cidr_block

  # Exactly one of the following options should be given
  transit_gateway_id = each.value.target.type == "transit_gateway_id" ? each.value.target.value : null
  nat_gateway_id     = each.value.target.type == "nat_gateway_id" ? each.value.target.value : null
}
