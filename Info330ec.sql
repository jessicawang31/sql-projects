-- 1. Load Raw Data
-- Create Table
CREATE TABLE Public_Art_Data (
    sac_id VARCHAR(255),
    project VARCHAR(255),
    artist_first_name VARCHAR(255),
    artist_last_name VARCHAR(255),
    title VARCHAR(255),
    description TEXT,
    classification VARCHAR(255),
    media VARCHAR(255),
    measurements VARCHAR(255),
    date VARCHAR(255),
    location VARCHAR(255),
    address VARCHAR(255),
    latitude FLOAT,
    longitude FLOAT,
    Geolocation TEXT
);


-- Create Temp Table
-- Done in PSQL Tool:
CREATE TABLE temp_Public_Art_Data (
    sac_id VARCHAR(255),
    project VARCHAR(255),
    artist_first_name VARCHAR(255),
    artist_last_name VARCHAR(255),
    title VARCHAR(255),
    description TEXT,
    classification VARCHAR(255),
    media VARCHAR(255),
    measurements VARCHAR(255),
    date VARCHAR(255),
    location VARCHAR(255),
    address VARCHAR(255),
    latitude FLOAT,
    longitude FLOAT,
    Geolocation TEXT
);


-- Load Data
-- Done in PSQL Tool:
\copy temp_Public_Art_Data(sac_id, project, artist_first_name, artist_last_name, title, 
	description, classification, media, measurements, date, location, address, latitude, 
	longitude, Geolocation
) From '/Users/jessicawang/Desktop/23-24 school/Public_Art_Data.csv' 
CSV HEADER;


-- Insert data from the temporary table to the final table
-- Done in PSQL Tool:
INSERT INTO Public_Art_Data (sac_id, project, artist_first_name, artist_last_name, title, 
	description, classification, media, measurements, date, location, address, latitude, 
	longitude, Geolocation)
SELECT sac_id, project, artist_first_name, artist_last_name, title, 
	description, classification, media, measurements, date, location, address, latitude, 
	longitude, Geolocation
FROM temp_Public_Art_Data;


-- Drop the temporary table
-- Done in PSQL Tool:
DROP TABLE temp_Public_Art_Data; -- still need to drop

-- 2. Figure out the keys
SELECT sac_id, COUNT(*)
FROM Public_Art_Data
GROUP BY sac_id;

SELECT title, COUNT(*)
FROM Public_Art_Data
GROUP BY title;

-- key?
SELECT sac_id, title, COUNT(*)
FROM Public_Art_Data
GROUP BY sac_id, title;


-- 3. Fix empty descriptions
UPDATE Public_Art_Data
SET description = NULL
WHERE description = '';


-- 4. Create clean public art table
CREATE TABLE clean_seattle_public_art (
    sac_id VARCHAR(255),
    project VARCHAR(255),
    title VARCHAR(255),
    description TEXT,
    media VARCHAR(255),
    date VARCHAR(255),
    location VARCHAR(255),
    PRIMARY KEY (sac_id, title)
);

-- 4a. Now load the clean art data
INSERT INTO clean_seattle_public_art
SELECT DISTINCT sac_id, project, title, description, media, date, location
FROM Public_Art_Data
WHERE sac_id IS NOT NULL;


-- 5. Create an artist table
CREATE TABLE seattle_public_art_artist (
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    suffix VARCHAR(10),
    PRIMARY KEY (first_name, last_name)
);


-- 6. Populate your artist table with all the artist data
-- This query was provided and doesn't run.
INSERT INTO seattle_public_art_artist(artist_first_name, artist_last_name)
SELECT artist_first_name, artist_last_name
FROM Public_Art_Data;

-- This is altered and does work as we select distinct names.
INSERT INTO seattle_public_art_artist (first_name, last_name)
SELECT DISTINCT artist_first_name, artist_last_name
FROM Public_Art_Data
WHERE artist_first_name IS NOT NULL 
AND artist_last_name IS NOT NULL;


-- 7. Fix the dirty artist data
-- ESD00.074.06 (Jr. included in first name)
--done
DELETE FROM seattle_public_art_artist a
WHERE a.last_name = 'Washington' AND a.first_name = 'James Jr.'; 

INSERT INTO seattle_public_art_artist VALUES ('James', 'Washington', 'Jr.');

-- PR99.044 (three people listed in last name column)
-- PR99.043 (three people listed in last name column)
-- PR99.046 (three people listed in last name column)
-- PR99.045 (three people listed in last name column)
DELETE FROM seattle_public_art_artist a
WHERE a.last_name = 'Fels, Donald; Feddersen, Joe; Quick to see Smith, Jaune';

INSERT INTO seattle_public_art_artist VALUES ('Donald', 'Fels', NULL);
INSERT INTO seattle_public_art_artist VALUES ('Joe', 'Feddersen', NULL);
INSERT INTO seattle_public_art_artist VALUES ('Jaune', 'Quick to see Smith', NULL);

-- NEA97.024 (two people listed in last name column)
-- PR97.022 (two people listed in last name column)
DELETE FROM seattle_public_art_artist a
WHERE a.last_name = 'Brother and Mark Calderon';

INSERT INTO seattle_public_art_artist VALUES ('Beliz', 'Brother', NULL);
INSERT INTO seattle_public_art_artist VALUES ('Mark', 'Calderon', NULL);

select *
from seattle_public_art_artist
where first_name = 'Beliz' and last_name = 'Brother'
or first_name = 'Mark' and last_name = 'Calderon';


-- LIB05.006 (First name repeated in last name column)
DELETE FROM seattle_public_art_artist a
WHERE a.last_name = 'D''Agostino, Fernanda'; 

INSERT INTO seattle_public_art_artist VALUES ('Fernanda', 'D''Agostino', NULL);


-- 8. Create the many-to-many relationship between art and artist
CREATE TABLE seattle_public_art_artist_work (
	sac_id varchar(200), 
    title varchar(200), 
    artist_first_name varchar(100), 
    artist_last_name varchar(100), 
    PRIMARY KEY (sac_id, title, artist_first_name, artist_last_name)
);


-- 9. Populate your new artist table
SELECT p.sac_id, p.title,  a.first_name, a.last_name
FROM seattle_public_art_artist a, Public_Art_Data p
WHERE a.first_name = p.artist_first_name
AND a.last_name = p.artist_last_name
AND sac_id IS NOT NULL;

INSERT INTO seattle_public_art_artist_work
SELECT DISTINCT p.sac_id, p.title,  a.first_name, a.last_name
FROM seattle_public_art_artist a, Public_Art_Data p
WHERE a.first_name = p.artist_first_name
AND a.last_name = p.artist_last_name
AND sac_id IS NOT NULL;

SELECT sac_id, artist_first_name, artist_last_name, title
FROM public_art_Data
WHERE sac_id = 'ESD00.074.06'
   OR sac_id = 'PR99.044'
   OR sac_id = 'PR99.043'
   OR sac_id = 'PR99.046'
   OR sac_id = 'PR99.045'
   OR sac_id = 'NEA97.024'
   OR sac_id = 'PR97.022'
   OR sac_id = 'LIB05.006';


-- the Artist with their project.
INSERT INTO seattle_public_art_artist_work VALUES ('ESD00.074.06', 'Coelacanths', 'James', 'Washington');

INSERT INTO seattle_public_art_artist_work VALUES ('PR99.044', 'Bronze Imbeds', 'Donald', 'Fels');
INSERT INTO seattle_public_art_artist_work  VALUES ('PR99.044', 'Pavers', 'Donald', 'Fels');
INSERT INTO seattle_public_art_artist_work  VALUES ('PR99.044', 'Viewers', 'Donald', 'Fels');
INSERT INTO seattle_public_art_artist_work  VALUES ('PR99.044', 'Bronze Plaques and Medallion', 'Donald', 'Fels');

INSERT INTO seattle_public_art_artist_work VALUES ('PR99.043', 'Bronze Imbeds', 'Joe', 'Feddersen');
INSERT INTO seattle_public_art_artist_work  VALUES ('PR99.043', 'Pavers', 'Joe', 'Feddersen');
INSERT INTO seattle_public_art_artist_work  VALUES ('PR99.043', 'Viewers', 'Joe', 'Feddersen');
INSERT INTO seattle_public_art_artist_work  VALUES ('PR99.043','Bronze Plaques and Medallion', 'Joe', 'Feddersen');

INSERT INTO seattle_public_art_artist_work VALUES ('PR99.046', 'Bronze Imbeds', 'Jaune', 'Quick to see Smith');
INSERT INTO seattle_public_art_artist_work  VALUES ('PR99.046', 'Pavers', 'Jaune', 'Quick to see Smith');
INSERT INTO seattle_public_art_artist_work  VALUES ('PR99.046', 'Viewers', 'Jaune', 'Quick to see Smith');
INSERT INTO seattle_public_art_artist_work  VALUES ('PR99.046', 'Bronze Plaques and Medallion', 'Jaune', 'Quick to see Smith');

INSERT INTO seattle_public_art_artist_work VALUES ('NEA97.024', 'Water Borne', 'Beliz', 'Brother');
INSERT INTO seattle_public_art_artist_work VALUES ('NEA97.024', 'Aureole', 'Beliz', 'Brother');

INSERT INTO seattle_public_art_artist_work VALUES ('PR97.022', 'Water Borne', 'Mark', 'Calderon');
INSERT INTO seattle_public_art_artist_work VALUES ('PR97.022', 'Aureole', 'Mark', 'Calderon');


INSERT INTO seattle_public_art_artist_work VALUES ('LIB05.006', 'Into the Green Wood', 'Fernanda', 'D''Agostino');

-- 10. Now query your clean schema!
SELECT artist_first_name, artist_last_name, COUNT(*)
FROM seattle_public_art_artist_work w, clean_seattle_public_art art
WHERE art.sac_id = w.sac_id
AND art.title = w.title
GROUP BY artist_first_name, artist_last_name
ORDER BY COUNT(*) DESC;