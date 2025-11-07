# Introduction
Diving into data job market! I focused on exploring data analyst role in Indonesia and also remotely. This project explores top paying data analyst role, in-demand skills in those roles, and where high demand meets high salary in data analytics.

Wants to know more? Check my queries [here](/projects/)

# Background
Driven by the desire to explore data analyst job market more efficiently, I intend to pinpoint what are the top-paid and in-demand skill for data analyst, streamlining others work to find the optimal jobs.

All the datasets are from Luke Barousse's [SQL Course](https://lukebarousse.com/sql). It's packed with insights on job titles, salaries, locations, and essential skills.

### Questions to be answered using SQL Queries:
1. What are the top-paying data analyst jobs in Indonesia and remote work?
2. What skills are requried for these top-paying jobs?
3. What skills are most in demand for data analyst in Indonesia and remote work?
4. Which data analyst skills are associated with higher salaries in these areas?
5. What are the most optimal skills to learn?

# Tools I Used
These are the tools I used in order to deep dive my research into the data analyst job market:
- **SQL**: The backbone of this analysis, allowing me to make and query the databases to unearth critical insights
- **PostreSQL**: My chosen database management system, great for handling the job posting data
- **Visual Studio Code**: My choice for database management and also executing SQL queries
- **Git & GitHub**: Essential tools for version control and sharing my SQL analysis, ensuring spaces for collaboration and project tracking 

# The Analysis
Every query I did in this project is aimed towards examining specific aspects of the data analyst job market. Here's my approached to each question:

### 1. Top Paying Data Analyst Job
In order to identify highest-paying roles, I filtered data analyst positios by average of yearly salary and location, focusing on Indonesia and remote work. This query highlights the high paying opportunities in the field.

```sql
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
```

Here's the breakdown of the top data analyst jobs in 2024:
- **Wide Salary Range**: Top 10 paying data analyst roles span from $185.000 to $650.000, indicating significant salary potential in the field
- **Diverse Employers**: Companies like AT&T, Pinterest, and UCLAHealthcareers are among those offering high salaries, showing a broad interest accross different industries
- **Job Title Variety**: There's a high diversity among job titles ranging from Data Analyst to Director of Analytics, reflecting various role and specialization within data analytics.

### 2. Skills for Top Paying Data Analyst Jobs
To analyze what skills are required for top paying jobs in data analyst, I joined the job postings with the skills data to be able to uncover what employers value for high-compensation roles.

```sql
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
        ((job_location like '%Indonesia%') OR
        (job_location like '%Anywhere%') OR 
        (job_work_from_home = TRUE)) AND 
        (salary_year_avg is not null)
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
```

Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2024:
- **SQL** is the leading skills with count of 10.
- **Python** follows closely by 9.
- **Tableau** is also highly sought after by the count of 7.

### 3. In-Demand Skills for Data Analyst
This particular query helped me identify skills that are most requested in job postings, shifting focus to areas with high-demand.

```sql
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
    count(skills_combine.skills) as skills_count
from skills_combine
RIGHT JOIN job_postings_fact
    on job_postings_fact.job_id = skills_combine.job_id
WHERE
    (job_title like '%Data Analyst%') AND
    ((job_location like '%Indonesia%') OR
    (job_location like '%Anywhere%') OR 
    (job_work_from_home = TRUE)) 
GROUP BY
    skills
ORDER BY
    skills_count desc
LIMIT 10
```

Here's the breakdown for the most demanded skills for data analyst in 2024:
- **SQL**, **Python**, and **Excel** are still leading the top three most demanded skill for data analyst.
- While that's the case, both **SQL** and **Excel** are still being emphasized for a strong fundamental in data processing and spreadsheet manipulation.
- Meanwhile, **Python**, **Tableau**, and **Power BI** are essential towards data storytelling and decision support.

### 4. Skills Based on Salary
Exploring further into association between skills and average yearly salary revealed which skills are the highest paying.

```sql
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
```
Here's the breakdown of what I found:
- **Full-Stack & Engineering Skills Command Top Dollar**: The highest salaries are for skills like **Bitbucket**, **FastAPI**, **Angular**, and **CSS**. This indicates that Data Analysts who can build data products, APIs, and interactive web applications, also blending analysis with software engineering are in a uniquely high-value niche.
- **Specialized Machine Learning is a Premium Career Path**: Deep learning frameworks like **Keras**, **TensorFlow**, and **PyTorch** are consistently high-paying. This shows a clear salary premium for analysts who move beyond general analytics into specialized AI and machine learning model development.
- **Big Data Engineering Trumps General Analytics**: Skills like **PySpark**, **Kafka**, and **Scala** (associated with data engineering and large-scale processing) offer higher average salaries than foundational analysis libraries like Pandas and NumPy. This highlights the market's high valuation for analysts who can handle data infrastructure and real-time processing.

### 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query attempted to pinpoint skills that are in high demand and have high salaries, offerring strategic focus for skill development.

```sql
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
```
Here's the breakdown:
- **Master the Core Data Science Stack**: High demand for **Pandas** and **Numpy** proves that core **Python** data manipulation and analysis skills are non-negotiable, foundational requirements for the majority of well-paying roles.
- **Specialize in Modern Data Platforms**: Tools like **Databricks**, **Airflow**, and **PySpark** command strong salaries because they are essential for building and managing scalable data pipelines in the cloud, representing the modern data infrastructure stack.
- **Niche Expertise Commands a Premium**: Specialized skills in areas like deep learning (**Keras**), version control systems (**Bitbucket**), or web frameworks (**Angular**) offer the highest pay, but with fewer job openings, making them ideal for targeted career paths.

# What I Learned
Throughout this project, I've learned a lot about manipulating datasets with SQL, especially with these skills
- **Query Crafting**: I've conquered the art of advanced SQL, such as merging tables together and using WITH clause to manuevers with temp table.
- **Data Aggregation**: Successfully using data aggregation such as COUNT and AVG, alongside GROUP BY and HAVING to uncovered insights from the data.
- **Analytical Function**: Turned complex dataset with different kinds of columns into an actionable and insighful SQL Queries.

# Conclusions
### Insights
1. **SQL is Non-Negotiable Foundation**: SQL appears in every top-paying data analyst role, making it the universal prerequisite skill that forms the bedrock of data analysis across all industries and seniority levels.
2. **Python Ecosystem Dominates High-Value Roles**: Python and its libraries (Pandas, NumPy) consistently rank in both high-demand and high-salary categories, indicating that Python proficiency transitions analysts from basic reporting to advanced analytics and machine learning capabilities.
3. **Visualization Skills Are Career Accelerators**: Tableau and Power BI emerge as critical differentiators, showing that the ability to translate complex data into actionable business insights through visualization commands premium compensation.
4. **Cloud & Big Data Tools Offer Salary Premiums**: Skills in Databricks, Airflow, and PySpark correlate with significantly higher salaries, reflecting the market's premium for analysts who can work with scalable, cloud-based data infrastructure and processing frameworks.
5. **Remote Work Expands Opportunities & Competition**: The prevalence of remote/anywhere roles in your analysis indicates that geographic barriers are diminishing, creating more opportunities but also increasing global competition for top data talent.

### Closing Thoughts
This project enhanced my SQL skills and provided me valuable insights into the data job market. Findings from the analysis serve as a guide for me to learn skills that are necessary and in-high demand to chase my dreams of becoming a data analyst. This exploration highlights the importance of continuously learning and adapting to emerging trends in the field of data analyst.