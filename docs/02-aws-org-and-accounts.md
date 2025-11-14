# AWS Organizations & Account Structure

**Management account**  
- Account ID: `408278014840`  
- Legal entity: **Elder Scare LLC**  
- Domain: `rabbitholestory.com`

**Organizational Units (OUs)**  
- `Sandbox` — experiments, demos, prototypes  
- `SharedServices` — central tooling (logging, cost, org-wide services)  
- `Prod` — production workloads

**Member accounts (created under the Org):**
- `RHA-Billing` — billing and finance visibility
- `RHA-Infra` — core infrastructure, shared APIs
- `RHA-Prod` — live RabbitHole ARC experiences

**Service Control Policy: `RH-GlobalSecuritySCP`**

- Restricts regions to `us-east-1`, `us-east-2`, `us-west-2`
- Denies high-cost services not needed for RabbitHole ARC:
  - `es:*` (OpenSearch)
  - `redshift:*`
  - `kendra:*`
  - `appstream:*`
