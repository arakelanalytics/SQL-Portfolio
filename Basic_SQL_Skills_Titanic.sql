
/* PROJECT 1
 Exporatorty data analysis demonstrating basic SQL skills and querys using a dataset regarding 
 the Titanic and its passengers */

-- PASSENGER CLASS VS SURVIVAL 

/* The survived column is boolean. Checking to see if there are any values other than 0 or 1 in the column before
starting analysis */
SELECT distinct survived
FROM titanic

-- count the number of passengers who survived the Titanic crash 
Select count(survived)
From titanic
where survived = 1

-- count the number of passengers who did not survived the Titanic crash 
Select count(survived)
From titanic
where survived = 0

/* Instead of running the two seperate queries above, use the group by statement to count
the number of passengers who survived and did not survive */
Select survived, count(*) as num_survived
From titanic
group by survived

-- use the group by statement to count the number of passengers in each passenger class
the number of passengers
Select pclass, count(*) as num_of_pass
From titanic
group by pclass

/*  use the group by statement to count the number of passengers who survived and died in each passenger class.
then use the order by statement and desc to order the results by the passender class first, and survived status 
second in descending order */
Select pclass, survived,  count(*) as num_of_pass
From titanic
group by pclass, survived
order by pclass desc, survived desc

/* a cleaner way to show the number of passengers who survived and died for each class. Using an if statement and the
sum function to total the number of those who survived and died into new columns.
SELECT */
    pclass,
    SUM( IF ( survived = 1, 1, 0 ) ) as num_survived,
    SUM( IF ( survived = 0, 1, 0 ) ) as num_died
  FROM titanic
  GROUP BY pclass;

-- same query as above but adding a new column to show the total number of passengers in each class as well
SELECT
    pclass,
    SUM( IF ( survived = 1, 1, 0 ) ) as num_survived,
    SUM( IF ( survived = 0, 1, 0 ) ) as num_died,
    count(*) as total_num_of_passengers
  FROM titanic
  GROUP BY pclass;

  /* same query as above but adding a new column to show the survival rate of passengers in each class as a 
  percentage in the "00.00%" format. Used the concat function to combine the numeric result of the calculation 
  with the "%" sign. used the round function to round the percentage to 2 decimal places. added an order by
  statement to order the results by highest survival rate to lowest */
SELECT
    pclass,
    SUM( IF ( survived = 1, 1, 0 ) ) as num_survived,
    SUM( IF ( survived = 0, 1, 0 ) ) as num_died,
    count(*) as total_num_of_passengers,
    concat(round(((SUM( IF ( survived = 1, 1, 0 ) ) / count(*)) * 100), 2), "%")  as survival_rate
  FROM titanic
  GROUP BY pclass
  ORDER BY survival_rate desc
  
-- PASSENGER CLASS VS AGE
  
-- shows the average age of passengers for each passenger class and sorts the results from oldest to youngest
SELECT pclass, round(avg(age), 0) as avg_age
FROM titanic
Group by pclass
order by pclass desc

/* used Case expression to create and group passengers by their age. if age is null or not a value represented 
in a bucket they are placed in the unknown bucket.*/
SELECT
Case
when age between 0 and 10 then "0-10"
when age between 11 and 20 then "10-20"
when age between 21 and 30 then "20-30"
when age between 31 and 40 then "30-40"
when age > 41 then "40 and up"
else "Unknown"
end as age_bucket,
count(*) as num_of_pas
  FROM titanic
  group by age_bucket
  order by age_bucket

/* same query as above but adding a where clause to filter out and group only the class 3 passengers
into the age buckets */
SELECT
Case
when age between 0 and 10 then "0-10"
when age between 11 and 20 then "10-20"
when age between 21 and 30 then "20-30"
when age between 31 and 40 then "30-40"
when age > 41 then "40 and up"
else "Unknown"
end as age_bucket,
count(*) as num_of_pas
  FROM titanic
  where pclass = 3
  group by age_bucket
  order by num_of_pas DESC

-- showing the same query but using a having clause to show only the buckets who have greater than 150 passengers
 SELECT
Case
when age between 0 and 10 then "0-10"
when age between 11 and 20 then "10-20"
when age between 21 and 30 then "20-30"
when age between 31 and 40 then "30-40"
when age > 41 then "40 and up"
else "Unknown"
end as age_bucket,
count(*) as num_of_pas
  FROM titanic
  group by age_bucket
  having num_of_pas > 150
  order by age_bucket
  
  
  -- ADULT VS CHILD 
  
  -- number of adults vs children and the % breakdown of each of male vs female.
SELECT
Case
when age between 0 and 17 then "child"
when age >= 18 then "adult"
else "Unknown"
end as age_bucket,
count(*) as num_of_pas,
concat(round(((SUM( IF ( sex = "male", 1, 0) ) / count(*)) * 100), 2), "%")  as per_of_males,
concat(round(((SUM( IF ( sex = "female", 1, 0) ) / count(*)) * 100), 2), "%")  as per_of_females
  FROM titanic
  group by age_bucket
  order by age_bucket
  
  
-- survival rate of adults vs children

SELECT
Case
when age between 0 and 17 then "child"
when age >= 18 then "adult"
else "Unknown"
end as age_bucket,
count(*) as num_of_pas,
concat(round(((SUM( IF ( survived = 1, 1, 0 ) ) / count(*)) * 100), 2), "%")  as survival_rate
  FROM titanic
  group by age_bucket
  order by age_bucket
  
-- further breakdown of age groups
  SELECT
Case
when age between 0 and 4 then "Children under 5"
when age between 5 and 9 then "Children 6 - 10"
when age between 10 and 18 then "Children 10 - 18"
when age > 18 then "18 and older"
else "Unknown"
end as age_bucket,
count(*) as num_of_pas,
concat(round(((SUM( IF ( survived = 1 , 1, 0 ) ) / count(*)) * 100), 2), "%")  as survival_rate
  FROM titanic
  group by age_bucket
  order by survival_rate desc
  
-- survival rate of male adults vs male children vs female adults vs female children
  SELECT
Case
when age between 0 and 17 then "child"
when age >= 18 then "adult"
else "Unknown"
end as age_bucket,
count(*) as num_of_pas,
concat(round(((SUM( IF ( survived = 1 and sex = "male", 1, 0 ) ) / count(*)) * 100), 2), "%")  as survival_rate_male,
concat(round(((SUM( IF ( survived = 1 and sex = "female", 1, 0 ) ) / count(*)) * 100), 2), "%")  as survival_rate_female
  FROM titanic
  group by age_bucket
  order by age_bucket


