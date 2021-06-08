resource "aws_network_interface" "eni_openswan" {
  subnet_id         = aws_subnet.public_subnet_0.id
  private_ips       = ["172.100.0.100"]
  security_groups   = [aws_security_group.sg_openswan.id]
  source_dest_check = false
  tags = {
    Name = "eni_openswan"
  }
  depends_on = [
    aws_subnet.public_subnet_0,
    aws_security_group.sg_openswan
  ]
}

resource "aws_instance" "instance_openswan" {
  ami           = data.aws_ami.ec2_ami.id
  instance_type = var.aws_instance_size
  key_name      = aws_key_pair.ssh_key.key_name
  network_interface {
    network_interface_id = aws_network_interface.eni_openswan.id
    device_index         = 0
  }
  user_data     = data.template_file.template_openswan.rendered
  ebs_optimized = false
  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }
  tags = {
    Name = "instance_openswan"
  }
  depends_on = [
    aws_network_interface.eni_openswan,
    data.template_file.template_openswan
  ]
}

data "template_file" "template_openswan" {
  template = file("${path.module}/scripts/userdata_openswan.tpl")
  vars = {
    SSH_KEY_BASE64_PUBLIC   = data.local_file.ssh_public_key_file.content_base64
    SSH_KEY_BASE64_PRIVATE  = data.local_file.ssh_private_key_file.content_base64
    LEFT_EXTERNAL_IP     = aws_eip.eip_openswan.public_ip
    LEFT_SUBNET_CIDR     = "172.100.0.0/16" # aws_vpc.vpc_0.cidr_block
    RIGHT_EXTERNAL_IP    = aws_vpn_connection.vpn_connection_main.tunnel1_address
    RIGHT_SUBNET_CIDR    = "172.200.0.0/16" # aws_vpc.vpc_1.cidr_block
    TUNNEL_PRESHARED_KEY = aws_vpn_connection.vpn_connection_main.tunnel1_preshared_key
  }
  depends_on = [
    aws_eip.eip_openswan,
    aws_vpc.vpc_0,
    aws_vpc.vpc_1,
    aws_vpn_connection.vpn_connection_main
  ]
}

######## bastion ########
resource "aws_network_interface" "eni_bastion" {
  subnet_id         = aws_subnet.private_subnet_1.id
  private_ips       = ["172.200.0.100"]
  security_groups   = [aws_security_group.sg_bastion.id]
  source_dest_check = false
  tags = {
    Name = "eni_bastion"
  }
  depends_on = [
    aws_subnet.private_subnet_1,
    aws_security_group.sg_bastion
  ]
}

resource "aws_instance" "instance_bastion" {
  ami           = data.aws_ami.ec2_ami.id
  instance_type = var.aws_instance_size
  key_name      = aws_key_pair.ssh_key.key_name
  network_interface {
    network_interface_id = aws_network_interface.eni_bastion.id
    device_index         = 0
  }
  user_data     = data.template_file.template_bastion.rendered
  ebs_optimized = false
  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }
  tags = {
    Name = "instance_bastion"
  }
  depends_on = [
    aws_network_interface.eni_bastion,
    data.template_file.template_bastion
  ]
}

data "template_file" "template_bastion" {
  template = file("${path.module}/scripts/userdata_bastion.tpl")
  vars = {
    SSH_KEY_BASE64_PUBLIC   = data.local_file.ssh_public_key_file.content_base64
    SSH_KEY_BASE64_PRIVATE  = data.local_file.ssh_private_key_file.content_base64
  }
  depends_on = [
    aws_vpc.vpc_0,
    aws_vpc.vpc_1,
    aws_vpn_connection.vpn_connection_main
  ]
}
