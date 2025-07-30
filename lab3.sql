-- 1.
SELECT model_year, make, model, COUNT(*) AS num_cars, AVG(avg_range) AS avg_electric_range
FROM (
	SELECT model_year, make, model, vin, AVG(electric_range) AS avg_range
	FROM ev_wa
	GROUP BY model_year, make, model, vin
) AS vin_avg
GROUP BY model_year, make, model
ORDER BY avg_electric_range DESC
LIMIT 10;

-- "model_year"	"make"	"model"	"num_cars"	"avg_electric_range"
-- 2020	"TESLA"	"MODEL S"	22	333.5000000000000000
-- 2020	"TESLA"	"MODEL 3"	33	298.6666666666666667
-- 2020	"TESLA"	"MODEL X"	60	291.2000000000000000
-- 2020	"TESLA"	"MODEL Y"	22	291.0000000000000000
-- 2019	"TESLA"	"MODEL X"	62	289.0000000000000000
-- 2019	"TESLA"	"MODEL S"	22	270.0000000000000000
-- 2012	"TESLA"	"MODEL S"	41	265.0000000000000000
-- 2020	"CHEVROLET"	"BOLT EV"	39	259.0000000000000000
-- 2019	"HYUNDAI"	"KONA"	22	258.0000000000000000
-- 2020	"HYUNDAI"	"KONA"	33	258.0000000000000000


-- 2.
SELECT make, model, year1, year2, range1, range2, diff
FROM (
	SELECT y1.make AS make, y1.model AS model, y1.model_year AS year1, y2.model_year AS year2,
		y1.avg_range AS range1, y2.avg_range AS range2, (y2.avg_range - y1.avg_range) AS diff
	FROM (
	SELECT model_year, make, model, AVG(electric_range) AS avg_range
	FROM ev_wa
	GROUP BY model_year, make, model
	) AS y1
	JOIN (
		SELECT model_year, make, model, AVG(electric_range) AS avg_range
		FROM ev_wa
		GROUP BY model_year, make, model
	) AS y2 ON y1.model_year + 1 = y2.model_year AND y1.make = y2.make AND y1.model = y2.model
) AS improvement
ORDER BY diff DESC
LIMIT 10;

-- "make"	"model"	"year1"	"year2"	"range1"	"range2"	"diff"
-- "KIA"	"NIRO"	2018	2019	26.0000000000000000	163.8235294117647059	137.8235294117647059
-- "TESLA"	"MODEL 3"	2019	2020	220.0000000000000000	297.3070866141732283	77.3070866141732283
-- "TESLA"	"MODEL S"	2019	2020	270.0000000000000000	331.2342105263157895	61.2342105263157895
-- "TESLA"	"MODEL X"	2018	2019	238.0000000000000000	289.0000000000000000	51.0000000000000000
-- "NISSAN"	"LEAF"	2017	2018	107.0000000000000000	151.0000000000000000	44.0000000000000000
-- "VOLKSWAGEN"	"E-GOLF"	2016	2017	83.0000000000000000	125.0000000000000000	42.0000000000000000
-- "TESLA"	"MODEL S"	2017	2018	210.0000000000000000	249.0000000000000000	39.0000000000000000
-- "TESLA"	"MODEL X"	2017	2018	200.0000000000000000	238.0000000000000000	38.0000000000000000
-- "HYUNDAI"	"IONIQ"	2019	2020	44.1449275362318841	78.7647058823529412	34.6197783461210571
-- "KIA"	"NIRO"	2019	2020	163.8235294117647059	196.6443594646271511	32.8208300528624452

-- 3.
SELECT e.census_tract, COUNT(DISTINCT e.vin) AS num_cars, i.median_hh_income_2020
FROM ev_wa e
JOIN income i ON SUBSTRING(i.census_geo_id, 8) = e.census_tract
WHERE i.median_hh_income_2020 IS NOT NULL
GROUP BY e.census_tract, i.median_hh_income_2020
ORDER BY i.median_hh_income_2020 DESC
LIMIT 10;

-- "census_tract"	"num_cars"	"median_hh_income_2020"
-- "51107611029"	2			250001
-- "53033004101"	222			250001
-- "53033024100"	323			250001
-- "53033024602"	252			250001
-- "53033024601"	302			245278
-- "53033032217"	203			245099
-- "51059415600"	1			244028
-- "53033023902"	186			240833
-- "06013351200"	1			236923
-- "53033032215"	234			235821

-- 4a.
-- top 10
SELECT e.census_tract, COUNT(DISTINCT e.vin) AS num_cars, i.median_hh_income_2020, e.city
FROM ev_wa e
JOIN income i ON SUBSTRING(i.census_geo_id, 8) = e.census_tract
WHERE i.median_hh_income_2020 IS NOT NULL
GROUP BY e.census_tract, i.median_hh_income_2020, e.city
ORDER BY i.median_hh_income_2020 DESC
LIMIT 10;

-- "census_tract"	"num_cars"	"median_hh_income_2020"	"city"
-- "51107611029"	2			250001					"Aldie"
-- "53033004101"	222			250001					"Seattle"
-- "53033024100"	208			250001					"Clyde Hill"
-- "53033024100"	44			250001					"Hunts Point"
-- "53033024100"	1			250001					"Kirkland"
-- "53033024100"	101			250001					"Yarrow Point"
-- "53033024602"	252			250001					"Mercer Island"
-- "53033024601"	302			245278					"Mercer Island"
-- "53033032217"	203			245099					"Sammamish"
-- "51059415600"	1			244028					"Alexandria"

-- bottom 10
SELECT e.census_tract, COUNT(DISTINCT e.vin) AS num_cars, i.median_hh_income_2020, e.city
FROM ev_wa e
JOIN income i ON SUBSTRING(i.census_geo_id, 8) = e.census_tract
WHERE i.median_hh_income_2020 IS NOT NULL
GROUP BY e.census_tract, i.median_hh_income_2020, e.city
ORDER BY i.median_hh_income_2020 ASC
LIMIT 10;

-- "census_tract"	"num_cars"	"median_hh_income_2020"	"city"
-- "53075000100"	1			12473					"Pullman"
-- "53063003500"	19			14280					"Spokane"
-- "53075000601"	7			17294					"Pullman"
-- "53075000602"	6			21024					"Pullman"
-- "53075000500"	5			21696					"Pullman"
-- "53033005305"	23			21781					"Seattle"
-- "53077002005"	7			21783					"Sunnyside"
-- "29510127000"	1			21875					"Saint Louis"
-- "53037975404"	12			22080					"Ellensburg"
-- "53077000100"	7			23590					"Yakima"

-- 4b.
-- Yes, there is a difference in the number of electric vehicles in the two sets of
-- tracts. The top 10 have a total of 1336 cars and the bottom 10 have a total of 88.
-- The difference between the two is 1248. The differnce between the cities is also prevalent. 
-- Such as Seattle has 222 in the top 10 and 23 in the bottom 10. The results don't fully 
-- match my expectations as you would assume that higher-income areas have greater prevalence
-- of electric cars, however, it varies maybe based on factors such as infrastrucutre or culture.

-- Bonus.
SELECT e.city
FROM ev_wa e
JOIN income i ON SUBSTRING(i.census_geo_id, 8) = e.census_tract
GROUP BY e.city
HAVING MAX(i.median_hh_income_2020) < 40000;

-- "city"
-- "Cheyenne"
-- "Curlew"
-- "Danville"
-- "Goldsboro"
-- "Inchelium"
-- "Indian Wells"
-- "Laughlin"
-- "Lincoln City"
-- "Saint Louis"
-- "Taholah"
-- "Tempe"
-- "Ventura"
-- "West Palm Beach"