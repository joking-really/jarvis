# AI CRM Technical Stack — Session Decisions (2026-05-18)

## Product: Axovion CRM (SaaS) + Axovion Enterprise (Infrastructure)

## Final Decisions Log

### Business Model
- Pricing: Hybrid subscription + usage credits
- Tiers: Starter $49, Growth $79, Pro $149, Enterprise $349+
- Credit expiry: 12 months rolling
- Overage: $0.04/minute above plan
- Payment: Stripe
- Target: Pakistan initially, global expansion

### Multi-Tenancy
- Strategy: Database-per-tenant
- Isolation: Strong (separate DB per tenant)
- Connection: Mongoose connection pool
- Resolution: Subdomain-based (tenant.axovion.io)

### AI Stack
- Primary: Groq Llama 3.3 70B ($0.0009/1K tokens, <100ms)
- Fallback 1: OpenAI GPT-4o-mini ($0.015/1K tokens, 99.9% uptime)
- Fallback 2: Together AI Llama 3.3 70B ($0.0018/1K tokens)
- TTS: ElevenLabs Multilingual v2 ($0.10/1K chars)
- STT: OpenAI Whisper-1 ($0.006/min)
- Fallback cost cap: 20% max, then queue and retry primary

### Voice Architecture
- Provider: Twilio
- Numbers: Dedicated per tenant (Option B)
- Inbound: AI answers, warm transfer to human
- Outbound: Click-to-call from dashboard
- Transfer: Warm transfer (AI introduces, then drops)
- Voicemail: AI takes message outside business hours
- Recording: Audio temporary (24-48h), transcripts permanent

### Channels (MVP)
1. Voice (inbound + outbound)
2. WhatsApp (Meta Business API)
3. Email (Resend)
- Out of MVP: Instagram, Facebook Messenger

### Real-Time
- WebSocket: Socket.IO with Redis Adapter
- Rooms: tenant:{id}, user:{id}, conversation:{id}
- Events: conversation, message, call, handoff, agent status

### Database
- Primary: MongoDB Atlas M10 (Singapore)
- Strategy: Database-per-tenant
- Indexes: phone (unique), email, assignedAgentId, status, createdAt
- Text search: MongoDB native (no Elasticsearch for MVP)

### Cache
- Provider: Redis (Docker on EC2 for MVP)
- Uses: Session, tenant config, conversation context, rate limiting
- TTL: Config 5min, context 1hr, API 1min

### Queue
- Technology: BullMQ with Redis
- Queues: ai:response, transcription, webhook:deliver, analytics:daily
- Retry: Exponential backoff, dead letter queue after 5 attempts

### Storage
- Provider: Cloudflare R2
- Content: Documents, media, call recordings (temp), exports
- Cost: $0.015/GB, zero egress fees

### Email
- Provider: Resend
- Free tier: 3000/month
- Features: Transactional, template rendering

### Hosting
- Backend: AWS EC2 t3.large (Singapore ap-southeast-1)
- Frontend: Vercel (Next.js)
- CDN: Cloudflare (assets, DDoS, SSL)
- SSL: Cloudflare Origin CA

### Monitoring
- Errors: Sentry (free tier)
- Metrics: Grafana Cloud (free tier)
- Uptime: UptimeRobot (free tier)
- Latency: Custom tracking for AI providers
- Log retention: 30 days

### Security
- Auth: JWT (15min) + refresh (7d) + Google OAuth
- RBAC: Super Admin, Tenant Admin, Agent, Viewer
- API: API keys for Pro plan (read-only)
- Rate limiting: By tenant ID, tiered (Starter 500/hr, Growth 2000/hr, Pro 10000/hr)
- Webhooks: HTTPS + HMAC-SHA256 signature

### CI/CD
- Platform: GitHub Actions
- Flow: Test → Build Docker → Push to EC2 → Restart
- Rollback: Docker image tag-based

### Frontend
- Framework: Next.js 14 (App Router)
- UI: shadcn/ui + Tailwind CSS
- State: Zustand (client) + TanStack Query (server)
- Forms: React Hook Form + Zod
- Real-time: Socket.IO client

### Backend
- Framework: NestJS 10
- Structure: Domain-driven modules
- Language: TypeScript
- Validation: Zod + class-validator

### AI Agent Configuration
- Templates: Sales, Support, General (3 for MVP)
- Tone: Professional, Friendly, Casual
- Memory: Short-term (last 5 conversations, 48h window)
- Handoff triggers: Explicit request, negative sentiment, repeated failure
- Language: Auto-detect (English + Urdu for Pakistan), English fallback

### Human Handoff
- Routing: Round-robin
- Timeout: 30 seconds for agent acceptance
- No agent available: AI continues, collects callback info
- After resolution: AI resumes with full context summary

### Billing
- Model: Hybrid (subscription base + usage credits)
- Top-ups: $20 for 500 minutes
- Tracking: Per-tenant usage events
- Invoicing: Monthly via Stripe

### Feature Flags
- Level: Tenant-level
- Use: Gradual rollout, beta testing
- Storage: MongoDB tenant document

### White-Label
- MVP: Logo + primary color (Pro plan only)
- Full: Custom domain, complete branding (Enterprise)

### Document Upload
- Types: PDF, Word (.docx), CSV
- Processing: pdf-parse, mammoth, csv-parser
- Storage: R2
- Indexing: Knowledge base for AI context

### Compliance
- MVP: None specific (Pakistan market)
- Architected for: GDPR, CCPA, SOC 2
- Future: HIPAA, PCI DSS, FedRAMP (Enterprise)

## Cost Estimates (MVP, 50 customers)

| Service | Monthly Cost |
|---------|-------------|
| AWS EC2 t3.large | $65 |
| MongoDB Atlas M10 | $57 |
| Redis (Docker) | $0 |
| Cloudflare Pro | $20 |
| Twilio (voice) | $200 |
| Groq (AI) | $300 |
| ElevenLabs (TTS) | $150 |
| OpenAI (fallback) | $50 |
| Resend (email) | $0 |
| Stripe (processing) | $150 |
| Sentry | $0 |
| Grafana | $0 |
| **Total** | **~$1,007** |
| Revenue (50 × $79) | $3,950 |
| **Gross Margin** | **~75%** |

## Enterprise Differences

| Aspect | SaaS | Enterprise |
|--------|------|------------|
| Deployment | AWS EC2 | Kubernetes (EKS/AKS/GKE) |
| AI | Groq API | Self-hosted vLLM |
| TTS | ElevenLabs | Self-hosted Piper |
| Database | MongoDB Atlas | Self-hosted MongoDB |
| Storage | Cloudflare R2 | MinIO |
| Monitoring | Sentry + Grafana Cloud | Prometheus + Grafana |
| Orchestration | Docker Compose | Kubernetes |
| GitOps | GitHub Actions | ArgoCD |
| Secrets | Env vars | HashiCorp Vault |

## Files Generated

### axovion-crm (23 files, 4,832 lines)
- fullproject.md — Complete architecture
- mvp.md — MVP scope
- architecture.md — High-level design
- frontend.md — Next.js architecture
- backend.md — NestJS modules
- ai-agents.md — AI provider stack
- ai-orchestration.md — Message flow
- workflows.md — Business workflows
- deployment.md — Docker, CI/CD
- scaling.md — 4-phase strategy
- security.md — Auth, RBAC, data protection
- integrations.md — Built-in integrations
- billing.md — Pricing, usage tracking
- websocket.md — Socket.IO architecture
- redis.md — Caching strategy
- queues.md — BullMQ jobs
- monitoring.md — Metrics, alerting
- roadmap.md — 12-week plan
- tenancy.md — Database-per-tenant
- auth.md — JWT, OAuth, RBAC
- notifications.md — In-app + email
- analytics.md — MVP metrics
- infrastructure.md — AWS, Docker, Nginx

### axovion-enterprise (9 files, 988 lines)
- fullproject.md — Enterprise architecture
- mvp.md — Enterprise MVP scope
- architecture.md — Kubernetes-native design
- deployment.md — Helm charts, K8s manifests
- scaling.md — Enterprise scaling
- security.md — Compliance, encryption
- monitoring.md — Prometheus, Grafana
- roadmap.md — 12-week deployment
- infrastructure.md — K8s cluster, storage
