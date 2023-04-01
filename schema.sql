/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id INT PRIMARY KEY,
    name varchar(100),
    date_of_birth DATE,
    escape_attempts INT,
    neutered bool,
    weight_kg float
);

/* Alter Tables Animal */
ALTER TABLE animals ADD COLUMN species varchar;

/*Create owners table  */
CREATE TABLE owners (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(255),
    age INT  
);
/* Create the species table */
CREATE TABLE species (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(255)
);

/* Modify animals table*/

ALTER TABLE animals
DROP COLUMN species;


ALTER TABLE animals
ADD COLUMN species_id INT,
ADD FOREIGN KEY (species_id) REFERENCES species(id);

ALTER TABLE animals
ADD COLUMN owner_id INT,
ADD FOREIGN KEY (owner_id) REFERENCES owners(id);

--create vets table--
create table vets (
    id GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    name VARCHAR(255), 
    age INT, 
    date_of_graduation DATE
);

/*There is a many-to-many relationship between 
the tables species and vets: a vet can specialize 
in multiple species, and a species can have multiple 
vets specialized in it. Create a "join table" called 
specializations to handle this relationship.*/

create table specializations (species_id INT, vets_id INT);
ALTER TABLE specializations ADD CONSTRAINT species_fkey FOREIGN KEY (species_id) REFERENCES species(id);
ALTER TABLE specializations ADD CONSTRAINT vets_fkey FOREIGN KEY (vets_id) REFERENCES vets(id);

/*There is a many-to-many relationship between the 
tables animals and vets: an animal can visit multiple 
vets and one vet can be visited by multiple animals. 
Create a "join table" called visits to handle this 
relationship, it should also keep track of the date of the visit.*/

create table visits (animals_id INT, vets_id INT, date_of_visit date);
ALTER TABLE visits ADD CONSTRAINT animals_fkey FOREIGN KEY (animals_id) REFERENCES animals(id);
ALTER TABLE visits ADD CONSTRAINT vets_fkey FOREIGN KEY (vets_id) REFERENCES vets(id);

--Who was the last animal seen by William Tatcher--
SELECT animals.name 
FROM visits 
JOIN vets ON visits.vets_id = vets.id 
JOIN animals ON visits.animals_id = animals.id 
WHERE vets.name = 'William Tatcher' 
ORDER BY date_of_visit DESC 
LIMIT 1;


--How many different animals did Stephanie Mendez see?--
SELECT COUNT(animals.name) 
FROM visits 
JOIN vets ON visits.vets_id = vets.id 
JOIN animals ON visits.animals_id = animals.id 
WHERE vets.name = 'Stephanie Mendez';


--List all vets and their specialties, including vets with no specialties--
SELECT vets.name, species.name 
FROM specializations FULL 
JOIN vets ON specializations.vets_id = vets.id 
FULL JOIN species ON specializations.species_id = species.id;

--List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.--
SELECT animals.name 
FROM visits 
JOIN vets ON visits.vets_id = vets.id 
JOIN animals ON visits.animals_id = animals.id 
WHERE vets.name = 'Stephanie Mendez' 
AND visits.date_of_visit 
BETWEEN '2020-04-01' 
AND '2020-08-30';


--What animal has the most visits to vets?--
SELECT animals.name AS Pet, COUNT(*) 
AS CNT FROM visits 
JOIN vets ON visits.vets_id = vets.id 
JOIN animals ON visits.animals_id = animals.id 
GROUP BY Pet 
ORDER BY CNT 
DESC LIMIT 1;



--Who was Maisy Smith's first visit?--
SELECT animals.name 
FROM visits 
JOIN vets ON visits.vets_id = vets.id 
JOIN animals ON visits.animals_id = animals.id 
WHERE vets.name = 'Maisy Smith' 
ORDER BY visits.date_of_visit 
ASC 
LIMIT 1;


--Details for most recent visit: animal information, vet information, and date of visit.--
SELECT * FROM visits 
JOIN vets on visits.vets_id = vets.id 
JOIN animals ON visits.animals_id = animals.id 
ORDER BY visits.date_of_visit 
DESC LIMIT 1;


--How many visits were with a vet that did not specialize in that animal's species?--
SELECT COUNT(*) FROM visits J
OIN vets ON visits.vets_id = vets.id 
FULL JOIN specializations ON specializations.vets_id = vets.id 
WHERE specializations.species_id IS NULL;


--What specialty should Maisy Smith consider getting? Look for the species she gets the most.--
SELECT species.name AS S, COUNT(*) 
AS CNT FROM visits 
JOIN vets ON visits.vets_id = vets.id 
JOIN animals ON visits.animals_id = animals.id 
JOIN species ON animals.species_id = species.id 
FULL JOIN specializations ON specializations.vets_id = vets.id 
WHERE vets.name = 'Maisy Smith' 
GROUP BY S 
ORDER BY CNT 
DESC LIMIT 1;