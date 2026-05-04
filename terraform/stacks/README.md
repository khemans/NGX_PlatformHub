# Terraform stacks (application-facing)

These roots change more often than **`terraform/infrastructure/`** (VPC, global lock table). All **shared behavior** still lives in **`terraform/modules/`**.

| File | Purpose |
|------|---------|
| **`backend.tf`** | Only `terraform { backend "s3" {} }` (merges with the `terraform` block in `main.tf`). |
| **`main.tf`** | `terraform` (providers), `provider`, data sources, `locals`, `module` blocks. |
| **`variables.tf`** | Input declarations only. **No defaults** for identity, state location, versions, counts, or booleans you must choose explicitly—`terraform plan` / `apply` will error if they are missing. **Defaults allowed** for tunables (e.g. `container_port`, `alb_ingress_cidrs`, `secrets_recovery_window_in_days`). |
| **`outputs.tf`** | Exported values for `terraform_remote_state` and operators. |
| **`dev.tfvars.example`** | Copy to `dev.tfvars`; stack-only assignments. |

**VPC** lives under **`terraform/infrastructure/vpc/`** (not here). Remote state key remains **`${prefix}/vpc/terraform.tfstate`**.

## Environment tfvars (`terraform/env/`)

Split so each root only receives **declared** variables:

| File | Contents |
|------|----------|
| **`dev.core.tfvars.example`** | `aws_region`, `project_name`, `environment` — pass to **every** root (infrastructure + stacks). |
| **`dev.remote_state.tfvars.example`** | `terraform_state_bucket`, `terraform_state_region`, `terraform_state_prefix` — pass only to roots that read remote state (**stacks** below, not `infrastructure/vpc`, `infrastructure/dynamodb`, or `infrastructure/s3_state`). |
| **`prod.*.tfvars.example`** | Same layout for prod. |

Copy examples to `dev.core.tfvars`, `dev.remote_state.tfvars` (gitignored under `terraform/env/`).

See also **[`../infrastructure/README.md`](../infrastructure/README.md)** for DynamoDB lock table and VPC foundation.

## Commands (stacks only)

**security_groups**, **aurora**, **ecs_fargate**:

```bash
cd terraform/stacks/security_groups
terraform init -backend-config=backend.hcl
terraform plan \
  -var-file=../../env/dev.core.tfvars \
  -var-file=../../env/dev.remote_state.tfvars \
  -var-file=dev.tfvars
```

**secrets** (core only; optional `dev.tfvars` for recovery window):

```bash
cd terraform/stacks/secrets
terraform plan -var-file=../../env/dev.core.tfvars -var-file=dev.tfvars
```

## Apply order (full platform)

1. **`terraform/infrastructure/s3_state/`** (bootstrap; see [`../infrastructure/README.md`](../infrastructure/README.md)).  
2. **`terraform/infrastructure/dynamodb/`** (optional; S3 locking — same README).  
3. **`terraform/infrastructure/vpc/`**  
4. **`stacks/security_groups`** and **`stacks/secrets`** (parallel OK).  
5. **`stacks/aurora`**  
6. **`stacks/ecs_fargate`**

Keep **`container_port`** (and any non-default **`alb_ingress_cidrs`**) aligned between **security_groups** and **ecs_fargate**.

## CI (pipelines stay minimal)

`.github/workflows/terraform.yml` and `.gitlab-ci.yml` only run **`terraform fmt -check`** and **`terraform validate`** on **`terraform/infrastructure/*`** and **`terraform/stacks/*`**. Plan and apply use your tfvars and `backend.hcl` locally.

## Destroy order (reverse)

**ecs_fargate** → **aurora** → **security_groups** / **secrets** → **infrastructure/vpc** → **infrastructure/dynamodb** (after no backends reference the lock table) → **infrastructure/s3_state** (last; destroys the state bucket only when no state objects must remain).
