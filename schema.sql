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

