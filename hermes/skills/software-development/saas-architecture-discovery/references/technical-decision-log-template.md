# Technical Decision Log Template

Use this template to document architecture decisions during discovery sessions.

## Format

```
## Decision: [TOPIC]

**Date:** YYYY-MM-DD
**Status:** PROPOSED / ACCEPTED / REJECTED / DEPRECATED
**Context:** [What problem are we solving?]
**Options Considered:**
- Option A: [description] — [pros] — [cons]
- Option B: [description] — [pros] — [cons]
- Option C: [description] — [pros] — [cons]

**Decision:** [Which option chosen and why]
**Consequences:** [What this enables and what it limits]
**Reversible:** YES / NO [If yes, what would trigger reversal?]
```

## Example

```
## Decision: Tenant Isolation Strategy

**Date:** 2026-05-18
**Status:** ACCEPTED
**Context:** Multi-tenant SaaS CRM handling sensitive customer conversation data

**Options Considered:**
- Database-per-tenant: Highest isolation, compliance-friendly, easy per-tenant backup/restore — Higher infrastructure cost, connection pool management
- Collection-per-tenant: Middle ground — Complex query patterns, partial isolation
- Shared collections with tenant_id: Lowest cost, simplest queries — Risk of cross-tenant data leakage, strict query discipline required

**Decision:** Database-per-tenant
**Reasoning:** User's first customers are in Pakistan but global expansion planned. SOC 2 and GDPR compliance will be needed. Database-per-tenant makes compliance audits simpler and eliminates cross-tenant leakage risk. Cost is negligible at MVP scale ($0.08/database/month storage).
**Consequences:** Requires connection pool management. Easy to migrate hot tenants to dedicated clusters later.
**Reversible:** YES — Can migrate to collection-per-tenant later if cost becomes issue at 10,000+ tenants.
```

## Usage

1. Ask user the decision question (ONE at a time)
2. Present options with honest tradeoffs
3. Let user choose or delegate
4. Document with this template
5. Confirm back to user with "Locked in:"
6. Add to decision log that becomes architecture document

## Categories

- **Infrastructure:** Hosting, database, cache, storage, CDN
- **Architecture:** Monolith vs microservices, tenancy strategy, API design
- **AI/ML:** Model selection, fallback strategy, prompt engineering
- **Security:** Auth, authorization, encryption, compliance
- **Integrations:** Third-party APIs, webhooks, external services
- **Scaling:** Horizontal vs vertical, sharding, replication
- **Cost:** Pricing tiers, unit economics, margin targets
