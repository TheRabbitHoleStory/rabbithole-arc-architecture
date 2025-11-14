# Cost Governance & Tagging

## Tag model

Standard tags applied to RabbitHole ARC resources:

- `Application = RabbitHoleARC`
- `Environment = Prod | Sandbox | Shared`
- `CostCenter = RHA`
- `Owner = CTO`

These tags back Cost Explorer cost allocation and anomaly detection.

## Guardrails

- **Service Control Policy** restricts costly/unused services (OpenSearch, Redshift, Kendra, AppStream).
- **Budgets**:
  - `RabbitHoleARC-MonthlyBudget` — overall AWS spend cap
  - `RabbitHoleARC-Bedrock-MonthlyCap` — AI cost guardrail

## Org intent

Architecture designed to pass AWS SA review and enable:
- AWS Activate credits and follow-on programs
- Clear separation of experimental vs. production workloads
- Clean cost story for investors and finance
