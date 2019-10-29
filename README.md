# Terraform Bridgecrew Cloudtrail Integration
[![Maintained by Bridgecrew.io](https://img.shields.io/badge/maintained%20by-bridgecrew.io-blueviolet)](https://bridgecrew.io)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/bridgecrewio/terraform-aws-bridgecrew-cloudtrail.svg?label=latest)](https://github.com/bridgecrewio/terraform-aws-bridgecrew-cloudtrail/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D0.12.0-blue.svg)
[![CircleCI](https://circleci.com/gh/bridgecrewio/terraform-aws-bridgecrew-cloudtrail.svg?style=svg)](https://circleci.com/gh/bridgecrewio/terraform-aws-bridgecrew-cloudtrail)

## Installation Options
A Terraform module to create an Amazon Web Services (AWS) CloudTrail integration with Bridgecrew.

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

## Architecture:
![Architecture](https://github.com/bridgecrewio/terraform-aws-bridgecrew-cloudtrail/blob/master/docs/CustomerCloudFormation.png?raw=true)

## Variables:
| Name | Required? | Type | Default Value | Example Value | Description |
|---|---|---|---|---|---|
| company_name| YES | String | | testcustomer | The name of the customer. Must be alphanumeric. |
| account_alias | NO | String |  | prod | The alias of the account the CF is deployed in. This will be prepended to all the resources in the stack. Default is {company_name}-bc |
| create_cloudtrail | NO | Boolean | true | false | Indicate whther a new CloudTrail trail should be created. If not - existing_sns_arn and existing_bucket_name are required parameters. |
| log_file_prefix | NO | String |  | cloudtrail | The prefix which will be given to all the log files saved to the bucket. |
| existing_sns_arn | NO | String | | arn:aws:sns:us-east-1:090772183824:test-bc-bridgecrewcws | When connecting to an existing CloudTrail trail, please supply the existing trail's SNS ARN. |
| existing_bucket_name | NO | String | | test-bc-bridgecrewcws | When connecting to an existing CloudTrail trail, please supply the existing trail's bucket name (NOT ARN). |

## Outuput
| Name |  Example Value | Description |
|------|----------------|-------------|
| stack_id | arn:aws:cloudformation:us-east-1:090772183824:stack/test-bridgecrew/daeed550-fa25-11e9-b98a-0e23fbf2c85e | The identifier of the stack that was created | 
