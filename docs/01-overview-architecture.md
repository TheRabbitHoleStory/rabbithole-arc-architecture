# RabbitHole ARC — System Overview

RabbitHole ARC is an Augmented Reality Cinema platform built by **Elder Scare LLC**.

It combines:

- **Twine (SugarCube 2)** front-end for interactive story flow
- **YouTube IFrame API** for cinematic video playback
- **GPS triggers** (browser geolocation) for location-based unlocks
- **AWS API Gateway + Lambda** as the API layer
- **Amazon Bedrock** for AI agents (character dialogue, narrative generation)
- **Amazon Rekognition** for video intelligence on S3 media
- **Supabase** for auth, anonymous sessions, and player progress

This repo documents:

- High-level architecture diagrams
- AWS Organizations & account structure
- Bedrock and Rekognition pipelines
- Cost governance and tagging model

### Nova Controller (Planned)

RabbitHole ARC will introduce a **Nova Controller** service that sits alongside the existing AWS Bedrock / Rekognition pipeline:

- **Region:** `us-east-2` (same as existing Bedrock usage)
- **Runtime:** AWS Lambda behind API Gateway (REST, Lambda proxy)
- **Role:** High-level orchestration of AI tooling (Bedrock Nova models, Rekognition outputs, Supabase context) into a single, opinionated API for the front-end (Twine).
- **Endpoints (planned):**
  - `POST /nova/story-intel` – takes video/scene metadata, Rekognition labels, and user state; returns narrative intelligence for RabbitHole ARC.
  - `POST /nova/agent` – exposes a controlled multi-turn “ARC agent” for partners/investors to query system behavior.
- **Inputs:** S3 media keys, Rekognition analysis results, Supabase player/session IDs, front-end hints.
- **Outputs:** Compact JSON payloads (recommendations, tags, beats, prompts) used to drive Twine passages, UI states, and demo reporting.
