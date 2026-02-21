# PRD: Customer Insights for Marketing

> This document represents the business requirements as they'd appear on a Miro board — sticky notes from product and stakeholders. No technical specs, no column names. Just what the business needs.

---

## Business Context

The marketing team wants to answer two questions they currently can't:

1. **"How much is each customer worth to us over time, and does it depend on where they came from?"**
   - We spend differently across Google Ads, Meta, LinkedIn, etc. We need to know which channels bring in customers that keep buying vs. one-time buyers.
   - We want to segment customers into tiers so we can adjust budget allocation.

2. **"Where are we losing people in the funnel?"**
   - We know how many impressions we serve and how many conversions we get, but we don't know where the drop-off happens.
   - Is it impressions → clicks? Clicks → website visits? Visits → purchases?
   - We need this per campaign so we can kill the underperformers.

---

## What We Need

### Customer Lifetime Value
- Total revenue per customer over their entire history
- Which acquisition channel brought them in
- When they first and last purchased
- How many purchases they've made
- A simple segmentation: high-value, medium-value, low-value customers
- We define "high" as $500+, "medium" as $100-499, "low" as under $100

### Funnel Drop-Off Analysis
- For each campaign: how many impressions, clicks, website sessions, and conversions
- The conversion rate between each stage
- An overall efficiency score so we can rank campaigns against each other
- We want to spot which campaigns have great click-through but terrible session-to-conversion rates

---

## Stakeholder Notes

- **Head of Marketing:** "I want a single view per customer showing their lifetime value and the channel that acquired them. Simple."
- **Campaign Manager:** "Give me a funnel breakdown per campaign. I need to know where the money is leaking."
- **Data Analyst:** "We already have all this raw data in our warehouse. Sessions, conversions, campaign metrics — it's all there. We just don't have the models that connect them."

---

## Open Questions

- Do we want the funnel analysis at the campaign level or also at the channel level? → Start with campaign, aggregate to channel later if needed.
- Should LTV include attribution weighting? → No, keep it simple. Total conversion value per user.
