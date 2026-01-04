
-- Used import wizard to import job_skills and skill_categories csv files as these files are much smaller.


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




