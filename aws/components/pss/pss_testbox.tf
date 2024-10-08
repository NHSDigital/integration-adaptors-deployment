resource "aws_instance" "pss_testbox" {
  count = var.create_pss_testbox ? 1 : 0
  availability_zone = local.availability_zones[0]
  ami           = data.aws_ami.base_linux.id
  instance_type = "t2.micro"
  key_name = "nia_support"
  vpc_security_group_ids = [
    aws_security_group.pss_testbox_sg.id,
    aws_security_group.pss_container_access_sg.id,
    data.terraform_remote_state.base.outputs.postgres_access_sg_id
  ]
  subnet_id = aws_subnet.service_subnet[0].id
  user_data = data.template_cloudinit_config.testbox_user_data.rendered

  tags = merge(local.default_tags, {
     Name = "${local.resource_prefix}-testbox"
  })
}