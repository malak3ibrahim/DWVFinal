-- STEP 1: Create GDP table with GDP_per_capita and precomputed log
CREATE TABLE IF NOT EXISTS gdp_combined AS
SELECT 
    Country, 
    Year, 
    GDP_per_capita, 
    GDP_per_capita_log  -- This must have been calculated in Python and loaded
FROM global_edu_insights;

-- STEP 2: Create region-level average GDP (winsorized here just means mean)
CREATE TABLE IF NOT EXISTS region_avg AS
SELECT 
    Region, 
    ROUND(AVG(GDP_per_capita), 2) AS GDP_per_capita_winsorized
FROM global_edu_insights
GROUP BY Region;

-- STEP 3: Melt enrollment data into long format (Primary, Secondary, Tertiary)
CREATE TABLE IF NOT EXISTS enrollment_melted AS
SELECT Country, Year, 'Primary' AS Education_Level, Primary_Enrollment AS Enrollment_Rate
FROM global_edu_insights
UNION ALL
SELECT Country, Year, 'Secondary', Secondary_Enrollment FROM global_edu_insights
UNION ALL
SELECT Country, Year, 'Tertiary', Tertiary_Enrollment FROM global_edu_insights;

-- STEP 4: Join GDP with Region Average GDP using country-region mapping
CREATE TABLE IF NOT EXISTS gdp_with_region AS
SELECT 
    g.Country, 
    g.Year, 
    g.GDP_per_capita, 
    g.GDP_per_capita_log, 
    gei.Region, 
    r.GDP_per_capita_winsorized AS Region_Avg_GDP
FROM gdp_combined g
LEFT JOIN global_edu_insights gei 
    ON g.Country = gei.Country AND g.Year = gei.Year
LEFT JOIN region_avg r 
    ON gei.Region = r.Region;

-- QUERY 1: Get average enrollment rate per education level per year
SELECT 
    Year, 
    Education_Level, 
    ROUND(AVG(Enrollment_Rate), 2) AS Avg_Enrollment
FROM enrollment_melted
GROUP BY Year, Education_Level;

-- QUERY 2: Get top 10 countries by GDP per capita
SELECT 
    Country, 
    Year, 
    GDP_per_capita
FROM gdp_combined
ORDER BY GDP_per_capita DESC
LIMIT 10;
