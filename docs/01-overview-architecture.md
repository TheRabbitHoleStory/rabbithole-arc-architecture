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
