terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

data "aws_organizations_organization" "this" {}

resource "aws_organizations_policy" "rh_global_security" {
  name        = "RH-GlobalSecuritySCP"
  description = "Deny unsupported regions and restrict high-cost services"
  type        = "SERVICE_CONTROL_POLICY"
  content     = file("${path.module}/scp-rh-global-security.json")
}

resource "aws_organizations_policy_attachment" "root" {
  policy_id = aws_organizations_policy.rh_global_security.id
  target_id = data.aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_policy_attachment" "sandbox" {
  policy_id = aws_organizations_policy.rh_global_security.id
  target_id = "ou-d856-fqps3rtj"
}

resource "aws_organizations_policy_attachment" "shared_services" {
  policy_id = aws_organizations_policy.rh_global_security.id
  target_id = "ou-d856-jciayb29"
}

resource "aws_organizations_policy_attachment" "prod" {
  policy_id = aws_organizations_policy.rh_global_security.id
  target_id = "ou-d856-uhyy40uc"
}
