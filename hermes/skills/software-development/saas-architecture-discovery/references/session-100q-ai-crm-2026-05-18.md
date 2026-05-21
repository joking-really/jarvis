# Session Reference: 100+ Question AI CRM Architecture Discovery

**Date:** 2026-05-18  
**User:** Metawib (Axovion)  
**Products:** AI SaaS CRM + Enterprise AI Infrastructure  
**Session Duration:** 100+ questions before architecture generation  

## Session Pattern: 100+ Question Deep-Dive

This session validated the "100 meaningful questions before architecture" approach requested by the user. The depth prevented costly rework and produced a solid foundation.

### Question Categories Asked

| Category | Questions | Key Decisions |
|----------|-----------|---------------|
| Business Model | 1-5 | Hybrid pricing ($39-79-149), credit system, 12-month expiry |
| Tenant Isolation | 5 | Database-per-tenant |
| AI/Voice Architecture | 6-10 | Twilio+ElevenLabs+Groq, NOT AI-native APIs (cost) |
| Concurrency Planning | 10-12 | 500 concurrent system-wide (not per-tenant) |
| Resource Quotas | 12-13 | 10/20/50/100 concurrent calls by plan |
| Memory | 14-15 | Short-term (5 convos, 48h) for MVP |
| Handoff Triggers | 16-17 | Explicit request + negative sentiment + repeated failure |
| Website Crawl | 18-19 | Manual onboarding with AI-assisted pre-fill (NOT auto-crawl) |
| Dashboard Scope | 20-22 | Admin separate, Client+Agent combined |
| Auth | 23-24 | Email + Google OAuth |
| RBAC | 25-26 | 4 roles (Super Admin, Tenant Admin, Agent, Viewer) |
| Billing | 27-28 | Stripe, hybrid subscription + credits |
| Real-time | 29-30 | Socket.IO with Redis adapter |
| Database | 31-32 | MongoDB Atlas M10 |
| Storage | 33-34 | Cloudflare R2 |
| Recording | 35-36 | Transcripts only, audio deleted after processing |
| AI Fallback | 37-39 | Groq → OpenAI GPT-4o-mini → Together AI, 20% circuit breaker |
| Queue | 40-41 | BullMQ with Redis |
| Rate Limiting | 42-43 | By tenant ID, sliding window + token bucket |
| Email | 44-45 | Resend |
| Notifications | 46-47 | In-app + email only (no push) |
| Analytics | 48-49 | Operational metrics only |
| Deployment | 50-52 | Docker + Docker Compose on AWS EC2 |
| Domain | 53-54 | Subdomains per tenant |
| White-label | 55-56 | Logo + color on Pro plan only |
| Data Retention | 57-58 | Soft delete + 30-day grace |
| Support | 59-60 | Email only for MVP |
| Onboarding | 61-62 | Self-serve + 30-min onboarding call |
| Webhooks | 63-64 | Basic, 3 retries |
| API | 65-66 | Read-only for MVP |
| Testing | 67-68 | Unit + integration with real APIs |
| CI/CD | 69-70 | GitHub Actions → Docker → EC2 |
| Monitoring | 71-72 | UptimeRobot + Sentry + Grafana |
| Backup | 73-74 | Atlas automated + monthly restore test |
| Secrets | 75-76 | Env vars for MVP |
| Dependencies | 77-78 | Fail open + circuit breaker |
| Feature Flags | 79-80 | Tenant-level boolean flags |
| Code Org | 81-82 | Domain-driven folders |
| Frontend State | 83-84 | Zustand + TanStack Query |
| UI Library | 85-86 | shadcn/ui |
| Form Validation | 87-88 | React Hook Form + Zod |
| Compliance | 89-90 | None for MVP, architect for future |
| Localization | 91-92 | English UI + Urdu AI responses |
| AI Tone | 93-94 | 3 presets (Professional, Friendly, Casual) |
| Off-hours | 95-96 | AI continues with limited scope + message collection |
| Handoff Routing | 97-98 | Round-robin, AI holds if no agent |
| Transfer | 99-100 | Warm transfer |

## New Patterns Observed

### Pattern: "You Got It" Clarification
User expresses idea poorly or contradicts themselves, then confirms "you got it" when restated correctly.

**Example:**
- User: "inbound is most important because for customer queries... and outbound is more important than inbound because for order confirmation"
- Response: "Let me rephrase: outbound is HIGHEST priority (sales, cart recovery), inbound is HIGH priority (support). Both in MVP. Correct?"
- User: "yes agreed"

**Lesson:** Always restate your understanding before locking in. Present as "My understanding: [summary]. Correct?"

### Pattern: Typo Confirmation
User types incorrect technical names on mobile/fast chat ("11qro glabs" for ElevenLabs+Groq, "Skype" for Stripe).

**Response:** Gently confirm correct name without embarrassing. "I think you mean Stripe (payment processor), not Skype. Confirming — Stripe for payments?"

### Pattern: Multi-Part "Yes"
User answers "yes" to questions with multiple parts without specifying which.

**Response:** Break into single questions, or explicitly confirm each part: "You said yes — confirming both: 1) [A], 2) [B]. Correct?"

### Pattern: Quick Delegation
User agrees quickly with recommendations when presented clear tradeoffs. This is NOT lack of engagement — it is delegation to expert guidance.

**Lesson:** Do not ask "are you sure?" Accept delegation and briefly explain reasoning so they understand the decision.

### Pattern: Feature Scope Acceptance
User requests complex feature, accepts simpler MVP version when challenged with complexity, explicitly praises agile approach.

**Examples from session:**
- Website auto-crawl → Manual onboarding with pre-fill
- Per-agent business hours → Tenant-level hours
- AI support chatbot → Email only
- Visual flow builder → Template selection
- Full white-label → Logo + color only

### Pattern: Pricing Challenge
User initially thought pricing too high ($99-199). After market data and adjustment to $39-79-149, accepted.

**Lesson:** Present market data with competitor ranges, then propose startup-friendly pricing 30-40% below market. Emphasize: "You can always raise prices."

### Pattern: Geographic Context Driving Architecture
Pakistan-first customers affected multiple decisions:
- Urdu language support REQUIRED
- WhatsApp as primary channel
- Competitive pricing sensitivity
- ap-southeast-1 AWS region for latency
- No GDPR/CCPA initially but architect for expansion

## Key Technical Decisions from Session

| Decision | Chosen Option | Rejected Options |
|----------|--------------|------------------|
| Tenant isolation | Database-per-tenant | Collection-per-tenant, shared collections |
| Voice architecture | Twilio + ElevenLabs + Groq | Retell/Vapi/Bland (too expensive) |
| AI memory | Short-term (5 convos, 48h) | No memory, long-term (vector DB) |
| Handoff triggers | Explicit + sentiment + failure | All 7 options |
| Dashboard split | Admin separate, Client+Agent combined | 3 separate dashboards |
| Auth | Email + Google OAuth | Magic links, Microsoft OAuth |
| Billing | Hybrid subscription + credits | Pure subscription, pure usage |
| WebSocket | Socket.IO + Redis | Native ws, SSE |
| MongoDB hosting | Atlas M10 | Self-hosted, DocumentDB |
| File storage | Cloudflare R2 | S3, GridFS |
| Email | Resend | SendGrid, SES |
| Queue | BullMQ + Redis | SQS, RabbitMQ |
| Deployment | Docker + GitHub Actions | Manual, blue-green |
| CDN | Cloudflare | AWS CloudFront |
| Voice fallback | None (Twilio only) | Retell/Vapi as fallback |
| Notifications | In-app + email | WhatsApp, Slack, push |
| Analytics | Operational only | Business, AI performance |
| API | Read-only | Full CRUD, none |
| Testing | Unit + integration | None, full coverage |
| Support | Email only | Chatbot, docs, chat |
| Onboarding | Self-serve + call | Full self-serve, demo→sales |
| White-label | Logo + color (Pro) | None, full |
| Data retention | Soft delete 30 days | Immediate, 90 days |
| Backup test | Automated monthly | Manual quarterly |
| Secrets | Env vars | Secrets Manager, Vault |
| Rate limiting | By tenant ID | By IP, by API key |
| Domain | Subdomains | Paths, custom domains |
| Language | English UI + Urdu AI | Full i18n, English only |
| Off-hours AI | Limited scope + collect info | Full service, voicemail only |
| Call transfer | Warm transfer | Cold, conference, whisper |
| Voicemail | AI takes message + ticket | Standard voicemail, no voicemail |
| Reopening | New thread + summary | Same thread, no reopen |
| Closing | Human only + 24h auto | AI can close, no auto-close |
| Deduplication | Phone-based | None, fuzzy matching |
| Enrichment | None | Basic, third-party |
| Lead scoring | Rule-based | None, AI-based |
| Source tracking | Channel auto-detect | Manual, UTM, full attribution |
| Campaigns | Templated broadcast | None, full campaign builder |
| Template approval | Pre-approved library + auto-submit | Manual only, session-only |
| WABA | Hybrid (ours + bring own) | Ours only, bring own only |
| Message types | Text + media | Text only, interactive, rich |
| Voice notes | Transcribe + text reply | Store only, AI voice response |
| Email threading | Subject-based | None, reference-based |
| Email signature | Tenant-configured | None, agent name |
| Opt-out | Keyword-based | None, preference center |
| Data export | CSV | None, full JSON |
| API versioning | URL-based | None, header |
| API auth | API key | OAuth, JWT |
| Log retention | 30 days | 7 days, 90 days, 1 year |
| Error tracking | Sentry | None, PagerDuty |
| Performance | Grafana + AI latency | None, full APM |
| Server | AWS EC2 t3.large | DigitalOcean, Hetzner |
| SSL | Cloudflare Origin CA | Let's Encrypt, paid cert |
| DDoS | Cloudflare free | None, AWS Shield |
| Feature flags | Tenant-level boolean | None, user-level |
| Code org | Domain-driven | Flat, Clean Architecture |

## Cost Estimates Validated

| Scenario | Revenue | AI Costs | Infrastructure | Margin |
|----------|---------|----------|---------------|--------|
| 100 users Growth | $7,900/mo | $1,500-2,500 | $800-1,200 | 55-65% |
| 50 customers (launch) | $3,950/mo | ~$650 | ~$350 | ~75% |
| Enterprise deal (year 2) | $250K/yr | $40-60K deploy | $5-8K/mo | 70-75% |

## Files Produced

### axovion-crm (SaaS)
- fullproject.md (40,000+ words)
- mvp.md
- architecture.md
- frontend.md
- backend.md
- ai-agents.md
- ai-orchestration.md
- workflows.md
- deployment.md
- scaling.md
- security.md
- integrations.md
- billing.md
- websocket.md
- redis.md
- queues.md
- monitoring.md
- roadmap.md
- tenancy.md
- auth.md
- notifications.md
- analytics.md
- infrastructure.md

### axovion-enterprise (Infrastructure)
- fullproject.md
- mvp.md
- architecture.md
- deployment.md
- scaling.md
- security.md
- monitoring.md
- roadmap.md
- infrastructure.md
