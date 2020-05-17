# Terraform Bridgecrew Cloudtrail Integration
[![Maintained by Bridgecrew.io](https://img.shields.io/badge/maintained%20by-bridgecrew.io-blueviolet)](https://bridgecrew.io)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/bridgecrewio/terraform-aws-bridgecrew-cloudtrail.svg?label=latest)](https://github.com/bridgecrewio/terraform-aws-bridgecrew-cloudtrail/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D0.12.0-blue.svg)
[![CircleCI](https://circleci.com/gh/bridgecrewio/terraform-aws-bridgecrew-cloudtrail.svg?style=svg)](https://circleci.com/gh/bridgecrewio/terraform-aws-bridgecrew-cloudtrail)

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

## Architecture:
![Architecture](https://github.com/bridgecrewio/terraform-aws-bridgecrew-cloudtrail/blob/master/docs/CustomerCloudFormation.png?raw=true)

## Variables:
| Name | Required? | Type | Default Value | Example Value | Description |
|---|---|---|---|---|---|
| company_name| YES | String | | testcustomer | The name of the customer. Must be alphanumeric. |
| aws_profile| YES | String | | dev | The name of the AWS profile to be used. If using default credentials, set this value to null |
| account_alias | NO | String |  | prod | The alias of the account the CF is deployed in. This will be prepended to all the resources in the stack. Default is {company_name}-bc |
| create_cloudtrail | NO | Boolean | true | false | Indicate whether a new CloudTrail trail should be created. |
| create_bridgecrew_connection | NO | Boolean | true | false | Indicate whether an SNS queue and role for Bridgecrew should be created in this account. |
| log_file_prefix | NO | String |  | cloudtrail | The prefix which will be given to all the log files saved to the bucket. |
| existing_sns_arn | NO | String | | arn:aws:sns:us-east-1:090772183824:test-bc-bridgecrewcws | When connecting to an existing SNS topic, please supply the trail's SNS ARN. |
| existing_bucket_name | NO | String | | test-bc-bridgecrewcws | When connecting to an existing CloudTrail bucket, please supply the bucket name (NOT ARN). |
| existing_kms_key_arn | NO | String | | arn:aws:kms:us-east-1:090772183824:key/c79ebdc6-bb68-4e83-805f-be5304c10f1e | When using an existing KMS Key (to be accessed by Bridgecrew), specify the existing KMS key ARN. |
| security_account_id | NO | String | "" | 12345678900 | When connecting to a centralized CloudTrail bucket setup, please supply the ID of the AWS account that hosts the CloudTrail log bucket. We must be deployed in that central logging account beforehand for the integration to work correctly. |
| source_account_id | NO | String | | 090772183824 | When cloudtrail in another account is connecting to buckets and sns topics in this account, specify the account ID of that account. |
| organization_id | NO | String | | o-sv720a91a0 | When creating an organization-wide cloudtrail from the organization master. |
| logs_bucket_id | NO | String | | cloudtrail-logs-bucket | Bucket to place access logs from the cloudtrail bucket (defaults to no logs) |
| logs_file_expiration | NO | Number | 30 | 90 | How long to keep Cloudtrail logs in the bucket. |
| debug_policy | NO | Bool | true | false | Whether to give Bridgecrew read-only debugging access. |

## Outuput
| Name |  Example Value | Description |
|------|----------------|-------------|
| stack_id | arn:aws:cloudformation:us-east-1:090772183824:stack/test-bridgecrew/daeed550-fa25-11e9-b98a-0e23fbf2c85e | The identifier of the stack that was created | 
