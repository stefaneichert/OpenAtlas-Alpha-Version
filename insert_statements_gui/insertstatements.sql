-- insert Statement new entity (Site/Feature/SU/Find)
INSERT INTO openatlas.tbl_entities (user_id, classes_uid, entity_name_uri, entity_type, entity_description) VALUES ('youruserid', 12, 'your entitys name', 367, 'your entitys description'); -- replace values by variables from frontend. NOTE! Type: select UID by recursive query in GUI


--Type/Place etc. wizard:
-- select
SELECT child_id, child_name FROM openatlas.'your_entityclass'+parent_child WHERE parent_id = 'Topparent derived from GUI';
--Save child_id to variable - use variable for above value for entity_type

--Update Statements Tabs spatial:
UPDATE openatlas.tbl_entities SET (x_lon_easting, y_lat_northing, srid_epsg) = ('your x value', 'your y value' , 'your EPSG code') WHERE uid = 'records_uid'

--Update Statements Tabs chron/cult
UPDATE openatlas.tbl_entities SET (start_time_abs, end_time_abs, start_time_text, end_time_text) = ('your starttime integer', 'your endtime integer' , 'start text', 'end text') WHERE uid = 'records_uid'

--Update Statements Tabs dimensions
UPDATE openatlas.tbl_entities SET (dim_width, dim_length, dim_height, dim_thickness, dim_diameter, dim_units, dim_weight, dim_units_weight, dim_degrees) = (dim_width, dim_length, dim_height, dim_thickness, dim_diameter, dim_units, dim_weight, dim_units_weight, dim_degrees) WHERE uid = 'records_uid'
-- select dimension units: 
SELECT name, id FROM openatlas.types_all_tree WHERE name_path LIKE '%> Distance >%'; --save id to unit field in tbl_entities
SELECT name, id FROM openatlas.types_all_tree WHERE name_path LIKE '%> Weight >%'; --save id to unit field tbl_entities


--update user_edit
UPDATE openatlas.tbl_entities SET (user_edit) = ('user_id') WHERE uid = 'records_uid';


--Insert statement child of site/feature/su
INSERT INTO openatlas.tbl_entities (user_id, classes_uid, entity_name_uri, entity_type, x_lon_easting, y_lat_northing, srid_epsg, start_time_abs, start_time_text, end_time_abs, end_time_text) 
            VALUES ('your user id', 'classes_uid - =12 except for finds where it is 15', 'name of the new entity', 'type = integer selected by wizard', 'parents x', 'parents y', 'parents epsg', 'parents start time', 'parents start text', 'parents end time', 'parents end text');
            
INSERT INTO openatlas.tbl_links (links_entity_uid_from, links_entity_uid_to, links_cidoc_number_direction, links_creator) 
            VALUES ('uid of parent', 'uid of new_child', 11, 'your user id');
            

            
            
----insert statement bibliographical reference         
INSERT INTO openatlas.tbl_entities (user_id, classes_uid, entity_name_uri, entity_type, entity_description) VALUES ('youruserid', 11, 'Author Year', 'text-type', 'Full Citation');
---text type
SELECT name, id FROM openatlas.types_all_tree WHERE name_path LIKE '%> Text' OR name_path LIKE '%> Text >%'; --save id to type field in tbl_entities

--insert statement link to bibliographical reference
INSERT INTO openatlas.tbl_links (links_entity_uid_from, links_entity_uid_to, links_cidoc_number_direction, links_creator) 
           VALUES ('parent uid=uid of site/feature/su/find)', 'uid of bib ref', 4, 'youruserid');
           
           
--insert statement spatial

INSERT INTO openatlas.tbl_links (links_entity_uid_from, links_entity_uid_to, links_cidoc_number_direction, links_creator, links_annotation) 
            VALUES ('uid of parent', 'uid of new_child', 15, 'your user id', 'Parcel number');
            
UPDATE openatlas.tbl_links SET (links_entity_uid_to, links_annotation) = ('your new child uid by wizard', 'your new Parcel number') WHERE links_uid = 'your links uid';


--insert types general/evidence/cultural/chronological/

INSERT INTO openatlas.tbl_links (links_entity_uid_from, links_entity_uid_to, links_cidoc_number_direction, links_creator) 
            VALUES ('uid of parent', 'uid of new_child', 'links_cidoc_number_direction: chronological=13; cultural=9, all_typelinks=1(including evidence)', 'your user id');
            
            
            
UPDATE openatlas.tbl_links SET (links_entity_uid_to) = ('your new child uid by wizard') WHERE links_uid = 'your links uid';



--insert material
--insert statement spatial

INSERT INTO openatlas.tbl_links (links_entity_uid_from, links_entity_uid_to, links_cidoc_number_direction, links_creator, links_annotation) 
            VALUES ('uid of parent', 'uid material', 1, 'your user id', 'percentage of material');
            
UPDATE openatlas.tbl_links SET (links_entity_uid_to, links_annotation) = ('your material uid by wizard', 'new percentage') WHERE links_uid = 'your links uid';


--Delete statements
---tbl_entities
DELETE FROM openatlas.tbl_entities WHERE uid = 'my_current_uid';
--tbl_links
DELETE FROM openatlas.tbl_links WHERE links_uid = 'my_current_uid';



--Delete statement to delete arch unit + all subunits of resp. unit

   WITH RECURSIVE path(id, path, parent, name, parent_id, name_path) AS (
                 SELECT openatlas.arch_parent_child.child_id, ''::text || openatlas.arch_parent_child.child_id::text AS path, NULL::text AS text, openatlas.arch_parent_child.child_name, openatlas.arch_parent_child.parent_id, ''::text || openatlas.arch_parent_child.child_name::text AS name_path
                   FROM openatlas.arch_parent_child
                  WHERE openatlas.arch_parent_child.parent_id = "Uid of arch unit goes here (without quotes)" -- replace value with parent of top-category you want to have displayed
        UNION ALL 
                 SELECT openatlas.arch_parent_child.child_id, (parentpath.path || 
                        CASE parentpath.path
                            WHEN ' > '::text THEN ''::text
                            ELSE ' > '::text
                        END) || openatlas.arch_parent_child.child_id::text, parentpath.path, openatlas.arch_parent_child.child_name, openatlas.arch_parent_child.parent_id, 

		    (parentpath.name_path || 
                        CASE parentpath.name_path
                            WHEN ' > '::text THEN ''::text
                            ELSE ' > '::text
                        END) || openatlas.arch_parent_child.child_name::text

                   FROM openatlas.arch_parent_child, path parentpath
                  WHERE openatlas.arch_parent_child.parent_id::text = parentpath.id::text
        )

DELETE FROM openatlas.tbl_entities WHERE UID IN (SELECT path.id FROM path);
DELETE FROM openatlas.tbl_entities WHERE UID = "uid of your arch unit goes here";




