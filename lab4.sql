-- 1a.
CREATE TABLE questions(
	id BIGINT, 
	question_id VARCHAR(100), 
	question TEXT, 
	PRIMARY KEY(id, question_id)
);

INSERT INTO questions(id, question_id, question)
SELECT id, question_id, question
FROM alzheimers;

CREATE TABLE results(
	id BIGINT, 
	loc_abbrev VARCHAR(100), 
	source VARCHAR(100), 
	class TEXT, 
	topic TEXT, 
	question_id VARCHAR(100), 
	PRIMARY KEY(id, question_id),
	FOREIGN KEY(id, question_id) REFERENCES questions(id, question_id)
);

INSERT INTO results(id, question_id, loc_abbrev, source, class, topic)
SELECT id, question_id, loc_abbrev, source, class, topic
FROM alzheimers;

CREATE TABLE responses(
	id BIGINT, 
	question_id VARCHAR(100), 
	data_value VARCHAR(100), 
	data_value_unit VARCHAR(100),
	PRIMARY KEY(id, question_id),
	FOREIGN KEY(id, question_id) REFERENCES questions(id, question_id)
);

INSERT INTO responses(id, question_id, data_value, data_value_unit)
SELECT id, question_id, data_value, data_value_unit
FROM alzheimers;

-- 1b. 
-- For the responses table, I picked that id and question_id should be the primary keys
-- as they are a multikey in the other tables.

-- 1c.
-- The appropriate foreign key relations would be between results and questions and 
-- responses and questions, both referencing id and question_id as they're a multikey.


-- 2.
-- Create a table schema
CREATE TABLE EV (
    vin VARCHAR(100),
    county VARCHAR(100),
    city VARCHAR(100),
    state CHAR(2),
    postal_code INT,
    model_year INT,
    make VARCHAR(100),
    model VARCHAR(100),
    ev_type VARCHAR(100),
    cafv_eligibility VARCHAR(100),
    electric_range INT,
    base_msrp INT,
    legislative_district INT,
    dol_vehicle_id BIGINT,
    vehicle_location VARCHAR(100),
    electric_utility VARCHAR(255),
    census_tract BIGINT
);

-- Create a temporary table that matches the schema of the CSV file
-- Done in PSQL Tool:
CREATE TEMPORARY TABLE temp_EV (
    vin VARCHAR(100),
    county VARCHAR(100),
    city VARCHAR(100),
    state CHAR(2),
    postal_code INT,
    model_year INT,
    make VARCHAR(100),
    model VARCHAR(100),
    ev_type VARCHAR(100),
    cafv_eligibility VARCHAR(100),
    electric_range INT,
    base_msrp INT,
    legislative_district INT,
    dol_vehicle_id BIGINT,
    vehicle_location VARCHAR(100),
    electric_utility VARCHAR(255),
    census_tract BIGINT
);

-- Copy the data from the file to the temporary table
-- Done in PSQL Tool:
\copy temp_EV(vin, county, city, state, postal_code, model_year, make, model, ev_type,
    cafv_eligibility, electric_range, base_msrp, legislative_district, dol_vehicle_id,
    vehicle_location, electric_utility, census_tract
) FROM '/Users/jessicawang/Desktop/23-24 school/Electric_Vehicle_Population_Data-1.csv'
CSV HEADER;

-- Insert data from the temporary table to the final table
-- Done in PSQL Tool:
INSERT INTO EV (vin, county, city, state, postal_code, model_year, make, model, ev_type,
    			cafv_eligibility, electric_range, base_msrp, legislative_district, dol_vehicle_id,
   				vehicle_location, electric_utility, census_tract)
SELECT vin, county, city, state, postal_code, model_year, make, model, ev_type,
		cafv_eligibility, electric_range, base_msrp, legislative_district, dol_vehicle_id,
		vehicle_location, electric_utility, census_tract
FROM temp_EV;

-- Drop the temporary table
-- Done in PSQL Tool:
DROP TABLE temp_EV;

-- Bonus. Export data from the ‘alzheimers’ table in your database to a CSV file with headers.
-- Done in PSQL Tool:
\copy ev
TO '/Users/jessicawang/Desktop/23-24 school/Exported_Electric_Vehicle_Population_Data-1.csv'
CSV HEADER;