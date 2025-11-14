# 05 – Nova Controller (Planned)

## Purpose

The **Nova Controller** is a dedicated orchestration layer that standardizes how RabbitHole ARC uses **AWS Bedrock (Nova models)** together with existing media intelligence (Rekognition) and session state (Supabase).

Goals:

- Expose a **single clean API** to the Twine front-end for any “smart” behavior.
- Keep **model choice, prompts, and guardrails** on the backend (SA-friendly, auditable).
- Make the system easy to reason about in **Well-Architected / security reviews**.

---

## High-Level Design

- **Region:** `us-east-2`
- **Entry:** API Gateway (REST, Lambda proxy) → `novaController` Lambda.
- **Models:** Bedrock **Nova** family (text / multimodal) via inference profile.
- **State:** Supabase used for player/session/progress context.
- **Signals:** Rekognition outputs and S3 media metadata passed in as optional hints.

```text
Twine (SugarCube) UI
  → API GW /nova/*
    → Lambda: novaController
      → Bedrock Nova (via inference profile)
      → Supabase (player/session)
      → Rekognition results in S3/DB
    ← JSON response to UI
