# External Tool Evaluation Pattern

## Context

When a user discovers an open-source tool/framework (e.g., DeerFlow, LangChain, AutoGPT) and asks "can this help me build my product?" or "should I use this?"

## The Core Question

**Is this tool a FOUNDATION or a UTILITY?**

| Foundation | Utility |
|-----------|---------|
| You build ON it | You use it WHILE building |
| Dictates architecture | Fits into your architecture |
| Hard to replace later | Easy to swap |
| Examples: NestJS, Next.js, MongoDB | Examples: DeerFlow, n8n, Zapier |

## Evaluation Framework

### Step 1: Understand What the Tool Actually Is

Clone it, read the README, check the tech stack:

```bash
git clone <repo>
cd <repo>
cat README.md | head -100
cat package.json  # or pyproject.toml, Cargo.toml
cat Makefile      # or justfile, Taskfile.yml
```

Key questions:
- What problem does it solve?
- What is its architecture?
- What does it depend on?
- What does it produce?

### Step 2: Compare to Your Requirements

Create a comparison table:

| Requirement | Your Stack | The Tool | Match? |
|------------|-----------|----------|--------|
| Multi-tenancy | Database-per-tenant | None | ❌ |
| Billing | Stripe + credits | None | ❌ |
| Channels | Twilio, WhatsApp | Generic webhooks | ⚠️ |
| AI | Groq + ElevenLabs | Generic LLM orchestration | ⚠️ |
| Frontend | Next.js 15 | Next.js 16 + Python backend | ⚠️ |

### Step 3: Determine Integration Strategy

**If foundation mismatch:**
- Do NOT build on it
- Use it as a development tool instead
- Or ignore it entirely

**If utility match:**
- Integrate as a service/module
- Keep your architecture independent
- Wrap it in an adapter

### Step 4: Recommend to User

Be direct. Users appreciate honest assessment over hype.

**Template:**
```
[Tool Name] is a [what it is]. It does [specific thing] well.

For YOUR project:
- ❌ Don't use it as foundation (no tenancy, no billing, different architecture)
- ✅ Use it as [development tool / inspiration / specific module]
- 💡 Specific use: [e.g., orchestrate agent swarm, research best practices]

My recommendation: [clear action]
```

## Real Example: DeerFlow Evaluation

**What DeerFlow is:**
- ByteDance's open-source "super agent harness"
- LangGraph-based AI agent framework
- Python backend + Next.js frontend
- Skills system, sandbox execution, sub-agent delegation

**What Axovion CRM needs:**
- Multi-tenant SaaS with database-per-tenant
- Stripe billing with credit system
- Twilio voice + WhatsApp + email
- NestJS + Next.js monorepo
- Pakistan-first with Urdu support

**Evaluation:**

| Requirement | Axovion CRM | DeerFlow | Match? |
|------------|-------------|----------|--------|
| Tenancy | Database-per-tenant | None | ❌ |
| Backend | NestJS | Python/FastAPI | ❌ |
| Billing | Stripe + credits | None | ❌ |
| Voice | Twilio + ElevenLabs | Generic LLM | ⚠️ |
| AI memory | 5 convos, 48h window | Persistent memory | ✅ |
| Frontend | Next.js 15 | Next.js 16 | ⚠️ |

**Verdict:**
- ❌ Don't build CRM ON DeerFlow (wrong foundation)
- ✅ Use DeerFlow as development tool for agent swarm
- 💡 Specific use: Deep research skill, frontend design skill, skill-creator for reusable patterns

## Anti-Patterns

1. **"It's from [Big Company], it must be good"** — ByteDance, Google, Meta all ship tools that solve THEIR problems, not yours.

2. **"It has AI, we need AI"** — Generic AI orchestration ≠ your specific AI pipeline (voice + chat + handoff).

3. **"We can adapt it"** — Adapting a framework is often harder than building from scratch. Be honest about effort.

4. **"Let's use both"** — Two architectures = twice the complexity. Only do this if there's clear separation.

## When to Recommend Adoption

✅ **Use as foundation when:**
- Tool's architecture matches your requirements
- Tool provides features you'd otherwise build from scratch
- Community is active, documentation is complete
- You can afford the learning curve

✅ **Use as utility when:**
- Tool solves a specific problem well
- Integration is via API or simple wrapper
- Easy to replace if needed
- Doesn't dictate your architecture

❌ **Avoid when:**
- Foundation mismatch (different paradigm)
- Missing critical features (tenancy, billing, etc.)
- Overlaps with your core differentiator
- Would require significant adaptation
