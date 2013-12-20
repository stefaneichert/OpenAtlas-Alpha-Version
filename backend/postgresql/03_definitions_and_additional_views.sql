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
  types_all_tree.name_path  -- v
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
  types_all_tree.name_path  -- v
FROM 
  openatlas.types_all_tree, 
  openatlas.tbl_entities
WHERE 
  tbl_entities.entity_type = types_all_tree.id AND
  tbl_entities.classes_uid = 12 AND -- entity has to be a physical thing
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
  types_all_tree.name_path  -- v
FROM 
  openatlas.types_all_tree, 
  openatlas.tbl_entities
WHERE 
  tbl_entities.entity_type = types_all_tree.id AND
  tbl_entities.classes_uid = 12 AND -- entity has to be a physical thing
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
  types_all_tree.name_path  -- v
FROM 
  openatlas.types_all_tree, 
  openatlas.tbl_entities
WHERE 
  tbl_entities.entity_type = types_all_tree.id AND
  tbl_entities.classes_uid = 15 AND -- entity has to be a physical thing
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


--GRANT ALL ON SCHEMA openatlas TO openatla_jansaviktor; -- replace name and privileges if necessary
--GRANT ALL ON ALL TABLES IN SCHEMA openatlas TO openatla_jansaviktor; -- replace name and privileges if necessary

  
