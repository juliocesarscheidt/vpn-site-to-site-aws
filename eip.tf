resource "aws_eip" "eip_openswan" {
  vpc = true
  tags = {
    Name = "eip_openswan"
  }
  depends_on = [
    aws_vpc.vpc_0,
    aws_vpc.vpc_1
  ]
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.instance_openswan.id
  allocation_id = aws_eip.eip_openswan.id
  depends_on = [
    aws_instance.instance_openswan,
    aws_eip.eip_openswan
  ]
}

resource "aws_eip" "eip_nat_gw" {
  vpc = true
  tags = {
    Name = "eip_nat_gw"
  }
  depends_on = [
    aws_vpc.vpc_0,
    aws_vpc.vpc_1
  ]
}
