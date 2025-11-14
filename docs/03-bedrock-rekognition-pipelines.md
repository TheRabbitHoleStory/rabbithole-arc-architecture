# Bedrock & Rekognition Pipelines

## Bedrock (Future agents)

- Region: `us-east-2`
- Invocation through **API Gateway REST** + **Lambda (Node.js 22)**
- Lambda uses **Amazon Bedrock** via an inference profile ARN
- JSON response: `{ "message": "<agent reply text>" }`
- Twine (SugarCube) calls API Gateway with `fetch()` from the browser

## Rekognition (Video analysis demo)

- Region: `us-east-1`
- S3 ingest bucket: `rabbithole-rekognition-ingest` (private)
- Lambda #1: starts `StartLabelDetection` on the S3 object
- SNS topic receives Rekognition job complete event
- Lambda #2: calls `GetLabelDetection` and returns simplified:
  ```json
  {
    "status": "SUCCEEDED",
    "labels": [
      { "name": "Person", "timestampMs": 1234, "confidence": 98.7 }
    ]
  }
