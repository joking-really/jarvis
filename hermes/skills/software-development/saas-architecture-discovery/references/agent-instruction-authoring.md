# Authoring Agent Instructions for Complete SaaS Builds

## Context

When a user has completed a deep architecture discovery session (50-100+ questions) and wants to hand off implementation to AI coding agents (vibe coding), they need comprehensive instructions that capture every decision made during discovery.

## The Gap Problem

A typical agent instruction file is 300-500 lines. A 100-question architecture session produces 10,000+ words of decisions. The agent instructions must bridge this gap without losing critical details.

## Structure for Complete Build Instructions

### 1. Architecture Lock (Non-Negotiable Decisions)

List every technology decision with rationale. Format as table:

```markdown
| Layer | Technology | Rationale |
|-------|-----------|-----------|
| Frontend | Next.js 15 + TypeScript | App Router, SSR for SEO |
| Backend | NestJS 10 | Modular architecture, decorators |
```

### 2. Complete Feature List

Number every feature. Use consistent format:

```markdown
### N. FEATURE NAME (PRIORITY)
- **Sub-feature 1**: Detail
- **Sub-feature 2**: Detail with exact values
  - Nested detail: value
  - Nested detail: value
- **Schema/Config**:
  ```typescript
  interface FeatureConfig {
    field: string;
    options: string[];
  }
  ```
```

### 3. Module Specifications

For each backend module, provide:
- All REST endpoints (method, path, auth requirements)
- Complete Mongoose/TypeORM schemas
- Service method signatures
- Controller method signatures
- DTOs with validation rules

### 4. Frontend Page Specifications

For each page:
- Route path
- Required components
- API integrations
- State management
- Role-based access

### 5. Database Design

- Complete schema definitions
- All indexes (with justification)
- Relationships between collections
- Migration strategy

### 6. Environment Variables

Complete `.env.example` with all required variables, grouped by service.

### 7. Implementation Phases

6-week phased approach:
- Week 1: Foundation (auth, tenancy, core infra)
- Week 2: Core CRM (contacts, conversations, users)
- Week 3: AI & Channels (voice, WhatsApp, chat)
- Week 4: Automation (email, workflows, notifications)
- Week 5: Billing & Analytics
- Week 6: Polish & Deploy

### 8. Gap Analysis

Explicitly list what's ALREADY in the repo vs what needs building. Use checkboxes:

```markdown
**Backend:**
- ❌ Database-per-tenant (uses single DB)
- ❌ Twilio voice integration
- ✅ Auth module scaffolded
- ✅ Contact schema defined
```

### 9. Code Quality Requirements

- TypeScript strict mode
- No `any` types
- Class-validator DTOs
- Swagger/OpenAPI docs
- Unit tests for services

### 10. Critical Reminders

End with non-negotiables:
- Do NOT skip any feature
- Do NOT leave TODOs
- Test every endpoint
- Test every page
- Enforce tenant isolation

## Anti-Patterns to Avoid

1. **Vague descriptions** — "Implement AI" is useless. "Implement Groq Llama 3.3 70B with 5-message context window, 48h TTL, Urdu language detection" is actionable.

2. **Missing schemas** — Agents need complete Mongoose schemas, not just field names.

3. **Missing exact values** — Pricing tiers, rate limits, timeouts — all must be exact numbers.

4. **Assuming context** — The agent knows nothing about your business. Explain why each feature exists.

5. **Forgetting the frontend** — Backend-only instructions produce APIs with no UI.

## Real Example Output Size

For a multi-tenant AI CRM with 18 modules:
- v1 instructions: ~350 lines (insufficient)
- v2 instructions: ~935 lines (adequate)
- v3 instructions with full schemas: ~1,500 lines (comprehensive)

## Reference Architecture Docs

If detailed architecture docs exist in a separate repo, reference them explicitly:

```markdown
## Reference Documents

The following architecture docs exist in the `axovion-crm` repo and contain additional implementation details:
- `ai-agents.md` — AI provider stack, prompt templates, context management
- `ai-orchestration.md` — Message flow, handoff logic, event bus, queues
- `tenancy.md` — Database-per-tenant deep dive
- `billing.md` — Credit system, Stripe integration
- `workflows.md` — All business process flows

Clone: `https://github.com/joking-really/axovion-crm`
```

## Verification

Before handing off to agents, verify:
- [ ] Every feature from discovery is listed
- [ ] Every decision is documented with exact values
- [ ] Schemas are complete (all fields, types, indexes)
- [ ] Frontend pages are specified
- [ ] API endpoints are listed
- [ ] Environment variables are complete
- [ ] Gap analysis is honest (don't claim things exist that don't)
- [ ] Reference docs are linked
