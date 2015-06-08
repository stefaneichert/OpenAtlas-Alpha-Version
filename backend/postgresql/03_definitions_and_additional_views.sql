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



--site: non-moveable, physical things like settlements, churches, castles, graveyards...
  --  to document: Name, description, type, dating, center coordinates, dimensions
  --  defined by: Cidoc Class Nr = E018/physical thing AND Type = Site (or Subtype of Site)

DROP VIEW IF EXISTS openatlas.sites,
 openatlas.features,
 openatlas.stratigraphical_units,
 openatlas.finds,
 openatlas.texts,
 openatlas.links_evidence, 
 openatlas.links_parents_arch,
 openatlas.links_images,
 openatlas.links_age,
 openatlas.links_sex,
 openatlas.links_bibliography,
 openatlas.links_chronological,
 openatlas.links_cultural,
 openatlas.links_graveconstruction,
 openatlas.links_graveshape,
 openatlas.links_material,
 openatlas.links_places,
 openatlas.links_rights,
 openatlas.links_rightsholder;



CREATE OR REPLACE VIEW openatlas.sites AS  
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
  st_x(st_transform(st_setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326)) AS X_WGS84, 
  st_y(st_transform(st_setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326)) AS Y_WGS84
FROM 
  openatlas.types_all_tree, 
  openatlas.tbl_entities
WHERE 
  tbl_entities.entity_type = types_all_tree.id AND
  tbl_entities.classes_uid = 12 AND -- entity has to be a physical thing
  types_all_tree.name_path LIKE '%> Site%'; -- entity's type must be Site or Subtype



--feature: non-moveable, physical things of which a site is composed of like buildings, walls, ditches, graves...
  --  to document: Name, description, type, dating, center coordinates, dimensions
  --  defined by: Cidoc Class Nr = E018/physical thing AND Type = Feature (or Subtype of Feature)

CREATE OR REPLACE VIEW openatlas.features AS  
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
  st_x(st_transform(st_setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326)) AS X_WGS84, 
  st_y(st_transform(st_setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326)) AS Y_WGS84,
  tbl_links.links_entity_uid_from AS parent -- v parent uid of feature
FROM 
  openatlas.types_all_tree, 
  openatlas.tbl_entities,
  openatlas.tbl_links
WHERE 
  tbl_entities.entity_type = types_all_tree.id AND
  tbl_entities.classes_uid = 12 AND -- entity has to be a physical thing
  tbl_links.links_entity_uid_to = tbl_entities.uid AND
  tbl_links.links_cidoc_number_direction = 11 AND
  types_all_tree.name_path LIKE '%> Feature%'; -- entity's type must be Feature or Subtype



--stratigraphical unit: physical things of which a feature is composed of like backfillings, skeletons, deposits...
  --  to document: Name, description, type, dating, center coordinates, dimensions
  --  defined by: Cidoc Class Nr = E018/physical thing AND Type = Stratigraphical Unit (or Subtype of Stratigraphical Unit)

CREATE OR REPLACE VIEW openatlas.stratigraphical_units AS  
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
  st_x(st_transform(st_setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326)) AS X_WGS84, 
  st_y(st_transform(st_setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326)) AS Y_WGS84,
  tbl_links.links_entity_uid_from AS parent -- v parent uid of feature
FROM 
  openatlas.types_all_tree, 
  openatlas.tbl_entities,
  openatlas.tbl_links
WHERE 
  tbl_entities.entity_type = types_all_tree.id AND
  tbl_entities.classes_uid = 12 AND -- entity has to be a physical thing
  tbl_links.links_entity_uid_to = tbl_entities.uid AND
  tbl_links.links_cidoc_number_direction = 11 AND
  types_all_tree.name_path LIKE '%> Stratigraphical Unit%'; -- entity's type must be Stratigraphical Unit or Subtype


--Finds: moveable physical things that were/are contained/found in stratigraphical units like pots, weapons, glass, tools...
  --  to document: Name, description, type, dating, center coordinates, dimensions
  --  defined by: Cidoc Class Nr = E019/physical object AND Type = Finds (or Subtype of Finds)

CREATE OR REPLACE VIEW openatlas.finds AS  
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
  st_x(st_transform(st_setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326)) AS X_WGS84, 
  st_y(st_transform(st_setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326)) AS Y_WGS84,
  tbl_links.links_entity_uid_from AS parent -- v parent uid of feature
FROM 
  openatlas.types_all_tree, 
  openatlas.tbl_entities,
  openatlas.tbl_links
WHERE 
  tbl_entities.entity_type = types_all_tree.id AND
  tbl_entities.classes_uid = 15 AND -- entity has to be a physical thing
  tbl_links.links_entity_uid_to = tbl_entities.uid AND
  tbl_links.links_cidoc_number_direction = 11 AND
  types_all_tree.name_path LIKE '%> Finds%'; -- entity's type must be Finds or Subtype



--Bibliography: Literature, papers, reports, charters, documents ecc. that refer to resp. document other entities
  --  to document: Name, description, type, year, center coordinates, dimensions
  --  defined by: Cidoc Class Nr = E031/document AND Type = Text (or Subtype of Text)

CREATE OR REPLACE VIEW openatlas.texts AS  
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
  openatlas.types_all_tree, 
  openatlas.tbl_entities
WHERE 
  tbl_entities.entity_type = types_all_tree.id AND
  tbl_entities.classes_uid = 11 AND -- entity has to be a document
  types_all_tree.name_path LIKE '%> Text%'; -- entity's type must be Text or Subtype
  
  
 
--Evidence Links: Archeological units like sites, features, stratigraphical_units and finds that are linked to entities of Class E55 (type) that are subtypes (has broader term - P127) of "Evidence"
     
 CREATE OR REPLACE VIEW openatlas.links_evidence AS 
SELECT 
   openatlas.tbl_links.links_entity_uid_from, -- Site/Feature etc. that is known by a certain type of evidence
   --openatlas.tbl_links.links_cidoc_number_direction, 
   --openatlas.tbl_links.links_entity_uid_to, -- Evidence by which the site is known
   --openatlas.tbl_links.links_creator,
   openatlas.tbl_links.links_uid,
   openatlas.types_all_tree.name_path, -- name path contains *Evidence
   openatlas.types_all_tree.name,
   --openatlas.types_all_tree.path,
   openatlas.tbl_links.links_annotation
FROM (openatlas.tbl_links INNER JOIN openatlas.tbl_entities ON openatlas.tbl_links.links_entity_uid_to = openatlas.tbl_entities.uid) 
 INNER JOIN openatlas.types_all_tree ON openatlas.tbl_entities.uid = openatlas.types_all_tree.id
 WHERE (((openatlas.tbl_links.links_cidoc_number_direction)=1) AND ((openatlas.types_all_tree.name_path) Like '%> Evidence >%'));


--Archeological_Parent Links: Archeological units like sites, features and stratigraphical_units (E18) that are parents (is composed of - p46a) of other archeological units
     
 CREATE OR REPLACE VIEW openatlas.links_parents_arch AS 
SELECT 
   openatlas.tbl_links.links_entity_uid_from, --archeological parent like a certain Site
   openatlas.tbl_links.links_cidoc_number_direction, -- P46a
   openatlas.tbl_links.links_entity_uid_to, -- archeological child like a certain feature from a certain site
   openatlas.tbl_links.links_creator,
   openatlas.tbl_links.links_uid,
   openatlas.tbl_links.links_annotation,
   openatlas.types_all_tree.name_path,
   openatlas.types_all_tree.name,
   openatlas.types_all_tree.path,
   openatlas.tbl_entities.entity_name_uri,
   openatlas.tbl_entities.entity_description 
FROM openatlas.tbl_links 
 INNER JOIN (openatlas.tbl_entities INNER JOIN openatlas.types_all_tree ON openatlas.tbl_entities.entity_type=openatlas.types_all_tree.id)
 ON openatlas.tbl_links.links_entity_uid_to=openatlas.tbl_entities.uid 
 WHERE (((openatlas.tbl_links.links_cidoc_number_direction)=11)) 
 ORDER BY openatlas.tbl_entities.entity_name_uri, openatlas.tbl_entities.uid; 
 

 
 
 --Image Links: Entitites (e.g. sites, features and stratigraphical_units, finds etc.) that are documented (P070b) in images (E31 entities that have the type image or subtype)
     
 CREATE OR REPLACE VIEW openatlas.links_images AS  
SELECT 
   openatlas.types_all_tree.name_path, -- must contain *> Image *
   openatlas.tbl_links.links_entity_uid_from, -- entity that is documented by an image
   openatlas.tbl_links.links_entity_uid_to, -- image that shows the entity
   openatlas.tbl_links.links_cidoc_number_direction, -- is documented in (P70b)
   openatlas.tbl_entities.uid, 
   openatlas.tbl_entities.entity_id, 
   openatlas.tbl_entities.entity_name_uri, 
   openatlas.tbl_links.links_uid,
   openatlas.tbl_links.links_annotation
FROM openatlas.tbl_links 
INNER JOIN (openatlas.tbl_entities INNER JOIN openatlas.types_all_tree ON openatlas.tbl_entities.entity_type = openatlas.types_all_tree.id)
ON openatlas.tbl_links.links_entity_uid_to = openatlas.tbl_entities.uid
WHERE (((openatlas.types_all_tree.name_path) Like '%> Image %'))
ORDER BY openatlas.tbl_entities.uid;



 --Age Links: Burials/Skeletons that have a certain type (P002a) of age (type - E55, Subtype of "Age >"
     
 CREATE OR REPLACE VIEW openatlas.links_age AS
SELECT 
   openatlas.tbl_links.links_entity_uid_from, 
   openatlas.tbl_links.links_cidoc_number_direction, 
   openatlas.tbl_links.links_entity_uid_to, 
   openatlas.tbl_links.links_creator, 
   openatlas.tbl_links.links_uid, 
   openatlas.types_all_tree.name_path, 
   openatlas.types_all_tree.name, 
   openatlas.types_all_tree.path, 
   openatlas.tbl_links.links_annotation 
 FROM openatlas.tbl_links 
   INNER JOIN (openatlas.tbl_entities INNER JOIN openatlas.types_all_tree ON openatlas.tbl_entities.uid=openatlas.types_all_tree.id)
   ON openatlas.tbl_links.links_entity_uid_to=openatlas.tbl_entities.uid 
   WHERE (((openatlas.tbl_links.links_cidoc_number_direction)=1) AND ((openatlas.types_all_tree.name_path) Like '%Age >%'));


--Sex Links: Burials/Skeletons that have a certain type (P002a) of sex (type - E55, Subtype of "Sex >"
     
 CREATE OR REPLACE VIEW openatlas.links_sex AS
SELECT 
   openatlas.tbl_links.links_entity_uid_from, 
   openatlas.tbl_links.links_cidoc_number_direction, 
   openatlas.tbl_links.links_entity_uid_to, 
   openatlas.tbl_links.links_creator, 
   openatlas.tbl_links.links_uid, 
   openatlas.types_all_tree.name_path, 
   openatlas.types_all_tree.name, 
   openatlas.types_all_tree.path, 
   openatlas.tbl_links.links_annotation 
 FROM openatlas.tbl_links 
   INNER JOIN (openatlas.tbl_entities INNER JOIN openatlas.types_all_tree ON openatlas.tbl_entities.uid=openatlas.types_all_tree.id)
   ON openatlas.tbl_links.links_entity_uid_to=openatlas.tbl_entities.uid 
   WHERE (((openatlas.tbl_links.links_cidoc_number_direction)=1) AND ((openatlas.types_all_tree.name_path) Like '%Sex >%'));
   
   

--Bibliography Links: Entitites (e.g. sites, features and stratigraphical_units, finds, images etc.) that are documented (P070b) in texts (E31 entities that have a subtype of text)
     
 CREATE OR REPLACE VIEW openatlas.links_bibliography AS   
SELECT 
  openatlas.tbl_links.links_entity_uid_from, 
  --openatlas.tbl_links.links_cidoc_number_direction, 
  openatlas.tbl_links.links_entity_uid_to, 
  --openatlas.tbl_links.links_creator, 
  openatlas.tbl_links.links_uid, 
  --openatlas.types_all_tree.name_path, 
  openatlas.types_all_tree.name, 
  --openatlas.types_all_tree.path, 
  openatlas.tbl_entities.entity_name_uri, 
  openatlas.tbl_entities.entity_description, 
  openatlas.tbl_links.links_annotation
FROM openatlas.tbl_links 
   INNER JOIN (openatlas.tbl_entities INNER JOIN openatlas.types_all_tree ON openatlas.tbl_entities.entity_type = openatlas.types_all_tree.id)
    ON openatlas.tbl_links.links_entity_uid_to = openatlas.tbl_entities.uid
WHERE (((openatlas.tbl_links.links_cidoc_number_direction)=4) AND ((openatlas.types_all_tree.name_path) Like '%> Text >%'))
ORDER BY openatlas.tbl_entities.entity_name_uri, openatlas.tbl_entities.uid;



--Chronological Links: Archeological units like sites, features, stratigraphical_units and finds that are linked (P86a) to entities of Class E52 (timespan)
     
 CREATE OR REPLACE VIEW openatlas.links_chronological AS 

SELECT 
   openatlas.tbl_links.links_entity_uid_from, 
   openatlas.tbl_links.links_cidoc_number_direction, 
   openatlas.tbl_links.links_entity_uid_to, 
   openatlas.tbl_links.links_creator, 
   openatlas.tbl_links.links_uid, 
   openatlas.chronological_period_all_tree.name_path, 
   openatlas.chronological_period_all_tree.name, 
   openatlas.chronological_period_all_tree.path 
 FROM openatlas.tbl_links 
    INNER JOIN openatlas.chronological_period_all_tree ON openatlas.tbl_links.links_entity_uid_to=openatlas.chronological_period_all_tree.id 
    WHERE (((openatlas.tbl_links.links_cidoc_number_direction)=13)); 
    
    
--cultural Links: Archeological units like sites, features, stratigraphical_units and finds that are linked (P10a) to entities of Class E4 (period)
CREATE OR REPLACE VIEW openatlas.links_cultural AS 
SELECT 
  openatlas.tbl_links.links_entity_uid_from, 
  openatlas.tbl_links.links_cidoc_number_direction, 
  openatlas.tbl_links.links_entity_uid_to, 
  openatlas.tbl_links.links_creator, 
  openatlas.tbl_links.links_uid, 
  openatlas.cultural_period_all_tree.name_path, 
  openatlas.cultural_period_all_tree.name, 
  openatlas.cultural_period_all_tree.path 
FROM openatlas.tbl_links 
 INNER JOIN openatlas.cultural_period_all_tree ON openatlas.tbl_links.links_entity_uid_to=openatlas.cultural_period_all_tree.id 
 WHERE (((openatlas.tbl_links.links_cidoc_number_direction)=9)); 
   



--grave construction Links: Graves that are (P2 has tyoe) to entities of Class E55 (type) that are subtypes of 'Grave Construction'
CREATE OR REPLACE VIEW openatlas.links_graveconstruction AS    
SELECT 
   openatlas.tbl_links.links_entity_uid_from, 
   openatlas.tbl_links.links_cidoc_number_direction, 
   openatlas.tbl_links.links_entity_uid_to, 
   openatlas.tbl_links.links_creator, 
   openatlas.tbl_links.links_uid, 
   openatlas.types_all_tree.name_path, 
   openatlas.types_all_tree.name, 
   openatlas.types_all_tree.path, 
   openatlas.tbl_links.links_annotation
 FROM openatlas.tbl_links 
    INNER JOIN (openatlas.tbl_entities 
       INNER JOIN openatlas.types_all_tree 
       ON openatlas.tbl_entities.uid = openatlas.types_all_tree.id) 
    ON openatlas.tbl_links.links_entity_uid_to = openatlas.tbl_entities.uid
 WHERE (((openatlas.tbl_links.links_cidoc_number_direction)=1) AND ((openatlas.types_all_tree.name_path) Like '%Grave Construction%'));

 
 
--grave shape Links: Graves that are linked (P2 has type) to entities of Class E55 (type) that are subtypes of 'Grave Shape'
CREATE OR REPLACE VIEW openatlas.links_graveshape AS    
SELECT 
   openatlas.tbl_links.links_entity_uid_from, 
   openatlas.tbl_links.links_cidoc_number_direction, 
   openatlas.tbl_links.links_entity_uid_to, 
   openatlas.tbl_links.links_creator, 
   openatlas.tbl_links.links_uid, 
   openatlas.types_all_tree.name_path, 
   openatlas.types_all_tree.name, 
   openatlas.types_all_tree.path, 
   openatlas.tbl_links.links_annotation
 FROM openatlas.tbl_links 
    INNER JOIN (openatlas.tbl_entities 
       INNER JOIN openatlas.types_all_tree 
       ON openatlas.tbl_entities.uid = openatlas.types_all_tree.id) 
    ON openatlas.tbl_links.links_entity_uid_to = openatlas.tbl_entities.uid
 WHERE (((openatlas.tbl_links.links_cidoc_number_direction)=1) AND ((openatlas.types_all_tree.name_path) Like '%Grave Shape%'));
 
 
 --Material Links: archeological units that have a certain type (P002a) of material (E57, Subtype of "Material >"
     
 CREATE OR REPLACE VIEW openatlas.links_material AS
SELECT 
   openatlas.tbl_links.links_entity_uid_from, 
   --openatlas.tbl_links.links_cidoc_number_direction, 
   --openatlas.tbl_links.links_entity_uid_to, 
   --openatlas.tbl_links.links_creator, 
   openatlas.tbl_links.links_uid, 
   openatlas.types_all_tree.name_path, 
   openatlas.types_all_tree.name, 
   --openatlas.types_all_tree.path, 
   openatlas.tbl_links.links_annotation 
 FROM openatlas.tbl_links 
   INNER JOIN (openatlas.tbl_entities INNER JOIN openatlas.types_all_tree ON openatlas.tbl_entities.uid=openatlas.types_all_tree.id)
   ON openatlas.tbl_links.links_entity_uid_to=openatlas.tbl_entities.uid 
   WHERE (((openatlas.tbl_links.links_cidoc_number_direction)=1) AND ((openatlas.types_all_tree.name_path) Like '%Material >%'));

   
--Place Links: archeological units that are located within (P053a) places (E53)
     
 CREATE OR REPLACE VIEW openatlas.links_places AS
SELECT 
  tbl_links.links_entity_uid_from, 
  tbl_links.links_uid, 
  place_all_tree.name_path, 
  place_all_tree.name, 
  types.entity_name_uri AS type_name, 
  tbl_links.links_annotation
FROM 
  openatlas.tbl_links, 
  openatlas.place_all_tree, 
  openatlas.tbl_entities, 
  openatlas.tbl_entities types
WHERE 
  tbl_links.links_entity_uid_to = place_all_tree.id AND
  place_all_tree.id = tbl_entities.uid AND
  tbl_entities.entity_type = types.uid AND
  tbl_links.links_cidoc_number_direction = 15 AND 
  place_all_tree.name_path LIKE '%World%';
   

   
--Rights Links: entities that are that are subject to (P104a) certain rights (E30)
     
 CREATE OR REPLACE VIEW openatlas.links_rights AS
SELECT 
    openatlas.tbl_links.links_entity_uid_from, 
    openatlas.tbl_links.links_cidoc_number_direction, 
    openatlas.tbl_links.links_entity_uid_to, 
    openatlas.tbl_links.links_creator, 
    openatlas.tbl_links.links_uid, 
    openatlas.tbl_entities.classes_uid, 
    openatlas.tbl_entities.entity_name_uri, 
    openatlas.tbl_entities.entity_description, 
    openatlas.tbl_entities.entity_id
  FROM openatlas.tbl_links 
    INNER JOIN openatlas.tbl_entities ON openatlas.tbl_links.links_entity_uid_to = openatlas.tbl_entities.uid
  WHERE (((openatlas.tbl_links.links_cidoc_number_direction)=17) AND ((openatlas.tbl_entities.classes_uid)=21));
  

  
  --Rightsholder Links: entities whose rights are held (P105a) by certain actors (E39)
     
 CREATE OR REPLACE VIEW openatlas.links_rightsholder AS  
SELECT 
   openatlas.tbl_links.links_entity_uid_from, 
   openatlas.tbl_links.links_cidoc_number_direction, 
   openatlas.tbl_links.links_entity_uid_to, 
   openatlas.tbl_links.links_creator, 
   openatlas.tbl_links.links_uid, 
   openatlas.tbl_entities.classes_uid, 
   openatlas.tbl_entities.entity_name_uri, 
   openatlas.tbl_entities.entity_description, 
   openatlas.tbl_entities.entity_id
  FROM openatlas.tbl_links 
     INNER JOIN openatlas.tbl_entities ON openatlas.tbl_links.links_entity_uid_to = openatlas.tbl_entities.uid
  WHERE (((openatlas.tbl_links.links_cidoc_number_direction)=19));



  

GRANT SELECT ON ALL TABLES IN SCHEMA public TO public;
GRANT SELECT ON ALL TABLES IN SCHEMA openatlas TO public;


--GRANT ALL ON SCHEMA public TO openatla_jansaviktor; -- replace name and privileges if necessary
--GRANT ALL ON ALL TABLES IN SCHEMA openatlas TO openatla_jansaviktor; -- replace name and privileges if necessary
--GRANT ALL ON SCHEMA public TO openatla_jansaviktor; -- replace name and privileges if necessary
--GRANT ALL ON ALL TABLES IN SCHEMA openatlas TO openatla_jansaviktor; -- replace name and privileges if necessary

  


