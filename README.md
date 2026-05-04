# NGX Platform Hub

Terraform-first workspace for the **NGX Senior Platform Engineer** take-home: modular AWS infrastructure, split Terraform state, and a path to an ECS Fargate–hosted automation service backed by Aurora PostgreSQL.

Full challenge scope, acceptance criteria, and a **delta against what is implemented today** live in [**`PRD.md`**](PRD.md).

## Prerequisites

- [Terraform](https://www.terraform.io/) **≥ 1.6**
- An AWS account (this stack is **not** free-tier friendly: NAT, ALB, Aurora Serverless v2, Fargate)
- An S3 bucket (and optionally DynamoDB) for remote state, if you use the provided partial `backend "s3"` workflow

## Repository layout

| Path | Purpose |
|------|---------|
| **`terraform/modules/`** | Reusable modules: `vpc`, `security_groups`, `secrets`, `aurora`, `ecs_fargate`. |
| **`terraform/stacks/`** | One Terraform root per slice; each has its own S3 state key. See [**`terraform/stacks/README.md`**](terraform/stacks/README.md). |
| **`terraform/env/`** | Shared `*.core.tfvars` / `*.remote_state.tfvars` examples (copy to real `.tfvars`, gitignored). |
| **`diagrams/`** | Architecture diagram source ([**`diagrams/architecture.md`**](diagrams/architecture.md)). |
| **`DECISIONS.md`** | Short design rationale for major choices. |
| **`.github/workflows/`** | GitHub Actions: `terraform fmt` + `terraform validate` only. |
| **`.gitlab-ci.yml`** | Same checks for GitLab mirrors. |

## Quick start

1. Copy **`terraform/env/*.tfvars.example`** to real tfvars (see [`terraform/stacks/README.md`](terraform/stacks/README.md) for which stacks need which files).
2. In each stack directory, copy **`backend.hcl.example`** → **`backend.hcl`** and set bucket, key, and region.
3. Apply stacks **in order**: `vpc` → `security_groups` & `secrets` → `aurora` → `ecs_fargate`.

Detailed commands, destroy order, and CI behavior are documented in **`terraform/stacks/README.md`**.

## Status (summary)

Infrastructure modules and stacks for **VPC**, **security groups**, **Secrets Manager**, **Aurora PostgreSQL (Serverless v2)**, and **ECS Fargate + ALB** (placeholder workload) are in place. A **custom automation service** (application code, Dockerfile, deeper observability, PRD supplemental option, AI workflow artifacts) is still to be built; see **`PRD.md`** §9–§10.

## License

Unless you add one, this repository has **no license file**; add `LICENSE` before publishing if you intend open redistribution.
