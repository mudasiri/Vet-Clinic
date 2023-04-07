/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

/* Update the Species */
BEGIN;
UPDATE animals SET species = 'unspecified';
ROLLBACK;

/* Querying data */

BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
COMMIT;

BEGIN;
DELETE FROM animals WHERE name != '';
ROLLBACK;


BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT delete_dob;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO SAVEPOINT delete_dob;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 1;
COMMIT;

SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts < 1;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, MAX(escape_attempts) FROM animals GROUP BY neutered;
SELECT MAX(weight_kg) FROM animals GROUP BY neutered;
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-01-01' GROUP BY species;


---What animals belong to Melody Pond?---
SELECT animals.name
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

---List of all animals that are pokemon (their type is Pokemon).--
SELECT animals.name
FROM animals
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

---List all owners and their animals, remember to include those that don't own any animal.--
SELECT owners.full_name, animals.name
FROM owners
LEFT JOIN animals ON owners.id = animals.owners_id;

---How many animals are there per species?--
SELECT species.name, COUNT(animals.id) 
FROM species 
JOIN animals ON species.id = animals.species_id 
GROUP BY species.name;

---List all Digimon owned by Jennifer Orwell.--
SELECT animals.name
FROM animals
JOIN species ON animals.species_id = species.id
JOIN owners ON animals.owner_id = owners.id
WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell';

--- List all animals owned by Dean Winchester that haven't tried to escape.--
SELECT animals.name
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

---Who owns the most animals?--
SELECT owners.full_name, COUNT(animals.id)
FROM owners
JOIN animals ON owners.id = animals.owner_id
GROUP BY owners.full_name
ORDER BY COUNT(animals.id) DESC
LIMIT 1;

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