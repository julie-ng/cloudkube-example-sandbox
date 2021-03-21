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

output "acr_role_assginments" {
  value = [
    for k, v in zipmap( # needed to combine resource and data sources
      keys(azurerm_role_assignment.acr_assignments),
    values(azurerm_role_assignment.acr_assignments)) :
    {
      tostring(k) = {
        id                   = v.id
        scope                = v.scope
        role_definition_name = v.role_definition_name
        principal_id         = v.principal_id
        principal_type       = v.principal_type
        principal_name       = data.azurerm_user_assigned_identity.acr_principals[k].name
        principal_rg         = data.azurerm_user_assigned_identity.acr_principals[k].resource_group_name
      }
    }
  ]
}