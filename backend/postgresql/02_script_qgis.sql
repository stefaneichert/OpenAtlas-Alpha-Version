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


--this script sets up tables with types and their paths for sites, features, stratigraphical units and finds
--these tables are used in qgis to be joined with tbl_entities for to display the various entities by their types
--this script should be called from the gui after changing or adding types


-- tbl_gis_sitetypes

DROP TABLE IF EXISTS openatlas.tbl_gis_sitetypes CASCADE;
CREATE TABLE openatlas.tbl_gis_sitetypes
-- The table contains the names and paths of sites' types 
-- It is used for a join in qgis

(
  uid integer NOT NULL, -- same uid as in tbl_entities
  type_name character varying(250), -- name resp. unique appelation of entity
  path character varying(250) -- to whom it may concern
  
);

GRANT ALL ON openatlas.tbl_gis_sitetypes TO public;

INSERT INTO openatlas.tbl_gis_sitetypes (uid, type_name, path) SELECT id, name, name_path FROM openatlas.types_all_tree WHERE name_path LIKE '%Site >%';
UPDATE openatlas.tbl_gis_sitetypes SET path = replace(path, 'Types > Site > ', '');



-- tbl_gis_featuretypes
DROP TABLE IF EXISTS openatlas.tbl_gis_featuretypes CASCADE;
CREATE TABLE openatlas.tbl_gis_featuretypes
-- The table contains the names and paths of features' types 
-- It is used for a join in qgis

(
  uid integer NOT NULL, -- same uid as in tbl_entities
  type_name character varying(250), -- name resp. unique appelation of entity
  path character varying(250) -- to whom it may concern
  
);

GRANT ALL ON openatlas.tbl_gis_featuretypes TO public;

INSERT INTO openatlas.tbl_gis_featuretypes (uid, type_name, path) SELECT id, name, name_path FROM openatlas.types_all_tree WHERE name_path LIKE '%Feature >%';
UPDATE openatlas.tbl_gis_featuretypes SET path = replace(path, 'Types > Feature > ', '');


-- tbl_gis_strat_unitstypes
DROP TABLE IF EXISTS openatlas.tbl_gis_strat_unitstypes CASCADE;
CREATE TABLE openatlas.tbl_gis_strat_unitstypes
-- The table contains the names and paths of strat_units' types 
-- It is used for a join in qgis

(
  uid integer NOT NULL, -- same uid as in tbl_entities
  type_name character varying(250), -- name resp. unique appelation of entity
  path character varying(250) -- to whom it may concern
  
);

GRANT ALL ON openatlas.tbl_gis_strat_unitstypes TO public;

INSERT INTO openatlas.tbl_gis_strat_unitstypes (uid, type_name, path) SELECT id, name, name_path FROM openatlas.types_all_tree WHERE name_path LIKE '%Stratigraphical Unit >%';
UPDATE openatlas.tbl_gis_strat_unitstypes SET path = replace(path, 'Types > Stratigraphical Unit > ', '');

-- tbl_gis_findtypes
DROP TABLE IF EXISTS openatlas.tbl_gis_findtypes CASCADE;
CREATE TABLE openatlas.tbl_gis_findtypes
-- The table contains the names and paths of finds' types 
-- It is used for a join in qgis

(
  uid integer NOT NULL, -- same uid as in tbl_entities
  type_name character varying(250), -- name resp. unique appelation of entity
  path character varying(250) -- to whom it may concern
  
);

GRANT ALL ON openatlas.tbl_gis_findtypes TO public;

INSERT INTO openatlas.tbl_gis_findtypes (uid, type_name, path) SELECT id, name, name_path FROM openatlas.types_all_tree WHERE name_path LIKE '%Finds >%';
UPDATE openatlas.tbl_gis_findtypes SET path = replace(path, 'Types > Finds > ', '');

