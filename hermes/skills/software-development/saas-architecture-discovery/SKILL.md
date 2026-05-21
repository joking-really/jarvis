---
name: saas-architecture-discovery
description: "Discovery sessions for SaaS product architecture: requirements gathering, MVP scoping, pricing strategy, and technical decision documentation."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [saas, architecture, discovery, requirements, mvp, pricing, planning]
    related_skills: [writing-plans, plan, subagent-driven-development, e-commerce-brand-research]
---

# SaaS Architecture Discovery

Discovery sessions for SaaS and multi-tenant product architecture. Covers requirements gathering, MVP scoping, pricing strategy, technical decision documentation, and phased roadmap planning.

## When to Use

- Building a new SaaS product from scratch
- Architecting multi-tenant systems
- Planning AI-first SaaS platforms (CRM, automation, voice, chat)
- Defining MVP vs post-MVP feature boundaries
- Setting pricing tiers and unit economics
- Choosing between database isolation strategies
- Planning real-time systems (WebSockets, voice, messaging)

## User Preferences (CRITICAL)

### Sequential Questioning

The user prefers **ONE question per turn**. Never ask multiple questions in a single message. Wait for their answer, then ask the next.

**Bad:**
```
What is your pricing model? And what is your target market? And what tech stack do you prefer?
```

**Good:**
```
What is your pricing model?
```

Then wait for answer. Then ask the next.

### WhatsApp Platform Constraints

The user's primary communication platform is WhatsApp. **No markdown rendering.** Use plain text only. Send media files with `MEDIA:/path/to/file` syntax.

### Agile MVP Approach

The user explicitly prefers an agile MVP approach. When they describe a large feature, propose a minimal viable version first, then ask if they want the full version later. They praised this approach when used.

Example: When user asked for auto-onboarding via website crawl, proposed manual onboarding with AI-assisted pre-fill instead of full auto-crawl. User accepted and praised the approach.

### Pricing Validation

The user will challenge pricing recommendations if they feel too high. Present market data, competitor analysis, and a range. Let them choose. Be ready to adjust downward with justification.

**Key insight:** User initially thought pricing was too high. After presenting market data and adjusting to $39-79-149 tiers, user accepted. Always present a RANGE and let user validate.

### Autonomous Actions

When the user says "push it yourself" or similar, handle the full workflow without excessive back-and-forth. Check env vars first, ask only as last resort.

### Decision Confirmation Style

After each major decision, confirm back to user with "Locked in:" format. User responds positively to this pattern. Example:

```
Locked in:
- Database-per-tenant: YES
- Twilio + ElevenLabs + Groq: YES
- Hybrid pricing (sub + overage): YES
```

This builds a decision log that becomes the architecture document.

### Clarification Pattern

The user sometimes expresses ideas poorly or contradicts themselves mid-thought, then says "you got it" when restated correctly. When this happens:

1. Restate YOUR understanding clearly
2. Ask "Is this correct?" or present as "My understanding: [summary]. Correct?"
3. Only lock in after explicit confirmation

Example from session:
- User: "inbound is most important... outbound is more important than inbound"
- Response: "Let me rephrase: outbound is HIGHEST priority for proactive sales, inbound is HIGH priority for support. Both in MVP. Correct?"
- User: "yes agreed"

### Typo Confirmation Pattern

User occasionally types incorrect technical names (e.g., "11qro glabs" for ElevenLabs + Groq, "Skype" for Stripe, "fullproject.empty" for fullproject.md). This happens especially on mobile or fast chat.

**Response pattern:** Gently confirm correct name before proceeding. Do not embarrass or draw attention to error.

**Bad:**
```
You said Skype but that's a video app. Did you mean Stripe?
```

**Good:**
```
I think you mean Stripe (payment processor), not Skype. Confirming — Stripe for payments?
```

### Multi-Part "Yes" Pattern

User sometimes answers "yes" or "agreed" to questions with multiple parts without specifying which parts they are agreeing to.

**Response pattern:** Break into single questions, or explicitly confirm each part before locking in.

**Example:**
```
You said yes — confirming both:
1. One agent can have multiple deals
2. Deals can be unassigned (in pool)

Correct?
```

### "You Got It" Pattern

User expresses ideas poorly, contradicts themselves mid-thought, or uses imprecise language. When you restate correctly, they say "you got it" or "that was exactly what I was thinking."

**Response pattern:**
1. Restate YOUR understanding clearly and concisely
2. Present as "My understanding: [summary]. Correct?"
3. Only lock in after explicit confirmation ("yes", "agreed", "correct")

**Example from session:**
- User: "inbound is most important because for customer queries... and outbound is more important than inbound because for order confirmation"
- Response: "Let me rephrase to confirm: outbound is HIGHEST priority (sales, cart recovery), inbound is HIGH priority (support). Both in MVP. Correct?"
- User: "yes agreed"

### Feature Scope Acceptance Pattern

User requests complex feature (per-agent business hours, full website auto-crawl, visual flow builder, AI support chatbot). When challenged with complexity and MVP scope, accepts simpler alternative and explicitly praises the agile approach.

**Response pattern:**
1. Acknowledge validity of request ("This is a real business need")
2. Explain complexity (time, risk, delay to launch)
3. Propose simpler MVP version that delivers 80% value
4. Promise full version on post-MVP roadmap
5. Ask for acceptance

**Example:**
```
Website auto-crawl is powerful but requires:
- Anti-bot handling, CAPTCHA solving
- Unstructured HTML extraction
- Auto-prompt generation (high risk of bad prompts)

That's 4-6 weeks of work. For MVP, I recommend:
- One-time crawl of 3 pages (homepage, contact, pricing)
- Pre-fill 3 template prompts
- Customer edits before going live

Full auto-crawl on roadmap for month 3-4. Accept?
```

### Quick Delegation Pattern

User often agrees with recommendations quickly when presented with clear tradeoffs and honest reasoning. This is NOT lack of engagement — it is delegation to expert guidance.

**Do not:** Ask follow-up "are you sure?" questions. Accept the delegation and proceed.

**Do:** Continue explaining reasoning briefly so they understand the decision they delegated.

### Pricing Challenge Pattern

User will challenge pricing recommendations if they feel too high. Present market data with competitor ranges, then propose lower startup-friendly pricing with justification.

**Response pattern:**
1. Present competitor pricing (high tier, mid tier, niche)
2. Explain why market rate may not fit pre-brand startup
3. Propose 30-40% below market for launch
4. Emphasize: "You can always raise prices. Hard to lower without angering customers."
5. Let user validate

**Example:**
```
Market rate for AI CRM: $99-199/user.
My recommendation for YOUR pre-brand launch:
- Starter: $39/user
- Growth: $79/user  
- Pro: $149/user

Reason: Unknown players can't charge Salesforce prices. Land-and-expand: get them in at $79, upsell when they see ROI.
```

### Geographic Context

User's first customers are in **Pakistan**. This affects multiple architectural decisions:

| Aspect | Implication |
|--------|-------------|
| Localization | Urdu language support REQUIRED for AI responses (auto-detect, English fallback) |
| Compliance | No GDPR/CCPA initially, but architect for future expansion |
| Pricing sensitivity | Pakistan market needs competitive pricing — may need localized pricing later |
| Dominant channel | WhatsApp is the primary business communication channel |
| Support | WhatsApp support may be expected by local customers |
| AI model | Groq Llama 3.3 70B handles Urdu reasonably well with auto-detection prompt |

**Language support decision from session:**
- UI: English only for MVP
- AI responses: English + Urdu (auto-detect incoming message language)
- Fallback: English if detection fails
- Other languages: Post-MVP (Hindi, Arabic, etc.)

### AI Coding Tools for Production Build

User explicitly wants to use AI coding assistants (vibe coding) for production implementation. Tools mentioned:
- Kimi K2.6 (API access available to user)
- Claude Code / Claude Opus 4
- OpenCode
- GPT-5.5 / Codex (note: GPT-5.5 not released as of 2026-05; clarify if user means GPT-4o or o3)

**Recommendation for this user:**

| Task | Recommended Tool | Reason |
|------|-----------------|--------|
| Architecture & system design | Kimi K2.6 | User already using, good reasoning |
| Backend (NestJS) | Claude Code or Claude Opus 4 | Best for TypeScript, understands NestJS patterns, massive context window |
| Frontend (Next.js) | Claude Code or V0 (Vercel) | Superior UI component generation |
| Debugging & refactoring | Claude Code | Best at understanding broken code across files |
| Telephony/WebSocket edge cases | Claude Opus 4 | Complex async flow reasoning |

**Critical caveat:** No single AI can build this system alone. Human oversight required for:
- Security (auth, tenant isolation)
- Database schema design (hard to change later)
- API contract stability
- Twilio webhook reliability
- AI prompt safety (prevent prompt injection)

Use AI for implementation speed. Human architect for decisions that are expensive to reverse.

**When user asks about vibe coding tools:**
1. Acknowledge their tools (Kimi K2.6, Claude Code, etc.)
2. Give multi-model strategy recommendation
3. Emphasize human oversight for critical decisions
4. Suggest discussing after architecture phase completes
5. Never recommend a single tool for entire project

### Tone & Personality Preferences

User responds well to:
- Direct, no-fluff communication
- Honest tradeoff explanations ("this is complex because...")
- Challenge when they propose risky ideas (they appreciate being saved from mistakes)
- "Locked in:" confirmation pattern after decisions

## Discovery Flow

### Phase 1: Business Model Understanding

Ask ONE question at a time:

1. **Monetization model** — Subscription, usage-based, hybrid, enterprise license?
2. **Target customer** — SMB, mid-market, enterprise? Industry verticals?
3. **Competitive differentiation** — What existing tools don't do?
4. **Scale targets** — Users, tenants, revenue timeline?

### Phase 2: Technical Architecture Decisions

For each major decision, present options with tradeoffs, then ask for choice:

**Tenant Isolation:**
- Database-per-tenant (highest isolation, compliance-friendly, higher cost)
- Collection-per-tenant (middle ground)
- Shared collections with tenant_id (lowest cost, strict query discipline needed)

**AI/Voice Architecture:**
- AI-native APIs (Retell/Vapi/Bland) — fast time-to-market, high per-minute cost
- Self-assembled (Twilio + ElevenLabs + Groq) — lower cost, more control, more build time

**Real-time Concurrency Planning:**
- Ask for realistic concurrent usage, not aspirational
- Challenge inflated numbers gently with industry benchmarks
- Plan infrastructure for 12-month target, not launch day

**Memory Strategy:**
- No memory (simplest)
- Conversation-level only (current session)
- Short-term (last N conversations, time window)
- Long-term (infinite, requires vector DB)
- Hybrid: short-term for MVP, long-term on roadmap

### Phase 3: Feature Prioritization

When user lists many features, force MVP prioritization:

```
You listed: voice, WhatsApp, Instagram, Facebook, email, live dashboard, analytics, white-label.

For MVP, I recommend: voice + WhatsApp + email only.

Reason: Building all 5 channels = 6 month delay. Voice is your differentiator. WhatsApp has highest engagement. Email is table stakes.

The rest go to post-MVP roadmap. Do you agree?
```

### Phase 4: Pricing Strategy

Present market analysis with competitor data:

```
Competitor pricing:
- Salesforce Einstein: $300-500/user/month
- HubSpot AI: $800-1200/month for 5 users
- Freshsales: $47-87/user/month

My recommendation for YOUR pre-brand launch:
- Starter: $39/user (limited AI calls)
- Growth: $79/user (unlimited AI, voice, 3 channels)
- Pro: $149/user (AI builder, API, monitoring)

You can always raise prices. Hard to lower without angering existing customers.
```

If user challenges as too high, adjust downward with revised justification.

### Phase 5: Decision Documentation

After each decision, confirm back to user:

```
Locked in:
- Database-per-tenant: YES
- Twilio + ElevenLabs + Groq: YES
- Hybrid pricing (sub + overage): YES
- Short-term memory (5 convos, 48h): YES
- Handoff triggers: explicit request + negative sentiment + repeated failure
- Dedicated phone number per tenant: YES
- Document upload: PDF + Word + CSV
- MVP channels: Voice + WhatsApp + Email
```

This builds a decision log that becomes the architecture document.

## Question Bank

### Business Model
1. How do you plan to monetize?
2. What is your target customer profile?
3. What is your competitive moat?
4. What are your 12-month scale targets?

### Technical
5. What is your tenant isolation strategy?
6. What is your telephony backend?
7. What is your expected concurrent usage (realistic, not aspirational)?
8. What is your AI memory strategy?
9. What triggers human handoff?
10. How do you provision phone numbers?
11. What document types for AI training?
12. What is your WebSocket strategy?
13. Where do you host MongoDB?
14. Where do you store files and media?
15. What is your email service provider?
16. What is your background job queue?
17. How do you rate-limit per tenant?
18. What is your AI provider fallback strategy?
19. Do you record calls, and what compliance is needed?
20. What notifications do you need?

### Product
12. What is your EXACT MVP feature list?
13. What is your live dashboard scope?
14. Do you want auto-onboarding from website crawl?
15. What are your resource quotas per plan?

### Pricing
16. What is your credit expiration policy?
17. What is your overage billing model?

## Market Analysis Technique

When user asks for market research:

1. Use web search or execute_code to gather competitor pricing
2. Structure as JSON or markdown with tiers
3. Present: high tier, mid tier, specific niche
4. Give recommendation with reasoning
5. Let user validate or adjust

Example output format:
```
High Tier:
- Salesforce Einstein: $300-500/user/month
- HubSpot AI: $800-1200/5 users/month

Mid Tier:
- Freshsales: $47-87/user/month
- Pipedrive: $64-99/user/month

AI Voice Specific:
- Aircall: $30-50/user + $0.03-0.05/min
- Balto: $100-200/agent/month

My recommendation: Hybrid per-seat + usage
- Starter: $49/user
- Growth: $99/user
- Pro: $199/user
```

## Pitfalls

| Pitfall | Why It Happens | Solution |
|---------|---------------|----------|
| User describes full vision as MVP | Enthusiasm, lack of scoping experience | Force prioritization, propose phased roadmap |
| Inflated concurrency numbers | Optimistic projections | Challenge with industry benchmarks, plan for 12-month realistic target |
| Pricing too high for pre-brand | Market rate ≠ startup rate | Start 30-40% below market, raise after product-market fit |
| Mixing subscription and credit models | User wants flexibility | Propose hybrid: base sub + credit top-ups |
| Auto-onboarding in MVP | Underestimating complexity | Propose manual onboarding with AI-assisted pre-fill |
| All channels in MVP | Feature creep | Force 2-3 channel limit for MVP |
| User suggests unreliable AI providers as fallback | Cost sensitivity over reliability | Explain latency/uptime requirements for voice, recommend OpenAI/Together as fallback |
| Conflicting priorities in same sentence | User thinking out loud | Clarify gently, restate both positions, ask for explicit priority |
| Credit system without expiration | User-friendly but accounting nightmare | Propose 12-month rolling expiry as fair middle ground |
| Mobile push notifications in MVP | Adds React Native/PWA complexity | Defer to post-MVP, in-app + email sufficient |
| Recording audio long-term | Expensive storage, compliance-heavy | Propose transcript-only storage, audio deleted after processing |
| User typos in technical names ("Skype" for Stripe, "11qro" for ElevenLabs) | Typing on mobile/fast chat | Gently confirm correct name before proceeding |
| User says "yes" to multi-part question | Answering quickly without reading full question | Break into single questions, or ask for explicit confirmation of each part |
| User expresses idea poorly then says "you got it" | Thinking faster than typing | Restate your understanding, ask "Is this correct?" before locking in |
| User wants per-agent features in MVP | Real business need (shift work) but complex | Acknowledge validity, scope to tenant-level for MVP, promise per-agent on roadmap |
| Backup restore never tested | "It won't happen to me" syndrome | Make quarterly restore test non-negotiable, document steps, time yourself |
| White-label scope creep | User wants full custom domains + branding | Limit to logo + primary color for MVP, full white-label = enterprise upsell |
| Support system over-engineering | User wants AI chatbot + docs + email at launch | Remind: 10 customers = 5-10 emails/week. Personal response is faster than building bot. |
| Conflicting statements about priority | User re-evaluating mid-conversation | Pause, restate both positions, ask for explicit ranking |
| User presents external tool as potential foundation | Hype, big company name, "AI" keyword | Evaluate using external-tool-evaluation pattern. Most tools are utilities, not foundations. |

### Pattern: External Tool Presented as Foundation

User discovers an open-source tool (e.g., DeerFlow, LangChain, AutoGPT) and asks "can this help me build?" or "should I use this?"

**Response pattern:**
1. Clone and analyze the tool (README, stack, architecture)
2. Evaluate: Is it a FOUNDATION or a UTILITY?
3. Compare against user's requirements in a table
4. Be direct: Most tools are utilities, not foundations
5. Recommend specific use cases if utility matches

**Example from session:**
- User: "My other agent told me about DeerFlow. Can this help?"
- Analysis: DeerFlow = general AI agent harness (Python + Next.js). Axovion CRM = specific multi-tenant SaaS (NestJS + Next.js).
- Verdict: ❌ Don't build CRM ON DeerFlow (no tenancy, no billing, wrong backend). ✅ Use DeerFlow as dev tool for agent swarm orchestration.
- User accepted the honest assessment.

See `references/external-tool-evaluation.md` for full framework.

### Pattern: "Uh, okay" Delegation

User responds with brief acknowledgment ("Uh, okay", "ok then", "yeah okay") when accepting a recommendation after challenge or clarification. This is NOT disinterest — it is the user processing and accepting your guidance.

**Do not:** Ask follow-up "are you sure?" or re-explain. Accept and move to next question.

**Do:** Confirm the decision with "Locked in:" format, then proceed immediately.

**Example from session:**
- Response: "Per-agent hours is NOT MVP scope. 2-3 weeks of dev work for a feature 10% of customers need."
- User: "ok then I will go with your recomendation"
- Correct follow-up: "Good. A + C for MVP. Per-agent hours on roadmap. Locked in. [Next question]"

### Pattern: Contradiction Within Single Message

User states two contradictory things in one message, then accepts correction when restated.

**Example from session:**
- User: "inbound is most important because for customer queries and other things and outbound is more important than inbound because for order confirmation and cart recovery things"
- This is logically contradictory: inbound cannot be "most important" AND outbound "more important than inbound"
- Response: "Let me rephrase to confirm: outbound is HIGHEST priority (sales, cart recovery), inbound is HIGH priority (support). Both in MVP. Correct?"
- User: "yes agreed"

**Lesson:** When user contradicts themselves, do not call it out as a contradiction. Instead, present the two positions clearly and ask which takes priority. They will naturally correct themselves.

### Pattern: "I wasn't able to express" / "You got it"

User explicitly states they were thinking the same thing but couldn't articulate it well. This is a strong validation signal.

**Response:** Accept gracefully, do not dwell on it. Move forward immediately.

**Example:**
- User: "I just wasn't able to express what I wanted but you got 100% right in your recommendation. That means the thing you recommended was exactly what I was thinking but I wasn't able to express that."
- Correct response: "Understood. We're aligned. [Next question]"

### Pattern: "Go to internet, do market analysis"

User explicitly asks for market research rather than answering a business question themselves. This is a valid delegation — they want data-driven recommendations.

**Response pattern:**
1. Acknowledge: "I will research current market data"
2. Use web search or execute_code to gather competitor pricing
3. Structure as clear tiers (high/mid/niche)
4. Give recommendation with reasoning
5. Let user validate or adjust
6. Do NOT ask the original question again — the market data IS the answer

**Example from session:**
- User: "Go to internet, do the market analysis and figure out what are the best answers... Can you do that or not?"
- Response: Conducted research, presented competitor pricing, gave recommendation
- User accepted without further debate

### Pattern: "You are acting as [multiple roles]"

User opens with a detailed persona definition (Senior SaaS Architect, Enterprise CRM Architect, AI Systems Engineer, etc.) and explicit instructions to "behave like a real CTO, systems architect, SaaS planner, and technical co-founder."

**Response pattern:**
1. Acknowledge the role expectation directly
2. Immediately shift tone to match: direct, no-fluff, tradeoff-focused, challenging
3. Do NOT revert to generic chatbot mode
4. Use phrases like: "I need to challenge this," "My recommendation," "Locked in:"
5. Behave like a technical co-founder making expensive decisions, not an advisor suggesting options

**Example from session:**
- User: "You are acting as: Senior SaaS Architect, Enterprise CRM Architect, AI Systems Engineer... Your responsibility is NOT to behave like a generic chatbot."
- Response: Direct challenging of inflated concurrency numbers, honest pricing pushback, "I need to flag a fundamental tension"
- User responded positively throughout, validating the CTO persona approach

### Pattern: "Ask at least 100 meaningful questions"

User explicitly requires deep discovery with a minimum question count before generating architecture.

**Response pattern:**
1. Count questions explicitly (or implicitly via numbering)
2. Ask ONE question per turn — never batch
3. After ~50 questions, check if user wants to continue or accelerate
4. At 100, confirm readiness before generating docs
5. Each question must be non-repetitive and high-value
6. Detect contradictions from previous answers and challenge them

**Example from session:**
- Reached 100 questions, then asked 5 more critical ones before generating
- User accepted the depth without complaint
- Generated architecture was comprehensive enough to build from

### Pattern: Multi-Product Architecture Session

User needs architecture for TWO or more separate but related products simultaneously.

**Response pattern:**
1. Treat each product as fully separate (repos, deployments, architectures)
2. Identify shared components that can be extracted later
3. Document differences clearly in a comparison table
4. Create separate fullproject.md files for each
5. Note cross-product strategy (Product 1 feeds Product 2 pipeline)

**Example from session:**
- Product 1: SaaS CRM (shared cloud, API-based AI)
- Product 2: Enterprise Infrastructure (client-deployed, self-hosted AI)
- Shared: Core NestJS/Next.js codebase
- Different: Deployment, AI stack, monitoring, orchestration

### Pattern: GitHub Push Failure (Token Not Persisted)

When user provides GitHub PAT in chat, it does NOT persist to environment variables. Git push will fail with "could not read Password" or "Invalid username or token."

**Response pattern:**
1. Do NOT write token to disk or .git-credentials (security risk)
2. Explain that chat tokens don't persist to shell env
3. Provide manual push instructions with token as env var
4. Remind user to unset token afterward
5. Never store token in skill or memory

**Example from session:**
- User provided: ***REDACTED***
- Token not in env: echo $GH_TOKEN returned empty
- Correct response: Provide manual commands, remind to unset afterward

### Pattern: Rapid Agreement After Challenge

User quickly agrees ("agreed", "yes", "ok agree") after you challenge a technically risky or expensive decision. This indicates they trust your expertise and want you to guide them away from pitfalls.

**Examples from session:**
- User wanted Retell/Vapi as voice fallback → Challenged (different architecture, 10x cost) → User: "Then I think we should agree with you"
- User wanted per-agent business hours in MVP → Challenged (2-3 weeks dev, 10% need) → User: "ok then I will go with your recomendation"
- User wanted AI support chatbot + docs for MVP → Challenged (overkill at 10 customers) → User: "Okay, in the both questions, I will go with the recommendation"

**Lesson:** When you challenge with clear reasoning, user delegates the decision. Accept gracefully and lock it in.

### Pattern: Repository Naming Confusion

User provides repository names with typos or unclear naming ("exopian-1", "exopian interfaces" when company is Axovion). They also mention brand evolution ("Batik was my first concept").

**Response:** Gently clarify the correct names. Confirm understanding of brand evolution. Lock in correct names before proceeding.

**Example:**
- User: "GitHub repo name should be exopian-1, exopian interfaces. And, butty is not my name, butty was my first classed one"
- Response: "I think you mean Axovion (your company), not Exopian. And Batik was your earlier brand. Confirming: repos should be axovion-crm and axovion-enterprise?"
- User: "yes"

### Pattern: Timeline Pressure + Quality Demand

User wants "as soon as possible" AND "solid foundation, not just hack." These are not contradictory — they want efficient execution of a well-architected system.

**Response:** Set a specific timeline (e.g., 12 weeks to MVP) and create phased documentation (MVP.md + fullproject.md) so they can start building immediately while having the full vision documented.

### Pattern: Vibe Coding Tool Questions Mid-Architecture

User asks about AI coding tools (Kimi K2.6, Claude Code, etc.) during architecture phase. They want to know if their tools can handle the build.

**Response pattern:**
1. Acknowledge their tools
2. Give multi-model strategy (different tools for different tasks)
3. Emphasize human oversight for critical decisions
4. Suggest discussing after architecture completes
5. Never recommend a single tool for entire project
6. Note if a tool they mentioned doesn't exist (e.g., GPT-5.5 not released)

**Example from session:**
- User: "Can I do it in KimiK 2.6 or should I go with emergent or cloud opus 4.7 or GPT-5.5 in codex?"
- Response: Multi-model strategy table + caveat that GPT-5.5 not released

### Pattern: GitHub Push Failure (Token Not Persisted)

When user provides GitHub PAT in chat, it does NOT persist to environment variables. Git push will fail with "could not read Password" or "Invalid username or token."

**Response pattern:**
1. Do NOT write token to disk or .git-credentials (security risk)
2. Explain that chat tokens don't persist to shell env
3. Provide manual push instructions with token as env var
4. Remind user to unset token afterward
5. Never store token in skill or memory

**Example from session:**
- User provided: ***REDACTED*** (long token)
- Token not in env: echo $GH_TOKEN returned empty
- Correct response: Provide manual commands, remind to unset afterward

## Multi-Product Architecture Pattern

This session involved architecting TWO separate but related products simultaneously:

1. **Product 1 (SaaS):** Multi-tenant AI CRM Platform
2. **Product 2 (Enterprise):** Custom-deployed AI Infrastructure

### Key Differences Documented

| Aspect | SaaS CRM | Enterprise Infrastructure |
|--------|----------|--------------------------|
| Deployment | Shared cloud (AWS EC2) | Client cloud / on-premise |
| AI | API-based (Groq, OpenAI) | Self-hosted (vLLM) |
| Voice | Twilio + ElevenLabs | Twilio + self-hosted Piper |
| Database | MongoDB Atlas | Self-hosted MongoDB |
| Storage | Cloudflare R2 | MinIO / Ceph |
| Monitoring | Sentry + Grafana Cloud | Prometheus + Grafana |
| Orchestration | Docker Compose | Kubernetes |
| GitOps | GitHub Actions | ArgoCD |
| Secrets | Env vars | HashiCorp Vault |

### Shared Components
- Core NestJS backend (same codebase)
- Next.js frontend (same codebase)
- AI orchestration logic
- Conversation management
- Handoff system

### Documentation Strategy
- Separate repos: axovion-crm, axovion-enterprise
- Each with fullproject.md + modular docs
- SaaS docs focus on speed-to-market
- Enterprise docs focus on deployment, compliance, managed services

## Updated Pitfalls

| Pitfall | Example from Session | Solution |
|---------|---------------------|----------|
| User contradicts themselves in one message | "inbound is most important... outbound is more important than inbound" | Restate both positions, ask for priority |
| User types wrong tool names | "11qro glabs", "Skype" for Stripe | Gently confirm correct name |
| User answers "yes" to multi-part question without specifying | "yes for both" when asked two separate questions | Break into single questions, confirm each part |
| User wants complex feature after agreeing to MVP scope | Re-introducing per-agent hours after accepting tenant-level | Remind of locked MVP scope, note for roadmap |
| User asks about build tools during architecture phase | "Can Kimi K2.6 build this?" | Give brief answer, defer deep discussion to post-architecture |
| User provides unclear repo names | "exopian-1" when company is Axovion | Clarify gently, confirm correct names |
| User expresses timeline pressure + quality demand | "as soon as possible" + "solid foundation" | Set specific timeline, create phased docs |
| User re-asks about already-decided topic | AI model stack re-discussed after already locked | Refer to "Locked in:" log, move forward |
| User accepts challenge too quickly | "Then I think we should agree with you" | Lock in immediately, do not re-ask |
| User says "nothing about that" when asked to clarify | "4: nothing about that!" after unclear sentence | Accept and move on, do not press |
| GitHub token provided in chat fails to push | Token not in environment variables | Provide manual push instructions, remind to unset token |

## Multi-Product Architecture Pattern

This session involved architecting TWO separate but related products simultaneously:

1. **Product 1 (SaaS):** Multi-tenant AI CRM Platform
2. **Product 2 (Enterprise):** Custom-deployed AI Infrastructure

### Key Differences Documented

| Aspect | SaaS CRM | Enterprise Infrastructure |
|--------|----------|--------------------------|
| Deployment | Shared cloud (AWS EC2) | Client cloud / on-premise |
| AI | API-based (Groq, OpenAI) | Self-hosted (vLLM) |
| Voice | Twilio + ElevenLabs | Twilio + self-hosted Piper |
| Database | MongoDB Atlas | Self-hosted MongoDB |
| Storage | Cloudflare R2 | MinIO / Ceph |
| Monitoring | Sentry + Grafana Cloud | Prometheus + Grafana |
| Orchestration | Docker Compose | Kubernetes |
| GitOps | GitHub Actions | ArgoCD |
| Secrets | Env vars | HashiCorp Vault |

### Shared Components
- Core NestJS backend (same codebase)
- Next.js frontend (same codebase)
- AI orchestration logic
- Conversation management
- Handoff system

### Documentation Strategy
- Separate repos: axovion-crm, axovion-enterprise
- Each with fullproject.md + modular docs
- SaaS docs focus on speed-to-market
- Enterprise docs focus on deployment, compliance, managed services

## Updated Pitfalls

| Pitfall | Example from Session | Solution |
|---------|---------------------|----------|
| User contradicts themselves in one message | "inbound is most important... outbound is more important than inbound" | Restate both positions, ask for priority |
| User types wrong tool names | "11qro glabs", "Skype" for Stripe | Gently confirm correct name |
| User answers "yes" to multi-part question without specifying | "yes for both" when asked two separate questions | Break into single questions, confirm each part |
| User wants complex feature after agreeing to MVP scope | Re-introducing per-agent hours after accepting tenant-level | Remind of locked MVP scope, note for roadmap |
| User asks about build tools during architecture phase | "Can Kimi K2.6 build this?" | Give brief answer, defer deep discussion to post-architecture |
| User provides unclear repo names | "exopian-1" when company is Axovion | Clarify gently, confirm correct names |
| User expresses timeline pressure + quality demand | "as soon as possible" + "solid foundation" | Set specific timeline, create phased docs |
| User re-asks about already-decided topic | AI model stack re-discussed after already locked | Refer to "Locked in:" log, move forward |
| User accepts challenge too quickly | "Then I think we should agree with you" | Lock in immediately, do not re-ask |
| User says "nothing about that" when asked to clarify | "4: nothing about that!" after unclear sentence | Accept and move on, do not press |
## References

- `references/agent-instruction-authoring.md` — Authoring comprehensive agent instructions for complete SaaS builds (v1→v2→execution plan evolution)
- `references/saas-pricing-benchmarks.md` — Competitor pricing data and market sizing
- `references/technical-decision-log-template.md` — Decision documentation format
- `references/mvp-scoping-worksheet.md` — Feature prioritization framework
- `references/ai-crm-technical-stack.md` — Complete technical stack decisions for AI CRM platform (includes cost estimates, enterprise differences, file structure)
- `references/session-100q-ai-crm-2026-05-18.md` — Full session log with 100+ questions and all decisions
- `references/nestjs-nextjs-monorepo-scaffold.md` — Full project scaffold with NestJS backend + Next.js frontend structure, modules, and config
- `references/github-push-patterns.md` — GitHub auth failures, token timeouts, and push recovery patterns
- `references/external-tool-evaluation.md` — Pattern for evaluating external frameworks/tools before adoption (foundation vs utility analysis)