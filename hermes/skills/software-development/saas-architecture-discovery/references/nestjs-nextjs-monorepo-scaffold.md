# NestJS + Next.js Monorepo Scaffold Reference

## Session: 2026-05-19, Axovion CRM Full Project Push

## Project Structure

```
axovion-crm-full-project/
├── README.md
├── package.json          # Workspace root
├── .gitignore
├── docker-compose.yml    # MongoDB + Redis + API + Web
├── apps/
│   ├── api/              # NestJS backend
│   │   ├── package.json
│   │   ├── tsconfig.json
│   │   ├── nest-cli.json
│   │   ├── Dockerfile
│   │   ├── .env.example
│   │   └── src/
│   │       ├── main.ts
│   │       ├── app.module.ts
│   │       ├── auth/           # JWT, guards, decorators, strategies
│   │       ├── tenants/        # Multi-tenant support
│   │       ├── users/          # 4 RBAC roles
│   │       ├── contacts/       # CRM contacts
│   │       ├── conversations/  # Messages, channels
│   │       ├── ai/             # Groq integration, sentiment
│   │       ├── billing/        # Subscriptions, credits
│   │       ├── notifications/  # Email queue (BullMQ + Resend)
│   │       ├── analytics/      # Dashboard stats
│   │       ├── webhooks/       # Stripe, Twilio, WhatsApp
│   │       └── websocket/      # Real-time (Socket.IO)
│   └── web/              # Next.js frontend
│       ├── package.json
│       ├── tsconfig.json
│       ├── next.config.js
│       ├── tailwind.config.ts
│       ├── postcss.config.js
│       ├── Dockerfile
│       ├── .env.example
│       ├── next-env.d.ts
│       ├── public/
│       ├── app/
│       │   ├── layout.tsx
│       │   ├── page.tsx        # Redirects to /dashboard
│       │   ├── login/page.tsx
│       │   ├── dashboard/page.tsx
│       │   ├── conversations/page.tsx
│       │   ├── contacts/page.tsx
│       │   └── settings/page.tsx
│       ├── components/
│       │   ├── Sidebar.tsx
│       │   └── StatCard.tsx
│       └── lib/
│           ├── api.ts          # Axios instance with interceptors
│           └── store.ts        # Zustand store
└── packages/
    └── shared/             # Shared types & utilities
        ├── package.json
        ├── tsconfig.json
        └── src/
            ├── index.ts
            └── types.ts
```

## Backend Modules (NestJS)

| Module | Purpose | Key Files |
|--------|---------|-----------|
| Auth | JWT auth, guards, roles | auth.module.ts, auth.service.ts, jwt.strategy.ts |
| Tenants | Multi-tenant DB isolation | tenants.module.ts, tenant.schema.ts |
| Users | RBAC (super_admin, tenant_admin, agent, viewer) | users.module.ts, user.schema.ts |
| Contacts | CRM contact management | contacts.module.ts, contact.schema.ts |
| Conversations | Multi-channel messaging | conversations.module.ts, conversation.schema.ts |
| AI | Groq LLM integration, sentiment | ai.module.ts, ai.service.ts |
| Billing | Stripe subscriptions, usage credits | billing.module.ts, subscription.schema.ts |
| Notifications | BullMQ + Resend email queue | notifications.module.ts, email.processor.ts |
| Analytics | Event tracking, dashboard stats | analytics.module.ts, analytics.schema.ts |
| Webhooks | Stripe, Twilio, WhatsApp handlers | webhooks.module.ts |
| WebSocket | Real-time Socket.IO gateway | websocket.module.ts, websocket.gateway.ts |

## Frontend Pages (Next.js)

| Page | Route | Features |
|------|-------|----------|
| Login | /login | Email/password auth |
| Dashboard | /dashboard | Stats cards, activity feed, quick actions |
| Conversations | /conversations | Table view, status badges, search |
| Contacts | /contacts | Card grid, search, status filters |
| Settings | /settings | Tabs: general, team, billing, integrations |

## Docker Compose Services

```yaml
services:
  mongodb:    # MongoDB 7 with persistent volume
  redis:      # Redis 7 for BullMQ + Socket.IO adapter
  api:        # NestJS on port 3001
  web:        # Next.js on port 3000
```

## Environment Variables (API)

```
PORT=3001
MONGODB_URI=mongodb://localhost:27017
REDIS_URL=redis://localhost:6379
JWT_SECRET=...
TWILIO_ACCOUNT_SID=...
ELEVENLABS_API_KEY=...
GROQ_API_KEY=...
RESEND_API_KEY=...
STRIPE_SECRET_KEY=...
```

## Key Implementation Notes

1. **Database-per-tenant:** Each tenant gets own DB (`axovion_tenant_<subdomain>`)
2. **JWT payload includes tenantId:** All requests validated against tenant context
3. **x-tenant-id header:** Frontend sends tenant ID on every request
4. **BullMQ for email:** Background queue with retry logic
5. **Socket.IO namespaces:** `/crm` namespace with room per tenant
6. **AI memory window:** Last 5 messages sent as context to Groq
7. **Urdu support:** AI auto-detects language, falls back to English

## Scaffolding Commands (for future projects)

```bash
# Create root
mkdir project-name && cd project-name
git init

# Create backend
mkdir -p apps/api/src/{auth,tenants,users,contacts,conversations,ai,billing,notifications,analytics,webhooks,websocket}
# Write package.json, tsconfig.json, nest-cli.json, main.ts, app.module.ts
# Write each module: *.module.ts, *.service.ts, *.controller.ts, schemas/*.schema.ts

# Create frontend
mkdir -p apps/web/app/{login,dashboard,conversations,contacts,settings}
mkdir -p apps/web/components apps/web/lib
# Write package.json, next.config.js, tailwind.config.ts, postcss.config.js
# Write layout.tsx, page.tsx files, components, lib/api.ts, lib/store.ts

# Create shared package
mkdir -p packages/shared/src
# Write package.json, tsconfig.json, types.ts

# Write root files
# README.md, package.json (workspaces), .gitignore, docker-compose.yml

# Commit and push
git add -A
git commit -m "Initial commit"
git remote add origin https://github.com/owner/repo.git
git push -u origin main
```
