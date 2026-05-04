# Terraform stacks (split state)

All **behavior** lives in **`terraform/modules/`**. Each stack root is intentionally thin:

| File | Purpose |
|------|---------|
| **`backend.tf`** | Only `terraform { backend "s3" {} }` (merges with the `terraform` block in `main.tf`). |
| **`main.tf`** | `terraform` (providers), `provider`, data sources, `locals`, `module` blocks. |
| **`variables.tf`** | Input declarations only. **No defaults** for identity, state location, versions, counts, or booleans you must choose explicitly—`terraform plan` / `apply` will error if they are missing. **Defaults allowed** for tunables (e.g. `vpc_cidr`, `single_nat_gateway`, `container_port`, `alb_ingress_cidrs`, `secrets_recovery_window_in_days`). |
| **`outputs.tf`** | Exported values for `terraform_remote_state` and operators. |
| **`dev.tfvars.example`** | Copy to `dev.tfvars`; stack-only assignments. |

## Environment tfvars (`terraform/env/`)

Split so each stack only receives **declared** variables (Terraform rejects unknown keys in `-var-file`):

| File | Contents |
|------|----------|
| **`dev.core.tfvars.example`** | `aws_region`, `project_name`, `environment` — pass to **every** stack. |
| **`dev.remote_state.tfvars.example`** | `terraform_state_bucket`, `terraform_state_region`, `terraform_state_prefix` — pass only to **security_groups**, **aurora**, **ecs_fargate** (not vpc or secrets). |
| **`prod.*.tfvars.example`** | Same layout for prod. |

Copy examples to `dev.core.tfvars`, `dev.remote_state.tfvars` (gitignored under `terraform/env/`).

## Commands

**vpc** (no remote-state vars):

```bash
cd terraform/stacks/vpc
terraform init -backend-config=backend.hcl
terraform plan  -var-file=../../env/dev.core.tfvars
terraform apply -var-file=../../env/dev.core.tfvars
```

Optional stack overrides:

```bash
terraform plan -var-file=../../env/dev.core.tfvars -var-file=dev.tfvars
```

**security_groups**, **aurora**, **ecs_fargate**:

```bash
terraform plan \
  -var-file=../../env/dev.core.tfvars \
  -var-file=../../env/dev.remote_state.tfvars \
  -var-file=dev.tfvars
```

**secrets** (core only; optional `dev.tfvars` for recovery window):

```bash
terraform plan -var-file=../../env/dev.core.tfvars -var-file=dev.tfvars
```

## Apply order

1. **vpc**  
2. **security_groups** and **secrets** (parallel OK)  
3. **aurora**  
4. **ecs_fargate**

Keep **`container_port`** (and any non-default **`alb_ingress_cidrs`**) aligned between **security_groups** and **ecs_fargate**.

## CI (pipelines stay minimal)

`.github/workflows/terraform.yml` and `.gitlab-ci.yml` only run **`terraform fmt -check`** and **`terraform validate`** (with **`init -backend=false`**). They do **not** set stack inputs, AWS credentials, or backend config. All values for **plan** / **apply** come from your **`terraform/env/*.tfvars`**, **`terraform/stacks/<stack>/dev.tfvars`** (or prod equivalents), and **`backend.hcl`** when you run Terraform locally or in your own automation.

## Destroy order (reverse)

**ecs_fargate** → **aurora** → **security_groups** / **secrets** → **vpc**.
