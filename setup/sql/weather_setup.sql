DROP TABLE nflverse.kg.plays_weather;
CREATE TABLE nflverse.kg.plays_weather
AS
(SELECT DISTINCT 
game_id, 
weather ,
REPLACE(REGEXP_MATCH('^(.*?) Temp:', weather) ,' Temp:','') as condition,
--REPLACE(REGEXP_MATCH('^[A-Z][0-9] Temp:', weather) ,' Temp:','') as condition_class,
REGEXP_MATCH('\\d{2,3}', weather) as temperature_f,
CAST(REPLACE(REGEXP_MATCH('\\d{2,3}\%', weather),'%','') AS float)/100 as humidity,
REPLACE(REGEXP_MATCH('Wind: (\\w+)', weather), 'Wind: ', '') as wind_direction,
REPLACE(REGEXP_MATCH('(\\d+) mph', weather), ' mph', '') as wind_speed

FROM nflverse.kg.plays) WITH DATA;

-- ALTER TABLE nflverse.kg.plays_weather
--     DROP COLUMN condition;

SELECT * FROM nflverse.kg.plays_weather;