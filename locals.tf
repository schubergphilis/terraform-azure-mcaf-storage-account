locals {
  identity_system_assigned_user_assigned = (var.system_assigned_identity_enabled && var.user_assigned_identities != []) ? {
    this = {
      type                       = "SystemAssigned, UserAssigned"
      user_assigned_resource_ids = var.user_assigned_identities
    }
  } : null
  identity_system_assigned = var.system_assigned_identity_enabled ? {
    this = {
      type                       = "SystemAssigned"
      user_assigned_resource_ids = null
    }
  } : null
  identity_user_assigned = var.user_assigned_identities != [] ? {
    this = {
      type                       = "UserAssigned"
      user_assigned_resource_ids = var.user_assigned_identities
    }
  } : null
}
