# 02 — Nova Controller (Bedrock)

## Purpose

The **Nova Controller** is a lightweight orchestration Lambda that exposes a single
HTTP endpoint for RabbitHole ARC front-ends (Twine / Miss Murder Me demo) to call
into **Amazon Bedrock (Nova models)**.

It gives us:
- A single, well-defined API for “AI thinking” in the demo.
- Central control over model choice, system prompts, and guardrails.
- A place to add logging, safety checks, and cost controls.

## High-level flow

1. User interacts with the Miss Murder Me demo (Twine / SugarCube).
2. Front-end calls `POST /nova-controller` on **API Gateway (REST, Lambda proxy)**.
3. API Gateway invokes the **`nova-controller` Lambda**.
4. Lambda:
   - Validates the request.
   - Builds a prompt / body for a **Nova** model on Bedrock.
   - Calls Nova via **Amazon Bedrock** in `us-east-2` (region can be adjusted).
   - Normalizes the model’s response into a simple JSON shape.
5. Lambda returns `{ "message": "…string…" }` (or richer JSON) back through API Gateway.
6. Twine renders the reply with a typewriter effect, etc.

## Endpoint contract

**Method:** `POST`  
**Path (example):** `/nova-controller`  
**Auth:** (initial demo) none or simple API key; future: Supabase / JWT.

### Request body (from Twine)

```jsonc
{
  "playerId": "anon-123",
  "mode": "storyBeat",      // "storyBeat" | "analysis" | "systemDebug" (future)
  "context": {
    "sceneId": "mmm-demo-01",
    "beatId": "interrogation-1"
  },
  "userInput": "The player’s text or choice here",
  "metadata": {
    "client": "twine",
    "build": "demo-2025-11",
    "source": "miss-murder-me"
  }
}
