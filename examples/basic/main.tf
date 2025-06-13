terraform {
  required_version = ">= 1.7"
}

module "storage_account" {
  source = "../.."

  name                = "Storage Account"
  resource_group_name = "Resource Group Name"
  location            = "West Europe"

  network_configuration = {
    ip_rules = ["123.123.123.123"]
  }

  storage_containers = {
    "container1" = {}
  }

  storage_file_shares = {
    "fileshare1" = {
      quota = 5
    }
    "fileshare2" = {
      quota = 50
    }
    "fileshare3" = {
      quota = 35
    }
  }

  share_properties = {
    smb = {
      authentication_types            = ["NTLMv2", "Kerberos"]
      channel_encryption_type         = ["AES-128-CCM", "AES-128-GCM", "AES-256-GCM"]
      kerberos_ticket_encryption_type = ["RC4-HMAC", "AES-256"]
      multichannel_enabled            = false
      versions                        = ["SMB3.0", "SMB3.1.1"]
    }
    retention_policy = {
      days = 30
    }
  }

  azure_files_authentication = {
    directory_type = "AD"
    active_directory = {
      domain_name         = "<domain-name>"
      domain_guid         = "<domain-guid>"
      domain_sid          = "<domain-sid>"
      storage_sid         = "<storage-sid>"
      forest_name         = "<forest-name>"
      netbios_domain_name = "<netbios-domain-name>"
    }
    default_share_level_permission = "StorageFileDataSmbShareReader"
  }
}
