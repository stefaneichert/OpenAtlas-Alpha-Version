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
--    WEB-Frontend developed by Stefan Eichert                              --
--    Qt-Frontend developed by Viktor Jansa 2013, viktor.jansa@gmx.net      --
--                                                                          --
------------------------------------------------------------------------------


--create/replace new schema

DROP SCHEMA IF EXISTS openatlasweb CASCADE; 

CREATE SCHEMA openatlasweb;



--Archeological_Parent Links: Archeological units like sites, features and stratigraphical_units (E18) that are parents (is composed of - p46a) of other archeological units
DROP TABLE IF EXISTS openatlasweb.web_fe_links CASCADE;
CREATE TABLE openatlasweb.web_fe_links

(
    uniqueindex serial,
    uid_from integer,
    uid_to integer,
    typename text,
    unitname text,
    description text,
    

  CONSTRAINT archparents_pkey PRIMARY KEY (uniqueindex)
);


INSERT INTO openatlasweb.web_fe_links
    (uid_from,
    uid_to,
    typename,
    unitname,
    description)
  SELECT
   openatlas.tbl_links.links_entity_uid_from, --archeological parent like a certain Site
   openatlas.tbl_links.links_entity_uid_to,
   openatlas.types_all_tree.name,
   openatlas.tbl_entities.entity_name_uri,
   openatlas.tbl_entities.entity_description 
FROM openatlas.tbl_links 
 INNER JOIN (openatlas.tbl_entities INNER JOIN openatlas.types_all_tree ON openatlas.tbl_entities.entity_type=openatlas.types_all_tree.id)
 ON openatlas.tbl_links.links_entity_uid_to=openatlas.tbl_entities.uid 
 WHERE (((openatlas.tbl_links.links_cidoc_number_direction)=11)) 
 ORDER BY openatlas.tbl_entities.entity_name_uri, openatlas.tbl_entities.uid; 


--links for evidence
DROP TABLE IF EXISTS openatlasweb.web_fe_links_evidence CASCADE;
CREATE TABLE openatlasweb.web_fe_links_evidence

(
    uniqueindex serial,
    uid_from integer,
    uid_to integer,
    evidence text,
        

  CONSTRAINT evidence_pkey PRIMARY KEY (uniqueindex)
);


INSERT INTO openatlasweb.web_fe_links_evidence
    (uid_from,
    uid_to,
    evidence)
  SELECT 
   openatlas.tbl_links.links_entity_uid_from, -- Site/Feature etc. that is known by a certain type of evidence
   openatlas.tbl_links.links_entity_uid_to,
   openatlas.types_all_tree.name
   FROM (openatlas.tbl_links INNER JOIN openatlas.tbl_entities ON openatlas.tbl_links.links_entity_uid_to = openatlas.tbl_entities.uid) 
 INNER JOIN openatlas.types_all_tree ON openatlas.tbl_entities.uid = openatlas.types_all_tree.id
 WHERE (((openatlas.tbl_links.links_cidoc_number_direction)=1) AND ((openatlas.types_all_tree.name_path) Like '%Evidence%'));
 
 
 --Image Links: Entitites (e.g. sites, features and stratigraphical_units, finds etc.) that are documented (P070b) in images (E31 entities that have the type image or subtype)
     
DROP TABLE IF EXISTS openatlasweb.web_fe_links_images CASCADE;
CREATE TABLE openatlasweb.web_fe_links_images

(
    uniqueindex serial,
    uid_from integer,
    entity_id text,
        

  CONSTRAINT images_pkey PRIMARY KEY (uniqueindex)
);


INSERT INTO openatlasweb.web_fe_links_images
    (uid_from,
    entity_id
    )
  SELECT 

   openatlas.tbl_links.links_entity_uid_from, -- entity that is documented by an image
   openatlas.tbl_entities.entity_id 
 FROM openatlas.tbl_links 
INNER JOIN (openatlas.tbl_entities INNER JOIN openatlas.types_all_tree ON openatlas.tbl_entities.entity_type = openatlas.types_all_tree.id)
ON openatlas.tbl_links.links_entity_uid_to = openatlas.tbl_entities.uid
WHERE (((openatlas.types_all_tree.name_path) Like '%> Image %'))
ORDER BY openatlas.tbl_entities.uid;




--Bibliography Links: Entitites (e.g. sites, features and stratigraphical_units, finds, images etc.) that are documented (P070b) in texts (E31 entities that have a subtype of text)

DROP TABLE IF EXISTS openatlasweb.web_fe_links_bibliography CASCADE;
CREATE TABLE openatlasweb.web_fe_links_bibliography

(
    uniqueindex serial,
    uid_from integer,
    authoryear text,
    citation text,
    pages text,    

  CONSTRAINT bib_pkey PRIMARY KEY (uniqueindex)
);


INSERT INTO openatlasweb.web_fe_links_bibliography
    (uid_from,
    authoryear,
    citation,
    pages)
 SELECT 
  openatlas.tbl_links.links_entity_uid_from, 
  openatlas.tbl_entities.entity_name_uri, 
  openatlas.tbl_entities.entity_description, 
  openatlas.tbl_links.links_annotation
FROM openatlas.tbl_links 
   INNER JOIN (openatlas.tbl_entities INNER JOIN openatlas.types_all_tree ON openatlas.tbl_entities.entity_type = openatlas.types_all_tree.id)
    ON openatlas.tbl_links.links_entity_uid_to = openatlas.tbl_entities.uid
WHERE (((openatlas.tbl_links.links_cidoc_number_direction)=4) AND ((openatlas.types_all_tree.name_path) Like '%> Text >%'))
ORDER BY openatlas.tbl_entities.entity_name_uri, openatlas.tbl_entities.uid;



--Chronological Links: Archeological units like sites, features, stratigraphical_units and finds that are linked (P86a) to entities of Class E52 (timespan)

DROP TABLE IF EXISTS openatlasweb.web_fe_links_chronological CASCADE;
CREATE TABLE openatlasweb.web_fe_links_chronological

(
    uniqueindex serial,
    uid_from integer,
    period text,    

  CONSTRAINT chron_pkey PRIMARY KEY (uniqueindex)
);


INSERT INTO openatlasweb.web_fe_links_chronological
    (uid_from,
    period)
  SELECT 
   openatlas.tbl_links.links_entity_uid_from, 
   openatlas.chronological_period_all_tree.name_path 
  FROM openatlas.tbl_links 
    INNER JOIN openatlas.chronological_period_all_tree ON openatlas.tbl_links.links_entity_uid_to=openatlas.chronological_period_all_tree.id 
    WHERE (((openatlas.tbl_links.links_cidoc_number_direction)=13)); 
    
    
--cultural Links: Archeological units like sites, features, stratigraphical_units and finds that are linked (P10a) to entities of Class E4 (period)
DROP TABLE IF EXISTS openatlasweb.web_fe_links_cultural CASCADE;
CREATE TABLE openatlasweb.web_fe_links_cultural

(
    uniqueindex serial,
    uid_from integer,
    cultperiod text,    

  CONSTRAINT cult_pkey PRIMARY KEY (uniqueindex)
);


INSERT INTO openatlasweb.web_fe_links_cultural
    (uid_from,
    cultperiod)
  SELECT  
  openatlas.tbl_links.links_entity_uid_from, 
  openatlas.cultural_period_all_tree.name_path 
 FROM openatlas.tbl_links 
 INNER JOIN openatlas.cultural_period_all_tree ON openatlas.tbl_links.links_entity_uid_to=openatlas.cultural_period_all_tree.id 
 WHERE (((openatlas.tbl_links.links_cidoc_number_direction)=9)); 
   

   
--Place Links: archeological units that are located within (P053a) places (E53)

DROP TABLE IF EXISTS openatlasweb.web_fe_links_places CASCADE;
CREATE TABLE openatlasweb.web_fe_links_places

(
    uniqueindex serial,
    uid_from integer,
    placepath text,
    placetype text,
    parcel text,    

  CONSTRAINT place_pkey PRIMARY KEY (uniqueindex)
);


INSERT INTO openatlasweb.web_fe_links_places
    (uid_from,
    placepath,
    placetype,
    parcel)
SELECT 
    openatlas.tbl_links.links_entity_uid_from, 
    openatlas.place_all_tree.name_path, 
    tbl_entities_1.entity_name_uri AS type_name, 
    openatlas.tbl_links.links_annotation
  FROM (openatlas.tbl_links 
     INNER JOIN openatlas.place_all_tree ON openatlas.tbl_links.links_entity_uid_to = openatlas.place_all_tree.id) 
     INNER JOIN (openatlas.tbl_entities INNER JOIN openatlas.tbl_entities AS tbl_entities_1 ON openatlas.tbl_entities.entity_type = tbl_entities_1.uid) 
     ON openatlas.place_all_tree.id = openatlas.tbl_entities.uid
  WHERE (((openatlas.tbl_links.links_cidoc_number_direction)=15) AND ((openatlas.place_all_tree.name_path) Like '%Europe%'));



-------SITES and children-------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------


--create table for sites (web) and insert sites with wgs84 coordinates

DROP TABLE IF EXISTS openatlasweb.web_fe_tbl_sites CASCADE;
CREATE TABLE openatlasweb.web_fe_tbl_sites

(
    uniqueindex serial,
    old_uid integer,
    entity_id text,
    sitename text, 
    sitetype text, 
    description text,
    starttime integer,
    endtime integer,
    start_time_text text, 
    end_time_text text, 
    easting double precision,
    northing double precision,
    markertype text,
    parent integer,  
    

  CONSTRAINT web_sites_pkey PRIMARY KEY (uniqueindex)
);

--insert site data
INSERT INTO openatlasweb.web_fe_tbl_sites 
    (
    old_uid,
    entity_id, 
    sitename, 
    sitetype, 
    description, 
    starttime, 
    endtime, 
    start_time_text, 
    end_time_text, 
    easting,
    northing)  
 SELECT
    tbl_entities.uid,
    tbl_entities.entity_id,
    tbl_entities.entity_name_uri, 
    replace(types_all_tree.name_path, 'Types > Site > '::text, ''::text), 
    tbl_entities.entity_description,
    tbl_entities.start_time_abs, 
    tbl_entities.end_time_abs, 
    tbl_entities.start_time_text, 
    tbl_entities.end_time_text, 
    st_x(st_transform(st_setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326)), 
    st_y(st_transform(st_setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326))
   FROM openatlas.types_all_tree, openatlas.tbl_entities
  WHERE tbl_entities.entity_type = types_all_tree.id AND tbl_entities.classes_uid = 12 AND types_all_tree.name_path ~~ '%> Site%'::text 
  ORDER BY tbl_entities.entity_name_uri;

  UPDATE openatlasweb.web_fe_tbl_sites SET easting = 2000, northing = 2000 where easting > 180;
  UPDATE openatlasweb.web_fe_tbl_sites SET easting = 2000, northing = 2000 where northing > 90;
  UPDATE openatlasweb.web_fe_tbl_sites SET easting = 2000, northing = 2000 where easting < -180;
  UPDATE openatlasweb.web_fe_tbl_sites SET easting = 2000, northing = 2000 where northing < -90;
  UPDATE openatlasweb.web_fe_tbl_sites SET easting = 2000, northing = 2000 where easting IS NULL;
  UPDATE openatlasweb.web_fe_tbl_sites SET markertype = 'resources/images/logos/maps/questionmark.png';
  UPDATE openatlasweb.web_fe_tbl_sites SET markertype = 'resources/images/logos/maps/settlement.png' WHERE sitetype LIKE 'Settlement%';
  UPDATE openatlasweb.web_fe_tbl_sites SET markertype = 'resources/images/logos/maps/hillfort.png' WHERE sitetype LIKE '%Hilltop%';
  UPDATE openatlasweb.web_fe_tbl_sites SET markertype = 'resources/images/logos/maps/bishopric.png' WHERE sitetype LIKE '%> Bishopric%';
  UPDATE openatlasweb.web_fe_tbl_sites SET markertype = 'resources/images/logos/maps/monastery.png' WHERE sitetype LIKE '%> Monastery%';
  UPDATE openatlasweb.web_fe_tbl_sites SET markertype = 'resources/images/logos/maps/church.png' WHERE sitetype LIKE '%> Church%';
  UPDATE openatlasweb.web_fe_tbl_sites SET markertype = 'resources/images/logos/maps/cemetery.png' WHERE sitetype LIKE '%Burial%';
  UPDATE openatlasweb.web_fe_tbl_sites SET markertype = 'resources/images/logos/maps/churchyard.png' WHERE sitetype LIKE '%Churchyard%';
  UPDATE openatlasweb.web_fe_tbl_sites SET markertype = 'resources/images/logos/maps/mountain.png' WHERE sitetype LIKE '%Mountain%';
  UPDATE openatlasweb.web_fe_tbl_sites SET markertype = 'resources/images/logos/maps/economy.png' WHERE sitetype LIKE '%Economic%';
  UPDATE openatlasweb.web_fe_tbl_sites SET markertype = 'resources/images/logos/maps/road.png' WHERE sitetype LIKE '%Way%';
  UPDATE openatlasweb.web_fe_tbl_sites SET markertype = 'resources/images/logos/maps/watercrossing.png' WHERE sitetype LIKE '%Watercrossing%';
  UPDATE openatlasweb.web_fe_tbl_sites SET markertype = 'resources/images/logos/maps/boundary.png' WHERE sitetype LIKE '%Boundary%';
  UPDATE openatlasweb.web_fe_tbl_sites SET markertype = 'resources/images/logos/maps/strayfind.png' WHERE sitetype LIKE '%Strayfind%';
  UPDATE openatlasweb.web_fe_tbl_sites SET markertype = 'resources/images/logos/maps/lake.png' WHERE sitetype LIKE '%Waterbody%';
  
  
  
  


--table for features
DROP TABLE IF EXISTS openatlasweb.web_fe_tbl_features CASCADE;
CREATE TABLE openatlasweb.web_fe_tbl_features

(
    uniqueindex serial,
    old_uid integer,
    entity_id text,
    sitename text, 
    sitetype text, 
    description text,
    starttime integer,
    endtime integer,
    start_time_text text, 
    end_time_text text, 
    easting double precision,
    northing double precision,
    markertype text,
    markercolor text,
    parent integer,  
    

  CONSTRAINT web_features_pkey PRIMARY KEY (uniqueindex)
);

--insert feauture data
INSERT INTO openatlasweb.web_fe_tbl_features 
    (
    old_uid,
    entity_id, 
    sitename, 
    sitetype, 
    description, 
    starttime, 
    endtime, 
    start_time_text, 
    end_time_text, 
    easting,
    northing,
    parent)  
 SELECT
    tbl_entities.uid,
    tbl_entities.entity_id,
    tbl_entities.entity_name_uri, 
    replace(types_all_tree.name_path, 'Types > Feature > '::text, ''::text), 
    tbl_entities.entity_description,
    tbl_entities.start_time_abs, 
    tbl_entities.end_time_abs, 
    tbl_entities.start_time_text, 
    tbl_entities.end_time_text, 
    st_x(st_transform(st_setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326)), 
    st_y(st_transform(st_setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326)),
    uid_from
   FROM openatlas.types_all_tree, openatlas.tbl_entities, openatlasweb.web_fe_links
  WHERE tbl_entities.entity_type = types_all_tree.id AND tbl_entities.uid = web_fe_links.uid_to AND tbl_entities.classes_uid = 12 AND types_all_tree.name_path ~~ '%> Feature%'::text 
  ORDER BY tbl_entities.entity_name_uri;

  UPDATE openatlasweb.web_fe_tbl_sites SET easting = 2000, northing = 2000 where easting > 180;
  UPDATE openatlasweb.web_fe_tbl_sites SET easting = 2000, northing = 2000 where northing > 90;
  UPDATE openatlasweb.web_fe_tbl_sites SET easting = 2000, northing = 2000 where easting < -180;
  UPDATE openatlasweb.web_fe_tbl_sites SET easting = 2000, northing = 2000 where northing < -90;
  UPDATE openatlasweb.web_fe_tbl_sites SET easting = 2000, northing = 2000 where easting IS NULL;
  

	--table for strats
	DROP TABLE IF EXISTS openatlasweb.web_fe_tbl_strats CASCADE;
	CREATE TABLE openatlasweb.web_fe_tbl_strats

	(
	    uniqueindex serial,
	    old_uid integer,
	    entity_id text,
	    sitename text, 
	    sitetype text, 
	    description text,
	    starttime integer,
	    endtime integer,
	    start_time_text text, 
	    end_time_text text, 
	    easting double precision,
	    northing double precision,
	    markertype text,
	    markercolor text,
	    parent integer,  
	    

	  CONSTRAINT web_strats_pkey PRIMARY KEY (uniqueindex)
	);

	--insert strat data
	INSERT INTO openatlasweb.web_fe_tbl_strats 
	    (
	    old_uid,
	    entity_id, 
	    sitename, 
	    sitetype, 
	    description, 
	    starttime, 
	    endtime, 
	    start_time_text, 
	    end_time_text, 
	    easting,
	    northing,
	    parent)  
	 SELECT
	    tbl_entities.uid,
	    tbl_entities.entity_id,
	    tbl_entities.entity_name_uri, 
	    replace(types_all_tree.name_path, 'Types > Stratigraphical Unit > '::text, ''::text), 
	    tbl_entities.entity_description,
	    tbl_entities.start_time_abs, 
	    tbl_entities.end_time_abs, 
	    tbl_entities.start_time_text, 
	    tbl_entities.end_time_text, 
	    st_x(st_transform(st_setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326)), 
	    st_y(st_transform(st_setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326)),
	    uid_from
	   FROM openatlas.types_all_tree, openatlas.tbl_entities, openatlasweb.web_fe_links
	  WHERE tbl_entities.entity_type = types_all_tree.id AND tbl_entities.uid = web_fe_links.uid_to AND tbl_entities.classes_uid = 12 AND types_all_tree.name_path ~~ '%> Stratigraphical Unit%'::text 
	  ORDER BY tbl_entities.entity_name_uri;

	  UPDATE openatlasweb.web_fe_tbl_sites SET easting = 2000, northing = 2000 where easting > 180;
	  UPDATE openatlasweb.web_fe_tbl_sites SET easting = 2000, northing = 2000 where northing > 90;
	  UPDATE openatlasweb.web_fe_tbl_sites SET easting = 2000, northing = 2000 where easting < -180;
	  UPDATE openatlasweb.web_fe_tbl_sites SET easting = 2000, northing = 2000 where northing < -90;
	  UPDATE openatlasweb.web_fe_tbl_sites SET easting = 2000, northing = 2000 where easting IS NULL;

--table for finds
DROP TABLE IF EXISTS openatlasweb.web_fe_tbl_finds CASCADE;
CREATE TABLE openatlasweb.web_fe_tbl_finds

(
    uniqueindex serial,
    old_uid integer,
    entity_id text,
    sitename text, 
    sitetype text, 
    description text,
    starttime integer,
    endtime integer,
    start_time_text text, 
    end_time_text text, 
    easting double precision,
    northing double precision,
    markertype text,
    markercolor text,
    parent integer,  
    

  CONSTRAINT web_finds_pkey PRIMARY KEY (uniqueindex)
);

--insert strat data
INSERT INTO openatlasweb.web_fe_tbl_finds 
    (
    old_uid,
    entity_id, 
    sitename, 
    sitetype, 
    description, 
    starttime, 
    endtime, 
    start_time_text, 
    end_time_text, 
    easting,
    northing,
    parent)  
 SELECT
    tbl_entities.uid,
    tbl_entities.entity_id,
    tbl_entities.entity_name_uri, 
    replace(types_all_tree.name_path, 'Types > Finds > '::text, ''::text), 
    tbl_entities.entity_description,
    tbl_entities.start_time_abs, 
    tbl_entities.end_time_abs, 
    tbl_entities.start_time_text, 
    tbl_entities.end_time_text, 
    st_x(st_transform(st_setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326)), 
    st_y(st_transform(st_setsrid(tbl_entities.geom, tbl_entities.srid_epsg), 4326)),
    uid_from
   FROM openatlas.types_all_tree, openatlas.tbl_entities, openatlasweb.web_fe_links
  WHERE tbl_entities.entity_type = types_all_tree.id AND tbl_entities.uid = web_fe_links.uid_to AND types_all_tree.name_path ~~ '%> Finds%'::text 
  ORDER BY tbl_entities.entity_name_uri;

  UPDATE openatlasweb.web_fe_tbl_sites SET easting = 2000, northing = 2000 where easting > 180;
  UPDATE openatlasweb.web_fe_tbl_sites SET easting = 2000, northing = 2000 where northing > 90;
  UPDATE openatlasweb.web_fe_tbl_sites SET easting = 2000, northing = 2000 where easting < -180;
  UPDATE openatlasweb.web_fe_tbl_sites SET easting = 2000, northing = 2000 where northing < -90;
  UPDATE openatlasweb.web_fe_tbl_sites SET easting = 2000, northing = 2000 where easting IS NULL;

--table for advanced filter criteria

DROP TABLE IF EXISTS openatlasweb.web_fe_tbl_filter CASCADE;
CREATE TABLE openatlasweb.web_fe_tbl_filter

(
    uniqueindex serial,
    uid_site integer,
    sitename text,
    sitetype text,
    starttime integer,
    endtime integer,
    start_time_text text, 
    end_time_text text, 
    cultural text,
    chronological text,
    evidence text,
    place text,
     
    

  CONSTRAINT web_filter_pkey PRIMARY KEY (uniqueindex)
);




INSERT INTO openatlasweb.web_fe_tbl_filter
    (
    uid_site,
    sitename,
    sitetype,
    starttime,
    endtime,
    start_time_text, 
    end_time_text, 
    cultural,
    chronological,
    evidence,
    place)  


SELECT 
openatlas.sites.uid,
openatlas.sites.entity_name_uri,
openatlas.sites.name_path,
openatlas.sites.start_time_abs,
openatlas.sites.end_time_abs,
openatlas.sites.start_time_text,
openatlas.sites.end_time_text,
openatlas.links_cultural.name_path,
openatlas.links_chronological.name_path,
openatlas.links_evidence.name_path,
openatlas.links_places.name_path

FROM 
(openatlas.links_evidence RIGHT JOIN 
(
(openatlas.sites LEFT JOIN openatlas.links_cultural ON openatlas.sites.uid = openatlas.links_cultural.links_entity_uid_from) 
LEFT JOIN openatlas.links_chronological ON openatlas.sites.uid = openatlas.links_chronological.links_entity_uid_from) 

ON openatlas.links_evidence.links_entity_uid_from = openatlas.sites.uid) 
LEFT JOIN openatlas.links_places ON openatlas.sites.uid = openatlas.links_places.links_entity_uid_from;




--table for password
DROP TABLE IF EXISTS openatlasweb.web_fe_tbl_sec CASCADE;
CREATE TABLE openatlasweb.web_fe_tbl_sec

(
    sec_id serial,
    username text,
    password text, 
    

  CONSTRAINT web_sec_pkey PRIMARY KEY (sec_id)
);

GRANT USAGE ON SCHEMA openatlasweb TO openatla_wavemaker;
GRANT SELECT ON 	
			openatlasweb.web_fe_links_bibliography,
			openatlasweb.web_fe_links_chronological,
			openatlasweb.web_fe_links_cultural,
			openatlasweb.web_fe_links_evidence,
			openatlasweb.web_fe_links_images,
			openatlasweb.web_fe_links,
			openatlasweb.web_fe_links_places,
			openatlasweb.web_fe_tbl_sites,
			openatlasweb.web_fe_tbl_strats,
			openatlasweb.web_fe_tbl_finds,
			openatlasweb.web_fe_tbl_filter,
			openatlasweb.web_fe_tbl_features,
			openatlasweb.web_fe_tbl_sec

			TO openatla_wavemaker;


INSERT INTO openatlasweb.web_fe_tbl_sec 
    (
    username,
    password)  
    VALUES ('admin', 'atlas2013');