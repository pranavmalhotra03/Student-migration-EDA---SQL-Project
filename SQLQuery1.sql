USE PROJECTS

SELECT * FROM global_student_migration



-- Check null values in all columns
SELECT 
  SUM(CASE WHEN student_id IS NULL THEN 1 ELSE 0 END) AS null_student_id,
  SUM(CASE WHEN origin_country IS NULL THEN 1 ELSE 0 END) AS null_origin_country,
  SUM(CASE WHEN destination_country IS NULL THEN 1 ELSE 0 END) AS null_destination_country,
  SUM(CASE WHEN destination_city IS NULL THEN 1 ELSE 0 END) AS null_destination_city,
  SUM(CASE WHEN university_name IS NULL THEN 1 ELSE 0 END) AS null_university_name,
  SUM(CASE WHEN course_name IS NULL THEN 1 ELSE 0 END) AS null_course_name,
  SUM(CASE WHEN field_of_study IS NULL THEN 1 ELSE 0 END) AS null_field_of_study,
  SUM(CASE WHEN year_of_enrollment IS NULL THEN 1 ELSE 0 END) AS null_year_of_enrollment,
  SUM(CASE WHEN scholarship_received IS NULL THEN 1 ELSE 0 END) AS null_scholarship_received,
  SUM(CASE WHEN enrollment_reason IS NULL THEN 1 ELSE 0 END) AS null_enrollment_reason,
  SUM(CASE WHEN graduation_year IS NULL THEN 1 ELSE 0 END) AS null_graduation_year,
  SUM(CASE WHEN placement_status IS NULL THEN 1 ELSE 0 END) AS null_placement_status,
  SUM(CASE WHEN placement_country IS NULL THEN 1 ELSE 0 END) AS null_placement_country,
  SUM(CASE WHEN placement_company IS NULL THEN 1 ELSE 0 END) AS null_placement_company,
  SUM(CASE WHEN starting_salary_usd IS NULL THEN 1 ELSE 0 END) AS null_starting_salary_usd,
  SUM(CASE WHEN gpa_or_score IS NULL THEN 1 ELSE 0 END) AS null_gpa_or_score,
  SUM(CASE WHEN visa_status IS NULL THEN 1 ELSE 0 END) AS null_visa_status,
  SUM(CASE WHEN post_graduation_visa IS NULL THEN 1 ELSE 0 END) AS null_post_graduation_visa,
  SUM(CASE WHEN language_proficiency_test IS NULL THEN 1 ELSE 0 END) AS null_language_proficiency_test,
  SUM(CASE WHEN test_score IS NULL THEN 1 ELSE 0 END) AS null_test_score
FROM global_student_migration;



-- Checking how many unique origin countries, destination countries, and universities are in the dataset
SELECT 
  COUNT(DISTINCT origin_country) AS unique_origin_countries,
  COUNT(DISTINCT destination_country) AS unique_destination_countries,
  COUNT(DISTINCT university_name) AS unique_universities
FROM global_student_migration;



-- Top destination countries by student count
SELECT destination_country, COUNT(*) AS total_students
FROM global_student_migration
GROUP BY destination_country
ORDER BY total_students DESC;


-- Top universities by number of students
SELECT TOP 10 university_name, COUNT(*) AS student_count
FROM global_student_migration
GROUP BY university_name
ORDER BY student_count DESC;



-- Most common fields of study
SELECT top 10 field_of_study, COUNT(*) AS count
FROM global_student_migration
GROUP BY field_of_study
ORDER BY count DESC;


-- Comparing average GPA for students with and without scholarships
SELECT scholarship_received, AVG(gpa_or_score) AS avg_gpa
FROM global_student_migration
GROUP BY scholarship_received;


-- Average salary by placement country
SELECT placement_country, AVG(starting_salary_usd) AS avg_salary
FROM global_student_migration
WHERE placement_country IS NOT NULL
GROUP BY placement_country
ORDER BY avg_salary DESC;



-- Placement rate by field of study
SELECT field_of_study,
       COUNT(*) AS total_students,
       SUM(CASE WHEN placement_status = 'Placed' THEN 1 ELSE 0 END) AS placed_students,
       ROUND(100.0 * SUM(CASE WHEN placement_status = 'Placed' THEN 1 ELSE 0 END) / COUNT(*), 2) AS placement_rate
FROM global_student_migration
GROUP BY field_of_study
ORDER BY placement_rate DESC;



-- Total enrollments per year
SELECT year_of_enrollment, COUNT(*) AS enrollments
FROM global_student_migration
GROUP BY year_of_enrollment
ORDER BY year_of_enrollment;

-- Graduation vs placement trends
SELECT graduation_year,
       COUNT(*) AS graduates,
       SUM(CASE WHEN placement_status = 'Placed' THEN 1 ELSE 0 END) AS placed
FROM global_student_migration
GROUP BY graduation_year
ORDER BY graduation_year;


-- Top companies that hired the most students
SELECT top 10 placement_company, COUNT(*) AS hires
FROM global_student_migration
WHERE placement_company IS NOT NULL
GROUP BY placement_company
ORDER BY hires DESC;

-- Average starting salary by university
SELECT top 10 university_name, AVG(starting_salary_usd) AS avg_salary
FROM global_student_migration
GROUP BY university_name
ORDER BY avg_salary DESC;



-- Count of visa types used in each destination country
SELECT destination_country, visa_status, COUNT(*) AS count
FROM global_student_migration
GROUP BY destination_country, visa_status
ORDER BY destination_country, count DESC;

-- Average test score per language proficiency test
SELECT language_proficiency_test, AVG(test_score) AS avg_score
FROM global_student_migration
GROUP BY language_proficiency_test
ORDER BY avg_score DESC;



-- Checking for invalid GPA scores (outside 0–10 range)
SELECT *
FROM global_student_migration
WHERE gpa_or_score < 0 OR gpa_or_score > 10;

-- Checking for outliers in salary (very high or very low)
SELECT *
FROM global_student_migration
WHERE starting_salary_usd > 200000 OR starting_salary_usd < 1000;

