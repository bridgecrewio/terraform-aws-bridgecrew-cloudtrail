# Terraform Bridgecrew Cloudtrail Integration
[![Maintained by Bridgecrew.io](https://img.shields.io/badge/maintained%20by-bridgecrew.io-blueviolet)](https://bridgecrew.io)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/bridgecrewio/terraform-aws-bridgecrew-cloudtrail.svg?label=latest)](https://github.com/bridgecrewio/terraform-aws-bridgecrew-cloudtrail/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D0.12.0-blue.svg)
[![CircleCI](https://circleci.com/gh/bridgecrewio/terraform-aws-bridgecrew-cloudtrail.svg?style=svg)](https://circleci.com/gh/bridgecrewio/terraform-aws-bridgecrew-cloudtrail)


A Terraform module to create an Amazon Web Services (AWS) integration with Bridgecrew.

## Architecture:
![Architecture](https://github.com/bridgecrewio/terraform-aws-bridgecrew-cloudtrail/blob/master/docs/CustomerCloudFormation.png?raw=true)

## Variables:
| Name | Required? | Type | Default Value | Example Value | Description |
|---|---|---|---|---|---|
| customer_name| YES | String | | testcustomer | The name of the customer. Must be alphanumeric. |
| resource_name_prefix | NO | String |  | acme-bc | The prefix that will be given to all the resources in the stack. Default is {customer_name}-bc |
| create_cloudtrail | NO | Boolean | true | false | Indicate whther a new CloudTrail trail should be created. If not - existing_sns_arn and existing_bucket_name are required parameters. |
| log_file_prefix | NO | String |  | cloudtrail | The prefix which will be given to all the log files saved to the bucket. |
| existing_sns_arn | NO | String | | arn:aws:sns:us-east-1:090772183824:test-bc-bridgecrewcws | When connecting to an existing CloudTrail trail, please supply the existing trail's SNS ARN. |
| existing_bucket_name | NO | String | | test-bc-bridgecrewcws | When connecting to an existing CloudTrail trail, please supply the existing trail's bucket name (NOT ARN). |

## Outuput
| Name |  Example Value | Description |
|------|----------------|-------------|
| stack_id | arn:aws:cloudformation:us-east-1:090772183824:stack/test-bridgecrew/daeed550-fa25-11e9-b98a-0e23fbf2c85e | The identifier of the stack that was created | 
