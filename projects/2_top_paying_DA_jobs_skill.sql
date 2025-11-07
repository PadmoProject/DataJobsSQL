WITH top_paying_jobs as (
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
    LEFT JOIN company_dim on company_dim.company_id = job_postings_fact.company_id
    WHERE
        (job_title_short like '%Data Analyst%') AND
        (job_location like '%Indonesia%') AND (salary_year_avg is not null)
    ORDER BY
        salary_year_avg desc
    LIMIT 10 
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim on top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
    salary_year_avg desc

/*
Could possibly export to JSON to ask AI to make insights 
*/