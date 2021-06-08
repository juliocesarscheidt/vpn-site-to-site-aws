######## AZs ########
output "aws_availability_zones" {
  value = data.aws_availability_zones.available_azs.names
}

######## IPs ########
output "eip_openswan_public_ip" {
  value = aws_eip.eip_openswan.public_ip
}

output "instance_openswan_public_ip" {
  value = aws_instance.instance_openswan.public_ip
}

output "instance_bastion_public_ip" {
  value = aws_instance.instance_bastion.public_ip
}

######## VPC ########
output "vpc_0_default_route_table_id" {
  value = aws_vpc.vpc_0.default_route_table_id
}

output "vpc_1_default_route_table_id" {
  value = aws_vpc.vpc_1.default_route_table_id
}

######## VPN ########
output "vpn_connection_main_transit_gateway_attachment_id" {
  value       = aws_vpn_connection.vpn_connection_main.transit_gateway_attachment_id
}

######## VPN XML config ########
# output "vpn_connection_main_configuration" {
#   value = aws_vpn_connection.vpn_connection_main.customer_gateway_configuration
# }

######## VPN first tunnel ########
output "vpn_connection_main_tunnel1_address" {
  value = aws_vpn_connection.vpn_connection_main.tunnel1_address
}

output "vpn_connection_main_tunnel1_cgw_inside_address" {
  value = aws_vpn_connection.vpn_connection_main.tunnel1_cgw_inside_address
}

output "vpn_connection_main_tunnel1_vgw_inside_address" {
  value = aws_vpn_connection.vpn_connection_main.tunnel1_vgw_inside_address
}

output "vpn_connection_main_tunnel1_preshared_key" {
  value     = aws_vpn_connection.vpn_connection_main.tunnel1_preshared_key
  sensitive = true
}

######## VPN second tunnel ########
output "vpn_connection_main_tunnel2_address" {
  value = aws_vpn_connection.vpn_connection_main.tunnel2_address
}

output "vpn_connection_main_tunnel2_cgw_inside_address" {
  value = aws_vpn_connection.vpn_connection_main.tunnel2_cgw_inside_address
}

output "vpn_connection_main_tunnel2_vgw_inside_address" {
  value = aws_vpn_connection.vpn_connection_main.tunnel2_vgw_inside_address
}

output "vpn_connection_main_tunnel2_preshared_key" {
  value     = aws_vpn_connection.vpn_connection_main.tunnel2_preshared_key
  sensitive = true
}
