-- Create a derived table by joining GDP with region average GDP
CREATE TABLE gdp_with_region AS
SELECT g.Country, g.Year, g.GDP_per_capita, g.GDP_per_capita_log, r.Region, r.GDP_per_capita_winsorized AS Region_Avg_GDP
FROM gdp_combined g
LEFT JOIN region_avg r ON g.Country = r.Region;

-- Query 1: Get average enrollment rate per level and year
SELECT Year, Education_Level, ROUND(AVG(Enrollment_Rate), 2) AS Avg_Enrollment
FROM enrollment_melted
GROUP BY Year, Education_Level;

-- Query 2: Get top 10 countries by raw GDP per capita
SELECT Country, Year, GDP_per_capita
FROM gdp_combined
ORDER BY GDP_per_capita DESC
LIMIT 10;
