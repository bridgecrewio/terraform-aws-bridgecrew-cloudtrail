# Terraform Bridgecrew Cloudtrail Integration

[![Maintained by Bridgecrew.io](https://img.shields.io/badge/maintained%20by-bridgecrew.io-blueviolet)](https://bridgecrew.io)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/bridgecrewio/terraform-aws-bridgecrew-cloudtrail.svg?label=latest)](https://github.com/bridgecrewio/terraform-aws-bridgecrew-cloudtrail/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D0.12.0-blue.svg)
[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/bridgecrewio/terraform-aws-bridgecrew-cloudtrail/cis_aws)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=bridgecrewio%2Fterraform-aws-bridgecrew-cloudtrail&benchmark=CIS+AWS+V1.2)

## Installation Options

This is a terraform module that creates an Amazon Web Services (AWS) CloudTrail integration with Bridgecrew.

### Starting fresh

This stack is created with all the best practices and CIS benchmark requirements:

1. A dedicated CMK is created, with rotation enabled.
2. A CloudTrail trail is created, and it's logs are encrypted-at-rest using the dedicated CMK.
3. The logs bucket has Versioning enabled and denies unsecure (non-HTTPS) connections.

### Connecting to an existing CloudTrail trail

The module supports connecting to an existing CloudTrail trail. This requires 3 inputs:

1. Setting `create_cloudtrail` to false.
2. Supplying the name of the bucket where the CloudTrail logs are being saved to, as `existing_bucket_name`.
3. Supplying the ARN of the SNS used by the trail to notify of new logs, in `existing_sns_arn`.
This can be configured manually on the existing trail.
4. If a KMS key is associated with this CloudTrail, update the key policy to allow Bridgecrew to decrypt.  For example:

```json
        {
          "Sid" : "Enable Bridgecrew log decryption",
          "Effect": "Allow",
          "Principal": {
            "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.company_name}-bc-bridgecrewcwssarole"
          },
          "Action": [ "kms:Decrypt", "kms:ReEncryptFrom" ],
          "Resource": "*",
          "Condition": {
            "StringEquals" : {
              "kms:CallerAccount" : "${data.aws_caller_identity.current.account_id}" },
              "StringLike": {
                "kms:EncryptionContext:aws:cloudtrail:arn" : "arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"
              }
            }
        },
```

### Creating a CloudTrail trail and other infrastructure in separate AWS accounts

This module supports creating a CloudTrail trail in one account, and creating the rest of the infrastructure in a separate account.
This may be optimal in cases where you want an organization trail from the organization master, but you want it to send logs to a bucket in a logs account.

#### In the bucket destination account

1. Set `create_cloudtrail` to false.
2. Set `source_account_id` to the account that will host the cloudtrail

#### In the trail source account

1. Set `existing_bucket_name`, `existing_kms_key_arn`, and `existing_sns_arn` to values output in the previous step
2. Set `create_bridgecrew_connection` to false

In both accounts, be sure to set the `organization_id` if this is an organization-wide trail.

## Usage

Include **module.cloudtrail.tf** in your existing Terraform code, and/or see *example/examplea* as your guide:

```terraform
module "cloudtrail" {
  source      = "bridgecrewio/bridgecrew-cloudtrail/aws"
  version     = "v1.5.4"
  org_name    = "<your org name>"
  aws_profile = "<aws profile>"
  api-token   = var.api_token
}
```

Set your **api_token** as an environmental variable not in your code:

```bash
export TF_VAR_api_token= "xxxxxx-xxxxx-xxxx-xxxxxx"
```

## Architecture

![Architecture](https://github.com/bridgecrewio/terraform-aws-bridgecrew-cloudtrail/blob/master/docs/CustomerCloudFormation.png?raw=true)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.trail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_iam_role.bridgecrew_account_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.bridgecrew_cws_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.bridgecrew_describe_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.bridgecrew_security_audit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.cloudtrail_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.cloudtrail_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.bridgecrew_cws_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.bridgecrew_cws_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_lifecycle_configuration.bridgecrew_cws_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.bridgecrew_cws_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_policy.bridgecrew_cws_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.bridgecrew_cws_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.bridgecrew_cws_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.bridgecrew_cws_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_sns_topic.cloudtrail_to_bridgecrew](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.cloudtrail_to_bridgecrew](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.cloudtrail_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sqs_queue.cloudtrail_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [null_resource.create_bridgecrew](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.disconnect_bridgecrew](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.kms_policy_delay](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.update_bridgecrew](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_uuid.external_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [aws_caller_identity.caller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.bridgecrew_account_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.bridgecrew_cws_bucket_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.bridgecrew_cws_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.bridgecrew_describe_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudtrail_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudtrail_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudtrail_to_bridgecrew](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [template_file.message](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_alias"></a> [account\_alias](#input\_account\_alias) | The alias of the account the CF is deployed in. This will be prepended to all the resources in the stack. Default is {company\_name}-bc | `string` | `""` | no |
| <a name="input_api_token"></a> [api\_token](#input\_api\_token) | This is your Bridgecrew platform Api token Set as and Environment variable TF\_VAR\_api\_token | `string` | n/a | yes |
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | The profile that was used to deploy this module. If the default profile / default credentials are used, set this value to null. | `string` | n/a | yes |
| <a name="input_bridgecrew_account_id"></a> [bridgecrew\_account\_id](#input\_bridgecrew\_account\_id) | The Account number of Bridgecrew. Internal use only | `string` | `"890234264427"` | no |
| <a name="input_company_name"></a> [company\_name](#input\_company\_name) | The name of the company the integration is for. Must be alphanumeric. | `string` | n/a | yes |
| <a name="input_create_bridgecrew_connection"></a> [create\_bridgecrew\_connection](#input\_create\_bridgecrew\_connection) | Indicate whether the SQS queue and IAM policies for Bridgecrew need to be set up.  This may be false if you are connecting a cloudtrail in a new account to an existing bucket. | `bool` | `true` | no |
| <a name="input_create_cloudtrail"></a> [create\_cloudtrail](#input\_create\_cloudtrail) | Indicate whether a new CloudTrail trail should be created. If not - existing\_sns\_arn and existing\_bucket\_name are required parameters. | `bool` | `true` | no |
| <a name="input_existing_bucket_name"></a> [existing\_bucket\_name](#input\_existing\_bucket\_name) | When connecting to an existing CloudTrail trail, please supply the existing trail's bucket name (NOT ARN). | `string` | `null` | no |
| <a name="input_existing_sns_arn"></a> [existing\_sns\_arn](#input\_existing\_sns\_arn) | When connecting to an existing CloudTrail trail, please supply the existing trail's SNS ARN. | `string` | `null` | no |
| <a name="input_log_file_expiration"></a> [log\_file\_expiration](#input\_log\_file\_expiration) | n/a | `number` | `30` | no |
| <a name="input_log_file_prefix"></a> [log\_file\_prefix](#input\_log\_file\_prefix) | The prefix which will be given to all the log files saved to the bucket. | `string` | `""` | no |
| <a name="input_logs_bucket_id"></a> [logs\_bucket\_id](#input\_logs\_bucket\_id) | Bucket to place access logs from the cloudtrail bucket | `string` | `null` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | ID or the organization (for org-wide cloudtrails) | `string` | `""` | no |
| <a name="input_security_account_id"></a> [security\_account\_id](#input\_security\_account\_id) | When connecting to an existing CloudTrail trail, which puts its logs in a bucket which is in **another** account | `string` | `""` | no |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | The SNS topic name for Bridgecrew integration. Internal use only | `string` | `"handle-customer-actions"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_customer_name"></a> [customer\_name](#output\_customer\_name) | The customer name as defined on Bridgecrew signup |
| <a name="output_deployment_region"></a> [deployment\_region](#output\_deployment\_region) | The region that the customer ran this module |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | The KMS key cloudtrail will use for encryption |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The cross-account access role ARN for Bridgecrew |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | The s3 bucket name for cloudtrail. |
| <a name="output_s3_key_prefix"></a> [s3\_key\_prefix](#output\_s3\_key\_prefix) | The s3 log prefix for cloudtrail, inside the bucket. |
| <a name="output_sns_topic_name"></a> [sns\_topic\_name](#output\_sns\_topic\_name) | The sns topic cloudtrail will push to. |
| <a name="output_sqs_queue_arn"></a> [sqs\_queue\_arn](#output\_sqs\_queue\_arn) | The SQS queue ARN to share with Bridgecrew for CloudTrail integration |
| <a name="output_sqs_queue_url"></a> [sqs\_queue\_url](#output\_sqs\_queue\_url) | The SQS queue URL to share with Bridgecrew for CloudTrail integration |
| <a name="output_template_version"></a> [template\_version](#output\_template\_version) | Bridgecrew.io template version. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Related Projects

Check out these related projects.

- [terraform-aws-bridgecrew-remediation](https://github.com/bridgecrewio/terraform-aws-bridgecrew-remediation)

## Help

**Got a question?**

File a GitHub [issue](https://github.com/bridgecrewio/terraform-aws-bridgecrew-read-only/issues).

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/bridgecrewio/terraform-aws-bridgecrew-read-only/issues) to report any bugs or file feature requests.

## Copyrights

Copyright © 2020-2022 Bridgecrew

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements. See the NOTICE file
distributed with this work for additional information
regarding copyright ownership. The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at

<https://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied. See the License for the
specific language governing permissions and limitations
under the License.
