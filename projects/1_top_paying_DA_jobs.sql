SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name as companies_name
FROM 
    job_postings_fact
LEFT JOIN 
    company_dim on company_dim.company_id = job_postings_fact.company_id
WHERE
    (job_title_short like '%Data Analyst%') AND
    ((job_location like '%Indonesia%') OR
    (job_location like '%Anywhere%') OR 
    (job_work_from_home = TRUE)) AND 
    (salary_year_avg is not null)
ORDER BY
    salary_year_avg desc
LIMIT 10