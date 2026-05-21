# Session Decision Log — 2026-05-18

## Session Context

**Products:** Two related but separate products
- Product 1: Multi-tenant AI SaaS CRM Platform
- Product 2: Custom Enterprise AI Infrastructure Platform (manual deployment per client)

**User:** Metawib, building BATIK brand. Pakistan-first customers. WhatsApp primary communication.
**Session type:** Deep architecture discovery — 90+ questions before architecture generation
**Approach:** Sequential questioning (one question per turn), agile MVP scoping

---

## Business Model Decisions

| # | Decision | Value | Locked |
|---|----------|-------|--------|
| 1 | Product 1 monetization | Hybrid: base subscription + credit top-ups | YES |
| 2 | Product 1 pricing tiers | Starter $39, Growth $79, Pro $149, Enterprise $349+ | YES |
| 3 | Product 2 monetization | Hybrid managed deployment: $75K-250K setup + $50K-150K/year license + $15K-40K/month managed | YES |
| 4 | Credit expiration | 12-month rolling expiry, FIFO consumption | YES |
| 5 | Credit alerts | 30 days and 7 days before expiry | YES |
| 6 | AI usage pooling | Pooled across organization, not per-user | YES |
| 7 | Annual billing | 2 months free for annual prepay | YES |
| 8 | Free trial | 14-day free trial + freemium (1 user, limited AI) | YES |
| 9 | White-label premium | 40% premium for white-label option | YES |
| 10 | Product 1 → Product 2 pipeline | SaaS clients upgrade to enterprise when they outgrow shared infra | YES |

---

## Technical Architecture Decisions

| # | Decision | Value | Locked |
|---|----------|-------|--------|
| 11 | Tenant isolation | Database-per-tenant | YES |
| 12 | Voice telephony | Twilio | YES |
| 13 | Text-to-speech | ElevenLabs | YES |
| 14 | Primary LLM | Groq Llama 3.3 70B | YES |
| 15 | Fallback 1 | OpenAI GPT-4o-mini | YES |
| 16 | Fallback 2 | Together AI Llama 3.3 70B | YES |
| 17 | Fallback circuit-breaker | Max 20% fallback usage, then queue primary | YES |
| 18 | Transcription | Whisper (OpenAI) | YES |
| 19 | Audio storage | Delete 24-48h after transcription | YES |
| 20 | Transcript storage | Permanent in MongoDB | YES |
| 21 | Concurrent calls target (launch) | 5-10 total | YES |
| 22 | Concurrent calls target (month 6) | 50-100 | YES |
| 23 | Concurrent calls target (month 12) | 200-500 | YES |
| 24 | Per-tenant call limits | Starter: 10 concurrent, Growth: 20, Pro: 50-100 | YES |
| 25 | Phone number strategy | Dedicated number per tenant (Twilio) | YES |
| 26 | Call transfer | Warm transfer (AI introduces, then drops) | YES |
| 27 | Voicemail | AI voicemail with transcription | YES |
| 28 | Call recording consent | Play "this call is recorded" message | YES |

---

## AI & Memory Decisions

| # | Decision | Value | Locked |
|---|----------|-------|--------|
| 29 | AI memory strategy | Short-term: last 5 conversations, 48h window | YES |
| 30 | Memory implementation | Embedded array in MongoDB contact document | YES |
| 31 | Long-term memory | Post-MVP (vector DB) | YES |
| 32 | Handoff triggers | Explicit request + negative sentiment + repeated failure (2-3x) | YES |
| 33 | AI during human handling | AI leaves thread completely | YES |
| 34 | Conversation closing | Human only, auto-close after 24h inactivity | YES |
| 35 | Reopening closed conversations | New thread with previous context summary | YES |
| 36 | Off-hours behavior | AI informs + limited help + takes message + creates ticket | YES |
| 37 | Business hours | Tenant-level, timezone-aware, per-agent shifts post-MVP | YES |
| 38 | AI tone presets | Professional, Friendly, Casual | YES |
| 39 | Custom tone | Pro plan only | YES |
| 40 | Language support | UI English, AI responses English + Urdu (auto-detect) | YES |
| 41 | Language fallback | English if detection fails | YES |
| 42 | AI agent config | Simple form + 5-10 pre-built templates | YES |
| 43 | Visual flow builder | Post-MVP | YES |
| 44 | Lead scoring | Simple rule-based (source, response, pricing inquiry) | YES |

---

## Channel Decisions

| # | Decision | Value | Locked |
|---|----------|-------|--------|
| 45 | MVP channels | Voice (inbound + outbound) + WhatsApp + Email | YES |
| 46 | Instagram DM | Post-MVP (month 2-3) | YES |
| 47 | Facebook Messenger | Post-MVP (month 4-6) | YES |
| 48 | SMS | Post-MVP (month 4-6) | YES |
| 49 | WhatsApp message types | Text + images + documents + voice notes | YES |
| 50 | WhatsApp voice notes | Transcribe with Whisper, respond with text | YES |
| 51 | WhatsApp WABA | Hybrid: your WABA for Starter/Growth, tenant's own for Pro/Enterprise | YES |
| 52 | WhatsApp templates | Pre-approved library + auto-submit 5 basics on signup | YES |
| 53 | Email threading | Subject-based | YES |
| 54 | Email signature | Tenant-configured | YES |
| 55 | Email service | Resend | YES |
| 56 | Opt-out | Keyword-based ("STOP", "UNSUBSCRIBE") | YES |

---

## Data & Storage Decisions

| # | Decision | Value | Locked |
|---|----------|-------|--------|
| 57 | Database | MongoDB Atlas M10 | YES |
| 58 | ODM | Mongoose | YES |
| 59 | File storage | Cloudflare R2 | YES |
| 60 | Document upload | PDF + Word + CSV | YES |
| 61 | Contact import | CSV upload + manual entry | YES |
| 62 | Contact deduplication | Phone-based merge | YES |
| 63 | Contact enrichment | None for MVP | YES |
| 64 | Data export | CSV only | YES |
| 65 | Data retention (cancelled) | Soft delete + 30-day grace, then hard delete | YES |
| 66 | Self-delete | Tenant can self-delete | YES |
| 67 | Backup testing | Automated monthly via GitHub Actions | YES |
| 68 | RTO | 4 hours | YES |
| 69 | RPO | 24 hours | YES |

---

## Infrastructure Decisions

| # | Decision | Value | Locked |
|---|----------|-------|--------|
| 70 | Frontend hosting | Vercel | YES |
| 71 | Backend hosting | AWS EC2 t3.large (ap-southeast-1) | YES |
| 72 | Server specs | 4 vCPU, 8GB RAM, 160GB SSD | YES |
| 73 | Deployment | Docker + Docker Compose | YES |
| 74 | CI/CD | GitHub Actions → Docker build → push → restart | YES |
| 75 | Environments | Production + local dev only | YES |
| 76 | Staging | Post-MVP (100+ customers) | YES |
| 77 | Domain | Subdomains per tenant (*.yourplatform.com) | YES |
| 78 | SSL | Cloudflare Origin CA | YES |
| 79 | CDN | Cloudflare | YES |
| 80 | DDoS protection | Cloudflare free tier | YES |
| 81 | Real-time | Socket.IO + Redis Adapter | YES |
| 82 | Queue | BullMQ + Redis | YES |
| 83 | Redis location | Self-hosted on same EC2 instance | YES |
| 84 | Secret management | Environment variables (Docker Compose) | YES |
| 85 | Terraform/CloudFormation | From day 1 for portability | YES |

---

## Dashboard & UI Decisions

| # | Decision | Value | Locked |
|---|----------|-------|--------|
| 86 | Admin dashboard | Separate (your team) | YES |
| 87 | Client + Agent dashboard | Combined for MVP | YES |
| 88 | Agent-only dashboard | Post-MVP | YES |
| 89 | Live dashboard features | Active calls, live transcripts, AI status, queue status, message stream | YES |
| 90 | Analytics scope | Operational metrics only (calls, messages, handoff rate, duration) | YES |
| 91 | Reporting export | CSV only | YES |
| 92 | Search | Basic + advanced filters | YES |
| 93 | Saved filters | Post-MVP | YES |
| 94 | Semantic search | Post-MVP (vector DB) | YES |
| 95 | Unified timeline | Yes (all channels in one feed) | YES |
| 96 | Contact notes + tasks | Yes, with due dates | YES |
| 97 | Reminders | Post-MVP | YES |

---

## Authentication & Security

| # | Decision | Value | Locked |
|---|----------|-------|--------|
| 98 | Auth methods | Email + Google OAuth | YES |
| 99 | MFA | Post-MVP | YES |
| 100 | Roles | Super Admin, Tenant Admin, Agent, Viewer | YES |
| 101 | API auth | API key in header | YES |
| 102 | API versioning | URL-based (/api/v1/) | YES |
| 103 | API rate limits | Tiered: Starter 500/hr, Growth 2000/hr, Pro 10000/hr | YES |
| 104 | Webhook security | HTTPS + HMAC signature | YES |
| 105 | Webhook retries | Exponential backoff, 7 attempts, dead letter queue | YES |
| 106 | Rate limiting by | Tenant ID | YES |

---

## Billing & Payments

| # | Decision | Value | Locked |
|---|----------|-------|--------|
| 107 | Payment processor | Stripe | YES |
| 108 | Billing model | Hybrid: base subscription + usage overage + credit top-ups | YES |
| 109 | Overage billing | 1.5x included rate | YES |
| 110 | Credit purchase | $20 for 500 minutes (example) | YES |
| 111 | Plan downgrade | Credits don't downgrade, features do | YES |

---

## Monitoring & Operations

| # | Decision | Value | Locked |
|---|----------|-------|--------|
| 112 | Uptime monitoring | UptimeRobot (free) | YES |
| 113 | Error tracking | Sentry (free tier) | YES |
| 114 | Performance metrics | Grafana Cloud (free tier) | YES |
| 115 | AI provider latency tracking | Custom metrics in Grafana | YES |
| 116 | Log scope | Errors + API + AI interactions | YES |
| 117 | Log retention | 30 days | YES |
| 118 | Alerting | Email for now, PagerDuty post-MVP | YES |

---

## Support & Onboarding

| # | Decision | Value | Locked |
|---|----------|-------|--------|
| 119 | Customer support channel | Email only | YES |
| 120 | AI support chatbot | Post-MVP (200+ customers) | YES |
| 121 | Self-service docs | Post-MVP (based on actual questions) | YES |
| 122 | Onboarding | Self-serve signup + 30-min onboarding call | YES |
| 123 | Website crawl onboarding | Manual: crawl 3 pages, pre-fill prompts, customer edits | YES |
| 124 | Full auto-onboarding | Post-MVP | YES |

---

## Webhooks & API

| # | Decision | Value | Locked |
|---|----------|-------|--------|
| 125 | Webhook events | New contact, call start/end, handoff, AI failure, deal stage change | YES |
| 126 | Webhook scope | Basic POST + retry | YES |
| 127 | Webhook signature | HMAC-SHA256 | YES |
| 128 | Webhook delivery logs | Post-MVP | YES |
| 129 | Public API scope | Read-only for MVP | YES |
| 130 | Full CRUD API | Post-MVP | YES |

---

## Testing & Quality

| # | Decision | Value | Locked |
|---|----------|-------|--------|
| 131 | Unit tests | Yes (business logic, AI orchestration) | YES |
| 132 | Integration tests | Yes (API endpoints) | YES |
| 133 | E2E tests | No (frontend changes too fast) | YES |
| 134 | Real API testing | Yes (Twilio, ElevenLabs, Groq) | YES |
| 135 | Mock testing | No | YES |

---

## Caching & Performance

| # | Decision | Value | Locked |
|---|----------|-------|--------|
| 136 | Tenant config cache | 5 minutes TTL | YES |
| 137 | Conversation context cache | 1 hour TTL | YES |
| 138 | User session cache | 24 hours TTL | YES |
| 139 | Rate limit counter cache | 1 hour TTL | YES |

---

## MongoDB Indexing

| # | Collection | Indexes |
|---|-----------|---------|
| 140 | contacts | phone (unique), email, tenant_id, created_at, assigned_agent_id |
| 141 | conversations | tenant_id, contact_id, status, created_at, updated_at |
| 142 | messages | conversation_id, created_at, channel |
| 143 | deals | tenant_id, contact_id, stage, created_at, assigned_agent_id |
| 144 | calls | tenant_id, contact_id, status, started_at, ended_at |
| 145 | users | tenant_id, email, role |
| 146 | webhooks | tenant_id, event_type, status, created_at |
| 147 | tenants | subdomain, status, plan |

---

## Pipeline & CRM

| # | Decision | Value | Locked |
|---|----------|-------|--------|
| 148 | Default pipeline | New Lead → Contacted → Qualified → Proposal → Negotiation → Closed Won/Lost | YES |
| 149 | Custom pipelines | Pro plan | YES |
| 150 | Lead assignment | Round-robin | YES |
| 151 | Skill-based routing | Post-MVP | YES |
| 152 | Deal stages | Fixed for MVP, customizable Pro+ | YES |
| 153 | Lead source tracking | Auto-detect from channel | YES |
| 154 | UTM tracking | Post-MVP | YES |

---

## White-Label

| # | Decision | Value | Locked |
|---|----------|-------|--------|
| 155 | Logo + primary color | Pro plan ($149+) | YES |
| 156 | Custom domain | Enterprise | YES |
| 157 | Full branding | Enterprise | YES |

---

## Campaigns & Broadcasts

| # | Decision | Value | Locked |
|---|----------|-------|--------|
| 158 | Templated broadcast | Yes (MVP) | YES |
| 159 | Segments | Post-MVP | YES |
| 160 | A/B testing | Post-MVP | YES |
| 161 | Drip sequences | Post-MVP | YES |

---

## Key Session Insights

1. **User praised agile MVP approach** when used to scope down website auto-crawl, visual flow builder, and AI support chatbot.

2. **User accepted lower pricing** after market data presented. Final tiers: $39/$79/$149/$349+.

3. **User's first customers in Pakistan** drove Urdu language support decision and WhatsApp priority.

4. **User wants to use AI coding assistants** (Kimi K2.6, Claude Code) for production build. Multi-model strategy recommended.

5. **User occasionally types incorrect tech names** ("Skype" for Stripe, "11qro" for ElevenLabs). Gentle correction needed.

6. **User sometimes answers "yes" to multi-part questions** without specifying which parts. Break into single questions or confirm each part.

7. **User expresses ideas poorly then says "you got it"** when restated correctly. Restate understanding before locking in.

8. **User delegates quickly** when presented with clear tradeoffs. Don't ask "are you sure?" — accept delegation and explain reasoning.

9. **AWS chosen over DigitalOcean** due to $800-1000 free credits. Terraform from day 1 for portability.

10. **Voice is differentiator** — must be in MVP despite complexity. WhatsApp + email support voice strategy.

---

## Open Questions for Next Session

1. Product 2 (Enterprise Infrastructure) architecture — separate discovery needed
2. Specific NestJS module structure
3. Next.js page/component structure
4. MongoDB schema details
5. AI orchestration flow (prompt chaining, context management)
6. Twilio Media Streams implementation details
7. WebSocket room architecture per tenant
8. BullMQ job definitions
9. Stripe subscription + usage billing integration
10. Docker Compose service definitions
