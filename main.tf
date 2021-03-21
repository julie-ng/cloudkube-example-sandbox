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
  name          = var.name
  name_squished = replace(local.name, "-", "")
}

# Resource Group
# --------------

resource "azurerm_resource_group" "rg" {
  name     = "${local.name}-rg"
  location = "centralus"
  tags     = var.tags
}

# Container Registry
# ------------------

# Registry

resource "azurerm_container_registry" "cr" {
  name                = "${local.name_squished}cr"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  tags                = var.tags
}

# Assignments

data "azurerm_user_assigned_identity" "acr_principals" {
  for_each            = var.acr_identities
  name                = each.value.user_mi_name
  resource_group_name = each.value.user_mi_rg
}

resource "azurerm_role_assignment" "acr_assignments" {
  for_each             = var.acr_identities
  scope                = azurerm_container_registry.cr.id
  role_definition_name = var.acr_identities[each.key].user_mi_role
  principal_id         = data.azurerm_user_assigned_identity.acr_principals[each.key].principal_id
}

# Key Vault
# ---------

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
  tags                        = var.tags
}
