terraform {
  required_providers {
    aws = {
      version = "3.26.0"
      source  = "hashicorp/aws"
    }
    random = {
      version = "3.0.1"
      source  = "hashicorp/random"
    }
    null = {
      version = "3.0.0"
      source  = "hashicorp/null"
    }
    template = {
      version = "2.2.0"
      source  = "hashicorp/template"
    }
  }
}
