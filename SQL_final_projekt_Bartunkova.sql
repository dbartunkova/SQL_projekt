-- �prava hodnot v tabulk�ch lookup_table a covid19_basic_differences
-- z "Czechia" na "Czech Republic"
UPDATE lookup_table SET country = 'Czech Republic' WHERE country = 'Czechia';

UPDATE covid19_basic_differences SET country = 'Czech Republic' WHERE country = 'Czechia';

-- �prava hodnot v tabulce countries z "Praha" na "Prague"
UPDATE countries SET capital_city = 'Prague' WHERE capital_city = 'Praha';

-- bin�rn� prom�nn� pro v�kend/pracovn� den = 'weekend'
CREATE VIEW v_weekend AS
SELECT 
	c.country , 
	c.date , 
    CASE WHEN WEEKDAY(c.date) in (5, 6) THEN 1 ELSE 0 END AS weekend
FROM covid19_basic_differences c
;

-- ro�n� obdob� dan�ho dne = 'season'
CREATE VIEW v_season AS
SELECT 
	c.country , 
	c.date, 
 (CASE WHEN month(c.date) IN (12, 1, 2) THEN '0'
      WHEN month(c.date) IN (3, 4, 5) THEN '1'
      WHEN month(c.date) IN (6, 7, 8) THEN '2'
      WHEN month(c.date) IN (9, 10, 11) THEN '3'
 END) AS season
FROM covid19_basic_differences c
;

-- toto je view, kde je country, date, weekend, season
CREATE VIEW v_season_weekend AS
SELECT 
	v_weekend.country , 
	v_weekend.date , 
	v_weekend.weekend , 
	v_season.season
FROM v_weekend
JOIN v_season 
	ON v_weekend.country = v_season.country 
AND v_weekend.date = v_season.date
;

-- vytvo�en� view s GDP na osobu za rok 2019 = 'GDP_obyvatele_2019'
CREATE VIEW v_hdp AS
SELECT 
        *, 
        GDP/population AS GDP_obyvatele_2019
FROM economies
WHERE country IN
        (SELECT DISTINCT 
                country 
         FROM countries
        )
AND year = '2019'
;

-- spojen� v_hdp s celkov�m view
CREATE VIEW v_season_weekend_hdp AS
SELECT 
	v_season_weekend.country , 
	v_season_weekend.date , 
	v_season_weekend.weekend , 
	v_season_weekend.season , 
	v_hdp.mortaliy_under5 , 
	v_hdp.GDP_obyvatele_2019
FROM v_season_weekend
JOIN v_hdp 
	ON v_season_weekend.country = v_hdp.country 
;

-- procentn� pod�l dan�ch n�bo�enstv� v dan�m st�t� = 'religion_percentage_2020'
CREATE VIEW v_religion AS
SELECT 
	r.country , 
	r.religion , 
    ROUND( r.population / r2.total_population_2020 * 100, 2 ) AS religion_percentage_2020
FROM religions r 
JOIN (
        SELECT r.country , 
        r.year,  
        SUM(r.population) AS total_population_2020
        FROM religions r 
        WHERE r.year = 2020 AND r.country != 'All Countries'
        GROUP BY r.country
    ) r2
    ON r.country = r2.country
    AND r.year = r2.year
    AND r.population > 0
 ;

-- spojen� v_religion s v_season_weekend_hdp
CREATE VIEW v_season_weekend_hdp_religion AS
SELECT 
	v_season_weekend_hdp.country , 
	v_season_weekend_hdp.date , 
	v_season_weekend_hdp.weekend , 
	v_season_weekend_hdp.season , 
	v_season_weekend_hdp.mortaliy_under5 , 
	v_season_weekend_hdp.GDP_obyvatele_2019 , 
	v_religion.religion , 
	v_religion.religion_percentage_2020
FROM v_season_weekend_hdp
JOIN v_religion
	ON v_season_weekend_hdp.country = v_religion.country 
;

-- doba do�it� v roce 1965 a 2015 a rozd�l mezi t�mto dv�ma rok�m = 'life_exp_difference'
CREATE VIEW v_doba_doziti AS
SELECT 
	a.country , 
	a.life_exp_1965 , 
	b.life_exp_2015,
    ROUND( b.life_exp_2015 - a.life_exp_1965, 2 ) AS life_exp_difference
FROM (
    SELECT le.country , le.life_expectancy AS life_exp_1965
    FROM life_expectancy le 
    WHERE year = 1965
    ) a JOIN (
    SELECT le.country , le.life_expectancy AS life_exp_2015
    FROM life_expectancy le 
    WHERE year = 2015
    ) b
    ON a.country = b.country
;

-- spojen� v_doba_doziti s celkov�m view
CREATE VIEW v_season_weekend_hdp_religion_doziti AS
SELECT 
	v_season_weekend_hdp_religion.country , 
	v_season_weekend_hdp_religion.date , 
	v_season_weekend_hdp_religion.weekend , 
	v_season_weekend_hdp_religion.season ,
	v_season_weekend_hdp_religion.mortaliy_under5 , 
	v_season_weekend_hdp_religion.GDP_obyvatele_2019 , 
	v_season_weekend_hdp_religion.religion , 
	v_season_weekend_hdp_religion.religion_percentage_2020 ,
	v_doba_doziti.life_exp_difference
FROM v_season_weekend_hdp_religion
JOIN v_doba_doziti 
	ON v_season_weekend_hdp_religion.country = v_doba_doziti.country 
;

-- vytvo�en� sloupce 'percentage confirmed' - procento z proveden�ch test�, kter� byly pozitivn�
CREATE VIEW v_covid AS
SELECT
        base.date ,
        base.country ,
        base.confirmed ,
        a.tests_performed ,
        ROUND((base.confirmed * 100) / a.tests_performed, 2) AS percentage_confirmed
FROM (
          SELECT 
                  date ,
                country ,
                confirmed
          FROM covid19_basic_differences cbd 
         ) base
LEFT JOIN 
         (
          SELECT
          			date ,
                  country ,
                  tests_performed
          FROM covid19_tests ct 
         ) a
	ON base.country = a.country
	AND base.date = a.date
;

-- p�id�n� n�zvu hlavn�ho m�sta, 'population_density' a 'median_age_2018'
CREATE VIEW v_wsmgrrlcpm AS
SELECT 
	base.country, 
	base.date , 
	base.weekend , 
	base.season , 
	base.mortaliy_under5 ,
	base.GDP_obyvatele_2019 , 
	base.religion , 
	base.religion_percentage_2020,
	base.life_exp_difference , 
	a.capital_city , 
	a.population_density , 
	a.median_age_2018 
FROM v_season_weekend_hdp_religion_doziti AS base
JOIN countries AS a 
	ON base.country = a.country
;

-- spojen� v_covid s hlavn�m view
CREATE VIEW v_wsmgrrlcpmp AS
SELECT 
	base.country, 
	base.date , 
	base.weekend , 
	base.season , 
	base.mortaliy_under5 ,
	base.GDP_obyvatele_2019 , 
	base.religion , 
	base.religion_percentage_2020 ,
	base.life_exp_difference , 
	base.capital_city , 
	base.population_density , 
	base.median_age_2018 , 
	a.percentage_confirmed
FROM v_wsmgrrlcpm AS base
JOIN v_covid AS a 
	ON base.country = a.country 
	AND base.date = a.date
;

-- vytvo�en� sloupce 'confirmed_per_milion' - po�et denn� potvrzen�ch p��pad� na milion obyvatel
CREATE VIEW v_daily_confirmed_per_milion AS
SELECT
        base.date ,
        base.country ,
        base.confirmed ,
        ROUND((base.confirmed*1000000)/a.population, 2) AS confirmed_per_milion
FROM (
          SELECT 
                  date ,
                country ,
                confirmed 
          FROM covid19_basic_differences cb
         ) base
LEFT JOIN 
         (
          SELECT
                  country,
                  population
          FROM lookup_table lt 
          WHERE province IS NULL
         ) a
	ON base.country = a.country
;

-- spojen� v_daily_confirmed_per_milion s hlavn�m view
CREATE VIEW v_wsmgrrlcpmpc AS
SELECT 
	base.country , 
	base.date, base.weekend , 
	base.season , 
	base.mortaliy_under5 ,
	base.GDP_obyvatele_2019 , 
	base.religion , 
	base.religion_percentage_2020 ,
	base.life_exp_difference , 
	base.capital_city , 
	base.population_density , 
	base.median_age_2018 , 
	base.percentage_confirmed , 
	a.confirmed_per_milion
FROM v_wsmgrrlcpmp AS base 
JOIN v_daily_confirmed_per_milion AS a
	ON base.country = a.country
	AND base.date = a.date
;

-- vytvo�en� sloupce 'gini_koeficient'
CREATE VIEW v_gini AS
SELECT 
	country , 
	ROUND(gini / 100, 2) AS gini_koeficient , 
	year
FROM economies e 
WHERE gini IS NOT NULL
GROUP BY country
;

-- pspojen� v_gini s celkov�m view
CREATE VIEW v_wsmgrrlcpmpcg AS
SELECT 
	base.country , 
	base.date , 
	base.weekend , 
	base.season ,
	base.mortaliy_under5 ,
	base.GDP_obyvatele_2019 , 
	base.religion , 
	base.religion_percentage_2020 ,
	base.life_exp_difference , 
	base.capital_city , 
	base.population_density , 
	base.median_age_2018 , 
	base.percentage_confirmed , 
	base.confirmed_per_milion , 
	a.gini_koeficient
FROM v_wsmgrrlcpmpc AS base 
JOIN v_gini AS a
	ON base.country = a.country
;

-- po�et hodin v dan�m dni, kdy byly sr�ky nenulov� = 'rainy_hours'
CREATE VIEW v_rain AS
SELECT 
	time , 
	date , 
	city ,
	rain ,
	SUM(rain != '0.0 mm' ) * 3 AS rainy_hours
FROM weather
WHERE city IS NOT NULL
GROUP BY date , city
;

-- spojen� v_rain s celkov�m view
CREATE VIEW v_wsmgrrlcpmpcgr AS
SELECT 
	base.country , 
	base.date , 
	base.weekend , 
	base.season , 
	base.mortaliy_under5 ,
	base.GDP_obyvatele_2019 , 
	base.religion , 
	base.religion_percentage_2020 ,
	base.life_exp_difference , 
	base.capital_city , 
	base.population_density , 
	base.median_age_2018 , 
	base.percentage_confirmed , 
	base.confirmed_per_milion , 
	base.gini_koeficient , 
	a.rainy_hours
FROM v_wsmgrrlcpmpcg AS base 
LEFT JOIN v_rain AS a
	ON base.capital_city = a.city
	AND base.date = a.date
;

select * from v_wsmgrrlcpmpcg
where country = 'Zambia'
limit 4

-- maxim�ln� s�la v�tru v n�razech b�hem dne = 'max_daily_gust'
CREATE VIEW v_wind AS
SELECT 
	time , 
	gust , 
	date , 
	city , 
	MAX(gust) AS max_daily_gust
FROM weather
WHERE city IS NOT NULL
AND time != '00:00'
GROUP BY date, city
;

-- spojen� v_wind s celkov�m view
CREATE VIEW v_wsmgrrlcpmpcgrw AS
SELECT 
	base.country ,
	base.date ,
	base.weekend , 
	base.season , 
	base.mortaliy_under5 ,
	base.GDP_obyvatele_2019 ,
	base.religion , 
	base.religion_percentage_2020 ,
	base.life_exp_difference , 
	base.capital_city , 
	base.population_density ,
	base.median_age_2018 , 
	base.percentage_confirmed ,
	base.confirmed_per_milion , 
	base.gini_koeficient ,
	base.rainy_hours ,
	a.max_daily_gust
FROM v_wsmgrrlcpmpcgr AS base 
LEFT JOIN v_wind AS a
	ON base.capital_city = a.city
	AND base.date = a.date
;

-- vytvo�en� view v_temp, kde si na ��seln� typ p�em�n�m sloupec s teplotou temp
CREATE VIEW v_temp AS
SELECT
	time,
	date,
	city,
	CAST(REPLACE(temp,' �c', '') AS DOUBLE) AS teplota
FROM weather
;

-- vytvo�en� sloupce teplota s pr�m�rnou teplotou dan�ho dne
CREATE VIEW v_teplota_prumer AS
SELECT 
	time,
	date, 
	city,
	avg(teplota) AS average_temperature
	from v_temp
where city is not null
and time != '03:00'
and time != '09:00'
and time != '15:00'
and time != '21:00'
group by date, city
;

-- spojen� v_teplota_prumer s celkov�m view
CREATE VIEW v_wsmgrrlcpmpcgrwt AS
SELECT 
	base.country ,
	base.date ,
	base.weekend , 
	base.season , 
	base.mortaliy_under5 ,
	base.GDP_obyvatele_2019 ,
	base.religion , 
	base.religion_percentage_2020 ,
	base.life_exp_difference , 
	base.capital_city , 
	base.population_density ,
	base.median_age_2018 , 
	base.percentage_confirmed ,
	base.confirmed_per_milion , 
	base.gini_koeficient ,
	base.rainy_hours ,
	base.max_daily_gust,
	a.average_temperature
FROM v_wsmgrrlcpmpcgrw AS base 
LEFT JOIN v_teplota_prumer AS a
	ON base.capital_city = a.city
	AND base.date = a.date
;

-- vytvo�en� fin�ln� tabulky
CREATE TABLE t_dana_bartunkova_projekt_SQL_final AS
SELECT 
	country ,
	date ,
	weekend , 
	season , 
	mortaliy_under5 ,
	GDP_obyvatele_2019 ,
	religion , 
	religion_percentage_2020 ,
	life_exp_difference , 
	capital_city , 
	population_density ,
	median_age_2018 , 
	percentage_confirmed ,
	confirmed_per_milion , 
	gini_koeficient ,
	rainy_hours ,
	max_daily_gust, 
	average_temperature
FROM v_wsmgrrlcpmpcgrwt
;


describe t_dana_bartunkova_projekt_SQL_final
