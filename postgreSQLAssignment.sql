-- ===========================
-- Table Definitions
-- ===========================

CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    "name" VARCHAR(100),
    region VARCHAR(100)
);

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100),
    scientific_name VARCHAR(100),
    discovery_date DATE,
    conservation_status VARCHAR(100)
);

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INTEGER REFERENCES rangers(ranger_id),
    species_id INTEGER REFERENCES species(species_id),
    sighting_time TIMESTAMP,
    "location" VARCHAR(200),
    notes TEXT
);

-- ===========================
-- Insert Sample Data
-- ===========================

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

-- ===========================
-- Cleanup Tables (optional)
-- ===========================

DROP TABLE IF EXISTS sightings;
DROP TABLE IF EXISTS species;
DROP TABLE IF EXISTS rangers;

-- ===========================
-- Simple Queries & Operations
-- ===========================

-- View all rangers
SELECT * FROM rangers;

-- View all species
SELECT * FROM species;

-- View all sightings
SELECT * FROM sightings;

-- 1️⃣ Register a new ranger named 'Derek Fox' in region 'Coastal Plains'
INSERT INTO rangers ("name", region) VALUES ('Derek Fox', 'Coastal Plains');

-- 2️⃣ Count unique species ever sighted
SELECT COUNT(DISTINCT species_id) AS unique_species_count FROM sightings;

-- 3️⃣ Find all sightings where location includes "Pass"
SELECT * FROM sightings WHERE "location" LIKE '%Pass%';

-- 4️⃣ List each ranger's name and their total number of sightings
SELECT r.name, COUNT(s.sighting_id) AS total_sightings
FROM rangers AS r
JOIN sightings AS s USING(ranger_id)
GROUP BY r.name
ORDER BY r.name;

-- 5️⃣ List species that have never been sighted
SELECT common_name
FROM species
LEFT JOIN sightings USING(species_id)
WHERE sightings.sighting_id IS NULL;

-- 6️⃣ Show the most recent 2 sightings with species name and ranger name
SELECT s.common_name, sg.sighting_time, r."name"
FROM sightings sg
JOIN species s USING(species_id)
JOIN rangers r USING(ranger_id)
ORDER BY sg.sighting_time DESC
LIMIT 2;

-- 7️⃣ Update species discovered before 1800 to have conservation_status 'Historic'
UPDATE species
SET conservation_status = 'Historic'
WHERE EXTRACT(YEAR FROM discovery_date) < 1800;

-- 8️⃣ Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'
SELECT
  sighting_id,
  CASE
    WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 12 AND 16 THEN 'Afternoon'
    ELSE 'Evening'
  END AS time_of_day
FROM sightings
ORDER BY sighting_id;

-- 9️⃣ Delete rangers who have never sighted any species

DELETE FROM rangers
WHERE ranger_id NOT IN (SELECT ranger_id FROM sightings);
