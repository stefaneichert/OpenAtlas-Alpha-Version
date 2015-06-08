------------------------------------------------------------------------------
--                                                                          --
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
--    Database Design and MS-Access Frontend by Stefan Eichert 2013         --
--    stefan.eichert@univie.ac.at                                           --
--                                                                          --
--    Qt-Frontend developed by Viktor Jansa 2013, viktor.jansa@gmx.net      --
--                                                                          --
------------------------------------------------------------------------------


--This script enables recursive_triggers and fires the original triggers recursively from the install script by inserting the top parents
--As a result the path of the entities is inserted into the "_tree" tables
--To have an up to date version of the "_tree" tables this script needs to be run after every change of types, periods, timespans or places and their internal relationship



DELETE FROM all_tree;
DELETE FROM types_all_tree;
DELETE FROM cultural_period_all_tree;
DELETE FROM chronological_period_all_tree;
DELETE FROM place_all_tree;


PRAGMA recursive_triggers = TRUE;

INSERT INTO all_tree SELECT * FROM all_path WHERE name = "Types";
INSERT INTO all_tree SELECT * FROM all_path WHERE name = "Cultural Periods";
INSERT INTO all_tree SELECT * FROM all_path WHERE name = "Human history";
INSERT INTO all_tree SELECT * FROM all_path WHERE name = "Places";
INSERT INTO types_all_tree SELECT * FROM types_path WHERE name = "Types";
INSERT INTO cultural_period_all_tree SELECT * FROM cultural_period_path WHERE name = "Cultural Periods";
INSERT INTO chronological_period_all_tree SELECT * FROM chronological_period_path WHERE name = "Human history";
INSERT INTO place_all_tree SELECT * FROM place_path WHERE name = "Places";

PRAGMA recursive_triggers = FALSE;
