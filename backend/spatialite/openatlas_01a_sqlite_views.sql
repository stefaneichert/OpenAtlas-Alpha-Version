------------------------------------------------------------------------------
--                                                                          --
--  This file is part of openATLAS.                                         --
--                                                                          --
--    openATLAS is free software: you can redistribute it and/or modify     --
--    it under the terms of the GNU General Public License as published by  --
--    the Free Software Foundation, either version 3 of the License, or     --
--    any later version.                                                    --
--                                                                          --
--    openATLAS is distributed in the hope that it will be useful,          --
--    but WITHOUT ANY WARRANTY; without even the implied warranty of        --
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         --
--    GNU General Public License for more details.                          --
--                                                                          --
--    You should have received a copy of the GNU General Public License     --
--    along with openATLAS. If not, see <http://www.gnu.org/licenses/>.     --
--                                                                          --
--    Database Design by Stefan Eichert 2013, stefan.eichert@univie.ac.at   --
--    Frontend developed by Viktor Jansa 2013, viktor.jansa@gmx.net         --
--                                                                          --
------------------------------------------------------------------------------

--Views/Queries for different Types of real stuff represented in OpenATLAS:
  --Note: if fields are commented by "a" it means that they automatically retrieve their values from triggers in the backend
  --Note: if fields are commented by "v" it means that they should be visible for the user in the GUI
  --Note: if fields are commented by "e" it means that they should be editable for the user in the GUI
  --Note: if fields are uncommented the user should not be able to see/edit them in the gui. 





--delete previously created views
DROP VIEW IF EXISTS sites;
DROP VIEW IF EXISTS features;
DROP VIEW IF EXISTS stratigraphical_units;
DROP VIEW IF EXISTS finds;
DROP VIEW IF EXISTS texts;
DROP VIEW IF EXISTS links_evidence; 
DROP VIEW IF EXISTS links_parents_arch;
DROP VIEW IF EXISTS links_images;
DROP VIEW IF EXISTS links_age;
DROP VIEW IF EXISTS links_sex;
DROP VIEW IF EXISTS links_bibliography;
DROP VIEW IF EXISTS links_chronological;
DROP VIEW IF EXISTS links_cultural;
DROP VIEW IF EXISTS links_graveconstruction;
DROP VIEW IF EXISTS links_graveshape;
DROP VIEW IF EXISTS links_material;
DROP VIEW IF EXISTS links_places;
DROP VIEW IF EXISTS links_rights;
DROP VIEW IF EXISTS links_rightsholder;






--site: non-moveable, physical things like settlements, churches, castles, graveyards...
  --  to document: Name, description, type, dating, center coordinates, dimensions
  --  defined by: Cidoc Class Nr = E018/physical thing AND Type = Site (or Subtype of Site)
  
CREATE VIEW sites AS  
SELECT 
  tbl_entities.uid, -- a
  tbl_entities.user_id, --default value from the login dialogue
  tbl_entities.entity_id, -- automatically created if NULL
  tbl_entities.timestamp_creation, --a
  tbl_entities.timestamp_edit, --a
  tbl_entities.user_edit, -- the fronted should insert the current users user_id on update
  tbl_entities.classes_uid, -- the frontend should insert the uid of the physical thing class on insert (=12)
  tbl_entities.entity_name_uri, --v e
  tbl_entities.entity_description, -- v e 
  tbl_entities.start_time_abs, -- v e
  tbl_entities.entity_remarks, 
  tbl_entities.end_time_abs, -- v e
  tbl_entities.start_time_text, -- v e
  tbl_entities.end_time_text, -- v e
  tbl_entities.dim_width, -- v e
  tbl_entities.dim_length, -- v e
  tbl_entities.dim_height, -- v e
  tbl_entities.dim_thickness, -- v e
  tbl_entities.dim_diameter, -- v e
  tbl_entities.dim_units, -- v e
  tbl_entities.dim_degrees, -- v e 
  tbl_entities.x_lon_easting, -- v e
  tbl_entities.y_lat_northing, -- v e
  tbl_entities.srid_epsg, -- e
			  -- If NULL then the frontend should automatically insert a Default SRID Number defined in the global settings
                          -- If necessary the user should be able to select another SRID by its name or number in a dialog that saves the chosen srid's number in the srid field of the current dataset)
                          -- In the GUI a Lookup Field should show the SRIDS name
  tbl_entities.geom, -- a
  tbl_entities.entity_type, -- e (In the GUI the user should be able to select the type by its name in a hierarchical organized Select-Dialogue that saves the chosen type's uid in the entity_type field of the current dataset)
  types_all_tree.name_path,  -- v
  st_x(st_transform(setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326)) AS X_WGS84, 
  st_y(st_transform(setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326)) AS Y_WGS84
FROM 
  types_all_tree, 
  tbl_entities
WHERE 
  tbl_entities.entity_type = types_all_tree.id AND
  tbl_entities.classes_uid = 12 AND -- entity has to be a physical thing
  types_all_tree.name_path LIKE '%> Site%'; -- entity's type must be Site or Subtype
  
  
  
--feature: non-moveable, physical things of which a site is composed of like buildings, walls, ditches, graves...
  --  to document: Name, description, type, dating, center coordinates, dimensions
  --  defined by: Cidoc Class Nr = E018/physical thing AND Type = Feature (or Subtype of Feature)

CREATE VIEW features AS  
SELECT 
  tbl_entities.uid, -- a
  tbl_entities.user_id, --default value from the login dialogue
  tbl_entities.entity_id, -- automatically created if NULL
  tbl_entities.timestamp_creation, --a
  tbl_entities.timestamp_edit, --a
  tbl_entities.user_edit, -- the fronted should insert the current users user_id on update
  tbl_entities.classes_uid, -- the frontend should insert the uid of the physical thing class on insert (=12)
  tbl_entities.entity_name_uri, --v e
  tbl_entities.entity_description, -- v e 
  tbl_entities.start_time_abs, -- v e (The frontend should insert the parents Value on default)
  tbl_entities.entity_remarks, 
  tbl_entities.end_time_abs, -- v e (The frontend should insert the parents Value on default)
  tbl_entities.start_time_text, -- v e (The frontend should insert the parents Value on default)
  tbl_entities.end_time_text, -- v e (The frontend should insert the parents Value on default)
  tbl_entities.dim_width, -- v e
  tbl_entities.dim_length, -- v e
  tbl_entities.dim_height, -- v e
  tbl_entities.dim_thickness, -- v e
  tbl_entities.dim_diameter, -- v e
  tbl_entities.dim_units, -- v e
  tbl_entities.dim_degrees, -- v e 
  tbl_entities.x_lon_easting, -- v e (The frontend should insert the parents Value on default)
  tbl_entities.y_lat_northing, -- v e (The frontend should insert the parents Value on default)
  tbl_entities.srid_epsg, -- e 
			  -- The frontend should insert the parents Value on default.
                          -- If NULL then the frontend should automatically insert a Default SRID Number defined in the global settings
                          -- If necessary the user should be able to select another SRID by its name or number in a dialog that saves the chosen srid's number in the srid field of the current dataset)
                          -- In the GUI a Lookup Field should show the SRIDS name
  tbl_entities.geom, -- a
  tbl_entities.entity_type, -- e (In the GUI the user should be able to select the type by its name in a hierarchical organized Select-Dialogue that saves the chosen type's uid in the entity_type field of the current dataset)
  types_all_tree.name_path,  -- v
  st_x(st_transform(setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326)) AS X_WGS84, 
  st_y(st_transform(setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326)) AS Y_WGS84,
  tbl_links.links_entity_uid_from AS parent -- v parent uid of feature
FROM 
  types_all_tree, 
  tbl_entities,
  tbl_links
WHERE 
  tbl_entities.entity_type = types_all_tree.id AND
  tbl_entities.classes_uid = 12 AND -- entity has to be a physical thing
  tbl_links.links_entity_uid_to = tbl_entities.uid AND
  tbl_links.links_cidoc_number_direction = 11 AND
  types_all_tree.name_path LIKE '%> Feature%'; -- entity's type must be Feature or Subtype



--stratigraphical unit: physical things of which a feature is composed of like backfillings, skeletons, deposits...
  --  to document: Name, description, type, dating, center coordinates, dimensions
  --  defined by: Cidoc Class Nr = E018/physical thing AND Type = Stratigraphical Unit (or Subtype of Stratigraphical Unit)

CREATE VIEW stratigraphical_units AS  
SELECT 
  tbl_entities.uid, -- a
  tbl_entities.user_id, --default value from the login dialogue
  tbl_entities.entity_id, -- automatically created if NULL
  tbl_entities.timestamp_creation, --a
  tbl_entities.timestamp_edit, --a
  tbl_entities.user_edit, -- the fronted should insert the current users user_id on update
  tbl_entities.classes_uid, -- the frontend should insert the uid of the physical thing class on insert (=12)
  tbl_entities.entity_name_uri, --v e
  tbl_entities.entity_description, -- v e 
  tbl_entities.start_time_abs, -- v e (The frontend should insert the parents Value on default)
  tbl_entities.entity_remarks, 
  tbl_entities.end_time_abs, -- v e (The frontend should insert the parents Value on default)
  tbl_entities.start_time_text, -- v e (The frontend should insert the parents Value on default)
  tbl_entities.end_time_text, -- v e (The frontend should insert the parents Value on default)
  tbl_entities.dim_width, -- v e
  tbl_entities.dim_length, -- v e
  tbl_entities.dim_height, -- v e
  tbl_entities.dim_thickness, -- v e
  tbl_entities.dim_diameter, -- v e
  tbl_entities.dim_units, -- v e
  tbl_entities.dim_weight, -- v e
  tbl_entities.dim_units_weight, -- v e
  tbl_entities.dim_degrees, -- v e 
  tbl_entities.x_lon_easting, -- v e (The frontend should insert the parents Value on default)
  tbl_entities.y_lat_northing, -- v e (The frontend should insert the parents Value on default)
  tbl_entities.srid_epsg, -- e 
			  -- The frontend should insert the parents Value on default.
                          -- If NULL then the frontend should automatically insert a Default SRID Number defined in the global settings
                          -- If necessary the user should be able to select another SRID by its name or number in a dialog that saves the chosen srid's number in the srid field of the current dataset)
                          -- In the GUI a Lookup Field should show the SRIDS name
  tbl_entities.geom, -- a
  tbl_entities.entity_type, -- e (In the GUI the user should be able to select the type by its name in a hierarchical organized Select-Dialogue that saves the chosen type's uid in the entity_type field of the current dataset)
  types_all_tree.name_path,  -- v
  st_x(st_transform(setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326)) AS X_WGS84, 
  st_y(st_transform(setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326)) AS Y_WGS84,
  tbl_links.links_entity_uid_from AS parent -- v parent uid of feature
FROM 
  types_all_tree, 
  tbl_entities,
  tbl_links
WHERE 
  tbl_entities.entity_type = types_all_tree.id AND
  tbl_entities.classes_uid = 12 AND -- entity has to be a physical thing
  tbl_links.links_entity_uid_to = tbl_entities.uid AND
  tbl_links.links_cidoc_number_direction = 11 AND
  types_all_tree.name_path LIKE '%> Stratigraphical Unit%'; -- entity's type must be Stratigraphical Unit or Subtype


--Finds: moveable physical things that were/are contained/found in stratigraphical units like pots, weapons, glass, tools...
  --  to document: Name, description, type, dating, center coordinates, dimensions
  --  defined by: Cidoc Class Nr = E019/physical object AND Type = Finds (or Subtype of Finds)

CREATE VIEW finds AS  
SELECT 
  tbl_entities.uid, -- a
  tbl_entities.user_id, --default value from the login dialogue
  tbl_entities.entity_id, -- automatically created if NULL
  tbl_entities.timestamp_creation, --a
  tbl_entities.timestamp_edit, --a
  tbl_entities.user_edit, -- the fronted should insert the current users user_id on update
  tbl_entities.classes_uid, -- the frontend should insert the uid of the physical object class on insert (=15)
  tbl_entities.entity_name_uri, --v e
  tbl_entities.entity_description, -- v e 
  tbl_entities.start_time_abs, -- v e (The frontend should insert the parents Value on default)
  tbl_entities.entity_remarks, 
  tbl_entities.end_time_abs, -- v e (The frontend should insert the parents Value on default)
  tbl_entities.start_time_text, -- v e (The frontend should insert the parents Value on default)
  tbl_entities.end_time_text, -- v e (The frontend should insert the parents Value on default)
  tbl_entities.dim_width, -- v e
  tbl_entities.dim_length, -- v e
  tbl_entities.dim_height, -- v e
  tbl_entities.dim_thickness, -- v e
  tbl_entities.dim_diameter, -- v e
  tbl_entities.dim_units, -- v e
  tbl_entities.dim_weight, -- v e
  tbl_entities.dim_units_weight, -- v e
  tbl_entities.dim_degrees, -- v e 
  tbl_entities.x_lon_easting, -- v e (The frontend should insert the parents Value on default)
  tbl_entities.y_lat_northing, -- v e (The frontend should insert the parents Value on default)
  tbl_entities.srid_epsg, -- e 
			  -- The frontend should insert the parents Value on default.
                          -- If NULL then the frontend should automatically insert a Default SRID Number defined in the global settings
                          -- If necessary the user should be able to select another SRID by its name or number in a dialog that saves the chosen srid's number in the srid field of the current dataset)
                          -- In the GUI a Lookup Field should show the SRIDS name
  tbl_entities.geom, -- a
  tbl_entities.entity_type, -- e (In the GUI the user should be able to select the type by its name in a hierarchical organized Select-Dialogue that saves the chosen type's uid in the entity_type field of the current dataset)
  types_all_tree.name_path,  -- v
  st_x(st_transform(setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326)) AS X_WGS84, 
  st_y(st_transform(setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326)) AS Y_WGS84,
  tbl_links.links_entity_uid_from AS parent -- v parent uid of feature
FROM 
  types_all_tree, 
  tbl_entities,
  tbl_links
WHERE 
  tbl_entities.entity_type = types_all_tree.id AND
  tbl_entities.classes_uid = 15 AND -- entity has to be a physical thing
  tbl_links.links_entity_uid_to = tbl_entities.uid AND
  tbl_links.links_cidoc_number_direction = 11 AND
  types_all_tree.name_path LIKE '%> Finds%'; -- entity's type must be Finds or Subtype



  
--Bibliography: Literature, papers, reports, charters, documents ecc. that refer to resp. document other entities
  --  to document: Name, description, type, year, center coordinates, dimensions
  --  defined by: Cidoc Class Nr = E031/document AND Type = Text (or Subtype of Text)

CREATE VIEW texts AS  
SELECT 
  tbl_entities.uid, -- a
  tbl_entities.user_id, --default value from the login dialogue
  tbl_entities.entity_id, -- automatically created if NULL (= Jabref's id if bibliography is imported from/linked to Jabref)
  tbl_entities.timestamp_creation, --a
  tbl_entities.timestamp_edit, --a
  tbl_entities.user_edit, -- the fronted should insert the current users user_id on update
  tbl_entities.classes_uid, -- the frontend should insert the uid of the document class on insert (=11)
  tbl_entities.entity_name_uri, -- v e (Authors Name + Year)
  tbl_entities.entity_description, -- v e (Citation of document)
  tbl_entities.start_time_abs, -- v e (Year of Publishing) 
  tbl_entities.entity_remarks, 
  tbl_entities.entity_type, -- e (In the GUI the user should be able to select the type by its name in a hierarchical organized Select-Dialogue that saves the chosen type's uid in the entity_type field of the current dataset)
  types_all_tree.name AS type_name, 
  types_all_tree.name_path  -- v
FROM 
  types_all_tree, 
  tbl_entities
WHERE 
  tbl_entities.entity_type = types_all_tree.id AND
  tbl_entities.classes_uid = 11 AND -- entity has to be a document
  types_all_tree.name_path LIKE '%> Text%'; -- entity's type must be Text or Subtype
  
  
 
--Evidence Links: Archeological units like sites, features, stratigraphical_units and finds that are linked to entities of Class E55 (type) that are subtypes (has broader term - P127) of "Evidence"
     
 CREATE VIEW links_evidence AS 
SELECT 
   tbl_links.links_entity_uid_from, -- Site/Feature etc. that is known by a certain type of evidence
   --tbl_links.links_cidoc_number_direction, 
   --tbl_links.links_entity_uid_to, -- Evidence by which the site is known
   --tbl_links.links_creator,
   tbl_links.links_uid,
   types_all_tree.name_path, -- name path contains *Evidence
   types_all_tree.name,
   --types_all_tree.path,
   tbl_links.links_annotation
FROM (tbl_links INNER JOIN tbl_entities ON tbl_links.links_entity_uid_to = tbl_entities.uid) 
 INNER JOIN types_all_tree ON tbl_entities.uid = types_all_tree.id
 WHERE (((tbl_links.links_cidoc_number_direction)=1) AND ((types_all_tree.name_path) Like '%> Evidence >%'));


--Archeological_Parent Links: Archeological units like sites, features and stratigraphical_units (E18) that are parents (is composed of - p46a) of other archeological units
     
 CREATE VIEW links_parents_arch AS 
SELECT 
   tbl_links.links_entity_uid_from, --archeological parent like a certain Site
   tbl_links.links_cidoc_number_direction, -- P46a
   tbl_links.links_entity_uid_to, -- archeological child like a certain feature from a certain site
   tbl_links.links_creator,
   tbl_links.links_uid,
   tbl_links.links_annotation,
   types_all_tree.name_path,
   types_all_tree.name,
   types_all_tree.path,
   tbl_entities.entity_name_uri,
   tbl_entities.entity_description 
FROM tbl_links 
 INNER JOIN (tbl_entities INNER JOIN types_all_tree ON tbl_entities.entity_type=types_all_tree.id)
 ON tbl_links.links_entity_uid_to=tbl_entities.uid 
 WHERE (((tbl_links.links_cidoc_number_direction)=11)) 
 ORDER BY tbl_entities.entity_name_uri, tbl_entities.uid; 
 

 
 
 --Image Links: Entitites (e.g. sites, features and stratigraphical_units, finds etc.) that are documented (P070b) in images (E31 entities that have the type image or subtype)
     
 CREATE VIEW links_images AS  
SELECT 
   types_all_tree.name_path, -- must contain *> Image *
   tbl_links.links_entity_uid_from, -- entity that is documented by an image
   tbl_links.links_entity_uid_to, -- image that shows the entity
   tbl_links.links_cidoc_number_direction, -- is documented in (P70b)
   tbl_entities.uid, 
   tbl_entities.entity_id, 
   tbl_entities.entity_name_uri, 
   tbl_links.links_uid,
   tbl_links.links_annotation
FROM tbl_links 
INNER JOIN (tbl_entities INNER JOIN types_all_tree ON tbl_entities.entity_type = types_all_tree.id)
ON tbl_links.links_entity_uid_to = tbl_entities.uid
WHERE (((types_all_tree.name_path) Like '%> Image %'))
ORDER BY tbl_entities.uid;



 --Age Links: Burials/Skeletons that have a certain type (P002a) of age (type - E55, Subtype of "Age >"
     
 CREATE VIEW links_age AS
SELECT 
   tbl_links.links_entity_uid_from, 
   tbl_links.links_cidoc_number_direction, 
   tbl_links.links_entity_uid_to, 
   tbl_links.links_creator, 
   tbl_links.links_uid, 
   types_all_tree.name_path, 
   types_all_tree.name, 
   types_all_tree.path, 
   tbl_links.links_annotation 
 FROM tbl_links 
   INNER JOIN (tbl_entities INNER JOIN types_all_tree ON tbl_entities.uid=types_all_tree.id)
   ON tbl_links.links_entity_uid_to=tbl_entities.uid 
   WHERE (((tbl_links.links_cidoc_number_direction)=1) AND ((types_all_tree.name_path) Like '%Age >%'));


--Sex Links: Burials/Skeletons that have a certain type (P002a) of sex (type - E55, Subtype of "Sex >"
     
 CREATE VIEW links_sex AS
SELECT 
   tbl_links.links_entity_uid_from, 
   tbl_links.links_cidoc_number_direction, 
   tbl_links.links_entity_uid_to, 
   tbl_links.links_creator, 
   tbl_links.links_uid, 
   types_all_tree.name_path, 
   types_all_tree.name, 
   types_all_tree.path, 
   tbl_links.links_annotation 
 FROM tbl_links 
   INNER JOIN (tbl_entities INNER JOIN types_all_tree ON tbl_entities.uid=types_all_tree.id)
   ON tbl_links.links_entity_uid_to=tbl_entities.uid 
   WHERE (((tbl_links.links_cidoc_number_direction)=1) AND ((types_all_tree.name_path) Like '%Sex >%'));
   
   

--Bibliography Links: Entitites (e.g. sites, features and stratigraphical_units, finds, images etc.) that are documented (P070b) in texts (E31 entities that have a subtype of text)
     
 CREATE VIEW links_bibliography AS   
SELECT 
  tbl_links.links_entity_uid_from, 
  --tbl_links.links_cidoc_number_direction, 
  tbl_links.links_entity_uid_to, 
  --tbl_links.links_creator, 
  tbl_links.links_uid, 
  --types_all_tree.name_path, 
  types_all_tree.name, 
  --types_all_tree.path, 
  tbl_entities.entity_name_uri, 
  tbl_entities.entity_description, 
  tbl_links.links_annotation
FROM tbl_links 
   INNER JOIN (tbl_entities INNER JOIN types_all_tree ON tbl_entities.entity_type = types_all_tree.id)
    ON tbl_links.links_entity_uid_to = tbl_entities.uid
WHERE (((tbl_links.links_cidoc_number_direction)=4) AND ((types_all_tree.name_path) Like '%> Text >%'))
ORDER BY tbl_entities.entity_name_uri, tbl_entities.uid;



--Chronological Links: Archeological units like sites, features, stratigraphical_units and finds that are linked (P86a) to entities of Class E52 (timespan)
     
 CREATE VIEW links_chronological AS 

SELECT 
   tbl_links.links_entity_uid_from, 
   tbl_links.links_cidoc_number_direction, 
   tbl_links.links_entity_uid_to, 
   tbl_links.links_creator, 
   tbl_links.links_uid, 
   chronological_period_all_tree.name_path, 
   chronological_period_all_tree.name, 
   chronological_period_all_tree.path 
 FROM tbl_links 
    INNER JOIN chronological_period_all_tree ON tbl_links.links_entity_uid_to=chronological_period_all_tree.id 
    WHERE (((tbl_links.links_cidoc_number_direction)=13)); 
    
    
--cultural Links: Archeological units like sites, features, stratigraphical_units and finds that are linked (P10a) to entities of Class E4 (period)
CREATE VIEW links_cultural AS 
SELECT 
  tbl_links.links_entity_uid_from, 
  tbl_links.links_cidoc_number_direction, 
  tbl_links.links_entity_uid_to, 
  tbl_links.links_creator, 
  tbl_links.links_uid, 
  cultural_period_all_tree.name_path, 
  cultural_period_all_tree.name, 
  cultural_period_all_tree.path 
FROM tbl_links 
 INNER JOIN cultural_period_all_tree ON tbl_links.links_entity_uid_to=cultural_period_all_tree.id 
 WHERE (((tbl_links.links_cidoc_number_direction)=9)); 
   



--grave construction Links: Graves that are (P2 has tyoe) to entities of Class E55 (type) that are subtypes of 'Grave Construction'
CREATE VIEW links_graveconstruction AS    
SELECT 
   tbl_links.links_entity_uid_from, 
   tbl_links.links_cidoc_number_direction, 
   tbl_links.links_entity_uid_to, 
   tbl_links.links_creator, 
   tbl_links.links_uid, 
   types_all_tree.name_path, 
   types_all_tree.name, 
   types_all_tree.path, 
   tbl_links.links_annotation
 FROM tbl_links 
    INNER JOIN (tbl_entities 
       INNER JOIN types_all_tree 
       ON tbl_entities.uid = types_all_tree.id) 
    ON tbl_links.links_entity_uid_to = tbl_entities.uid
 WHERE (((tbl_links.links_cidoc_number_direction)=1) AND ((types_all_tree.name_path) Like '%Grave Construction%'));

 
 
--grave shape Links: Graves that are linked (P2 has type) to entities of Class E55 (type) that are subtypes of 'Grave Shape'
CREATE VIEW links_graveshape AS    
SELECT 
   tbl_links.links_entity_uid_from, 
   tbl_links.links_cidoc_number_direction, 
   tbl_links.links_entity_uid_to, 
   tbl_links.links_creator, 
   tbl_links.links_uid, 
   types_all_tree.name_path, 
   types_all_tree.name, 
   types_all_tree.path, 
   tbl_links.links_annotation
 FROM tbl_links 
    INNER JOIN (tbl_entities 
       INNER JOIN types_all_tree 
       ON tbl_entities.uid = types_all_tree.id) 
    ON tbl_links.links_entity_uid_to = tbl_entities.uid
 WHERE (((tbl_links.links_cidoc_number_direction)=1) AND ((types_all_tree.name_path) Like '%Grave Shape%'));
 
 
 --Material Links: archeological units that have a certain type (P002a) of material (E57, Subtype of "Material >"
     
 CREATE VIEW links_material AS
SELECT 
   tbl_links.links_entity_uid_from, 
   --tbl_links.links_cidoc_number_direction, 
   --tbl_links.links_entity_uid_to, 
   --tbl_links.links_creator, 
   tbl_links.links_uid, 
   types_all_tree.name_path, 
   types_all_tree.name, 
   --types_all_tree.path, 
   tbl_links.links_annotation 
 FROM tbl_links 
   INNER JOIN (tbl_entities INNER JOIN types_all_tree ON tbl_entities.uid=types_all_tree.id)
   ON tbl_links.links_entity_uid_to=tbl_entities.uid 
   WHERE (((tbl_links.links_cidoc_number_direction)=1) AND ((types_all_tree.name_path) Like '%Material >%'));

   
--Place Links: archeological units that are located within (P053a) places (E53)
     
 CREATE VIEW links_places AS
SELECT 
  tbl_links.links_entity_uid_from, 
  tbl_links.links_uid, 
  place_all_tree.name_path, 
  place_all_tree.name, 
  types.entity_name_uri AS type_name, 
  tbl_links.links_annotation
FROM 
  tbl_links, 
  place_all_tree, 
  tbl_entities, 
  tbl_entities types
WHERE 
  tbl_links.links_entity_uid_to = place_all_tree.id AND
  place_all_tree.id = tbl_entities.uid AND
  tbl_entities.entity_type = types.uid AND
  tbl_links.links_cidoc_number_direction = 15 AND 
  place_all_tree.name_path LIKE '%World%';
   

   
--Rights Links: entities that are that are subject to (P104a) certain rights (E30)
     
 CREATE VIEW links_rights AS
SELECT 
    tbl_links.links_entity_uid_from, 
    tbl_links.links_cidoc_number_direction, 
    tbl_links.links_entity_uid_to, 
    tbl_links.links_creator, 
    tbl_links.links_uid, 
    tbl_entities.classes_uid, 
    tbl_entities.entity_name_uri, 
    tbl_entities.entity_description, 
    tbl_entities.entity_id
  FROM tbl_links 
    INNER JOIN tbl_entities ON tbl_links.links_entity_uid_to = tbl_entities.uid
  WHERE (((tbl_links.links_cidoc_number_direction)=17) AND ((tbl_entities.classes_uid)=21));
  

  
  --Rightsholder Links: entities whose rights are held (P105a) by certain actors (E39)
     
 CREATE VIEW links_rightsholder AS  
SELECT 
   tbl_links.links_entity_uid_from, 
   tbl_links.links_cidoc_number_direction, 
   tbl_links.links_entity_uid_to, 
   tbl_links.links_creator, 
   tbl_links.links_uid, 
   tbl_entities.classes_uid, 
   tbl_entities.entity_name_uri, 
   tbl_entities.entity_description, 
   tbl_entities.entity_id
  FROM tbl_links 
     INNER JOIN tbl_entities ON tbl_links.links_entity_uid_to = tbl_entities.uid
  WHERE (((tbl_links.links_cidoc_number_direction)=19));
