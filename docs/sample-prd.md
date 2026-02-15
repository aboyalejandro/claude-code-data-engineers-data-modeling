# PRD: Customer Lifetime Value & Funnel Analysis

> This document represents the content of the Miro board used as the product requirements document. In practice, `miro_get_board_content` extracts this from sticky notes, text blocks, and diagram elements on the board.

---

## Business Context

The marketing analytics team needs deeper insight into two areas:

1. **Customer Lifetime Value (CLV)** — Understanding how much revenue each user generates over time, segmented by how they were acquired.
2. **Funnel Conversion Analysis** — Tracking where users drop off between impression → click → session → conversion, per campaign and channel.

These models extend the existing `marketing_analytics` dbt project, which already has staging models for campaigns, sessions, conversions, and attribution touchpoints.

---

## New Models Required

### Mart: `customer_lifetime_value`

**Purpose:** Track cumulative spend per user over time, segmented by acquisition channel.

**Columns:**
- `user_id` — Primary key
- `acquisition_channel` — Channel of the user's first session
- `first_purchase_date` — Date of first conversion
- `last_purchase_date` — Date of most recent conversion
- `total_conversions` — Count of all conversions
- `total_revenue` — Sum of all conversion values
- `avg_order_value` — Average conversion value
- `days_since_first_purchase` — Days between first purchase and most recent purchase
- `ltv_segment` — Categorization: 'high' (≥$500), 'medium' (≥$100), 'low' (<$100)

**Grain:** One row per user.

---

### Mart: `funnel_conversion_analysis`

**Purpose:** Track the funnel from impression → click → session → conversion per campaign/channel.

**Columns:**
- `campaign_id` — Foreign key to campaigns
- `campaign_name` — Name of the campaign
- `channel` — Advertising channel
- `total_impressions` — Count of impressions
- `total_clicks` — Count of clicks
- `total_sessions` — Count of sessions
- `total_conversions` — Count of conversions
- `click_through_rate` — clicks / impressions
- `click_to_session_rate` — sessions / clicks
- `session_to_conversion_rate` — conversions / sessions
- `overall_funnel_efficiency` — conversions / impressions
- `funnel_efficiency_score` — Relative ranking (percentile) of overall efficiency across campaigns

**Grain:** One row per campaign.

---

### Intermediate: `int_user_ltv_metrics`

**Purpose:** Aggregate user-level purchase history from staging models.

**Upstream dependencies:** `stg_conversions`, `stg_sessions`

**Columns:**
- `user_id` — Primary key
- `acquisition_channel` — Channel from user's first session
- `first_purchase_date` — Earliest conversion timestamp
- `last_purchase_date` — Latest conversion timestamp
- `total_conversions` — Count of conversions
- `total_revenue` — Sum of conversion values
- `avg_order_value` — Average conversion value
- `days_since_first_purchase` — Date difference between first and last purchase

**Grain:** One row per user who has at least one conversion.

---

### Intermediate: `int_funnel_stages_by_campaign`

**Purpose:** Calculate funnel stage counts from existing staging models.

**Upstream dependencies:** `stg_campaigns_daily`, `stg_sessions`, `stg_conversions`

**Columns:**
- `campaign_id` — Primary key
- `campaign_name` — Name of the campaign
- `channel` — Advertising channel
- `total_impressions` — Sum of impressions from campaigns_daily
- `total_clicks` — Sum of clicks from campaigns_daily
- `total_sessions` — Count of distinct sessions
- `total_conversions` — Count of distinct conversions
- `click_through_rate` — clicks / impressions
- `click_to_session_rate` — sessions / clicks
- `session_to_conversion_rate` — conversions / sessions

**Grain:** One row per campaign.

---

### Staging: `stg_ad_creatives`

**Purpose:** Clean the raw `ad_creatives` source table, which exists in the source definition but has no staging model yet.

**Upstream dependencies:** `source('marketing_raw', 'ad_creatives')`

**Columns:**
- `creative_id` — Primary key
- `campaign_id` — Foreign key to campaigns
- `creative_type` — Type of creative (image, video, carousel)
- `creative_name` — Name of the creative
- `impressions` — Number of impressions
- `clicks` — Number of clicks
- `ctr` — Click-through rate
- `spend` — Amount spent on this creative
- `calculated_ctr` — Calculated CTR (clicks / impressions) for validation

**Grain:** One row per creative.

---

## Acceptance Criteria

- [ ] All models follow existing naming conventions (`stg_`, `int_`, no prefix for marts)
- [ ] All models have schema YAML with column descriptions
- [ ] Key columns have `not_null` and `unique` tests where appropriate
- [ ] Calculations use `::float` for division and `COALESCE` for null handling
- [ ] Unit tests cover LTV segmentation logic and funnel drop-off calculations
- [ ] All models materialize as views (consistent with existing project)
