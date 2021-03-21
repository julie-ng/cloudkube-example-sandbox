terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.52.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

locals {
  tags = {
    public = "true"
    demo   = "true"
    env    = "prod"
    iac    = "terraform"
  }

  name          = "ci-demo-team-sandbox"
  name_squished = replace(local.name, "-", "")
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.name}-rg"
  location = "centralus"
  tags     = local.tags
}

resource "azurerm_container_registry" "cr" {
  name                = "${local.name_squished}cr"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  admin_enabled       = false
  tags                = local.tags
}

resource "azurerm_key_vault" "kv" {
  name                        = "${local.name}-kv"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  sku_name                    = "standard"
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true
	tags 												= local.tags
}

output "summary" {
	value = {
		resource_group = {
			name = azurerm_resource_group.rg.name
			location = azurerm_resource_group.rg.location
		}
		container_registry = {
			id = azurerm_container_registry.cr.id
			admin_enabled = azurerm_container_registry.cr.admin_enabled
			login_server = azurerm_container_registry.cr.login_server
		}
		key_vault = {
			id = azurerm_key_vault.kv.id
			vault_uri = azurerm_key_vault.kv.vault_uri
			enable_rbac_authorization = azurerm_key_vault.kv.enable_rbac_authorization
		}
	}
}