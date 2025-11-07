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
    count(skills_combine.skills) as skills_count,
    Round(avg(salary_year_avg),0) as yearly_avg
from 
    skills_combine
RIGHT JOIN job_postings_fact
    on job_postings_fact.job_id = skills_combine.job_id
WHERE
    (job_title like '%Data Analyst%') AND
    ((job_location like '%Indonesia%') OR
    (job_location like '%Anywhere%') OR 
    (job_work_from_home = TRUE))
GROUP BY
    skills
HAVING
    avg(salary_year_avg) is not null AND
    count(skills) > 10
ORDER BY
    yearly_avg desc, 
    skills_count desc
LIMIT 25