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





-- Table: job_skills -- 
CREATE TABLE job_skills (
    skill_id INT PRIMARY KEY,
    skill_name VARCHAR(100) UNIQUE NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES job_skill_categories(category_id)
);



-- Table: job_skill_categories
CREATE TABLE job_skill_categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50) UNIQUE NOT NULL
);

 


-- Table: job_skill_connector -- 
CREATE TABLE job_skill_connector (
    job_id BIGINT,
    skill_id INT,
    PRIMARY KEY (job_id, skill_id),
    FOREIGN KEY (job_id) REFERENCES job_postings(job_id),
    FOREIGN KEY (skill_id) REFERENCES job_skills(skill_id)
);



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