# Product Requirements Document (PRD)

**Project:** NGX Platform Hub — NGX Senior Platform Engineer Code Challenge  
**Source:** NGX Code Challenge (Senior Platform Engineer)  
**Document purpose:** Single source of truth for scope, requirements, and success criteria aligned to the challenge brief.

**Implementation snapshot (2026-05-03):** Terraform modules and split-state stacks (VPC, security groups, Secrets Manager, Aurora PostgreSQL Serverless v2, ECS Fargate + ALB) are in-repo with dual **fmt/validate-only** CI (GitHub Actions + GitLab). Root README, diagrams, automation **application** code, Terraform tests, supplemental “digging deeper” work, and AI workflow artifacts are **not** present yet. See **§10** for a full delta.

---

## 1. Overview

This initiative delivers an **Internal Developer Platform (IDP)**-style solution: Terraform-managed AWS infrastructure, a CI/CD pipeline, and an **automation service** that supports a common platform or developer workflow (“platform-as-a-product”). The work must demonstrate **AI-native development practices**, **operational maturity**, and **clear documentation** for reviewers and interview follow-up.

**Philosophy:** Quality and thoughtful decisions over raw completeness. Incomplete stretch goals are acceptable if trade-offs are explicit and the core is strong.

---

## 2. Goals

| Goal | Description |
|------|-------------|
| **G1** | Satisfy the **mandatory core challenge** and **at least one** supplemental “digging deeper” option. |
| **G2** | Deploy all Terraform-defined workloads through a **visible CI/CD pipeline** (any public SCM with a visible workflow file is acceptable; GitHub Actions is a natural fit). |
| **G3** | Ship a **containerized (ECS Fargate) or Lambda** automation service with validation, error handling, external exposure, and **observability**. |
| **G4** | Persist important service outputs to **S3**, **DynamoDB**, or **RDS Aurora PostgreSQL**. |
| **G5** | Evidence **AI-assisted workflow** in-repo and in at least one **open pull request** for discussion. |
| **G6** | Provide documentation and diagrams sufficient for deploy, review, and live demo during the technical interview. |

---

## 3. Non-goals & constraints

- **No hardcoded secrets:** Use SSM Parameter Store, Secrets Manager, or equivalent for sensitive values.
- **IAM:** Least privilege; **no wildcard IAM policies**.
- **AWS account:** Challenge assumes access to an AWS account (free tier acceptable where applicable).
- **Repository:** Code pushed to a **GitHub repository** (or equivalent) with **read-only** access for reviewers; maintain good Git hygiene.

---

## 4. Stakeholders & users

| Role | Interest |
|------|----------|
| **Candidate (builder)** | Implements platform, service, and docs; owns design rationale. |
| **NGX reviewers** | Evaluate architecture, Terraform quality, automation, CI/CD, AI workflow, and communication. |
| **Interview panel** | Live screen share, design/code walkthrough, baseline coding without AI, and AI workflow demo. |
| **Service “users”** | Developers or platform consumers implied by the chosen workflow (self-serve API, webhooks, health aggregation, portal backend, etc.). |

---

## 5. Evaluation rubric (from brief)

| Area | Weight | What reviewers evaluate |
|------|--------|-------------------------|
| Automation service | 30% | Code quality, error handling, architecture, developer experience |
| Infrastructure design & Terraform | 25% | Module structure, testing, idiomatic HCL, security posture |
| AI-native development workflow | 20% | AI used effectively as a collaborator, not only mentioned |
| CI/CD & operational maturity | 15% | Pipeline design, observability, deployment strategy |
| Communication & documentation | 10% | README, design rationale, diagram quality, commit history |

---

## 6. Functional requirements — core challenge

### 6.1 AI-native development workflow

- **FR-AI-1:** Include AI agent configuration in the repository (e.g. `CLAUDE.md`, custom instructions, MCP configs, or equivalent for the chosen tool).
- **FR-AI-2:** Keep **at least one pull request open** that illustrates AI-assisted development (commits, conversation, iteration).
- **FR-AI-3:** Candidate must be prepared to discuss what worked, where course-correction was needed, and how the workflow would improve.

### 6.2 Terraform & CI/CD

- **FR-TF-1:** Use **Terraform** to define infrastructure; **all workloads** deploy via a **CI/CD pipeline** (challenge wording). *Current repo choice:* GitHub Actions / GitLab run **`terraform fmt -check`** and **`terraform validate`** only; **plan/apply** and all variable values are **operator-driven** via `terraform/env/*.tfvars`, per-stack `dev.tfvars`, and `backend.hcl` (see `terraform/stacks/README.md`). A follow-up may add a separate deploy workflow or external runner without embedding stack config in YAML.
- **FR-TF-2:** Use **reusable modules** as appropriate. *Done:* `terraform/modules/` (vpc, security_groups, secrets, aurora, ecs_fargate) composed by thin roots under `terraform/stacks/`.
- **FR-TF-3:** Include **automated verification of configuration** in one or more modules (e.g. **Terraform tests** or equivalent checks that validate required configuration). *Not done yet:* no `terraform test` / policy checks in CI beyond validate.
- **FR-TF-4:** CI/CD must include a path for **deploying Terraform** resources. *Partial:* validate path exists; **apply** path is intentionally out of pipeline files pending explicit design (local CLI or future job that only references tfvars files, not inline env).
- **FR-TF-5:** Secrets via **SSM Parameter Store**, **Secrets Manager**, or similar — **no secrets in code**. *Done for infra:* app secret module + Aurora `manage_master_user_password`; tfvars examples hold placeholders only.
- **FR-TF-6:** IAM follows **least privilege**; **no wildcard policies**. *Done for current ECS execution/task inline policies* (no blanket `Resource: "*"` on IAM except where AWS APIs require documented exceptions—none added for generic `*` resource ARNs in this repo).

### 6.3 Automation service (primary focus)

- **FR-SVC-1:** Implement a service on **AWS ECS Fargate** or **AWS Lambda** supporting a **platform or developer workflow**; explicitly define the **user** and **experience** (“platform-as-a-product”).
- **FR-SVC-2:** Language is open (e.g. Python, TypeScript, Go, Java, Node per team stack).
- **FR-SVC-3:** **Input validation** and **robust error handling** are required.
- **FR-SVC-4:** **Containerized** (`Dockerfile`) for ECS, or **packaged** appropriately for Lambda.
- **FR-SVC-5:** Exposed via **load balancer**, **API Gateway (REST)**, or **CloudFront** (as appropriate to design).
- **FR-SVC-6:** Must be **demonstrable live** during the technical interview.
- **FR-SVC-7:** **Observability:** e.g. structured logging, **CloudWatch alarms** with **SNS** for key metrics (ECS: CPU/memory; Lambda: invocations/errors), and/or a simple dashboard — emphasis on **operational awareness**, not checkbox coverage.
- **FR-SVC-8:** Service must **record or emit important data** via at least one of: **S3**, **DynamoDB**, **RDS Aurora PostgreSQL** (reports, API outputs, or generated files).

**Illustrative ideas (non-exhaustive):**

- Self-service API to provision or configure cloud resources for dev teams.
- Webhook handler for GitHub/GitLab (e.g. labeling PRs, branch naming, deployment summaries via SNS).
- CLI or API aggregating health checks across services.
- Developer portal backend cataloging services, environments, or infrastructure.

### 6.4 Documentation

- **FR-DOC-1:** **README** with deploy steps and explanation of what was built.
- **FR-DOC-2:** **Design rationale** (1–2 paragraphs): one key design decision and alternatives considered — in README or `DECISIONS.md`.
- **FR-DOC-3:** **Technical diagram** (e.g. draw.io, Mermaid, or similar); commit source and/or image under a **`diagrams/`** directory (e.g. `.xml` and/or exported image).

---

## 7. Functional requirements — “digging deeper” (choose ≥1)

Complete **at least one** of the following. Depth in one area is preferred over shallow coverage of many.

| Option | Theme | Summary |
|--------|--------|---------|
| **1** | Advanced Terraform | Modularize heavily; CMK encryption at rest where supported; encryption in transit; comprehensive logging; serverless RDS used by the app; autoscaling; automated IaC checks/validation in CI/CD. |
| **2** | AI maturity | Use **Bedrock** in the containerized service; safe AI usage; multiple AI tasks cooperating; AI for PR reviews with a **sample PR** (may include intentionally flawed code for demo). |
| **3** | Application depth | Strong application code tied to data layer; IAM auth to Postgres or another data layer; API (e.g. FastAPI, Gin); health checks in app and infrastructure. |
| **4** | Operational intelligence | **Python or Go** tool aggregating platform ops data (e.g. GitHub Actions history, S3 encryption/logging audit, IAM role usage, log ingestion reports, resource inventories). |
| **5** | Diagrams | More detailed diagram(s) than core minimum — e.g. production GitOps or secure HA architecture. |
| **6** | Custom | Other relevant, unique, valuable platform work; may combine or vary the above. |

---

## 8. Technical context (NGX team stack reference)

- **DevEx:** GitHub, GitHub Actions, Claude Code, etc.
- **Client & services:** JavaScript, TypeScript, Java, React, Node, Python, etc.
- **Infrastructure:** Terraform; AWS (ECS, Lambda, CloudFront, S3, ElastiCache, RDS, Systems Manager, etc.)

Bonus consideration: demonstrating skills in the above technologies where it fits the design.

---

## 9. Success criteria (acceptance)

Use this checklist against the **original** challenge; bracketed notes reflect **this repository as of 2026-05-03**.

- [ ] **Core — AI (FR-AI):** AI agent config in repo + open PR demonstrating AI-assisted work. *[ ] Not started (`CLAUDE.md` / equivalent absent).*
- [ ] **Core — Terraform & CI (FR-TF):** Reusable modules; automated checks/tests; deploy path; no wildcard IAM; no hardcoded secrets. *Partial: modules + split S3 state stacks + least-privilege patterns + Secrets Manager; `[x]` fmt/validate CI only; `[ ]` Terraform tests; `[ ]` automated apply in CI.*
- [ ] **Core — Automation service (FR-SVC):** ECS Fargate or Lambda with validation, error handling, Dockerfile, LB/API GW/CloudFront, observability (logs/alarms/SNS), persistence (S3 | DynamoDB | Aurora). *Partial: `[x]` ECS Fargate + ALB + Aurora in Terraform; `[ ]` custom app code, Dockerfile, input validation, alarms/SNS, S3/Dynamo app persistence beyond Aurora as the data plane for future app.*
- [ ] **Core — Docs (FR-DOC):** README (deploy + what you built), design rationale, `diagrams/`. *Partial: `[x]` `terraform/stacks/README.md` + env/stack `*.tfvars.example`; `[ ]` repository root README, `DECISIONS.md`, `diagrams/`.*
- [ ] **Supplemental:** At least one “digging deeper” option (§7) with depth. *[ ] Not selected / not implemented.*
- [ ] **Repository hygiene:** Shareable read-only remote; commits support narrative. *Pending user push/PR policy.*

---

## 10. Implementation status (detailed delta)

| PRD / goal | Status | Evidence / gap |
|------------|--------|------------------|
| **G1** Core + supplemental | **In progress** | Core infra slice exists; supplemental option not started. |
| **G2** Visible CI/CD | **Partial** | `.github/workflows/terraform.yml`, `.gitlab-ci.yml` — lint/validate only by design; no `terraform apply` in YAML. |
| **G3** Automation service (product) | **Partial** | Terraform provisions ECS + ALB + placeholder **nginx** image; no bespoke platform service, Dockerfile, or app-layer validation yet. |
| **G4** Persistence (S3 / Dynamo / Aurora) | **Partial** | **Aurora PostgreSQL** + managed master secret; no app writing to S3/Dynamo yet. |
| **G5** AI workflow evidence | **Not started** | No `CLAUDE.md` / MCP config; no sample PR documented in-repo. |
| **G6** Docs & diagrams | **Partial** | Stack/env tfvars examples + stack README; no root README, `DECISIONS.md`, or `diagrams/`. |
| **FR-TF-2** Modules | **Done** | `terraform/modules/{vpc,security_groups,secrets,aurora,ecs_fargate}`. |
| **FR-TF-1 / FR-TF-4** Deploy via pipeline | **Gap** | Intentional: all stack inputs live in **tfvars** + `backend.hcl`; pipelines stay static. Reconcile with reviewers by adding a thin apply job that only invokes Terraform with committed or mounted var-files, or document TFC/GitOps. |
| **FR-TF-3** Tests | **Gap** | Add `terraform/tests` or module-level `tests` + optional `check` blocks / policy in CI. |
| **FR-TF-5 / FR-TF-6** Secrets & IAM | **Largely done** | Secrets Manager for app token + RDS-managed master; SG wiring; scoped IAM for ECS tasks (review ECR/public image pull path if switching images). |
| **FR-SVC** Full service requirements | **Gap** | Alarms/SNS, structured app logging, Dockerfile, API semantics, “platform user” narrative still open. |
| **§7 Supplemental** | **Not started** | Pick one option and link from future `DECISIONS.md`. |

**Inventory (paths):** `terraform/modules/`, `terraform/stacks/{vpc,security_groups,secrets,aurora,ecs_fargate}/`, `terraform/env/*.tfvars.example`, `.github/workflows/terraform.yml`, `.gitlab-ci.yml`.

---

## 11. Interview follow-up (product “release” demo)

If moving forward, the candidate should expect to:

- Screen share a **functioning** solution.  
- Walk through **design and key decisions** and **code**.  
- Complete a **short baseline** CLI/coding exercise **without AI**.  
- **Demo AI workflow** live (extend service, debug, or add a module).  
- Optionally show deployments or screenshots.

---

## 12. Traceability note

This PRD is derived from the official NGX Senior Platform Engineer code challenge PDF. Where the PDF had ambiguous line breaks, requirements were consolidated to match reviewer intent (e.g. Terraform module verification via tests or equivalent automated checks).
