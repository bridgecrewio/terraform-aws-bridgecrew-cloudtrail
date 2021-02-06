common_tags = {
  name = "Pizza"
}

my_config = {
  description    = "authentic Configuration"
  name           = "authentic"
  engine_type    = "ActiveMQ"
  engine_version = "5.15.0"
}

mq_broker = {
  name                = "authentic"
  engine_type         = "ActiveMQ"
  engine_version      = "5.15.0"
  host_instance_type  = "mq.t2.micro"
  deployment_mode     = "SINGLE_INSTANCE"
  publicly_accessible = false
}

vpc_name_tag    = "TEST"
sub_private_tag = "Public"
sub_public_tag  = "Public"
