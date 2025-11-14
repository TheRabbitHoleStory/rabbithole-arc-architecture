# rabbithole-arc-architecture
RabbitHole ARC – AWS architecture, Twine integration, Supabase backend
flowchart TB
  subgraph User["Audience / Reviewer"]
    W[Web / Mobile Browser]
  end

  subgraph Frontend["Twine (SugarCube) Front-End"]
    UI[RabbitHole ARC UI\n(rabbitholestory.com\nNetlify)]
    YT[YouTube IFrame Player]
    GPS[GPS / Device Sensors]
  end

  subgraph API["AWS API Layer (us-east-1/2)"]
    APIGW[API Gateway (REST)\n/talk, /startRekognition, /results]
    L1[Lambda: TalkToCharacter (Bedrock)]
    L2[Lambda: StartRekognitionJob]
    L3[Lambda: GetRekognitionResults]
  end

  subgraph AI["AI + Media Analytics"]
    BR[Amazon Bedrock (us-east-2)\nKendawg/Chalky agents]
    REK[Amazon Rekognition (us-east-1)\nLabel/Moderation on S3 video]
    SNS[SNS Topic (job status)]
  end

  subgraph Storage["Storage & Data"]
    S3I[S3: rabbithole-rekognition-ingest\n(ingest/private)]
    SUP[Supabase (Auth + Postgres)\nProgress, profiles, saves]
  end

  subgraph Gov["Cost & Governance (Mgmt Acct)"]
    ORG[AWS Organizations + OUs\nSandbox / SharedServices / Prod]
    SCP[SCP: Allowed Regions + Deny High-Cost\n(es:*, redshift:*, kendra:*, appstream:*)]
    BUD[Budgets + Anomaly Detection]
    CUR[Cost & Usage Report → S3]
    CW[CloudWatch Logs + Metrics\n(Alarms on spend/errors)]
  end

  W --> UI
  UI --- YT
  UI -->|fetch()| APIGW
  APIGW --> L1
  L1 -->|Invoke| BR
  L1 -->|reply JSON| APIGW --> UI

  UI -->|start analysis| APIGW --> L2 --> REK
  REK --> SNS
  L3 --> REK
  UI -->|poll /results| APIGW --> L3 -->|labels,timestamps| UI

  L2 --> S3I
  L3 --> SUP
  UI -->|auth/progress| SUP

  ORG -.-> SCP
  ORG -.-> BUD
  BUD -.-> CW
  ORG -.-> CURsequenceDiagram
  participant U as User Browser (Twine)
  participant GW as API Gateway (REST)
  participant T as Lambda: TalkToCharacter
  participant B as Amazon Bedrock (us-east-2)
  participant S3 as S3 ingest (us-east-1)
  participant R as Rekognition (us-east-1)
  participant G as Lambda: GetRekognitionResults
  participant DB as Supabase (Auth + Postgres)

  Note over U: User clicks rabbit / enters demo
  U->>GW: POST /talk {prompt, playerId, token}
  GW->>T: proxy event
  T->>B: invokeModel (persona system prompt)
  B-->>T: {message}
  T-->>GW: 200 {message}
  GW-->>U: render typewriter reply

  Note over U: Start video analysis (editor/demo)
  U->>GW: POST /startRekognitionAnalysis {s3Key}
  GW->>S3: (object must exist / presigned upload prior)
  GW->>R: StartLabelDetection (S3 URI)
  R-->>U: 202 {jobId via Lambda ack}

  Note over R: When complete
  R-->>G: GetLabelDetection by JobId (polled)
  G-->>GW: 200 {status, labels[]}
  GW-->>U: labels timeline → UI markers

  U->>DB: POST /progress {playerId, step, timestamp}
  DB-->>U: 200 OK

