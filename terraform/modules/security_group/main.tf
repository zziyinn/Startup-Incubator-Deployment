resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags,
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress_rules" {
  count = length(var.ingress_rules)

  security_group_id = aws_security_group.this.id
  type              = "ingress"

  cidr_blocks      = lookup(var.ingress_rules[count.index], "cidr_blocks", null)
  ipv6_cidr_blocks = lookup(var.ingress_rules[count.index], "ipv6_cidr_blocks", null)
  prefix_list_ids  = lookup(var.ingress_rules[count.index], "prefix_list_ids", null)
  description      = lookup(var.ingress_rules[count.index], "description", null)
  from_port        = lookup(var.ingress_rules[count.index], "from_port", 0)
  to_port          = lookup(var.ingress_rules[count.index], "to_port", 0)
  protocol         = lookup(var.ingress_rules[count.index], "protocol", "-1")
}

resource "aws_security_group_rule" "egress_rules" {
  count = length(var.egress_rules)

  security_group_id = aws_security_group.this.id
  type              = "egress"

  cidr_blocks      = lookup(var.egress_rules[count.index], "cidr_blocks", null)
  ipv6_cidr_blocks = lookup(var.egress_rules[count.index], "ipv6_cidr_blocks", null)
  prefix_list_ids  = lookup(var.egress_rules[count.index], "prefix_list_ids", null)
  description      = lookup(var.egress_rules[count.index], "description", null)
  from_port        = lookup(var.egress_rules[count.index], "from_port", 0)
  to_port          = lookup(var.egress_rules[count.index], "to_port", 0)
  protocol         = lookup(var.egress_rules[count.index], "protocol", "-1")
} 