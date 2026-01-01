CREATE DATABASE data_job_market_analysis_project;
use data_job_market_analysis_project;

-- Table: job_postings -- 
CREATE TABLE job_postings (
	job_id BIGINT PRIMARY KEY,
    job_title_short VARCHAR(255),
    job_title TEXT,
    job_location TEXT,
    job_via TEXT,
    job_schedule_type VARCHAR(100),
    job_work_from_home ENUM('TRUE', 'FALSE') NULL,
    job_posted_date DATE,
    job_no_degree_mention ENUM('TRUE', 'FALSE') NULL,
    job_health_insurance ENUM('TRUE', 'FALSE') NULL,
    job_country VARCHAR(100),
    salary_year_avg TEXT NULL,
    salary_hour_avg TEXT NULL,
    company_name TEXT
);

-- Importing Job postings csv (very large file)
TRUNCATE TABLE job_postings;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/job_postings.csv'
INTO TABLE job_postings
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' 
IGNORE 1 ROWS;



-- (RUN AFTER IMPORTING JOB POSTINGS CSV) Allowing empty values for salary year and salary hour 
UPDATE job_postings 
SET salary_year_avg = NULL 
WHERE salary_year_avg = '';

ALTER TABLE job_postings 
MODIFY COLUMN salary_year_avg INT;


UPDATE job_postings 
SET salary_hour_avg = NULL 
WHERE salary_hour_avg = '';

ALTER TABLE job_postings 
MODIFY COLUMN salary_hour_avg DECIMAL(15,2);



DESCRIBE job_postings;



-- Table: job_skills -- 
CREATE TABLE job_skills (
    skill_id INT PRIMARY KEY,
    skill_name VARCHAR(100) UNIQUE NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES job_skill_categories(category_id)
);

SELECT * FROM job_skills;


-- Table: job_skill_categories
CREATE TABLE job_skill_categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50) UNIQUE NOT NULL
);

SELECT * FROM job_skill_categories
ORDER BY category_id;
 



-- Table: job_skill_connector -- 
CREATE TABLE job_skill_connector (
    job_id BIGINT,
    skill_id INT,
    PRIMARY KEY (job_id, skill_id),
    FOREIGN KEY (job_id) REFERENCES job_postings(job_id),
    FOREIGN KEY (skill_id) REFERENCES job_skills(skill_id)
);



-- Importing job_skill_connector csv (over 1million rows, so we need to speed up process)
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE job_skill_connector;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cleaned_job_skill_connector.csv'
IGNORE -- <--- This tells MySQL to skip duplicates and keep going
INTO TABLE job_skill_connector
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' 
IGNORE 1 ROWS;

SET FOREIGN_KEY_CHECKS = 1;


SELECT count(*) FROM job_skill_connector;



-- View with Join Statement connecting job postings, job skills and skill categories (only showing jobs that have skills listed)
CREATE OR REPLACE VIEW v_job_skill_details AS
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
LEFT JOIN job_skill_connector AS jconn ON jp.job_id = jconn.job_id
LEFT JOIN job_skills AS js ON jconn.skill_id = js.skill_id
LEFT JOIN job_skill_categories AS jsc ON js.category_id = jsc.category_id;





-- Deep Analysis: ----------------------------------------------------------------------------------------------------------

-- JOB TITLES: ROLE COMPARISONS --


-- Do different roles have a wider variety skillset?
WITH skill_stats AS (
    -- unique skills per individual job_id
    SELECT 
        job_id,
        job_title_short,
        COUNT(skill_name) AS skills_per_job
    FROM v_job_skill_details
    GROUP BY job_id, job_title_short
),
skill_frequency AS (
    -- Count total occurrences of each skill across all postings for each role
    SELECT 
        job_title_short,
        skill_name,
        COUNT(*) AS total_occurrence
    FROM v_job_skill_details
    WHERE skill_name != 'No Skill Specified'
    GROUP BY job_title_short, skill_name
),
most_popular AS (
    -- most popular skill for each role
    SELECT 
        job_title_short,
        skill_name,
        ROW_NUMBER() OVER(PARTITION BY job_title_short ORDER BY total_occurrence DESC) as rank_order
    FROM skill_frequency
)

SELECT 
    stats.job_title_short AS job_role,
    ROUND(AVG(stats.skills_per_job), 1) AS avg_unique_skills,
    pop.skill_name AS most_popular_skill
FROM skill_stats stats
JOIN most_popular pop ON stats.job_title_short = pop.job_title_short
WHERE pop.rank_order = 1
GROUP BY stats.job_title_short, pop.skill_name
ORDER BY avg_unique_skills DESC;



-- Market Share by Role (Count & Percentage)
SELECT 
	job_title_short as job_role, 
    FORMAT(COUNT(*), 'N0') as job_count, 
    CONCAT(ROUND((COUNT(*) * 100.0) / SUM(COUNT(*)) OVER(), 2), "%") as percentage_share
    FROM job_postings
GROUP BY job_title_short
ORDER BY job_count;


-- Proportion of Roles that are remote
with job_roles AS (
	SELECT 
		job_title_short,
        COUNT(*) AS total_jobs
	FROM job_postings
    GROUP BY job_title_short
)
SELECT 
	jp.job_title_short,
    CONCAT(ROUND((SUM(CASE WHEN jp.job_work_from_home = 'FALSE' THEN 1 ELSE 0 END) / jobs.total_jobs) * 100, 1), '%') AS on_site_pct,
    CONCAT(ROUND((SUM(CASE WHEN jp.job_work_from_home = 'TRUE' THEN 1 ELSE 0 END) / jobs.total_jobs) * 100, 1), '%') AS remote_pct
FROM job_postings jp
JOIN job_roles jobs ON jp.job_title_short = jobs.job_title_short
GROUP BY jp.job_title_short
ORDER BY jobs.total_jobs DESC;



-- Skill Overlap between Data Analysts & Data Scientists (top 25 skills for data analysts):
WITH role_job_counts AS (
	SELECT 
		job_title_short,
        COUNT(*) as total_jobs
	FROM job_postings
    WHERE job_title_short IN ('Data Analyst', 'Data Scientist')
    GROUP BY job_title_short
),
skill_counts AS (
SELECT 
	job_title_short,
    skill_name,
    COUNT(*) as skill_count
FROM v_job_skill_details
WHERE job_title_short IN ('Data Analyst', 'Data Scientist')
GROUP BY job_title_short, skill_name
ORDER BY skill_count DESC
)

SELECT 
da.skill_name, 
-- Data Analyst Proportion
CONCAT(ROUND((da.skill_count / (SELECT total_jobs FROM role_job_counts WHERE job_title_short = 'Data Analyst')) * 100, 1), '%') AS da_proportion,

-- Data Scientist Proportion
CONCAT(ROUND((ds.skill_count / (SELECT total_jobs FROM role_job_counts WHERE job_title_short = "Data Scientist")) * 100, 1), '%') as ds_proportion 
FROM skill_counts da
INNER JOIN skill_counts ds ON da.skill_name = ds.skill_name
WHERE da.job_title_short = 'Data Analyst' 
  AND ds.job_title_short = 'Data Scientist'
LIMIT 25;










-- JOB LOCATION IMPACT --

-- Remote Job Proportion by Country: For each country, compare the number of remote and on-site jobs.
with country_totals AS (
	SELECT 
		job_country,
        COUNT(*) AS total_jobs
	FROM job_postings
    GROUP BY job_country
)
SELECT 
	jp.job_country,
    FORMAT(total_jobs, 'N0') as total_jobs,
	FORMAT(SUM(CASE WHEN jp.job_work_from_home = 'FALSE' THEN 1 ELSE 0 END), 'N0') AS on_site_count,
    CONCAT(ROUND((SUM(CASE WHEN jp.job_work_from_home = 'FALSE' THEN 1 ELSE 0 END) / countries.total_jobs) * 100, 1), '%') AS on_site_pct,
    FORMAT(SUM(CASE WHEN jp.job_work_from_home = 'TRUE' THEN 1 ELSE 0 END), 'N0') AS remote_job_count,
    CONCAT(ROUND((SUM(CASE WHEN jp.job_work_from_home = 'TRUE' THEN 1 ELSE 0 END) / countries.total_jobs) * 100, 1), '%') AS remote_pct
FROM job_postings jp
JOIN country_totals countries ON jp.job_country = countries.job_country
GROUP BY jp.job_country, countries.total_jobs
ORDER BY countries.total_jobs DESC
LIMIT 50;
    





-- Global Opportunity Density - Which countries have the highest number of job postings relative to the number of unique companies hiring 
SELECT 
	job_country,
	FORMAT(COUNT(job_id), 'N0') as total_jobs,
	COUNT(DISTINCT company_name) as unique_companies,

	-- Density Ratio (jobs / unique_companies) - Jobs per company
	CONCAT(ROUND(COUNT(job_id) / COUNT(DISTINCT(company_name)), 2), ' jobs per company') as density_ratio
FROM job_postings
WHERE job_country is not null
GROUP BY job_country
ORDER BY density_ratio DESC;



-- Degree Importance By Country
WITH country_totals AS (
	SELECT 
		job_country,
        COUNT(*) AS total_jobs
	FROM job_postings
    GROUP BY job_country
)
SELECT 
	jp.job_country,
    FORMAT(total_jobs, 'N0') as total_jobs,
	FORMAT(SUM(CASE WHEN job_no_degree_mention = 'TRUE' THEN 1 ELSE 0 END), 'N0') AS degree_mentioned,
    CONCAT(ROUND((SUM(CASE WHEN job_no_degree_mention = 'TRUE' THEN 1 ELSE 0 END) / countries.total_jobs) * 100, 1), '%') AS degree_pct,
    FORMAT(SUM(CASE WHEN jp.job_work_from_home = 'FALSE' THEN 1 ELSE 0 END), 'N0') AS no_degree_mentioned,
    CONCAT(ROUND((SUM(CASE WHEN job_no_degree_mention = 'FALSE' THEN 1 ELSE 0 END) / countries.total_jobs) * 100, 1), '%') AS no_degree_pct
FROM job_postings jp
JOIN country_totals countries ON jp.job_country = countries.job_country
GROUP BY jp.job_country, countries.total_jobs
ORDER BY countries.total_jobs DESC
LIMIT 50;




-- SALARY ANALYSIS -- 

-- Seniority Average Yearly Salary Difference 
SELECT 
    job_title_short,
    CASE 
        WHEN job_title LIKE '%Intern%' OR job_title LIKE '%intern%' THEN 'Intern'
        WHEN job_title LIKE '%Junior%' OR job_title LIKE '%Entry%' THEN 'Junior/Entry'
        WHEN job_title LIKE '%Senior%' THEN 'Senior'
        WHEN job_title LIKE '%Lead%' OR job_title LIKE '%Principal%' THEN 'Lead/Manager'
        ELSE 'Mid-Level/Not Specified'
    END AS seniority_level,
    CONCAT('$', FORMAT(ROUND(AVG(salary_year_avg), 0), 'N0')) AS avg_annual_salary,
    COUNT(*) AS job_count
FROM job_postings
WHERE 
    salary_year_avg IS NOT NULL 
GROUP BY job_title_short, seniority_level
ORDER BY job_title_short, avg_annual_salary;



-- Skill Category value: Which skill category is associated with the highest average annual salary
SELECT
	category_name,
    CONCAT('$', FORMAT(AVG(salary_year_avg) , 'N0')) as average_salary
FROM v_job_skill_details
GROUP BY category_name
ORDER BY average_salary DESC;



-- No-Degree Opportunity Cost: For roles that don't require a degree, is there a significant difference in salary?
SELECT 
    job_title_short,
    CASE
		WHEN job_no_degree_mention = 'TRUE' THEN 'no'
        WHEN job_no_degree_mention = 'FALSE' THEN 'yes'
	END AS degree_required,
    FORMAT(COUNT(*), 'N0') as job_count,
    CONCAT('$',FORMAT(AVG(salary_year_avg), 'N0')) as average_salary
FROM job_postings
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title_short, job_no_degree_mention
ORDER BY job_title_short, job_no_degree_mention;










-- TRENDS WITHIN THE DATA: TIME-SERIES ANALYSIS -- 

-- Were there hiring seasons during 2024?: Which month in 2024 had the highest and lowest volume of new job
with monthly_counts AS (
	SELECT 
		EXTRACT(MONTH FROM job_posted_date) as month_num,
        COUNT(job_id) as job_count
	FROM job_postings
    GROUP BY month_num
)
SELECT
	CASE month_num
        WHEN 1 THEN 'January' WHEN 2 THEN 'February' WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'   WHEN 5 THEN 'May'      WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'    WHEN 8 THEN 'August'   WHEN 9 THEN 'September'
        WHEN 10 THEN 'October' WHEN 11 THEN 'November' WHEN 12 THEN 'December'
    END AS month_2024,
    FORMAT(job_count, 'N0') as job_count,
    FORMAT(ROUND(AVG(job_count) OVER (ORDER BY month_num), 0), 'N0') as moving_avg_job_count,
    FORMAT(SUM(job_count) OVER (ORDER BY month_num), 'N0') as running_total_job_count
FROM monthly_counts;


-- Are senior or junior roles more favoured compared to each other?
WITH seniority_mapping AS(
	SELECT
		job_id,
        job_posted_date,
		CASE 
			WHEN job_title LIKE '%Intern%' OR job_title LIKE '%intern%' THEN 'Intern'
			WHEN job_title LIKE '%Junior%' OR job_title LIKE '%Entry%' THEN 'Junior/Entry'
			WHEN job_title LIKE '%Senior%' THEN 'Senior'
			WHEN job_title LIKE '%Lead%' OR job_title LIKE '%Principal%' THEN 'Lead/Manager'
			ELSE 'Mid-Level/Not Specified'
		END AS seniority_level
	FROM job_postings
),
quarterly_jobs AS (
	SELECT
		seniority_level,
        QUARTER(job_posted_date) as quarter_num,
        COUNT(job_id) as job_count
	FROM seniority_mapping
    GROUP BY seniority_level, quarter_num
),
quarter_pivot AS (
    SELECT
        seniority_level,
        MAX(CASE WHEN quarter_num = 1 THEN job_count ELSE 0 END) AS Q1,
        MAX(CASE WHEN quarter_num = 2 THEN job_count ELSE 0 END) AS Q2,
        MAX(CASE WHEN quarter_num = 3 THEN job_count ELSE 0 END) AS Q3,
        MAX(CASE WHEN quarter_num = 4 THEN job_count ELSE 0 END) AS Q4
    FROM quarterly_jobs
    GROUP BY seniority_level
)
SELECT
    seniority_level,
    Q1, Q2, Q3, Q4,
    (Q1 + Q2 + Q3 + Q4) AS total_jobs,
    CONCAT(ROUND((((Q1 + Q2 + Q3 + Q4) - Q1) / NULLIF(Q1, 0)) * 100, 1), '%') AS total_growth_pct
FROM quarter_pivot
ORDER BY total_growth_pct DESC;

    
    

-- Skills Trending in 2024: Were there any Skills that saw a huge increase in popularity throughout 2024?

with skill_quarters AS (
	SELECT
		skill_name,
        QUARTER(job_posted_date) as quarter_num,
        COUNT(job_title_short) as job_count
	FROM v_job_skill_details
    GROUP BY skill_name, quarter_num
),
quarter_pivot AS (
    SELECT 
        skill_name,
        MAX(CASE WHEN quarter_num = 1 THEN job_count ELSE 0 END) AS Q1,
        MAX(CASE WHEN quarter_num = 2 THEN job_count ELSE 0 END) AS Q2,
        MAX(CASE WHEN quarter_num = 3 THEN job_count ELSE 0 END) AS Q3,
        MAX(CASE WHEN quarter_num = 4 THEN job_count ELSE 0 END) AS Q4,
        (MAX(CASE WHEN quarter_num = 1 THEN job_count ELSE 0 END) +
         MAX(CASE WHEN quarter_num = 2 THEN
         job_count ELSE 0 END) +
         MAX(CASE WHEN quarter_num = 3 THEN job_count ELSE 0 END) +
         MAX(CASE WHEN quarter_num = 4 THEN job_count ELSE 0 END)) AS total_year_count
    FROM skill_quarters
    GROUP BY skill_name
)
SELECT 
	skill_name,
    Q1, Q2, Q3, Q4,
	CONCAT(ROUND((((total_year_count - Q1) / Q1) * 100), 1), '%') as total_growth_pct
FROM quarter_pivot
WHERE (Q1 + Q2 + Q3 + Q4) > 500
ORDER BY total_growth_pct DESC;





