with skills_combine as (
    SELECT
        job_id,
        skills
    FROM skills_job_dim as skills_to_job
    INNER JOIN skills_dim as skills_category
        on skills_to_job.skill_id = skills_category.skill_id
    )

SELECT
    skills,
    ROUND(avg(salary_year_avg), 0) as yearly_salary
from skills_combine
RIGHT JOIN job_postings_fact
    on job_postings_fact.job_id = skills_combine.job_id
WHERE
    (job_title like '%Data Analyst%') AND
    (salary_year_avg is not null) AND
    ((job_location like '%Indonesia%') OR
    (job_location like '%Anywhere%') OR 
    (job_work_from_home = TRUE)) 
GROUP BY
    skills
ORDER BY
    yearly_salary desc
LIMIT 25

/*
Could possibly export to JSON to ask AI to make insights 
*/