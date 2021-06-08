data "local_file" "ssh_public_key_file" {
  filename = "${path.module}/${var.aws_key_name}.pub"
}

data "local_file" "ssh_private_key_file" {
  filename = "${path.module}/${var.aws_key_name}"
}

resource "aws_key_pair" "ssh_key" {
  key_name   = var.aws_key_name
  public_key = data.local_file.ssh_public_key_file.content
}
