# Brand Research Session Notes

## Session: May 17, 2026

### Brands Analyzed
1. LaMaRetail (https://pk.lamaretail.com) - Fashion
2. Springs (https://springs.com.pk) - Grocery
3. Zarr (https://zarr.com.pk) - Fashion
4. Wisdom Therapeutics (https://wisdomtherapeutics.com) - Healthcare
5. Saeed Ghani (https://saeedghani.pk) - Beauty

### Key Learnings

#### Scraping Approach
- Static curl + grep works for homepage analysis but NOT for product catalogs
- Shopify stores load products via JavaScript - need Playwright for full scrape
- Using `curl -s -A "Mozilla/5.0"` avoids basic bot detection
- Extract platform by grepping for: `shopify`, `woocommerce`, `myshopify.com`

#### GitHub Push Workflow
1. Create repo via API first: `POST /user/repos`
2. Set remote with embedded token: `git remote set-url origin https://TOKEN@github.com/USER/REPO.git`
3. Rename branch if needed: `git branch -m master main`
4. Force push if repo has initial commit: `git push -u origin main --force`

#### Working Directory Trap
- Python `os.chdir()` in `execute_code` does NOT persist across calls
- Always verify with `os.getcwd()` or `pwd`
- The subprocess module inherits the Python process cwd, which may differ from shell

#### Delegate Task Timeout
- Subagents timed out on website scraping (30s limit too short)
- Better approach: Use direct shell commands or `execute_code` with Python
- For parallel scraping, use background processes with `&` and `wait`

#### User Expectation
- When user says "push it yourself", they expect autonomous handling
- Don't ask for token multiple times - use what's available or ask once
- If token was provided earlier in session, reuse it

### File Structure Created
```
/BrandName
├── products.csv          # Placeholder (JS rendering limitation noted)
├── website_audit.md      # Comprehensive analysis
├── pitch.md             # Personalized AI automation pitch
├── roi_calculator.html  # Interactive calculator (dark theme, PKR)
└── screenshots/         # Empty (requires browser automation)
```

### ROI Calculator Formula Patterns
```javascript
// Support savings
const supportSavings = (tickets * automationRate * days) * (staffCost / days / hoursPerDay);

// Cart recovery
const abandonedValue = monthlyOrders * (abandonmentRate / (100 - abandonmentRate)) * aov;
const recovered = abandonedValue * recoveryRate;

// Chat-driven sales
const chatSales = visitors * chatEngagementRate * chatConversionRate * aov;

// Subscription revenue
const subscriptionRevenue = subscribers * aov * subscriptionMultiplier;

// Return reduction savings
const returnSavings = monthlyOrders * (returnRate / 100) * aov * reductionPercentage;
```

### Brand Intelligence Summary

| Brand | Lead Score | Est. Monthly Impact | Primary Channel | AI Readiness |
|-------|-----------|-------------------|----------------|-------------|
| LaMaRetail | 8/10 | PKR 350K-700K | Instagram + Website | Ready |
| Springs | 9/10 | PKR 400K-800K | Website + WhatsApp | Ready |
| Zarr | 7/10 | PKR 250K-500K | Instagram + Website | Ready |
| Wisdom Therapeutics | 6/10 | PKR 150K-400K | Website | Not Ready |
| Saeed Ghani | 8/10 | PKR 400K-900K | Instagram + Website | Ready |
