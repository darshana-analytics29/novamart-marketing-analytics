# NovaMart Marketing Analytics
### End-to-End Data Analytics Project | PostgreSQL • Power BI • DAX • Excel

## Project Overview

NovaMart Marketing Analytics is an end-to-end data analytics portfolio project that examines digital marketing campaign performance for NovaMart, a retail business used as a case study.

The project analyses campaign data to compare marketing channels, campaign types, regions, devices, target audiences and time periods. Using PostgreSQL and Power BI, it turns raw campaign data into performance metrics, interactive dashboards and actionable recommendations.

The main objective is to understand where marketing generates the most revenue, which channels perform well on engagement and conversions, and where further investigation may improve marketing efficiency.

## Project Objectives

- Analyse marketing spend, impressions, clicks, conversions, revenue and new customers.
- Compare marketing channels using performance and efficiency metrics.
- Evaluate campaign types and individual campaigns.
- Identify differences across regions, devices and target audiences.
- Analyse monthly and quarterly performance trends.
- Identify data-quality risks and recommend actions supported by the analysis.

## Tools and Technologies

| Tool | Purpose |
|---|---|
| Microsoft Excel | Initial dataset inspection and exploration |
| PostgreSQL | Data preparation, SQL queries and performance analysis |
| Power BI | Interactive dashboards and data visualisation |
| DAX | KPI calculations and measures |

## Dataset

**Dataset filename:** `NovaMart_Marketing_Analytics_100K.xlsx`

- **Size:** Approximately 100,000 records and 15 fields
- **Reporting period:** 1 January 2024 – 31 December 2025
- **Cleaned PostgreSQL table:** `marketing_cleaned`

The dataset contains campaign dates, campaign names, marketing channels, campaign types, target audiences, regions, devices, spend, impressions, clicks, conversions, revenue, new customers and campaign status.

**Dataset reference:** [NovaMart Marketing Analytics Dataset Repository](https://github.com/sachin-as-DA/marketing-analytics-powerbi-sql)

**Data note:** NovaMart is treated as a fictional business for this case study. The dataset's original source has not been independently verified, and its figures should not be interpreted as actual company financial results. The Excel dataset is referenced through the repository above and is not currently listed among the files in this repository.

## Project Workflow

1. **Data inspection:** Reviewed the dataset structure, fields, record count and reporting period.
2. **Data preparation and validation:** Examined data quality, field formats, duplicates, missing values and numerical consistency.
3. **SQL analysis:** Used PostgreSQL to compare performance by channel, campaign, region, device, audience and time period.
4. **KPI calculation:** Analysed marketing performance using CTR, Conversion Rate, CPC, CPA, CAC and ROAS.
5. **Dashboard development:** Connected the cleaned PostgreSQL table to Power BI and developed four dashboard pages.
6. **Business recommendations:** Translated the findings into actions to investigate and test.

## Power BI Dashboard

The Power BI report contains four interactive dashboard pages covering overall marketing performance, channel performance, campaign performance, and regional and audience analysis.

### 1. Marketing Overview

This dashboard provides an overview of total revenue, spend, conversions, new customers, ROAS, revenue by channel, spend versus revenue, and monthly revenue trends.

![Marketing Overview](images/Marketing%20Overview.png)

### 2. Channel Performance Analysis

This dashboard compares marketing channels using click-through rate (CTR), conversion rate, clicks, and conversions to identify differences in engagement and conversion performance.

![Channel Performance Analysis](images/Channel%20Performance%20Analysis.png)

### 3. Campaign Performance Analysis

This dashboard compares revenue and ROAS by campaign type, campaign status distribution, and conversions across campaign types.

![Campaign Performance Analysis](images/Campaign%20Performance.png)

### 4. Regional and Audience Analysis

This dashboard analyses revenue and ROAS across regions and compares revenue and conversion rates across target audiences.

![Regional and Audience Analysis](images/Regional%20%26%20Audience%20Analysis.png)

## Key Findings

The following findings are based on the SQL analysis documented in the project report.

- **Email:** Recorded the strongest CTR and conversion rate in the channel comparison, alongside higher reported ROAS and lower CAC than other channels.
- **Google Ads:** Generated the highest total reported revenue, making it an important channel for revenue volume.
- **YouTube:** Showed comparatively weaker click-through and conversion performance, with higher acquisition costs.
- **Campaign types:** Brand Awareness generated the highest reported revenue, while Retention recorded the highest reported ROAS.
- **Named campaigns:** Summer Sale generated the highest reported campaign revenue, while Diwali Mega Sale had the highest reported ROAS.
- **Regions:** West generated the highest reported regional revenue, while North recorded the highest regional ROAS.
- **Devices:** Mobile generated the largest reported revenue and new-customer volume.
- **Target audiences:** Existing Customers contributed the highest reported audience revenue, while Families recorded the highest CTR and conversion rate in the audience comparison.

These results describe patterns in the available dataset. They do not establish that a particular channel or campaign caused the outcome.

## Key Performance Indicators (KPIs)

| KPI | Definition | Purpose |
|---|---|---|
| CTR | Total Clicks ÷ Total Impressions | Measures the share of impressions that resulted in clicks. |
| Conversion Rate | Total Conversions ÷ Total Clicks | Measures the share of clicks that resulted in conversions. |
| CPC | Total Spend ÷ Total Clicks | Measures average recorded cost per click. |
| CPA | Total Spend ÷ Total Conversions | Measures average recorded cost per conversion. |
| CAC | Total Spend ÷ Total New Customers | Measures average recorded acquisition cost per new customer. |
| ROAS | Total Attributed Revenue ÷ Total Spend | Measures revenue generated per unit of advertising spend. |

## Data Quality and Limitations

The analysis showed unusually high reported ROAS values of approximately **496.75x** and revenue totals in the billions. These results require further validation before they can support real-world business decisions.

Key limitations include:

- The original dataset source has not been independently verified.
- The business definitions of conversions, revenue and new customers require confirmation.
- Revenue and spend units, attribution and possible duplicate revenue need to be validated.
- ROAS measures revenue relative to advertising spend; it does not measure profit.
- The analysis is descriptive and diagnostic. It does not prove causation or forecast future performance.

## Recommendations

1. **Validate the data:** Check revenue units, attribution, calculations and consistency across Excel, PostgreSQL and Power BI.
2. **Study Email performance:** Investigate which audiences and campaigns contribute to Email's stronger engagement and conversion results.
3. **Investigate YouTube:** Review its creative, audience fit and targeting to identify possible improvements.
4. **Monitor Google Ads:** Track spending and results to assess whether its revenue contribution is efficient.
5. **Test before reallocating budgets:** Make controlled changes and measure their results before increasing or reducing marketing investment.

## Repository Contents

| File | Description |
|---|---|
| `PostGre SQL marketing analytics.sql` | SQL queries used for marketing analytics |
| `Power Bi marketing analytics dashboard.pbix` | Power BI dashboard report |
| `NovaMart_Marketing_Analytics_Project_Report.pdf` | Final project report and documentation |
| `Marketing Overview.png` | Marketing Overview dashboard screenshot |
| `Channel Performance Analysis.png` | Channel Performance dashboard screenshot |
| `Campaign Performance.png` | Campaign Performance dashboard screenshot |
| `Regional & Audience Analysis.png` | Regional and Audience dashboard screenshot |

## Conclusion

This project demonstrates an end-to-end marketing analytics workflow using PostgreSQL, Power BI, DAX and Excel. It compares marketing performance across channels, campaigns, regions, devices and audiences, then presents findings through interactive dashboards and business recommendations.

The analysis highlights the importance of examining both revenue and efficiency, validating data quality, and testing recommendations before making marketing budget decisions.

---

**Project Type:** Data Analytics Portfolio Case Study  
**Focus Areas:** Marketing Analytics | SQL | PostgreSQL | Power BI | DAX | Data Visualisation
