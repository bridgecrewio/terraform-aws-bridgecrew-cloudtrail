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

### Creating a CloudTrail trail and other infrastructure in seperate AWS accounts

This module supports creating a CloudTrail trail in one account, and creating the rest of the infrastructure in a seperate account.
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

## Architecture

![Architecture](https://github.com/bridgecrewio/terraform-aws-bridgecrew-cloudtrail/blob/master/docs/CustomerCloudFormation.png?raw=true)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| null | n/a |
| random | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_alias | The alias of the account the CF is deployed in. This will be prepended to all the resources in the stack. Default is {company\_name}-bc | `string` | `""` | no |
| aws\_profile | The profile that was used to deploy this module. If the default profile / default credentials are used, set this value to null. | `string` | n/a | yes |
| company\_name | The name of the company the integration is for. Must be alphanumeric. | `string` | n/a | yes |
| create\_bridgecrew\_connection | Indicate whether the SQS queue and IAM policies for Bridgecrew need to be set up.  This may be false if you are connecting a cloudtrail in a new account to an existing bucket. | `bool` | `true` | no |
| create\_cloudtrail | Indicate whether a new CloudTrail trail should be created. If not - existing\_sns\_arn and existing\_bucket\_name are required parameters. | `bool` | `true` | no |
| existing\_bucket\_name | When connecting to an existing CloudTrail trail, please supply the existing trail's bucket name (NOT ARN). | `string` | `null` | no |
| existing\_sns\_arn | When connecting to an existing CloudTrail trail, please supply the existing trail's SNS ARN. | `string` | `null` | no |
| log\_file\_expiration | n/a | `number` | `30` | no |
| log\_file\_prefix | The prefix which will be given to all the log files saved to the bucket. | `string` | `""` | no |
| logs\_bucket\_id | Bucket to place access logs from the cloudtrail bucket | `string` | `null` | no |
| organization\_id | ID or the organization (for org-wide cloudtrails) | `string` | `""` | no |
| security\_account\_id | When connecting to an existing CloudTrail trail, which puts its logs in a bucket which is in **another** account | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| customer\_name | The customer name as defined on Bridgecrew signup |
| deployment\_region | The region that the customer ran this module |
| kms\_key\_id | The KMS key cloudtrail will use for encryption |
| role\_arn | The cross-account access role ARN for Bridgecrew |
| s3\_bucket\_name | The s3 bucket name for cloudtrail. |
| s3\_key\_prefix | The s3 log prefix for cloudtrail, inside the bucket. |
| sns\_topic\_name | The sns topic cloudtrail will push to. |
| sqs\_queue\_arn | The SQS queue ARN to share with Bridgecrew for CloudTrail integration |
| sqs\_queue\_url | The SQS queue URL to share with Bridgecrew for CloudTrail integration |
| template\_version | Bridgecrew.io template version. |

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

Copyright © 2020-2021 Bridgecrew

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
[github]: https://github.com/bridgecrewio
[linkedin]: https://www.linkedin.com/in/bridgecrew/
[twitter]: https://twitter.com/bridgecrew
[share_twitter]: https://twitter.com/intent/tweet/?text=terraform-aws-bridgecrew-read-only/&url=https://github.com/bridgecrewio/terraform-aws-bridgecrew-read-only/
[share_linkedin]: https://www.linkedin.com/shareArticle?mini=true&title=terraform-aws-bridgecrew-read-only/&url=https://github.com/bridgecrewio/terraform-aws-bridgecrew-read-only/
[share_reddit]: https://reddit.com/submit/?url=https://github.com/bridgecrewio/terraform-aws-bridgecrew-read-only/
[share_facebook]: https://facebook.com/sharer/sharer.php?u=https://github.com/bridgecrewio/terraform-aws-bridgecrew-read-only/
[share_email]: mailto:?subject=terraform-aws-bridgecrew-read-only/&body=https://github.com/bridgecrewio/terraform-aws-bridgecrew-read-only/
