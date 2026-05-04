# Infrastructure (slow-changing foundations)

These roots hold **account-wide or long-lived** pieces that application stacks depend on. They change far less often than **`terraform/stacks/`** (ECS, Aurora sizing, security tweaks, etc.).

| Root | Purpose |
|------|---------|
| **`s3_state/`** | Dedicated **S3 bucket** for Terraform remote state (versioning, SSE-S3, public access block, optional deny non-TLS). Other roots’ `backend.hcl` **`bucket`** should match the name you set here. |
| **`vpc/`** | Shared VPC, subnets, NAT, route tables. Outputs are read by stacks via `terraform_remote_state`. |
| **`dynamodb/`** | DynamoDB table for **Terraform S3 backend state locking** (`LockID` string partition key). Deploy **once per AWS account and region** where you run Terraform; reuse the same table name in every `backend.hcl` `dynamodb_table` for that account/region. |

DynamoDB is **regional**, not VPC-scoped. Multiple VPCs in the same account and region **share one** lock table for Terraform. **Multiple AWS accounts** each need their own apply of `infrastructure/dynamodb` (and typically their own state bucket or prefix policy).

## Suggested apply order

1. **`s3_state/`** — Bootstrap: this root cannot use its own bucket until it exists. Run **`terraform init -backend=false`**, **`apply`** with `dev.core.tfvars` + `dev.tfvars` (see `backend.hcl.example`), then **`terraform init -migrate-state -backend-config=backend.hcl`** so this root’s state also lives in the new bucket.  
2. **`dynamodb/`** (optional; same bucket for `backend.hcl` once the bucket exists; init without `dynamodb_table` first if the table is not created yet).  
3. **`vpc/`**  
4. Then **`terraform/stacks/*`** as documented in [`../stacks/README.md`](../stacks/README.md).

## Commands

Same pattern as stacks: copy **`backend.hcl.example`**, env **`*.tfvars`**, stack **`dev.tfvars`**, then `terraform init -backend-config=backend.hcl` and `plan` / `apply`.

VPC example:

```bash
cd terraform/infrastructure/vpc
terraform plan -var-file=../../env/dev.core.tfvars
```

DynamoDB example (requires `table_name` in `dev.tfvars`):

```bash
cd terraform/infrastructure/dynamodb
terraform plan -var-file=../../env/dev.core.tfvars -var-file=dev.tfvars
```

**S3 state bucket** example (requires globally unique `bucket_name` in `dev.tfvars`):

```bash
cd terraform/infrastructure/s3_state
terraform plan -var-file=../../env/dev.core.tfvars -var-file=dev.tfvars
```

After apply, set **`terraform_state_bucket`** in `terraform/env/dev.remote_state.tfvars` to the created bucket name (see `s3_state` outputs).

Remote state keys for **VPC** remain **`${prefix}/vpc/terraform.tfstate`** so existing stacks do not need remote-state path changes.
