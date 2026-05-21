---
name: e-commerce-brand-research
description: "Systematic research, audit, and pitch generation workflow for e-commerce brands targeting AI automation services."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux]
metadata:
  hermes:
    tags: [e-commerce, research, sales, automation, scraping, pitch]
    related_skills: [web-scraping, sales-automation, github-repo-management]
---

# E-commerce Brand Research & Pitch Generation

Systematic workflow for researching e-commerce brands, identifying automation opportunities, and generating client-ready pitch materials.

## Overview

This skill covers the complete pipeline from brand discovery to pitch delivery:
1. Website scraping & data extraction
2. Comprehensive website audit
3. Personalized AI automation pitch
4. Interactive ROI calculator
5. GitHub repository organization

## Target Metrics

- **Retainer Target:** $300/month per client (adjustable)
- **ROI Projection:** 1,000%+ for all implementations
- **Lead Scoring:** 1-10 based on automation readiness
- **Deal Value:** Monthly retainer + implementation fees

## Workflow

### Phase 1: Discovery & Scraping

```bash
# Create brand directory structure
mkdir -p /tmp/brand-research/{BrandName}/screenshots

# Fetch homepage
curl -s -A "Mozilla/5.0" https://brand-website.com > /tmp/brand-research/BrandName/homepage.html

# Extract key data
grep -i 'facebook\|instagram\|youtube\|twitter' homepage.html | head -20
grep -o 'https://[^"]*facebook[^"]*' homepage.html | head -5
grep -i 'shopify\|woocommerce\|magento' homepage.html | head -5
```

**Platform Detection:**
- Shopify: Look for `myshopify.com`, `shopify.com`, `cdn.shopify.com`
- WooCommerce: Look for `woocommerce`, `wp-content`
- Custom: No clear platform indicators

### Phase 2: Website Audit

Create `website_audit.md` with these sections:

```markdown
# [Brand] Website Audit

## Brand Overview
- **Website:** URL
- **Platform:** Shopify/WooCommerce/Custom
- **Category:** Fashion/Grocery/Healthcare/Beauty/etc
- **Location:** City, Country
- **Description:** Brief brand description

## Pages Analyzed
- [ ] Homepage
- [ ] Product pages
- [ ] Category pages
- [ ] About page
- [ ] Contact page
- [ ] FAQ page
- [ ] Privacy Policy
- [ ] Terms & Conditions
- [ ] Refund/Return Policy

## Navigation Structure
- Main menu items
- Footer links
- Mobile menu behavior

## E-commerce Features
- [ ] Cart functionality
- [ ] Checkout flow
- [ ] Payment methods
- [ ] Guest checkout
- [ ] Account creation
- [ ] Wishlist
- [ ] Search functionality

## Trust Elements
- [ ] SSL certificate
- [ ] Customer reviews
- [ ] Trust badges
- [ ] Social media links
- [ ] Contact information
- [ ] Physical address

## Mobile UX
- [ ] Responsive design
- [ ] Mobile menu
- [ ] Touch targets
- [ ] Load speed
- [ ] Checkout mobile experience

## SEO Observations
- Meta descriptions
- Title tags
- Header structure
- Image alt tags
- URL structure

## Conversion Issues
- [ ] Weak CTAs
- [ ] No urgency triggers
- [ ] Missing social proof
- [ ] No live chat
- [ ] No abandoned cart recovery
- [ ] No personalization
- [ ] No WhatsApp integration

## Automation Opportunities
- [ ] AI chatbot
- [ ] Cart recovery
- [ ] WhatsApp automation
- [ ] Email automation
- [ ] Social media automation
- [ ] Inventory alerts
- [ ] Price drop alerts
```

### Phase 3: Pitch Creation

Create `pitch.md` with this structure:

```markdown
# [Brand] - AI Automation Pitch

## Executive Summary
**Brand:** Name
**Website:** URL
**Industry:** Category
**Target Retainer:** $300/month

## Business Intelligence
| Metric | Value |
|--------|-------|
| **Lead Score** | X/10 |
| **Estimated Deal Value** | $300/month |
| **Urgency Level** | Low/Medium/High |
| **Automation Maturity** | Very Low/Low/Medium/High |
| **Estimated Monthly Revenue Impact** | PKR X - Y |
| **Biggest Revenue Leak** | Description |
| **Fastest Win Automation** | Solution |
| **Highest Ticket Service** | Opportunity |
| **Ease of Close** | Easy/Medium/Hard |
| **Primary Communication Channel** | Website/WhatsApp/Instagram |
| **AI Readiness** | Not Ready/Ready/Advanced |

## Identified Weaknesses
1. [Weakness 1]
2. [Weakness 2]
3. [Weakness 3]

## Recommended Solutions

### 1. [Solution Name]
**Problem:** [Description]
**Solution:** [Description]
**Expected Impact:**
- Metric 1: X%
- Metric 2: Y%
**Estimated ROI:** Z%
**Implementation Difficulty:** Easy/Medium/Hard
**Priority:** CRITICAL/HIGH/MEDIUM

## Revenue Impact Projection
| Solution | Monthly Cost | Monthly Revenue Impact | ROI |
|----------|-------------|----------------------|-----|
| Solution 1 | $X | $Y | Z% |
| **TOTAL** | **$X** | **$Y** | **Z%** |

## Implementation Timeline
| Week | Deliverable |
|------|-------------|
| Week 1 | [Task] |
| Week 2 | [Task] |

## Next Steps
1. [Action 1]
2. [Action 2]
```

### Phase 4: ROI Calculator

Create `roi_calculator.html` with:
- Dark theme (matching Axovion brand)
- Editable input fields
- Real-time calculation
- Mobile responsive
- Brand-specific assumptions
- PKR currency support

**Key Formulas:**
```javascript
// Support savings
const supportSavings = (tickets * automationRate * days) * (staffCost / days / hoursPerDay);

// Cart recovery
const abandonedValue = monthlyOrders * (abandonmentRate / (100 - abandonmentRate)) * aov;
const recovered = abandonedValue * recoveryRate;

// Chat sales
const chatSales = visitors * chatEngagementRate * chatConversionRate * aov;

// Subscription revenue
const subscriptionRevenue = subscribers * aov * subscriptionMultiplier;
```

### Phase 5: Products CSV

Create `products.csv` with columns:
```csv
product_name,category,price,compare_price,discount_percentage,stock_status,product_url,image_url,description,variants,reviews_count,rating
```

**Note:** Many Shopify stores load products via JavaScript. Static scraping may not capture all products. Use browser automation (Playwright/Puppeteer) for complete product catalogs.

### Phase 6: GitHub Repository

```bash
# Initialize repo
cd /tmp/brand-research
git init
git add .
git commit -m "Add brand research for [N] e-commerce companies"

# Create repo via API first (avoids "repository not found" errors)
curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/user/repos \
  -d '{"name": "brand-research", "private": false, "auto_init": false}'

# Set remote with token and push
git remote add origin "https://${GITHUB_TOKEN}@github.com/${GH_USER}/brand-research.git"
git branch -m master main  # Ensure branch is named 'main'
git push -u origin main
```

**If push fails with "could not read Username":**
- Token is not being passed to git; embed it in the remote URL
- Check if branch is `master` locally but remote expects `main`

**If repo already exists on GitHub:**
- Use `git push -u origin main --force` only if you're sure you want to overwrite
- Or fetch first: `git fetch origin` then reconcile branches

**Pitfall — working directory confusion:**
When using `execute_code` with Python's `subprocess`, `os.chdir()` may not persist across calls. Always verify the working directory:
```python
import os
print(os.getcwd())  # Verify you're in /tmp/brand-research, not /home/ubuntu
```

**If user says "push it yourself":**
- They expect autonomous handling, not repeated requests for tokens
- Use the token they provided earlier in the session
- If no token is available, attempt to find it in environment variables first
- Only ask the user as a last resort, and ask once, not repeatedly

## Brand-Specific Insights

### Fashion Brands (LaMaRetail, Zarr)
- **Biggest leak:** Size/fit uncertainty → returns
- **Fastest win:** AI size assistant
- **Highest ticket:** Virtual try-on
- **Channel:** Instagram + Website

### Grocery (Springs)
- **Biggest leak:** Cart abandonment
- **Fastest win:** Cart recovery + WhatsApp tracking
- **Highest ticket:** Subscription model
- **Channel:** Website + WhatsApp

### Healthcare (Wisdom Therapeutics)
- **Biggest leak:** No digital engagement
- **Fastest win:** AI product chatbot
- **Highest ticket:** AI health consultation
- **Channel:** Website (phone-heavy)
- **Caution:** Regulatory compliance required

### Beauty (Saeed Ghani)
- **Biggest leak:** No personalization
- **Fastest win:** AI skin quiz
- **Highest ticket:** Subscription + replenishment
- **Channel:** Instagram + Website

## Pitfalls

| Problem | Cause | Solution |
|---------|-------|----------|
| Products not scraping | JS-rendered Shopify | Use Playwright or note limitation |
| Website blocks curl | Bot detection | Add User-Agent header |
| Push fails | No GH_TOKEN | Prepare locally, provide manual commands |
| Timeout on large sites | Slow response | Use `timeout` flag, retry with delay |
| Duplicate brand folders | Case sensitivity | Use consistent PascalCase naming |
| Subagent timeouts | Slow website scraping | Fall back to direct curl + shell scripts |
| Python env issues | Missing packages | Use shell commands instead of Python scripts |
| Branch push rejected | master vs main mismatch | Rename branch: `git branch -m master main` |

## Tools Required

- `curl` for basic scraping
- `grep` for data extraction
- `git` for version control
- Browser automation (Playwright) for JS sites

## References

- `references/brand-research-template.md` - Full template with all sections
- `references/brand-research-session-notes.md` - Session-specific learnings and pitfalls
- `templates/roi-calculator.html` - Starter HTML calculator
- `templates/pitch-template.md` - Pitch markdown template
