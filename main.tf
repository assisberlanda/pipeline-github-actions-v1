terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.14.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "danielgilterraformstate"
    container_name       = "remote-state"
    key                  = "pipeline-github/terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      owner      = "assisberlanda"
      managed-by = "terraform"
    }
  }
}

provider "azurerm" {
  features {}
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "assisberlanda-remote-state"
    key    = "aws-vpc/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "vnet" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "assisberlandaterrastate"
    container_name       = "remote-state"
    key                  = "azure-vnet/terraform.tfstate"
  }
}