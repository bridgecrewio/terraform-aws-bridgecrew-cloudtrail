data template_file "message" {
  count = var.create_bridgecrew_connection ? 1 : 0
  template = file("${path.module}/message.json")
  vars = {
    request_type         = "Create"
    bridgecrew_sns_topic = local.bridgecrew_sns_topic
    customer_name        = var.company_name
    account_id           = local.account_id
    external_id          = random_string.external_id.result
    logging_account_id   = var.source_account_id != "" ? var.source_account_id : local.account_id
    sqs_queue_url        = aws_sqs_queue.cloudtrail_queue[0].id
    role_arn             = aws_iam_role.bridgecrew_account_role[0].arn
    region               = data.aws_region.region.id
  }
}

resource "null_resource" "update_bridgecrew" {
  count = var.create_bridgecrew_connection ? 1 : 0
  triggers = {
    build = md5(data.template_file.message[0].rendered)
  }

  provisioner "local-exec" {
    command     = "aws sns ${local.profile_str} --region ${data.aws_region.region.id} publish --target-arn \"${local.bridgecrew_sns_topic}\" --message '${jsonencode(data.template_file.message[0].rendered)}'"
    working_dir = path.module
  }

  depends_on = [aws_cloudtrail.trail]
}

resource "null_resource" "disconnect_bridgecrew" {
  count = var.create_bridgecrew_connection ? 1 : 0

  provisioner "local-exec" {
    command = "aws sns ${local.profile_str} --region ${data.aws_region.region.id} publish --target-arn \"${local.bridgecrew_sns_topic}\" --message '${jsonencode(replace(data.template_file.message[0].rendered, "Create", "Delete"))}'"
    when    = "destroy"
  }
}