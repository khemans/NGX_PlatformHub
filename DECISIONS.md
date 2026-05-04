# Design decisions

This document records **why** a few major choices were made, not every Terraform line. For full requirements and current gaps, see **`PRD.md`**.

---

## 1. Split Terraform state (one S3 prefix, many state keys)

**Decision:** Each slice of the platform (`vpc`, `security_groups`, `secrets`, `aurora`, `ecs_fargate`) is a **separate Terraform root** under `terraform/stacks/`, each with its **own state object** in the **same** S3 bucket (key pattern `{prefix}/{stack}/terraform.tfstate`). Downstream stacks read upstream outputs via **`terraform_remote_state`**.

**Alternatives considered:**

- **Monolithic root:** Simpler first apply and fewer `terraform_remote_state` blocks, but one state file grows risk (blast radius, lock contention, slower plans) and makes partial rollback or team ownership harder.
- **Terragrunt / Terraform Cloud workspaces:** Strong DRY and pipeline integration; omitted here to keep the repo understandable without an extra tool or SaaS dependency for reviewers who only scan HCL.

**Trade-off:** Apply order is explicit (documented in `terraform/stacks/README.md`). Drift in an upstream stack can break a downstream plan until refreshed or fixed.

---

## 2. Stack inputs only in tfvars; CI limited to fmt + validate

**Decision:** **No** environment-specific values (names, regions, engine versions, counts, bucket names) are embedded in GitHub Actions or GitLab CI YAML. Pipelines run **`terraform fmt -check`** and **`terraform validate`** with **`init -backend=false`**. Operators (or a future wrapper) supply **`terraform/env/*.tfvars`**, per-stack **`dev.tfvars`**, and **`backend.hcl`** for real **`plan` / `apply`**.

**Alternatives considered:**

- **Full plan/apply in CI with OIDC:** Matches a strict reading of “deploy via pipeline” but pushes configuration into secrets/vars in YAML or generated files unless a hosted backend (e.g. Terraform Cloud) owns variables.
- **Terratest / kitchen in CI:** Valuable; not yet wired.

**Trade-off:** The challenge’s “visible deploy path” is satisfied today by **documented** local or org-specific automation plus the same workflow files on **GitHub and GitLab**; a thin apply job that only invokes Terraform with **checked-in or mounted var-files** (still no literals in YAML) can be added later without changing the variable model.

---

## 3. `terraform/infrastructure/` vs `terraform/stacks/`

**Decision:** Move **VPC** out of `terraform/stacks/` into **`terraform/infrastructure/vpc/`** alongside **`terraform/infrastructure/s3_state/`** (dedicated **S3 bucket** for Terraform state via module `s3_tfstate_bucket`) and **`terraform/infrastructure/dynamodb/`** (the **DynamoDB table** for **S3 backend state locking**, partition key `LockID`). Application-facing roots stay under **`terraform/stacks/`**.

**Alternatives considered:** Keep VPC as just another “stack” (fewer top-level folders) — rejected to make the split obvious for developers: **infrastructure** changes rarely; **stacks** change with services and tuning.

**Multi-account / multi-VPC:** DynamoDB is **regional**, not VPC-attached; deploy the lock module **once per AWS account and region** with a **unique `table_name` per account/region** (name collision is only within the same account and region). Multiple VPCs in the same account and region **reuse** the same lock table for Terraform. **Remote state path for VPC outputs** stays **`${prefix}/vpc/terraform.tfstate`** so downstream stacks did not need remote-state key changes when the folder moved. The **state bucket** root uses **`terraform init -backend=false`** on first run because the bucket cannot back its own state until it exists; operators then **migrate state** into the new bucket (documented in `terraform/infrastructure/README.md`).
