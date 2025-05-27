
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    "name" VARCHAR(100),
    region VARCHAR(100)

)


CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100),
    scientific_name VARCHAR(100),
    discovery_date DATE,
    conservation_status VARCHAR(100)
)

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INTEGER REFERENCES rangers(ranger_id),
    species_id INTEGER REFERENCES species(species_id),
    sighting_time TIMESTAMP ,
    "location" VARCHAR(200),
    notes TEXT
)

-- Insert sample data into rangers
INSERT INTO rangers (ranger_id, "name", region) VALUES
(1, 'Alice Green', 'Northern Hills'),
(2, 'Bob White', 'River Delta'),
(3, 'Carol King', 'Mountain Range');

-- Insert sample data into species
INSERT INTO species (species_id, common_name, scientific_name, discovery_date, conservation_status) VALUES
(1, 'Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
(2, 'Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
(3, 'Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
(4, 'Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

-- Insert sample data into sightings
INSERT INTO sightings (sighting_id, species_id, ranger_id, "location", sighting_time, notes) VALUES
(1, 1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(4, 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);


DROP TABLE rangers;
DROP TABLE species;
DROP TABLE sightings;

SELECT * FROM rangers;
SELECT * FROM species;
SELECT * FROM sightings;

-- 1️⃣ Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'
INSERT INTO rangers ("name", region) VALUES('Derek Fox', 'Coastal Plains');

-- 2️⃣ Count unique species ever sighted.
SELECT count(DISTINCT species_id) AS unique_species_count FROM sightings;

-- 3️⃣ Find all sightings where the location includes "Pass".

SELECT * FROM sightings WHERE "location" LIKE '%Pass%';

-- 4️⃣ List each ranger's name and their total number of sightings.
SELECT r.name, COUNT(s.sighting_id) AS total_sightings
FROM rangers AS r
JOIN sightings AS s USING(ranger_id)
GROUP BY r.name ORDER BY r.name;

-- 5️⃣ List species that have never been sighted.
SELECT common_name FROM sightings FULL JOIN species USING(species_id) WHERE sighting_id IS NULL;


