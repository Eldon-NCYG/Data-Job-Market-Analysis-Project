# Data-Job-Market-Analysis-Project
This project analyses roughly 500,000 tech job postings from the 2024 DataNerd.com data job dataset to understand trends within the current data and tech job market. The analysis pipeline combines SQL-driven data extraction, Python and Excel for data cleaning and exploratory analysis, and interactive Power BI dashboards to present insights clearly and visually.

## Project Backgorund / Motivation
I’m studying Computer Science and Statistics, and I wanted to explore what the future job market might look like for someone with my skill set. This dataset of data and tech job postings gave me a realistic way to investigate questions like:
- How do salaries compare between different roles and locations?
- How available are remove or hybrid positions?
- Which technical skills are most in demand?
- What's the split between junior, mid, and senior roles?

This project demonstrates the following essential data analytics skills:
- Building a repeatable SQL based workflow
- Cleaning and transforming messy data
- Performing exploratory data analysis in Python & Excel
- Creating interactive visualisations with Power BI that communicate clearly communicate insights for a non-technical audience 



## Data Dictionary
| Column Name             | Description                                                                 | Type         | Source           |
|-------------------------|-----------------------------------------------------------------------------|--------------|------------------|
| `job_title_short`       | Cleaned/standardized job title using BERT model (10-class classification)   | Calculated   | From `job_title` |
| `job_title`             | Full original job title as scraped                                          | Raw          | Scraped          |
| `job_location`          | Location string shown in job posting                                        | Raw          | Scraped          |
| `job_via`               | Platform the job was posted on (e.g., LinkedIn, Jobijoba)                   | Raw          | Scraped          |
| `job_schedule_type`     | Type of schedule (Full-time, Part-time, Contractor, etc.)                   | Raw          | Scraped          |
| `job_work_from_home`    | Whether the job is remote (`true`/`false`)                                  | Boolean      | Parsed           |
| `search_location`       | Location used by the bot to generate search queries                         | Generated    | Bot logic        |
| `job_posted_date`       | Date and time when job was posted                                           | Raw          | Scraped          |
| `job_no_degree_mention` | Whether the posting explicitly mentions no degree is required               | Boolean      | Parsed           |
| `job_health_insurance`  | Whether the job mentions health insurance                                   | Boolean      | Parsed           |
| `job_country`           | Country extracted from job location                                         | Calculated   | Parsed           |
| `salary_rate`           | Indicates if salary is annual or hourly                                     | Raw          | Scraped          |
| `salary_year_avg`       | Average yearly salary (calculated from salary ranges when available)        | Calculated   | Derived          |
| `salary_hour_avg`       | Average hourly salary (same logic as yearly)                                | Calculated   | Derived          |
| `company_name`          | Company name listed in job posting                                          | Raw          | Scraped          |
| `job_skills`            | List of relevant skills extracted from job posting using PySpark            | Parsed List  | NLP Extracted    |
| `job_type_skills`       | Dictionary mapping skill types (e.g., 'cloud', 'libraries') to skill sets   | Parsed Dict  | NLP Extracted    |



