locals {
  cmk = var.cmk_key_vault_id == null ? 0 : 1
}
