# Data-Job-Market-End-To-End-Analysis-Project

This project analyses roughly 500,000 tech job postings from the 2024 DataNerd.com data job dataset to understand trends within the current data and tech job market. The analysis pipeline combines SQL-driven data extraction, Python and Excel for data cleaning and exploratory analysis, and interactive Power BI dashboards to present insights clearly and visually.

## Project Backgorund / Motivation

I’m studying Computer Science and Statistics, and I wanted to explore what the future job market might look like for someone with my skill set. This dataset of data and tech job postings gave me a realistic way to investigate questions like:

- How do salaries compare between different roles and locations?
- How available are remote or hybrid positions?
- Which technical skills are most in demand?
- What's the split between junior, mid, and senior roles?

### This project demonstrates the following essential data analytics skills:

- Cleaning and transforming messy data
- Building a repeatable SQL based workflow
- Performing exploratory data analysis in Python & Excel
- Creating interactive visualisations with Power BI that communicate clearly communicate insights for a non-technical audience

# Data Dictionary

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

# Exploratory Data Analysis

The goal of this EDA was to understand and familiarise myself with the structure and the different patterns/trends of the dataset. My familiarity of the dataset is crucial for when I go into deeper analysis later on. The analysis was performed using Python with the pandas, matplotlib library. All code, visualizations, and detailed analysis are available in this [Jupyter Notebook](data_jobs_eda.ipynb).

## Considering Hypothesis Testing:

I considered performing hypothesis testing during this EDA to evaluate statistical significance between variables (e.g., salary differences between job titles or countries). However, because this dataset represents a scraped population of job listings rather than a random sample, descriptive and exploratory analysis provides more meaningful insights than inferential statistics. So for this project, I decided hypothesis testing was not necessary.

## Important Things I discovered about the overall structure of the dataset from this EDA:

- Many salary fields are missing because companies often don’t provide salary information, or they list only yearly or hourly pay.
- The job_skills and job_type_skills columns use non‑tabular formats (Python lists and JSON), which makes them difficult to query and requires cleaning.
- Not all of these columns are for analysis. For example, search_location doesn’t add value and will be removed during cleaning.

## Intersting and Potentially Insightful Data from this EDA:

- The salary ceiling is around $400k - $920k
- Machine Learning and Software Engineers have higher salaries than other job titles.
- The most in demand job titles were the Data Jobs - Data Engineers, Data Analysts, and Data Scientists.
- The top 5 countries with the most job listings were the U.S., India, The U.K., France, and Germany.

# Data Cleaning and Schema Normalization

### Non-tabular Columns

![alt text](Images/dataset_problem.png)
The original dataset contained two problematic columns: job_skills and job_type_skills. These fields were stored as Python lists and nested JSON dictionaries, which are difficult to query and analyze in SQL-based environments.

To enable relational analysis, I restructured the dataset by removing these columns from the `job_postings` table and transforming them into normalized tables. This process allowed me to build a clean schema that relationally connects `job_postings`, `job_skills`, and `job_skill_categories`.

### Transformation Process Summary

- **Extraction & Initial Cleaning:** With the help of **Excel** and **Power Query**, I was able to extract the data in the original dataset and create separate CSVs representing the different tables (inside the Schema Folder).
- **Skill & Category Mapping:** I extracted all unique job skills and associated categories from the `job_skills` & `job_type_skills` columns in the original dataset. A unique identifier was assigned for each unique skill and category. The results are [job_skills.csv](Schema/job_skills.csv) & [job_skill_categories.csv](Schema/job_skill_categories.csv).
- **Python Pandas Data Cleaning:** Because the mapping of jobs to skills resulted in a dataset exceeding 2 million rows, I utilized Python (Pandas) to handle the final transformation, resulting in [cleaned_job_skill_connectir.csv](Schema/cleaned_job_skill_connector.csv) .
- **Ensuring Data Integrity:** During the process, I used the .explode() method, I broke down the comma-separated skill strings into individual rows, ensuring no data was lost to Excel's row limits and ensuring data integrity. The full process can be viewed [here](data_cleaning.py).
- *More details about the Python cleaning process in the **Difficulties & Challenges** section at the bottom.*
![alt text](Images/data_jobs_erd.jpg)

### Other Data Cleaning Processes

- **Removed Unnecessary Columns:** Columns such as search_location did not contribute meaningful information to the analysis, so they were dropped to simplify the schema.
- **Standardised Text Formatting:** For the `job_skills` names - ensured consistent casing, spelling, and removing whitespace.
- **Removed Duplicates:** There were many job skills that were the same but spelt differently or abbreviated, so those duplicate skills were removed.
- **Referential Correctness:** I performed validation checks across all records to ensure IDs and relationships aligned across the schema.

# Schema Architecture in MySQL

I implemented the ERD I designed into a fully normalized, relational, schema in MySQL that follows the industry standard star schema design, allowing slicing of the data by any of the categorical columns - [main sql file](main.sql). This relational schema ensures:

- Fast, efficient querying across hundreds of thousands of rows
- Referential integrity between job postings, skills, and skill categories
- Scalable joins for skill‑based salary analysis, demand trends, and cross‑country comparisons
- A repeatable ingestion pipeline that can be re‑run as new data becomes available

### Schema Overview

The database consists of four core tables:

- `job_postings` - the main fact table containing cleaned job metadata.
- `job_skills` - a dimension table of unique skills extracted from the original dataset.
- `job_skill_categories` - a lookup table grouping skills into specific categories.
- `job_skill_connector` - a bridge table implementing a many-to-many relationship between job postings and skills.

###  Data Ingestion

To handle large CSV imports (400k + job postings and 1m + job skill connections), I implemented a high‑performance loading process using LOAD DATA INFILE, temporarily disabling foreign key checks to speed up ingestion while preserving integrity once loading is complete. Below is the query I wrote to import the job_skills_connector csv, which had 1 million + rows of data.

```
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cleaned_job_skill_connector.csv'
IGNORE -- Skip duplicates
INTO TABLE job_skill_connector
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
```

The importing process takes a minute max. If I were to use the traditional Table Data Import Wizard to import the CSVs into the tables, it would take a couple of hours (I know this because I tried this method at first...).

## Unified Job-Skill-Connector View

To perform analysis involving both job postings and their associated skills, I created a unified SQL view that encapsulates the many‑to‑many relationship across the schema. (Queries that don't involve job skills can use the `job_postings` table)

```
CREATE OR REPLACE VIEW v_job_skill_analysis AS
SELECT
    jp.job_id,
    jp.job_title_short,
    jp.job_location,
    jp.job_country,
    jp.company_name,
    jp.job_schedule_type,
    jp.job_work_from_home,
    jp.job_posted_date,

    -- Financial columns
    jp.salary_year_avg,
    jp.salary_hour_avg,

    -- Skill data for the many-to-many relationship
    js.skill_name,
    jsc.category_name
FROM
    job_postings AS jp
INNER JOIN job_skill_connector AS jconn ON jp.job_id = jconn.job_id
INNER JOIN job_skills AS js ON jconn.skill_id = js.skill_id
INNER JOIN job_skill_categories AS jsc ON js.category_id = jsc.category_id;

```
- **Primary Fact Table - `job_postings`:** Used as the primary facts source for general job market metrics. It is used for queries that do not require a job's associated skills. Using the base table minimizes computational overhead and improves query performance by avoiding unnecessary joins.


- **Analytical View - `v_job_skill_analysis`:** A unified interface that encapsulates the many-to-many relationships between job postings, job skills, and skill categories. Instead of repeatedly writing long join statements, this view provides structure that can be queried directly without the need to manually reconstruct the relational joins for every session.



# Deep Analysis into the Data
Rather than doing a simple surface-level summary about the data (which can be shown through data visualisations alone), I wanted to deliver a deeper analysis to uncover less obvious patterns, trends, and relationships. I have organised my deep analysis into five different categories: Job Titles, Job Location, Salaries, and Trends. Each category has questions designed to yieled deeper, decision-relevant insights. You can view the full analysis in the Deep Analysis Section of the [main sql file](main.sql).

### Job Titles: Role Comparisons

**Market Share by Role:** What is the total count and percentage share of each job title in the overall dataset?

**Skill Overlap between Data Analysts & Data Scientists:** What percentage of Data Analysts skills overlap with Data Scientists skills? (I'm most interested in both of these roles)

**Do different roles have a wider variety skillset?:** What is the average unique number of unique skills for each role?


### Job Location Impact:
**Remote Job Distribution by:** For each country, compare the number of remote and on-site jobs.

**Global Opportunity Density:** Which countries have the highest number of job postings relative to the number of unique companies hiring there?

**Degree Importance By Country:** Does the percentage of roles that require a degree vary significantly between different countries?



### Salary Analysis:


**Seniority Difference:** Does seniority affect the a role's average and median salary, and if so, how much?


**Skill Category Value:** Which skill category is associated with the highest median/average annual salary?


**No-Degree Opportunity Cost:** For roles that don't require a degree, is there a significant difference in salary?



### Trends within The Data: Time-Series Analysis
**Were there hiring seasons during 2024?:** Which month in 2024 had the highest and lowest volume of new job postings?

**Seniority Bias?:** Is the market favouring senior or junior roles? How did the number of senior and junior roles change throughout 2024?



**Skills Trending in 2024:** Were there any roles that saw a huge increase in popularity throughout 2024?





# Difficulties & Challenges

### Data Truncation via Excel Row Limits
While conducting the SQL deep analysis, I discovered that my quarterly trend results for the latter half of the year (Q3 and Q4) were significantly lower than expected. Upon investigation, I identified that the [job_skill_connector](Schema/Unused/job_skill_connector_truncated.csv) table, which manages the many-to-many relationship between jobs and skills only contained the connections for about half of the jobs in the dataset. Because the data was initially processed and exported through Excel (CSV version), it was silently truncated at 1,048,576 rows, which is the maximum limit for an Excel worksheet. This resulted in the loss of nearly half of the skill-mapping data, leading to inaccurate insights during the initial phase of the project (all other tables are fine).

### Resolving the Problem
To resolve this and ensure data integrity, instead of using Excel & Power Query for cleaning the `job_skill_connector`, I used Power Query and Python, specifically the Pandas library which can handle millions of rows without truncation. Once I cleaned the data, I ensured data integrity by making sure all records within the `job_skill_connector` performing a row-count validation between the raw source file and the SQL database.