# Azure Landing Zone

Terraform (azurerm provider ~> 4.0) for an Azure landing zone. See README.md for the architecture.

- Root configs: `platform/` (deployed once) and `landing-zones/corp/` (one state per environment via `-var-file` and backend `key`). Shared code lives in `modules/`.
- The spoke module needs two providers: default (workload subscription) and `azurerm.hub` (connectivity subscription) for the hub-side peering.
- Policy assignments at management-group scope have a 24-character name limit.
- Before committing, run `terraform fmt -recursive` and `terraform init -backend=false && terraform validate` in each root config; CI does the same.
- Never commit `terraform.tfvars`, `backend.hcl` or state files.
