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

| Column Name             | Description                                                               | Type        | Source           |
| ----------------------- | ------------------------------------------------------------------------- | ----------- | ---------------- |
| `job_title_short`       | Cleaned/standardized job title using BERT model (10-class classification) | Calculated  | From `job_title` |
| `job_title`             | Full original job title as scraped                                        | Raw         | Scraped          |
| `job_location`          | Location string shown in job posting                                      | Raw         | Scraped          |
| `job_via`               | Platform the job was posted on (e.g., LinkedIn, Jobijoba)                 | Raw         | Scraped          |
| `job_schedule_type`     | Type of schedule (Full-time, Part-time, Contractor, etc.)                 | Raw         | Scraped          |
| `job_work_from_home`    | Whether the job is remote (`true`/`false`)                                | Boolean     | Parsed           |
| `search_location`       | Location used by the bot to generate search queries                       | Generated   | Bot logic        |
| `job_posted_date`       | Date and time when job was posted                                         | Raw         | Scraped          |
| `job_no_degree_mention` | Whether the posting explicitly mentions no degree is required             | Boolean     | Parsed           |
| `job_health_insurance`  | Whether the job mentions health insurance                                 | Boolean     | Parsed           |
| `job_country`           | Country extracted from job location                                       | Calculated  | Parsed           |
| `salary_rate`           | Indicates if salary is annual or hourly                                   | Raw         | Scraped          |
| `salary_year_avg`       | Average yearly salary (calculated from salary ranges when available)      | Calculated  | Derived          |
| `salary_hour_avg`       | Average hourly salary (same logic as yearly)                              | Calculated  | Derived          |
| `company_name`          | Company name listed in job posting                                        | Raw         | Scraped          |
| `job_skills`            | List of relevant skills extracted from job posting using PySpark          | Parsed List | NLP Extracted    |
| `job_type_skills`       | Dictionary mapping skill types (e.g., 'cloud', 'libraries') to skill sets | Parsed Dict | NLP Extracted    |

## Exploratory Data Analysis

The goal of this EDA was to understand and familiarise myself with the structure and the different patterns/trends of the dataset. My familiarity of the dataset is crucial for when I go into further and deeper analysis later on. The analysis was performed using Python with the pandas, matplotlib library. All code, visualizations, and detailed analysis are available in this [Jupyter Notebook](data_jobs_eda.ipynb).

#### Considering Hypothesis Testing:
I considered performing hypothesis testing during this EDA to evaluate statistical significance between variables (e.g., salary differences between job titles or countries). However, because this dataset represents a scraped population of job listings rather than a random sample, descriptive and exploratory analysis provides more meaningful insights than inferential statistics. So for this project, I decided hypothesis testing was not necessary.


#### Important Things I discovered about the overall structure of the dataset from this EDA:

- There are a lot of rows that are missing data for their information about salary. This is because not all companies will list down their given salary for their job listings or will only have either the yearly or hourly salary listed.
- The `job_skills` and `job_type_skills` columns contain an unusual type of data. `job_skills` contains a list of data (in python syntax) while `job_type_skills` is in JSON form. This type of data is very hard to use. These two columns need to be cleaned.
- Not all of these columns are useful for the purpose of my analysis. I think that the column `search_location` wouldn't really provide much for this project. So I will remove this column when I clean the data.

#### Intersting and Potentially Insightful Data from this EDA:

- The salary ceiling is around $400k - $920k
- Machine Learning and Software Engineers have higher salaries than other job titles.
- The most in demand job titles were the Data Jobs - Data Engineers, Data Analysts, and Data Scientists.
- The top 5 countries with the most job listings were the U.S., India, The U.K., France, and Germany.

## Data Cleaning
