variable "bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name for Terraform state objects."

  validation {
    condition     = length(trimspace(var.bucket_name)) > 0 && length(var.bucket_name) <= 63
    error_message = "bucket_name must be non-empty and comply with S3 naming (<= 63 chars)."
  }
}

variable "enable_versioning" {
  type        = bool
  description = "Keep multiple versions of state objects (strongly recommended)."
  default     = true
}

variable "force_destroy" {
  type        = bool
  description = "Allow bucket deletion when non-empty (lab only)."
  default     = false
}

variable "deny_insecure_transport" {
  type        = bool
  description = "Attach bucket policy denying requests without TLS."
  default     = true
}

variable "prevent_destroy" {
  type        = bool
  description = "If true, Terraform will refuse to destroy the bucket resource."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Additional tags for the bucket."
  default     = {}
}
