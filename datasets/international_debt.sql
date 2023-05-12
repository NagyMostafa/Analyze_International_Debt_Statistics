-- Table: international_debt

CREATE TABLE international_debt
(
  country_name  varying(50),
  country_code  varying(50),
  indicator_name nvarying(MAX),
  indicator_code varying(50),
  debt Float
);

drop table international_debt

-- Copy over data from CSV
\copy international_debt From 'international_debt.csv' DELIMITER ',' CSV HEADER;

--1
--The first line of code connects us to the international_debt database where the table international_debt is residing. 
--Let's first SELECT all of the columns from the international_debt table. 
--Also, we'll limit the output to the first ten rows to keep the output clean.
select top(10) * 
from international_debt

--2
--From the first ten rows, we can see the amount of debt owed by Afghanistan in the different debt indicators.
--But we do not know the number of different countries we have on the table.
--There are repetitions in the country names because a country is most likely to have debt in more than one debt indicator.
--Without a count of unique countries, we will not be able to perform our statistical analyses holistically.
--In this section, we are going to extract the number of unique countries present in the table.
SELECT COUNT(DISTINCT country_name) AS total_distinct_countries
FROM international_debt;

--3
--We can see there are a total of 124 countries present on the table.
--As we saw in the first section, there is a column called indicator_name that briefly specifies the purpose of taking the debt.
--Just beside that column, there is another column called indicator_code which symbolizes the category of these debts.
--Knowing about these various debt indicators will help us to understand the areas in which a country can possibly be indebted to.
SELECT DISTINCT indicator_code AS distinct_debt_indicators
FROM international_debt
order by distinct_debt_indicators

--4
--As mentioned earlier, the financial debt of a particular country represents its economic state.
--But if we were to project this on an overall global scale, how will we approach it?
--Let's switch gears from the debt indicators now and find out the total amount of debt (in USD) that is owed by the different countries. 
--This will give us a sense of how the overall economy of the entire world is holding up.
SELECT round(sum(debt)/1000000, 2) as total_debt
FROM international_debt; 

--5
--Now that we have the exact total of the amounts of debt owed by several countries,
--let's now find out the country that owns the highest amount of debt along with the amount.
--Note that this debt is the sum of different debts owed by a country across several categories.
--This will help to understand more about the country in terms of its socio-economic scenarios.
--We can also find out the category in which the country owns its highest debt.
--But we will leave that for now.
SELECT top(1)
    country_name, 
    sum(debt) as total_debt
FROM international_debt
GROUP BY country_name
ORDER BY total_debt DESC

--6
--We now have a brief overview of the dataset and a few of its summary statistics.
--We already have an idea of the different debt indicators in which the countries owe their debts.
--We can dig even further to find out on an average how much debt a country owes?
--This will give us a better sense of the distribution of the amount of debt across different indicators.
SELECT top(10)
    indicator_code AS debt_indicator,
    indicator_name,
    avg(debt) as average_debt
FROM international_debt
GROUP BY indicator_code,indicator_name
ORDER BY average_debt desc

--7
--An interesting observation in the above finding is that there is a huge difference in the amounts of the indicators after the second one.
--This indicates that the first two indicators might be the most severe categories in which the countries owe their debts.
--We can investigate this a bit more so as to find out which country owes the highest 
--amount of debt in the category of long term debts (DT.AMT.DLXF.CD).
--Since not all the countries suffer from the same kind of economic disturbances,
--this finding will allow us to understand that particular country's economic condition a bit more specifically.
SELECT 
    country_name, 
    indicator_name
FROM international_debt
WHERE debt = (SELECT 
                 max(debt)
             FROM international_debt
             where indicator_code = 'DT.AMT.DLXF.CD');

--8
--We saw that long-term debt is the topmost category when it comes to the average amount of debt.
--But is it the most common indicator in which the countries owe their debt? Let's find that out.​
SELECT top(20)
    indicator_code, 
    count(*) as indicator_count
FROM international_debt
group by indicator_code
order by indicator_count desc,indicator_code desc

--9
--Let's change tracks from debt_indicators now and focus on the amount of debt again.
--Let's find out the maximum amount of debt that each country has. With this,
--we will be in a position to identify the other plausible economic issues a country might be going through.
--In this notebook, we took a look at debt owed by countries across the globe.
--We extracted a few summary statistics from the data and unraveled some interesting facts and figures.
--We also validated our findings to make sure the investigations are correct.​
SELECT top(10)
    country_name, 
    max(debt) as maximum_debt
FROM international_debt
group by country_name
order by maximum_debt desc

​