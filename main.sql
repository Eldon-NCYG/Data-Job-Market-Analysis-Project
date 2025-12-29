CREATE DATABASE data_job_market_analysis_project;
use data_job_market_analysis_project;

-- Table: job_postings
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



-- Table: job_skills
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
 



-- Table: job_skill_connector
CREATE TABLE job_skill_connector (
    job_id BIGINT,
    skill_id INT,
    PRIMARY KEY (job_id, skill_id),
    FOREIGN KEY (job_id) REFERENCES job_postings(job_id),
    FOREIGN KEY (skill_id) REFERENCES job_skills(skill_id)
);



-- Importing job_skill_connector csv (over 1million rows, so we need to speed up process)
SET FOREIGN_KEY_CHECKS = 0;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/job_skill_connector.csv'
IGNORE -- <--- This tells MySQL to skip duplicates and keep going
INTO TABLE job_skill_connector
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' 
IGNORE 1 ROWS;

SET FOREIGN_KEY_CHECKS = 1;


SELECT count(*) FROM job_skill_connector;



-- View with Join Statement connecting job postings, job skills and skill categories (only showing jobs that have skills listed)
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


SELECT * FROM v_job_skill_details;
