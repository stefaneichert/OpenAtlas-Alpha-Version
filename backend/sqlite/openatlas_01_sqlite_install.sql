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


--this script sets up the backend in an sqlite database when you run it from within your spatialite-environment like e.g. the spatialite gui or from the commandline





--drop existing views and tables
DROP VIEW IF EXISTS parent_child_all;
DROP TABLE IF EXISTS all_path;
DROP TABLE IF EXISTS place_path;
DROP VIEW IF EXISTS place_parent_child;
DROP TABLE IF EXISTS chronological_period_path;
DROP VIEW IF EXISTS chronological_period_parent_child;
DROP TABLE IF EXISTS cultural_period_path;
DROP VIEW IF EXISTS cultural_period_parent_child;
DROP TABLE IF EXISTS types_path;
DROP VIEW IF EXISTS types_parent_child;
DROP TABLE IF EXISTS tbl_gis_linestring;
DROP TABLE IF EXISTS tbl_gis_polygons;
DROP TABLE IF EXISTS tbl_gis_points;
DROP TABLE IF EXISTS tbl_links;
DROP TABLE IF EXISTS tbl_entities;
DROP TABLE IF EXISTS tbl_properties;
DROP TABLE IF EXISTS tbl_classes;


-- tbl_classes

CREATE TABLE tbl_classes
-- The table tbl_classes contains the list of classes used in Open Atlas. 
-- They are derived from the  CIDOC-CRM (http://www.cidoc-crm.org/). 
-- While the name may be translated or modified the meaning must remain the same
-- The CIDOC-Number is used to clearly identify the class

(
  tbl_classes_uid INTEGER PRIMARY KEY, -- auto incrementing ongoing number
  cidoc_class_nr character varying(10), -- CIDOC-Nr. 
  cidoc_class_original_name character varying(100) NOT NULL, -- original name of the class
  cidoc_class_name_translated character varying(100) NOT NULL, -- translated name of the class 
  class_description text, -- to whom it may concern
  class_parent_cidoc_nr character varying (50), --parent class
  
  
  CONSTRAINT tbl_classes_cidoc_class_name_translated_key UNIQUE (cidoc_class_name_translated),
  CONSTRAINT tbl_classes_cidoc_class_original_name_key UNIQUE (cidoc_class_original_name)
);


--sample data classes required (if new class is added, add it at the so that the uid of the other classes stays the same)
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E001', 'CRM entity', 'CRM Entität', NULL, 'E000');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E002', 'temporal entity', 'Geschehendes', NULL, 'E001');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E004', 'period', 'Kulturphase', NULL, 'E002');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E053', 'place', 'Ort', NULL, 'E001');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E077', 'persistent item', 'Seiendes', NULL, 'E001');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E070', 'thing', 'Sache', NULL, 'E077');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E071', 'man-made thing', 'Künstliches', NULL, 'E070');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E028', 'conceptual object', 'Begrifflicher Gegenstand', NULL, 'E071');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E089', 'propositional object', 'Aussagenobjekt', NULL, 'E028');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E073', 'information object', 'Informationsgegenstand', NULL, 'E089');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E031', 'document', 'Dokument', NULL, 'E071');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E018', 'physical thing', 'Materielles', NULL, 'E070');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E055', 'type', 'Typus', NULL, 'E071');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E052', 'timespan', 'Zeitspanne', NULL, 'E001');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E019', 'physical object', 'Materieller Gegenstand', NULL, 'E018');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E039', 'actor', 'Akteur', NULL, 'E077');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E021', 'person', 'Person', NULL, 'E039');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E058', 'measurement unit', 'Masseinheit', NULL, 'E055');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E057', 'material', 'Material', NULL, 'E055');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E000', 'class root', 'Klasse Ursprung', NULL, NULL);
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E030', 'right', 'Recht', NULL, 'E089');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E005', 'event', 'Ereignis', NULL, 'E004');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E030', 'acquisition', 'Erwerb', NULL, 'E005');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E033', 'linguistic object', 'Sprachlicher Gegenstand', NULL, 'E073');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E040', 'legal body', 'Juristische Person', NULL, 'E074');
INSERT INTO tbl_classes (cidoc_class_nr, cidoc_class_original_name, cidoc_class_name_translated, class_description, class_parent_cidoc_nr) VALUES ('E074', 'group', 'Gruppe', NULL, 'E039');



--tbl_properties

CREATE TABLE tbl_properties
-- The table properties contains the a list of properties used in Open Atlas. 
-- They are derived from the CIDOC-CRM (http://www.cidoc-crm.org/). 
-- While the name may be translated or modified the meaning must remain the same
-- The CIDOC-Number in combination with the property_from_original value is used to clearly identify the property and its direction
-- one entry has a source class and a target class

(
  tbl_properties_uid INTEGER PRIMARY KEY, -- auto incrementig ongoing number
  property_cidoc_number character varying(10), -- plain CIDOC-Nr.
  property_cidoc_number_direction character varying(10), --cidoc number + "a" or "b" is used for an exact definition for the source to target relation
  property_from_original character varying(250) NOT NULL, -- name of the property (source to target)
  property_to_original character varying(250), -- name of property (target to source)
  property_to_number character varying(10), --cidoc number + "a" or "b" is used for an exact definition for the source to target relation
  property_from_translated character varying(250) NOT NULL, -- name of the property, translated (source to target)
  property_to_translated character varying(250), -- name of property, translated (target to source)
  property_description text, -- to whom it may concern
  property_domain character varying(10), --top parent class that may have the property
  property_range character varying(10) --top parent class that this property can lead to

  
  
  -- property_cidoc_number_direction uid is used as a foreign key in other tables
);


INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ('P002', 'P002a', 'has type', 'is type of', 'P002b', 'hat den Typus', 'ist Typus von', NULL, 'E001', 'E055');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ('P002', 'P002b', 'is type of', 'has type', 'P002a', 'ist Typus von', 'hat den Typus', NULL, 'E055', 'E001');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ('P070', 'P070a', 'documents', 'is documented in',  'P070b', 'beschreibt', 'wird beschrieben in', NULL, 'E031', 'E001');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ('P070', 'P070b', 'is documented in', 'documents', 'P070a', 'wird beschrieben in', 'beschreibt', NULL, 'E001', 'E031');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ('P089', 'P089a', 'falls within (spatial)', 'contains (spatial)', 'P089b', 'liegt räumlich in', 'enthält räumlich', NULL, 'E053', 'E053');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ('P089', 'P089b', 'contains (spatial)', 'falls within (spatial)', 'P089a', 'enthält räumlich', 'liegt räumlich in', NULL, 'E053', 'E053');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ('P127', 'P127a', 'has broader term', 'has narrower term', 'P127b', 'fällt in die Überkategorie', 'enthält die Unterkategorie', NULL, 'E055', 'E055');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ('P127', 'P127b', 'has narrower term', 'has broader term', 'P127a', 'enthält die Unterkategorie', 'fällt in die Überkategorie', NULL, 'E055', 'E055');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ('P010', 'P010a', 'falls within (chronological)', 'contains (chronological)', 'P010b', 'fällt zeitlich in', 'enthält zeitlich', NULL, 'E004', 'E004');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ('P010', 'P010b', 'contains (chronological)', 'falls within (chronological)', 'P010a', 'enthält zeitlich', 'fällt zeitlich in', NULL, 'E004', 'E004');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ('P046', 'P046a', 'is composed of', 'forms part of', 'P046b', 'ist zusammengesetzt aus', 'bildet Teil von', NULL, 'E018', 'E018');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ('P046', 'P046b', 'forms part of', 'is composed of', 'P046a', 'bildet Teil von', 'ist zusammengesetzt aus', NULL, 'E018', 'E018');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ('P086', 'P086a', 'falls within (chronological)', 'contains (chronological)', 'P086b', 'fällt zeitlich in', 'enthält zeitlich', NULL, 'E052', 'E052');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ('P086', 'P086b', 'contains (chronological)', 'falls within (chronological)', 'P086a', 'enthält zeitlich', 'fällt zeitlich in', NULL, 'E052', 'E052');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ('P053', 'P053a', 'has former or current location', 'is former or current location of', 'P053b', 'hat Standort', 'ist Standort von', NULL, 'E018', 'E052');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ('P053', 'P053b', 'is former or current location of', 'has former or current location', 'P053a', 'ist Standort von', 'hat Standort', NULL, 'E053', 'E018');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ( 'P104', 'P104a', 'is subject to', 'applies to', 'P104b', 'Gegenstand von', 'findet Anwendung auf', NULL, 'E072', 'E030');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ( 'P104', 'P104b', 'applies to', 'is subject to', 'P104a', 'findet Anwendung auf', 'Gegenstand von', NULL, 'E030', 'E072');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ( 'P105', 'P105a', 'right held by', 'has right on', 'P105b', 'Rechte gehören', 'hat Rechte an', NULL, 'E072', 'E039');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ( 'P105', 'P105b', 'has right on', 'right held by', 'P105a', 'hat Rechte an', 'Rechte gehören', NULL, 'E039', 'E072');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ( 'P007', 'P007a', 'took place at', 'witnessed', 'P007b', 'fand statt in', 'bezeugte', NULL, 'E004', 'E053');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ( 'P007', 'P007b', 'witnessed', 'took place at', 'P007a', 'bezeugte', 'fand statt in', NULL, 'E053', 'E004');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ( 'P012', 'P012a', 'occurred in the presence of', 'was present at', 'P012b', 'fand statt im Beisein von', 'war anwesend bei', NULL, 'E005', 'E039');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ( 'P012', 'P012b', 'was present at', 'occurred in the presence of', 'P012a', 'war anwesend bei', 'fand statt im Beisein von', NULL, 'E039', 'E005');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ( 'P015', 'P015a', 'was influenced by', 'influenced', 'P015b', 'beeinflußte', 'wurde beeinflußt durch', NULL, 'E077', 'E005');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ( 'P015', 'P015b', 'influenced', 'was influenced by', 'P015a', 'wurde beeinflußt durch', 'beeinflußte', NULL, 'E005', 'E077');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ( 'P022', 'P022a', 'transferred title to', 'acquired title through', 'P022b', 'übertrug Besitztitel auf', 'erwarb Besitztitel durch', NULL, 'E005', 'E039');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ( 'P022', 'P022b', 'acquired title through', 'transferred title to', 'P022a', 'erwarb Besitztitel durch', 'übertrug Besitztitel auf', NULL, 'E039', 'E005');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ( 'P023', 'P023a', 'transferred title from', 'surrendered title through', 'P023b', 'übertrug Besitztitel von', 'trat Besitztitel ab in', NULL, 'E005', 'E039');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ( 'P023', 'P023b', 'surrendered title through', 'transferred title from', 'P023a', 'trat Besitztitel ab in', 'übertrug Besitztitel von', NULL, 'E039', 'E005');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ( 'P024', 'P024a', 'transferred title of', 'changed ownership through', 'P024b', 'übertrug Besitz über', 'ging über in Besitz durch', NULL, 'E007', 'E018');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ( 'P024', 'P024b', 'changed ownership through', 'transferred title of', 'P024a', 'ging über in Besitz durch', 'übertrug Besitz über', NULL, 'E018', 'E007');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ( 'P073', 'P073a', 'has translation', 'is translation of', 'P073b', 'hat Übersetzung', 'ist Übersetzung von', NULL, 'E033', 'E033');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ( 'P073', 'P073b', 'is translation of', 'has translation', 'P073a', 'ist Übersetzung von', 'hat Übersetzung', NULL, 'E033', 'E033');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ( 'P107', 'P107a', 'has current or former member', 'is current or former member of', 'P107b', 'hat derzeitiges oder früheres Mitglied', 'ist derzeitiges oder früheres Mitglied von', NULL, 'E074', 'E039');
INSERT INTO tbl_properties (property_cidoc_number, property_cidoc_number_direction, property_from_original, property_to_original, property_to_number, property_from_translated, property_to_translated, property_description, property_domain, property_range) VALUES ( 'P107', 'P107b', 'is current or former member of', 'has current or former member', 'P107a', 'ist derzeitiges oder früheres Mitglied von', 'hat derzeitiges oder früheres Mitglied', NULL, 'E039', 'E074');






-- tbl_entities
------------------------------------------------------------------------------------------------------------------------


CREATE TABLE tbl_entities
-- The table contains all entities recorded in openatlas
-- The user_id should be defined as a default value within the gui
-- Triggers in the database should do the following: 
--  composition of the entity_id
--  timestamps for creation and update + user that did the last edit
--  calculate geometry field from text (given: x-y coordinates and SRID) – on insert and update
--  calculate x-y coordinates from geometry (given geometry and SRID) – on insert and update

(
  --functional
  uid INTEGER PRIMARY KEY, -- ongoig number, auto increment
  user_id character varying(10) DEFAULT 'sys', -- user id (to be inserted by the gui)
  entity_id character varying(50), -- unique entity  ID automatically composed by adding user-id and an ongoing number 
  timestamp_creation text DEFAULT NULL, -- timestamp of the creation automatically composed 
  timestamp_edit text DEFAULT NULL, -- timestamp of last edit automatically composed 
  user_edit character varying(10), -- user responsible for the last edit (to be inserted by the gui)
  
  --identification
  classes_uid integer NOT NULL, -- class_nr of the entity (original cidoc nr)
  entity_name_uri character varying(250), -- name resp. unique appelation of entity
  entity_type integer, -- main type of entity
  entity_description text, -- to whom it may concern
  entity_remarks text, -- to whom it may concern

  --temporal (and used to determine the order of several entities that should not be ordered alphabetically)
  start_time_abs integer, -- chronological beginnig of dating (year) or in case of class "period" if no absolute chronological frame is given: a value for the order of it
  end_time_abs integer, --  chronological end of dating (year)
  start_time_text character varying(50), -- additional text to handle fuzzy temporal information
  end_time_text character varying(50), -- additional text to handle fuzzy temporal information

  --dimensions
  dim_width double, -- width of entity if exists
  dim_length double, -- length of entity if exists
  dim_height double, -- height of entity if exists
  dim_thickness double, -- thickness of entity if exists
  dim_diameter double, -- diameter of entity if exists
  dim_units integer, -- units of measurement like meters, centimeters...
  dim_weight double, -- weight of the entity if exists
  dim_units_weight integer, -- units of the weight like kilogram, ton, gram
  dim_degrees integer, -- degrees (360° for full circle, clockwise, north = 0, east = 90...)

    --spatial
  x_lon_easting double, -- X-coordinate
  y_lat_northing double, -- Y-coordinate
  srid_epsg integer, -- EPSG Code /SRID of the coord. System
  geom text, --dummy for spatiallite geom field

      
  CONSTRAINT tbl_entities_entity_class_nr_fkey FOREIGN KEY (classes_uid)
      REFERENCES tbl_classes (tbl_classes_uid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION
  
  );
    
    







--triggers for automatic creation of necessary values


--------------------------------------------------------------   
 --creation of id on insert

 
 --creation of user
 DROP TRIGGER IF EXISTS autocreate_user;
 CREATE TRIGGER autocreate_user
  AFTER INSERT
  ON tbl_entities
  FOR EACH ROW
  WHEN NEW.user_id IS NULL
  
  BEGIN
    
    UPDATE tbl_entities SET user_id = 'sys' WHERE uid = NEW.uid;
    
    END;
    
    
--creation of entity_id
    DROP TRIGGER IF EXISTS autocreate_entity_id;
 CREATE TRIGGER autocreate_entity_id
  AFTER INSERT
  ON tbl_entities
  FOR EACH ROW
  WHEN NEW.entity_id IS NULL
  
  BEGIN
    
    UPDATE tbl_entities SET entity_id = NEW.user_id || '_' || NEW.uid WHERE uid = NEW.uid;
    
    END;
    
 
    
    
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Inserting/Updating Data from/to hierarchical tables
-- These Triggers do this: 
-- 1. delete from the hierarchical table
-- 2. insert the new/updated row with child and parent values
-- 3. Set the path of the top parent
-- They are used to prepare the "_path" tables for the recursive query that inserts the path into the "_tree" tables

 DROP TRIGGER IF EXISTS update_hierarchy;
 CREATE TRIGGER update_hierarchy
  AFTER UPDATE
  ON tbl_entities
    
  BEGIN 
  
   DELETE FROM all_path WHERE id = NEW.uid;
   INSERT INTO all_path (name, id, parent_id) SELECT child_name, child_uid, parent_uid FROM parent_child_all WHERE child_uid = NEW.uid; 
   UPDATE all_path SET path = 15, name_path = "Types" WHERE name = "Types";
   UPDATE all_path SET path = 36, name_path = "Cultural Periods" WHERE name = "Cultural Periods";
   UPDATE all_path SET path = 44, name_path = "Human history" WHERE name = "Human history";
   UPDATE all_path SET path = 45, name_path = "Places" WHERE name = "Places";

  
   DELETE FROM types_path WHERE id = NEW.uid;
   INSERT INTO types_path (name, id, parent_id) SELECT child_name, child_id, parent_id FROM types_parent_child WHERE child_id = NEW.uid; 
   UPDATE types_path SET path = 15, name_path = "Types" WHERE name = "Types";

  
   DELETE FROM cultural_period_path WHERE id = NEW.uid;
   INSERT INTO cultural_period_path (name, id, parent_id, order_sequence) SELECT child_name, child_id, parent_id, order_sequence FROM cultural_period_parent_child WHERE child_id = NEW.uid;
   UPDATE cultural_period_path SET path = 36, name_path = "Cultural Periods" WHERE name = "Cultural Periods";
   
   DELETE FROM chronological_period_path WHERE id = NEW.uid;
   INSERT INTO chronological_period_path (name, id, parent_id, start_time, end_time) SELECT child_name, child_id, parent_id, start_time, end_time FROM chronological_period_parent_child WHERE child_id = NEW.uid;
   UPDATE chronological_period_path SET path = 44, name_path = "Human history" WHERE name = "Human history";
   
   DELETE FROM place_path WHERE id = NEW.uid;
   INSERT INTO place_path (name, id, parent_id) SELECT child_name, child_id, parent_id FROM place_parent_child WHERE child_id = NEW.uid;
   UPDATE place_path SET path = 45, name_path = "Places" WHERE name = "Places";
   
  
  END;
   
DROP TRIGGER IF EXISTS delete_hierarchy;
 CREATE TRIGGER delete_hierarchy
  AFTER DELETE
  ON tbl_entities
    
  BEGIN 
  
   DELETE FROM all_path WHERE id = OLD.uid;
   INSERT INTO all_path (name, id, parent_id) SELECT child_name, child_uid, parent_uid FROM parent_child_all WHERE child_uid = OLD.uid; 
   UPDATE all_path SET path = 15, name_path = "Types" WHERE name = "Types";
   UPDATE all_path SET path = 36, name_path = "Cultural Periods" WHERE name = "Cultural Periods";
   UPDATE all_path SET path = 44, name_path = "Human history" WHERE name = "Human history";
   UPDATE all_path SET path = 45, name_path = "Places" WHERE name = "Places";
   
   DELETE FROM types_path WHERE id = OLD.uid;
   INSERT INTO types_path (name, id, parent_id) SELECT child_name, child_id, parent_id FROM types_parent_child WHERE child_id = OLD.uid; 
   UPDATE types_path SET path = 15, name_path = "Types" WHERE name = "Types";

   
   DELETE FROM cultural_period_path WHERE id = OLD.uid;
   INSERT INTO cultural_period_path (name, id, parent_id, order_sequence) SELECT child_name, child_id, parent_id, order_sequence FROM cultural_period_parent_child WHERE child_id = OLD.uid;
   UPDATE cultural_period_path SET path = 36, name_path = "Cultural Periods" WHERE name = "Cultural Periods";
   
   DELETE FROM chronological_period_path WHERE id = OLD.uid;
   INSERT INTO chronological_period_path (name, id, parent_id, start_time, end_time) SELECT child_name, child_id, parent_id, start_time, end_time FROM chronological_period_parent_child WHERE child_id = OLD.uid;
   UPDATE chronological_period_path SET path = 44, name_path = "Human history" WHERE name = "Human history";
   
   DELETE FROM place_path WHERE id = OLD.uid;
   INSERT INTO place_path (name, id, parent_id) SELECT child_name, child_id, parent_id FROM place_parent_child WHERE child_id = OLD.uid;
   UPDATE place_path SET path = 45, name_path = "Places" WHERE name = "Places";
   
   
   
  
  END;
 
   
-- tbl_links
CREATE TABLE tbl_links
-- The table links contains the links between one entity and another via a certain property
(
  links_uid INTEGER PRIMARY KEY, -- autoincrement, ongoing Nr. 
  links_entity_uid_from integer NOT NULL, -- source entity uid
  links_cidoc_number_direction integer NOT NULL, -- cidoc code of the property + direction as defined in tbl_properties
  links_entity_uid_to integer NOT NULL, -- target entity uid
  links_annotation text, -- remarks, description etc. E.g. for declaring a page number in case of entity of class document „refers to“ entity of class thing ecc. 
  links_creator character varying(50) DEFAULT 'sys', -- username of the link's creator
  links_timestamp_start text DEFAULT NULL, -- date or time when the property begins to be linked to the entity
  links_timestamp_end text DEFAULT NULL, -- date or time when the property ends to be linked to the entity
  links_timestamp_creation text DEFAULT NULL, -- timestamp of the creation automatically composed
  links_timespan integer, -- duration of the link i.e. the timespan in which the property links the two entities (uid of a certain E52 entity)
  CONSTRAINT tbl_links_links_cidoc_number_direction_fkey FOREIGN KEY (links_cidoc_number_direction)
      REFERENCES tbl_properties (tbl_properties_uid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT tbl_links_links_entity_id_from_fkey FOREIGN KEY (links_entity_uid_from)
      REFERENCES tbl_entities (uid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT tbl_links_links_entity_id_to_fkey FOREIGN KEY (links_entity_uid_to)
      REFERENCES tbl_entities (uid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);


-- Inserting/Updating Data from/to hierarchical tables
-- These Triggers do the following: 
-- 1. delete from the hierarchical table
-- 2. insert a column with child and parent values
-- 3. Set the path of the top parent
-- They are used to prepare the "_path" tables for the recursive query that inserts the path into the "_tree" tables

 DROP TRIGGER IF EXISTS update_hierarchy_links;
 CREATE TRIGGER update_hierarchy_links
  AFTER UPDATE
  ON tbl_links
    
  BEGIN 
  
   DELETE FROM all_path WHERE id = NEW.links_entity_uid_from;
   INSERT INTO all_path (name, id, parent_id) SELECT child_name, child_uid, parent_uid FROM parent_child_all WHERE child_uid = NEW.links_entity_uid_from; 
   UPDATE all_path SET path = 15, name_path = "Types" WHERE name = "Types";
   UPDATE all_path SET path = 36, name_path = "Cultural Periods" WHERE name = "Cultural Periods";
   UPDATE all_path SET path = 44, name_path = "Human history" WHERE name = "Human history";
   UPDATE all_path SET path = 45, name_path = "Places" WHERE name = "Places";
  
   DELETE FROM types_path WHERE id = NEW.links_entity_uid_from;
   INSERT INTO types_path (name, id, parent_id) SELECT child_name, child_id, parent_id FROM types_parent_child WHERE child_id = NEW.links_entity_uid_from; 
   UPDATE types_path SET path = 15, name_path = "Types" WHERE name = "Types";

   
   DELETE FROM cultural_period_path WHERE id = NEW.links_entity_uid_from;
   INSERT INTO cultural_period_path (name, id, parent_id, order_sequence) SELECT child_name, child_id, parent_id, order_sequence FROM cultural_period_parent_child WHERE child_id = NEW.links_entity_uid_from;
   UPDATE cultural_period_path SET path = 36, name_path = "Cultural Periods" WHERE name = "Cultural Periods";
   
   DELETE FROM chronological_period_path WHERE id = NEW.links_entity_uid_from;
   INSERT INTO chronological_period_path (name, id, parent_id, start_time, end_time) SELECT child_name, child_id, parent_id, start_time, end_time FROM chronological_period_parent_child WHERE child_id = NEW.links_entity_uid_from;
   UPDATE chronological_period_path SET path = 44, name_path = "Human history" WHERE name = "Human history";
   
   DELETE FROM place_path WHERE id = NEW.links_entity_uid_from;
   INSERT INTO place_path (name, id, parent_id) SELECT child_name, child_id, parent_id FROM place_parent_child WHERE child_id = NEW.links_entity_uid_from;
   UPDATE place_path SET path = 45, name_path = "Places" WHERE name = "Places";
   
  
  END;
  
  
DROP TRIGGER IF EXISTS insert_hierarchy_links;
 CREATE TRIGGER insert_hierarchy_links
  AFTER INSERT
  ON tbl_links
    
  BEGIN 
  
   DELETE FROM all_path WHERE id = NEW.links_entity_uid_from;
   INSERT INTO all_path (name, id, parent_id) SELECT child_name, child_uid, parent_uid FROM parent_child_all WHERE child_uid = NEW.links_entity_uid_from; 
   UPDATE all_path SET path = 15, name_path = "Types" WHERE name = "Types";
   UPDATE all_path SET path = 36, name_path = "Cultural Periods" WHERE name = "Cultural Periods";
   UPDATE all_path SET path = 44, name_path = "Human history" WHERE name = "Human history";
   UPDATE all_path SET path = 45, name_path = "Places" WHERE name = "Places";
   
   DELETE FROM types_path WHERE id = NEW.links_entity_uid_from;
   INSERT INTO types_path (name, id, parent_id) SELECT child_name, child_id, parent_id FROM types_parent_child WHERE child_id = NEW.links_entity_uid_from; 
   UPDATE types_path SET path = 15, name_path = "Types" WHERE name = "Types";

   
   DELETE FROM cultural_period_path WHERE id = NEW.links_entity_uid_from;
   INSERT INTO cultural_period_path (name, id, parent_id, order_sequence) SELECT child_name, child_id, parent_id, order_sequence FROM cultural_period_parent_child WHERE child_id = NEW.links_entity_uid_from;
   UPDATE cultural_period_path SET path = 36, name_path = "Cultural Periods" WHERE name = "Cultural Periods";
   
   DELETE FROM chronological_period_path WHERE id = NEW.links_entity_uid_from;
   INSERT INTO chronological_period_path (name, id, parent_id, start_time, end_time) SELECT child_name, child_id, parent_id, start_time, end_time FROM chronological_period_parent_child WHERE child_id = NEW.links_entity_uid_from;
   UPDATE chronological_period_path SET path = 44, name_path = "Human history" WHERE name = "Human history";
   
   DELETE FROM place_path WHERE id = NEW.links_entity_uid_from;
   INSERT INTO place_path (name, id, parent_id) SELECT child_name, child_id, parent_id FROM place_parent_child WHERE child_id = NEW.links_entity_uid_from;
   UPDATE place_path SET path = 45, name_path = "Places" WHERE name = "Places";
   
  END;

  
  DROP TRIGGER IF EXISTS delete_hierarchy_links;
 CREATE TRIGGER delete_hierarchy_links
  AFTER DELETE
  ON tbl_links
    
  BEGIN 
  
   DELETE FROM all_path WHERE id = OLD.links_entity_uid_from;
   INSERT INTO all_path (name, id, parent_id) SELECT child_name, child_uid, parent_uid FROM parent_child_all WHERE child_uid = OLD.links_entity_uid_from; 
   UPDATE all_path SET path = 15, name_path = "Types" WHERE name = "Types";
   UPDATE all_path SET path = 36, name_path = "Cultural Periods" WHERE name = "Cultural Periods";
   UPDATE all_path SET path = 44, name_path = "Human history" WHERE name = "Human history";
   UPDATE all_path SET path = 45, name_path = "Places" WHERE name = "Places";
   
   DELETE FROM types_path WHERE id = OLD.links_entity_uid_from;
   INSERT INTO types_path (name, id, parent_id) SELECT child_name, child_id, parent_id FROM types_parent_child WHERE child_id = OLD.links_entity_uid_from; 
   UPDATE types_path SET path = 15, name_path = "Types" WHERE name = "Types";

   
   DELETE FROM cultural_period_path WHERE id = OLD.links_entity_uid_from;
   INSERT INTO cultural_period_path (name, id, parent_id, order_sequence) SELECT child_name, child_id, parent_id, order_sequence FROM cultural_period_parent_child WHERE child_id = OLD.links_entity_uid_from;
   UPDATE cultural_period_path SET path = 36, name_path = "Cultural Periods" WHERE name = "Cultural Periods";
   
   DELETE FROM chronological_period_path WHERE id = OLD.links_entity_uid_from;
   INSERT INTO chronological_period_path (name, id, parent_id, start_time, end_time) SELECT child_name, child_id, parent_id, start_time, end_time FROM chronological_period_parent_child WHERE child_id = OLD.links_entity_uid_from;
   UPDATE chronological_period_path SET path = 44, name_path = "Human history" WHERE name = "Human history";
   
   DELETE FROM place_path WHERE id = OLD.links_entity_uid_from;
   INSERT INTO place_path (name, id, parent_id) SELECT child_name, child_id, parent_id FROM place_parent_child WHERE child_id = OLD.links_entity_uid_from;
   UPDATE place_path SET path = 45, name_path = "Places" WHERE name = "Places";
   
  
  END;
  
  

--gis_tables

-- tbl_gis_linestring

CREATE TABLE tbl_gis_linestring
-- table that contains linestring geometries
(
  linestring_uid INTEGER PRIMARY KEY, -- autoincrement, ongoing Nr. 
  parent_entity_id character varying(100), -- ID from parent entity
  parent_uid integer, -- uid of parent
  object_name character varying(100), -- to whom it may concern
  object_description text, -- to whom it may concern
  srid_epsg integer, -- EPSG Code /SRID of the coord. System
  geom text,
  CONSTRAINT tbl_gis_linestring_parent_entity_id_fkey FOREIGN KEY (parent_uid)
      REFERENCES tbl_entities (uid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
  );

--SELECT AddGeometryColumn ( 'tbl_gis_linestring', 'geom', -1, 'LINESTRING', 2 );

-- tbl_gis_polygons

CREATE TABLE tbl_gis_polygons
-- table that contains polygon geometries
(
  polygons_uid INTEGER PRIMARY KEY, -- autoincrement, ongoing Nr. 
  parent_entity_id character varying(100), -- ID from parent entity
  parent_uid integer, -- uid of parent
  object_name character varying(100), -- to whom it may concern
  object_description text, -- to whom it may concern
  srid_epsg integer, -- EPSG Code /SRID of the coord. System
  geom text,
  CONSTRAINT tbl_gis_polygons_parent_entity_id_fkey FOREIGN KEY (parent_uid)
      REFERENCES tbl_entities (uid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
  );

--SELECT AddGeometryColumn ( 'tbl_gis_polygons', 'geom', -1, 'POLYGON', 2 );

-- tbl_gis_points

CREATE TABLE tbl_gis_points
-- table that contains polygon geometries
(
  points_uid INTEGER PRIMARY KEY, -- autoincrement, ongoing Nr. 
  parent_entity_id character varying(100), -- ID from parent entity
  parent_uid integer, -- uid of parent
  object_name character varying(100), -- to whom it may concern
  object_description text, -- to whom it may concern
  srid_epsg integer, -- EPSG Code /SRID of the coord. System
  geom text,
  CONSTRAINT tbl_gis_points_parent_entity_id_fkey FOREIGN KEY (parent_uid)
      REFERENCES tbl_entities (uid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
  );

--SELECT AddGeometryColumn ( 'tbl_gis_points', 'geom', -1, 'POINT', 2 );




--view parent_child_all (needed for tree-editor)
CREATE VIEW parent_child_all AS 
 SELECT 
    tbl_entities.uid AS child_uid,
    tbl_entities.entity_name_uri AS child_name,
    tbl_links.links_cidoc_number_direction AS link,
    tbl_entities_1.uid AS parent_uid, 
    tbl_entities_1.entity_name_uri AS parent_name 
   FROM tbl_entities
   JOIN tbl_links ON tbl_entities.uid = tbl_links.links_entity_uid_from
   JOIN tbl_entities tbl_entities_1 ON tbl_links.links_entity_uid_to = tbl_entities_1.uid;

   
--all path
CREATE TABLE all_path
  (
    name character varying(250),
    id integer,
    path text,
    parent_id integer,
    name_path text
 );   

--view types parent_child (needed for recursive view "types_path")

CREATE VIEW types_parent_child AS 
 SELECT 
    tbl_entities_1.uid AS parent_id,
    tbl_entities_1.entity_name_uri AS parent_name, 
    tbl_entities.uid AS child_id, 
    tbl_entities.entity_name_uri AS child_name
   FROM tbl_entities
   JOIN tbl_links ON tbl_entities.uid = tbl_links.links_entity_uid_from
   JOIN tbl_entities tbl_entities_1 ON tbl_links.links_entity_uid_to = tbl_entities_1.uid
  WHERE tbl_links.links_cidoc_number_direction = 7 AND (tbl_entities.classes_uid = 13 OR tbl_entities.classes_uid = 18 OR tbl_entities.classes_uid = 19);
  

  
  --types_path   
  
CREATE TABLE types_path
  (
    name character varying(250),
    id integer,
    path text,
    parent_id integer,
    name_path text
 );   
 
 
 

 
-- view_cultural_period_parent_child (needed for recursive view "cultural_period_path")
CREATE VIEW cultural_period_parent_child AS 
 SELECT tbl_entities_1.uid AS parent_id, 
    tbl_entities_1.entity_name_uri AS parent_name, 
    tbl_entities.uid AS child_id, 
    tbl_entities.entity_name_uri AS child_name,
    tbl_entities.start_time_abs AS order_sequence
   FROM tbl_entities
   JOIN tbl_links ON tbl_entities.uid = tbl_links.links_entity_uid_from
   JOIN tbl_entities tbl_entities_1 ON tbl_links.links_entity_uid_to = tbl_entities_1.uid
  WHERE tbl_links.links_cidoc_number_direction = 9 AND tbl_entities.classes_uid = 3;
  
  
-- cultural_period_path
CREATE TABLE cultural_period_path
(
    name character varying(250),
    id integer,
    path text,
    parent_id integer,
    name_path text,
    order_sequence integer
 );

 
 
 
-- view_chronological_period_parent_child (needed for recursive view "chronological_period_path") 
 CREATE VIEW chronological_period_parent_child AS 
 SELECT tbl_entities_1.uid AS parent_id, 
    tbl_entities_1.entity_name_uri AS parent_name, tbl_entities.uid AS child_id, 
    tbl_entities.entity_name_uri AS child_name, 
    tbl_entities.start_time_abs AS start_time, 
    tbl_entities.end_time_abs AS end_time
   FROM tbl_entities
   JOIN tbl_links ON tbl_entities.uid = tbl_links.links_entity_uid_from
   JOIN tbl_entities tbl_entities_1 ON tbl_links.links_entity_uid_to = tbl_entities_1.uid
  WHERE tbl_links.links_cidoc_number_direction = 13 AND tbl_entities.entity_type = 14
  ORDER BY tbl_entities.start_time_abs, tbl_entities.end_time_abs DESC;
  
  
  
-- chronological_period_all_tree
CREATE TABLE chronological_period_path
(
    name character varying(250),
    id integer,
    path text,
    parent_id integer,
    name_path text,
    start_time integer,
    end_time integer
 );
 

 
 -- view_places_parent_child 
 CREATE VIEW place_parent_child AS 
 SELECT tbl_entities_1.uid AS parent_id, 
    tbl_entities_1.entity_name_uri AS parent_name, tbl_entities.uid AS child_id, 
    tbl_entities.entity_name_uri AS child_name, 
    tbl_entities.entity_type AS type
   FROM tbl_entities
   JOIN tbl_links ON tbl_entities.uid = tbl_links.links_entity_uid_from
   JOIN tbl_entities tbl_entities_1 ON tbl_links.links_entity_uid_to = tbl_entities_1.uid
  WHERE tbl_links.links_cidoc_number_direction = 5 AND tbl_entities.classes_uid = 4;
  
  
 --place_path   
  
CREATE TABLE place_path
  (
    name character varying(250),
    id integer,
    path text,
    parent_id integer,
    name_path text
 );   
 
 
 
 
--Create tables with path of types, places, periods and timespans
--these tables need to be manually updated after the entitites have been inserted or changed by inserting the top parent of the category in order to fire the recursive trigger
--this needs to be done seperately and PRAGMA recursive_triggers have to be enabled before and disabled after from within another script


--all
DROP TABLE IF EXISTS all_tree;
CREATE TABLE all_tree 
(
name character varying(250),
uid INTEGER,
path TEXT,
parent_id INTEGER,
name_path TEXT
);


CREATE TRIGGER find_path_all AFTER INSERT ON all_tree BEGIN
 INSERT INTO all_tree (name, uid, parent_id, path, name_path) 
  SELECT 
   name,
   id,
   parent_id,
   NEW.path || " > " || id,
   NEW.name_path || " > " || name 
  FROM all_path
 WHERE
   all_path.parent_id = NEW.uid;



END;



--types
DROP TABLE IF EXISTS types_all_tree;
CREATE TABLE types_all_tree 
(
name character varying(250),
id INTEGER,
path TEXT,
parent_id INTEGER,
name_path TEXT
);


CREATE TRIGGER find_path AFTER INSERT ON types_all_tree BEGIN
 INSERT INTO types_all_tree (name, id, parent_id, path, name_path) 
  SELECT 
   name,
   id,
   parent_id,
   NEW.path || " > " || id,
   NEW.name_path || " > " || name 
  FROM types_path
 WHERE
   types_path.parent_id = NEW.id;



END;



--cultural periods

DROP TABLE IF EXISTS cultural_period_all_tree;
CREATE TABLE cultural_period_all_tree
(
    name character varying(250),
    id integer,
    path text,
    parent_id integer,
    name_path text,
    order_sequence integer
);



CREATE TRIGGER find_path_cult_per AFTER INSERT ON cultural_period_all_tree BEGIN
 INSERT INTO cultural_period_all_tree (name, id, parent_id, path, name_path, order_sequence) 
  SELECT 
   name,
   id,
   parent_id,
   NEW.path || " > " || id,
   NEW.name_path || " > " || name,
   order_sequence
  FROM cultural_period_path
 WHERE
   cultural_period_path.parent_id = NEW.id;



END;





--chronological periods

DROP TABLE IF EXISTS chronological_period_all_tree;
CREATE TABLE chronological_period_all_tree
(
   name character varying(250),
    id integer,
    path text,
    parent_id integer,
    name_path text,
    start_time integer,
    end_time integer
);




CREATE TRIGGER find_path_chron_per AFTER INSERT ON chronological_period_all_tree BEGIN
 INSERT INTO chronological_period_all_tree (name, id, parent_id, path, name_path, start_time, end_time) 
  SELECT 
   name,
   id,
   parent_id,
   NEW.path || " > " || id,
   NEW.name_path || " > " || name,
   start_time,
   end_time
  FROM chronological_period_path
 WHERE
   chronological_period_path.parent_id = NEW.id;



END;



--places

DROP TABLE IF EXISTS place_all_tree;
CREATE TABLE place_all_tree
  (
    name character varying(250),
    id integer,
    path text,
    parent_id integer,
    name_path text
 );
 
 


CREATE TRIGGER find_path_place AFTER INSERT ON place_all_tree BEGIN
 INSERT INTO place_all_tree (name, id, parent_id, path, name_path) 
  SELECT 
   name,
   id,
   parent_id,
   NEW.path || " > " || id,
   NEW.name_path || " > " || name
  FROM place_path
 WHERE
   place_path.parent_id = NEW.id;



END;






--insert required data
--required data Types

INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_003', 13, 'Feature');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_269', 13, 'Finds');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_277', 13, 'Site');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_279', 13, 'Stratigraphical Unit');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_282', 13, 'Evidence');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_283', 13, 'History');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_286', 13, 'Archaeology');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_293', 13, 'Reference');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_294', 13, 'Image');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_295', 13, 'Text');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_296', 13, 'Scientific Literature');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_297', 13, 'Primary Source');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_298', 13, 'Cultural Period');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_307', 13, 'Chronological Period');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_322', 13, 'Types');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_323', 13, 'Administrative Unit');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_324', 13, 'Continent');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_321', 13, 'open_atlas_hierarchy');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_331', 13, 'Measurement Units');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_332', 13, 'Distance');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_333', 18, 'Kilometer');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_334', 18, 'Meter');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_335', 18, 'Centimeter');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_336', 18, 'Millimeter');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_337', 13, 'Weight');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_338', 18, 'Ton');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_339', 18, 'Kilogram');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Typ_340', 18, 'Gram');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Sex_001', 13, 'Sex');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Sex_002', 13, 'Male');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Sex_003', 13, 'Female');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Age_001', 13, 'Age');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Age_002', 13, 'Adult');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Age_003', 13, 'Child');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri) VALUES ('Mat_001', 13, 'Material');


--sample data cultural periods required
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri, entity_type, start_time_abs) VALUES ('Per_001', 3, 'Cultural Periods', 13, '0');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri, entity_type, start_time_abs) VALUES ('Per_002', 3, 'Stone Age', 13, '-2000000');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri, entity_type, start_time_abs) VALUES ('Per_003', 3, 'Bronze Age', 13, '-3000');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri, entity_type, start_time_abs) VALUES ('Per_004', 3, 'Iron Age', 13, '-800');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri, entity_type, start_time_abs) VALUES ('Per_005', 3, 'Roman', 13, '1');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri, entity_type, start_time_abs) VALUES ('Per_006', 3, 'Medieval', 13, '500');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri, entity_type, start_time_abs) VALUES ('Per_007', 3, 'Modern Age', 13, '1500');

--sample data chronological periods required
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri, entity_type, start_time_abs, end_time_abs) VALUES ('chr_001', 14, 'Chronological Periods', 14, '-99999999', '2000');
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri, entity_type, start_time_abs, end_time_abs) VALUES ('chr_002', 14, 'Human history', 14, '-2000000', '2000');

--sample data places required
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri, entity_type) VALUES ('pla_001', 4, 'Places', NULL);
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri, entity_type) VALUES ('pla_002', 4, 'World', 17);
INSERT INTO tbl_entities (entity_id, classes_uid, entity_name_uri, entity_type) VALUES ('pla_003', 4, 'Europe', 17);
   
   
   

--sample data links
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'pla_001'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P089a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_321'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'chr_001'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_321'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Per_001'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P010a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_321'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_003'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_322'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_269'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_322'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_277'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_322'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_279'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_322'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_282'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_322'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_283'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_282'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_286'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_282'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_293'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_322'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_294'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_293'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_295'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_293'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_296'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_295'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_297'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_295'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_298'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_322'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_307'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_322'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_322'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_321'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_323'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_322'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_324'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_323'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_331'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_322'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_332'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_331'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_333'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_332'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_334'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_332'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_335'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_332'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_336'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_332'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_337'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_331'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_338'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_337'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_339'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_337'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_340'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_337'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Mat_001'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_322'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Sex_001'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_322'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Sex_002'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Sex_001'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Sex_003'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Sex_001'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Age_001'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Typ_322'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Age_002'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Age_001'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Age_003'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P127a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Age_001'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'pla_002'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P089a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'pla_001'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'chr_002'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P086a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'chr_001'));  
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Per_002'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P010a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Per_001'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Per_003'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P010a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Per_001'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Per_004'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P010a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Per_001'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Per_005'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P010a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Per_001'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Per_006'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P010a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Per_001'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'Per_007'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P010a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'Per_001'));
INSERT INTO tbl_links (links_entity_uid_from, links_cidoc_number_direction, links_entity_uid_to) VALUES ((SELECT uid FROM tbl_entities WHERE entity_id = 'pla_003'), (SELECT tbl_properties_uid serial FROM tbl_properties WHERE property_cidoc_number_direction = 'P089a'), (SELECT uid FROM tbl_entities WHERE entity_id = 'pla_002'));






 
 