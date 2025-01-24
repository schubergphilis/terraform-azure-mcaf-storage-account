locals {
  immutability_policy = (var.immutability_policy != null) ? {
    this = {
      allow_protected_append_writes = var.immutability_policy.allow_protected_append_writes
      state                         = var.immutability_policy.state
      period_since_creation_in_days = var.immutability_policy.period_since_creation_in_days
    }
  } : null
  identity_system_assigned_user_assigned = (var.system_assigned_identity_enabled && (length(var.user_assigned_identities) > 0)) ? {
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
  identity_user_assigned = (length(var.user_assigned_identities) > 0) ? {
    this = {
      type                       = "UserAssigned"
      user_assigned_resource_ids = var.user_assigned_identities
    }
  } : null
}
