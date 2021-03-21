# Outputs
# -------

output "summary" {
  value = {
    resource_group = {
      name     = azurerm_resource_group.rg.name
      location = azurerm_resource_group.rg.location
    }
    container_registry = {
      id            = azurerm_container_registry.cr.id
      name          = azurerm_container_registry.cr.name
      admin_enabled = azurerm_container_registry.cr.admin_enabled
      login_server  = azurerm_container_registry.cr.login_server
    }
    key_vault = {
      id                        = azurerm_key_vault.kv.id
      name                      = azurerm_key_vault.kv.name
      vault_uri                 = azurerm_key_vault.kv.vault_uri
      enable_rbac_authorization = azurerm_key_vault.kv.enable_rbac_authorization
    }
  }
}
