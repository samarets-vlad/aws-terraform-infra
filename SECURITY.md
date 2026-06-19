# Security Policy

## Supported Versions

This repository is a portfolio/reference project. Security fixes are applied to the `main` branch only.

| Branch | Supported |
|--------|-----------|
| `main` | ✅ |

## Reporting a Vulnerability

If you discover a security vulnerability in this repository:

1. **Do not open a public GitHub issue.**
2. Use GitHub's [private vulnerability reporting](https://github.com/samarets-vlad/aws-terraform-infra/security/advisories/new) feature.
3. Include a description of the issue, steps to reproduce, and potential impact.

You will receive a response within 72 hours.

## Security Practices in this Repository

- Secrets are **never** committed to the repository. Sensitive variables (`db_password`) are marked `sensitive = true` and must be supplied via environment variables (`TF_VAR_*`) or a secrets manager.
- All S3 buckets have public access blocked and server-side encryption enabled.
- RDS instances have storage encryption and deletion protection enabled by default.
- EC2 instances enforce IMDSv2 (`http_tokens = required`) to prevent SSRF attacks against the metadata endpoint.
- CI pipeline runs `tfsec` on every push and pull request to catch misconfigurations before they reach AWS.
