# Azure Landing Zone

Terraform for an Azure landing zone based on the Cloud Adoption Framework
reference design: a management group hierarchy, baseline Azure Policy
guardrails, central logging, and a hub-and-spoke network.

## What gets deployed

```
Tenant Root Group
└── Azure Landing Zone (alz)              policy: allowed locations, required tags,
    │                                             Microsoft cloud security benchmark
    ├── Platform
    │   ├── Management     ── management subscription:  Log Analytics workspace
    │   ├── Connectivity   ── connectivity subscription: hub VNet (+ optional Firewall, Bastion)
    │   └── Identity
    ├── Landing Zones
    │   ├── Corp           policy: deny public IPs      ── workload subscriptions: spoke VNets
    │   └── Online
    ├── Sandbox            policy: deny connectivity resources
    └── Decommissioned
```

Network:

```
                 ┌──────────────── Hub VNet 10.0.0.0/22 ────────────────┐
                 │ AzureFirewallSubnet  GatewaySubnet  AzureBastionSubnet│
                 │ snet-shared-services                                  │
                 └───────────────▲──────────────────────▲───────────────┘
                          peering│                      │peering
             ┌───────────────────┴──┐            ┌──────┴───────────────┐
             │ corp-dev 10.1.0.0/16 │            │ corp-prod 10.2.0.0/16│
             │ snet-app  snet-data  │            │ snet-app  snet-data  │
             └──────────────────────┘            └──────────────────────┘
```

Every spoke subnet gets its own NSG. When the hub firewall is enabled, spokes
send all egress (`0.0.0.0/0`) and DNS through it.

## Repository layout

| Path | Purpose |
| --- | --- |
| `platform/` | Root config, deployed once: management groups, policy, logging, hub network |
| `landing-zones/corp/` | Root config for Corp spokes, one state per environment (`dev.tfvars`, `prod.tfvars`) |
| `modules/management-groups` | Management group hierarchy and subscription placement |
| `modules/policy` | Built-in policy assignments |
| `modules/logging` | Log Analytics workspace |
| `modules/hub-network` | Hub VNet, Azure Firewall, Azure Bastion |
| `modules/spoke-network` | Spoke VNet, subnets, NSGs, route table, peering to the hub |
| `.github/workflows/terraform.yml` | CI: `fmt`, `init` and `validate` on every push and pull request |

## Prerequisites

- Terraform 1.6 or later, and the Azure CLI (`az login`).
- Subscriptions: one for management and one for connectivity (they can be the
  same subscription for testing), plus one per landing zone.
- Permissions for whoever runs `platform/`: **Owner** (or Management Group
  Contributor + Resource Policy Contributor) at the tenant root management
  group, and Contributor on the platform subscriptions. Tenant root access
  must first be enabled by a Global Administrator
  ([elevate access](https://learn.microsoft.com/azure/role-based-access-control/elevate-access-global-admin)).
- A storage account for Terraform state:

  ```bash
  az group create -n rg-tfstate -l westeurope
  az storage account create -n <unique-name> -g rg-tfstate --sku Standard_GRS --allow-blob-public-access false
  az storage container create -n tfstate --account-name <unique-name> --auth-mode login
  ```

## Deploy

### 1. Platform

```bash
cd platform
cp backend.hcl.example backend.hcl            # set the storage account
cp terraform.tfvars.example terraform.tfvars  # set subscription IDs and regions
terraform init -backend-config=backend.hcl
terraform plan -out tfplan
terraform apply tfplan
terraform output
```

To place a workload subscription under Corp, add it to `subscription_placement`
in `terraform.tfvars` and apply again.

### 2. Corp landing zones

Copy the hub values from `terraform output` in `platform/` into
`landing-zones/corp/<env>.tfvars`, set the workload `subscription_id`, then:

```bash
cd landing-zones/corp
cp backend.hcl.example backend.hcl
terraform init -backend-config=backend.hcl -backend-config="key=corp-dev.tfstate"
terraform plan -var-file=dev.tfvars -out tfplan
terraform apply tfplan
```

Use a separate state key (`corp-prod.tfstate`) and `-reconfigure` when
switching to another environment.

## Key settings

| Variable (`platform/`) | Default | Notes |
| --- | --- | --- |
| `allowed_locations` | none | Regions allowed by policy |
| `required_tags` | `environment`, `owner`, `cost-center` | Checked on resource groups |
| `enforce_required_tags` | `false` | `false` reports only; `true` denies untagged resource groups |
| `enable_firewall` | `false` | Azure Firewall costs roughly $900+/month (Standard) |
| `enable_bastion` | `false` | Azure Bastion is billed hourly |
| `hub_address_space` | `10.0.0.0/22` | Spokes use `10.1.0.0/16`, `10.2.0.0/16`, ... |

## Adding a new landing zone

- **Another Corp environment:** add `landing-zones/corp/<env>.tfvars` with a
  non-overlapping address space and deploy it with its own state key.
- **An Online landing zone (internet-facing):** copy `landing-zones/corp` to
  `landing-zones/online`, change the name prefix, and place its subscription
  under `online` in `subscription_placement`.

## Not included yet

This is a starting point. Common next steps:

- VPN or ExpressRoute gateway in `GatewaySubnet`.
- Firewall rule collections (the firewall denies everything by default).
- Private DNS zones for Private Endpoints, linked to the hub.
- Microsoft Defender for Cloud plans and subscription activity-log export to
  Log Analytics (DeployIfNotExists policies need managed identities).
- A CI job that runs `terraform plan` against Azure using OIDC
  (`azure/login` with a federated credential).
