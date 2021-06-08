resource "aws_customer_gateway" "customer_gateway_main" {
  bgp_asn    = 65000
  ip_address = aws_eip.eip_openswan.public_ip
  type       = "ipsec.1"
  tags = {
    Name = "customer_gateway_main"
  }
  depends_on = [aws_eip.eip_openswan]
}

######## VPN site-to-site connection ########
resource "aws_vpn_connection" "vpn_connection_main" {
  customer_gateway_id = aws_customer_gateway.customer_gateway_main.id
  transit_gateway_id  = aws_ec2_transit_gateway.transit_gateway_main.id
  # vpn_gateway_id      = aws_vpn_gateway.virtual_private_gateway_1.id
  type               = aws_customer_gateway.customer_gateway_main.type
  static_routes_only = true
  tags = {
    Name = "vpn_connection_main"
  }
  depends_on = [
    aws_customer_gateway.customer_gateway_main,
    aws_ec2_transit_gateway.transit_gateway_main
  ]
}

resource "aws_ec2_tag" "transit_gateway_vpn_connection_main_attachment" {
  resource_id = aws_vpn_connection.vpn_connection_main.transit_gateway_attachment_id
  key         = "Name"
  value       = "transit_gateway_vpn_connection_main_attachment"
}

######## transit gateway ########
resource "aws_ec2_transit_gateway" "transit_gateway_main" {
  amazon_side_asn                = "64512"
  auto_accept_shared_attachments = "enable"
  tags = {
    Name = "transit_gateway_main"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "transit_gateway_vpc_attachment_0" {
  subnet_ids         = [aws_subnet.public_subnet_0.id]
  transit_gateway_id = aws_ec2_transit_gateway.transit_gateway_main.id
  vpc_id             = aws_vpc.vpc_0.id
  tags = {
    Name = "transit_gateway_vpc_attachment_0"
  }
  depends_on = [
    aws_vpc.vpc_0,
    aws_subnet.public_subnet_0,
    aws_ec2_transit_gateway.transit_gateway_main
  ]
}

resource "aws_ec2_transit_gateway_route" "transit_gateway_route_0" {
  destination_cidr_block = "172.100.0.0/16"
  transit_gateway_attachment_id  = aws_vpn_connection.vpn_connection_main.transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.transit_gateway_main.association_default_route_table_id
  blackhole                      = false
  depends_on = [
    aws_vpn_connection.vpn_connection_main,
    aws_ec2_transit_gateway.transit_gateway_main
  ]
}

# resource "aws_vpn_gateway" "virtual_private_gateway_0" {
#   tags = {
#     Name = "virtual_private_gateway_0"
#   }
# }

# resource "aws_vpn_gateway_attachment" "vpn_attachment_vpg_0" {
#   vpc_id         = aws_vpc.vpc_0.id
#   vpn_gateway_id = aws_vpn_gateway.virtual_private_gateway_0.id
#   depends_on = [
#     aws_vpc.vpc_0,
#     aws_vpn_gateway.virtual_private_gateway_0
#   ]
# }

# resource "aws_vpn_gateway_route_propagation" "vpg_route_propagation_0" {
#   vpn_gateway_id = aws_vpn_gateway.virtual_private_gateway_0.id
#   route_table_id = aws_route_table.public_route_0.id
#   depends_on = [
#     aws_vpn_gateway.virtual_private_gateway_0,
#     aws_route_table.public_route_0
#   ]
# }

resource "aws_ec2_transit_gateway_vpc_attachment" "transit_gateway_vpc_attachment_1" {
  subnet_ids         = [aws_subnet.private_subnet_1.id]
  transit_gateway_id = aws_ec2_transit_gateway.transit_gateway_main.id
  vpc_id             = aws_vpc.vpc_1.id
  tags = {
    Name = "transit_gateway_vpc_attachment_1"
  }
  depends_on = [
    aws_vpc.vpc_1,
    aws_subnet.private_subnet_1,
    aws_ec2_transit_gateway.transit_gateway_main
  ]
}

# resource "aws_ec2_transit_gateway_route" "transit_gateway_route_1" {
#   destination_cidr_block         = "172.200.0.0/16"
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.transit_gateway_vpc_attachment_1.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway.transit_gateway_main.association_default_route_table_id
#   blackhole = false
#   depends_on = [
#     aws_ec2_transit_gateway_vpc_attachment.transit_gateway_vpc_attachment_1,
#     aws_ec2_transit_gateway.transit_gateway_main
#   ]
# }

resource "aws_vpn_gateway" "virtual_private_gateway_1" {
  tags = {
    Name = "virtual_private_gateway_1"
  }
}

resource "aws_vpn_gateway_attachment" "vpn_attachment_vpg_1" {
  vpc_id         = aws_vpc.vpc_1.id
  vpn_gateway_id = aws_vpn_gateway.virtual_private_gateway_1.id
  depends_on = [
    aws_vpc.vpc_1,
    aws_vpn_gateway.virtual_private_gateway_1
  ]
}

resource "aws_vpn_gateway_route_propagation" "vpg_route_propagation_1" {
  vpn_gateway_id = aws_vpn_gateway.virtual_private_gateway_1.id
  route_table_id = aws_route_table.private_route_1.id
  depends_on = [
    aws_vpn_gateway.virtual_private_gateway_1,
    aws_route_table.private_route_1
  ]
}
