-- -*- mode: sql; sql-product: mysql; server: 192.254.187.215; user: plapan_ln_admin; password: welcome; database: plapan_lndb; -*-

---User


DROP PROCEDURE IF EXISTS new_user;

DELIMITER  //
CREATE PROCEDURE new_user( IN _name CHARACTER(250), IN  _tags CHARACTER(250), IN _password CHARACTER(250), IN  _group INTEGER)
BEGIN
   INSERT INTO lnuser(usergroup_id, lnuser_name, tags, password)
   VALUES (_group, _name, _tags, _password);
END //
DELIMITER  ;

-- CALL new_user('myname', 'atag', 'welcome', 1);


----Project


DROP procedure IF EXISTS new_project;


DELIMITER  //
CREATE procedure new_project(IN _descr CHARACTER(250), IN  _project_name CHARACTER(250), IN _session_id INTEGER)
BEGIN
DECLARE v_id INT DEFAULT 0;
INSERT INTO project(descr, project_name, lnsession_id)
   VALUES (_descr, _project_name, _session_id);
   SET v_id = LAST_INSERT_ID();
   UPDATE project SET project_sys_name = CONCAT('PRJ-', v_id) WHERE id=v_id;
END //

DELIMITER ;

-- CALL new_project('description 1', 'MyTestProj1', 1 );

--  --Sample------------------------------------------------------------------------


DROP PROCEDURE IF EXISTS  new_sample;

DELIMITER  //
CREATE procedure new_sample(IN _project_id INTEGER, IN _well_id INTEGER, IN  _accs_id VARCHAR(250))
BEGIN
DECLARE s_id INTEGER DEFAULT 0;
   
   INSERT INTO sample( project_id, accs_id) VALUES (_project_id,   _accs_id);
   set s_id = LAST_INSERT_ID();

    UPDATE sample SET sample_sys_name = CONCAT('SPL-',s_id) WHERE id=s_id;
    INSERT INTO  well_sample( well_id, sample_id) VALUES (_well_id, s_id);
END //
DELIMITER ;

-- CALL new_sample( 1, 'hsdjhfds' );


DROP PROCEDURE IF EXISTS new_plate;

DELIMITER  //
CREATE procedure new_plate(IN _plate_type_id INTEGER, IN _plate_set_id INTEGER, IN _plate_format_id INTEGER, IN _plate_layout_name_id INTEGER,  IN _include_sample BOOLEAN, OUT plt_id INTEGER)
BEGIN  
  -- DECLARE plt_id INTEGER;
  DECLARE  ps_id INTEGER DEFAULT _plate_set_id;
  DECLARE  pf_id INTEGER;
  DECLARE  w_id INTEGER;
  DECLARE  s_id INTEGER;
  DECLARE prj_id INTEGER;
  DECLARE  spl_include BOOLEAN DEFAULT _include_sample;
  DECLARE   w INTEGER DEFAULT 1;	
DECLARE wt_id INTEGER;
DECLARE make_sample BOOLEAN;

   INSERT INTO plate(plate_type_id,   plate_format_id, plate_layout_name_id)
   VALUES (_plate_type_id,  _plate_format_id, _plate_layout_name_id);
   set plt_id = LAST_INSERT_ID();

    UPDATE plate SET plate_sys_name = CONCAT('PLT-',plt_id) WHERE id=plt_id;
     SELECT project_id FROM plate_set WHERE plate_set.id = ps_id INTO prj_id;


      REPEAT 
       INSERT INTO well(by_col, plate_id) VALUES (w, plt_id);
       SET w_id = LAST_INSERT_ID();
       SELECT well_type_id FROM plate_layout, plate_layout_name  WHERE plate_layout.plate_layout_name_id = plate_layout_name.id AND plate_layout.well_type_id = 1 AND plate_layout.plate_layout_name_id = _plate_layout_name_id AND well_by_col=w INTO wt_id;

--  check if it is an "unknown" well i.e. not a control      
      CASE 
      WHEN spl_include THEN
                        CASE 
                        WHEN wt_id = 1 THEN CALL new_sample(prj_id, w_id, null);
                        END CASE;
	END CASE; 		
      
     
   SET w = w + 1;
   until  w > _plate_format_id END REPEAT;

   INSERT INTO plate_plate_set(plate_set_id, plate_id) VALUES (ps_id, plt_id );

END //

DELIMITER ;


-- call new_plate(1,1,96,1, TRUE, @ps_id);
SELECT @ps_id;


SELECT * FROM sample;
SELECT * FROM well;
SELECT * FROM plate;



-- ---Plate_set-------------------------------------------
DROP PROCEDURE IF exists new_plate_set;

DELIMITER  //
CREATE procedure new_plate_set(_descr VARCHAR(30),_plate_set_name VARCHAR(30), _num_plates INTEGER, _plate_format_id INTEGER, _plate_type_id INTEGER, _project_id INTEGER, _plate_layout_name_id INTEGER, _with_samples BOOLEAN)
BEGIN 
   DECLARE  ps_id INTEGER;
   DECLARE n_plates INTEGER DEFAULT _num_plates;
   DECLARE p_type INTEGER DEFAULT _plate_type_id;
   DECLARE p_form INTEGER DEFAULT _plate_format_id;
   DECLARE prj_id INTEGER DEFAULT _project_id;
   DECLARE plt_id INTEGER;
   DECLARE play_n_id INTEGER DEFAULT _plate_layout_name_id;
   DECLARE w_spls BOOLEAN DEFAULT _with_samples;
   DECLARE plate_counter INTEGER DEFAULT 1;

   
   INSERT INTO plate_set(descr, plate_set_name, num_plates, plate_format_id, plate_type_id, project_id, plate_layout_name_id)
   VALUES (_descr, _plate_set_name, _num_plates, _plate_format_id, _plate_type_id, _project_id, _plate_layout_name_id );
   SET ps_id = LAST_INSERT_ID();
   
   UPDATE plate_set SET plate_set_sys_name = CONCAT('PS-',ps_id) WHERE id=ps_id;

	     -- _plate_type_id INTEGER, _plate_set_id INTEGER, _project_id INTEGER, _plate_format_id INTEGER, include_sample BOOLEAN
REPEAT 
CALL new_plate(p_type, ps_id, p_form, play_n_id, w_spls, @plt_id);
	    UPDATE plate_plate_set SET plate_order = plate_counter WHERE plate_set_id = ps_id AND plate_id = (SELECT @plt_id);


  SET plate_counter = plate_counter + 1;
   until  plate_counter > n_plates END REPEAT;

END //

DELIMITER ;


-- call  new_plate_set('using loop','ps-name-by-user',5,3,1,1,1,TRUE);

select COUNT(*) FROM plate;
SELECT COUNT(*) FROM sample;
SELECT COUNT(*) FROM well;

-----Plate_set from group-------------------------------------------

DROP PROCEDURE IF exists new_plate_set_from_group;

DELIMITER  //
CREATE procedure new_plate_set_from_group(IN _descr VARCHAR(30),IN _plate_set_name VARCHAR(30), IN _num_plates INTEGER, IN _plate_format_id INTEGER, IN _plate_type_id INTEGER, IN _project_id INTEGER, IN _plate_layout_name_id INTEGER, OUT ps_id INTEGER)
    
BEGIN
   
   INSERT INTO plate_set(descr, plate_set_name, num_plates, plate_format_id, plate_type_id, project_id, plate_layout_name_id)
   VALUES (_descr, _plate_set_name, _num_plates, _plate_format_id, _plate_type_id, _project_id, _plate_layout_name_id );
  SET ps_id= LAST_INSERT_ID();
   UPDATE plate_set SET plate_set_sys_name = CONCAT('PS-',ps_id) WHERE id=ps_id;

END //
DELIMITER ;


---Get all sample IDs in a plate set

DROP PROCEDURE IF exists get_num_samples_for_plate_set;

DELIMITER //
CREATE PROCEDURE get_num_samples_for_plate_set(IN _ps_id INTEGER, OUT num_samples INTEGER)
BEGIN 
DECLARE ps_id INTEGER DEFAULT _ps_id;
SET num_samples = (SELECT count(*)  FROM plate, plate_plate_set, well, sample, well_sample WHERE plate_plate_set.plate_set_id = ps_id AND plate_plate_set.plate_id = plate.id AND well.plate_id = plate.id AND well_sample.well_id = well.id AND well_sample.sample_id = sample.id);

END //
DELIMITER ;

-- call get_num_samples_for_plate_set(1, @num_samples); select @num_samples;

-- https://federico-razzoli.com/json-arrays-in-mysql-mariadb
-- associate multiple plate IDs with a plate set ID----------------------

DROP PROCEDURE assoc_plate_ids_with_plate_set_id( _plate_ids INTEGER[], _plate_set_id INTEGER);

CREATE PROCEDURE assoc_plate_ids_with_plate_set_id(_plate_ids int[], _plate_set_id int)

BEGIN 
DECLARE
   pid int;
   plate_ids int[];
   counter INTEGER;
   sql_statement VARCHAR;
   
counter := 1;
SELECT sort(_plate_ids) INTO plate_ids;
sql_statement := 'INSERT INTO plate_plate_set (plate_set_id, plate_id, plate_order) VALUES ';

  FOREACH pid IN ARRAY plate_ids
     LOOP
     sql_statement := sql_statement || '(' || _plate_set_id || ', '  ||  pid || ', ' || counter || '),';
     counter = counter + 1;
    END LOOP;

     sql_statement := SUBSTRING(sql_statement, 1, CHAR_LENGTH(sql_statement)-1) || ';';
     --RAISE notice 'sqlstatement: (%)', sql_statement;
     EXECUTE sql_statement;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

--SELECT assoc_plate_ids_with_plate_set_id('{101,100,102}', 10);


---hit_list-------------------------
   
CREATE OR REPLACE FUNCTION new_hit_list(_descr VARCHAR(250), _project_id INTEGER)
  RETURNS integer AS
$BODY$
DECLARE
   v_id integer;
BEGIN
   
   INSERT INTO hit_list(descr,  project_id)
   VALUES (_descr,  _project_id )
   RETURNING id INTO v_id;
   UPDATE hit_list SET hitlist_sys_name = 'HL-'||v_id WHERE id=v_id;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;



-----Assay_run---------------------

DROP FUNCTION new_assay_run(  VARCHAR(30), VARCHAR(30), INTEGER,  INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION new_assay_run( _assay_run_name VARCHAR(30), _descr VARCHAR(30), _assay_type_id INTEGER, _plate_set_id INTEGER, _plate_layout_name_id INTEGER)
  RETURNS integer AS
$BODY$
DECLARE
   v_id integer;
BEGIN
   
   INSERT INTO assay_run(assay_run_name , descr, assay_type_id, plate_set_id, plate_layout_name_id)
   VALUES (_assay_run_name, _descr, _assay_type_id, _plate_set_id, _plate_layout_name_id)
   RETURNING id INTO v_id;

    UPDATE assay_run SET assay_run_sys_name = 'AR-'||v_id WHERE id=v_id;

RETURN v_id;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;




DROP FUNCTION get_ids_for_sys_names( VARCHAR[], VARCHAR(30), VARCHAR(30));

CREATE OR REPLACE FUNCTION get_ids_for_sys_names( _sys_names VARCHAR[], _table VARCHAR(30), _sys_name VARCHAR(30))
  RETURNS integer[] AS
$BODY$
DECLARE
   sn varchar(20);
   an_int integer;
   sys_ids INTEGER[];
   sql_statement VARCHAR;
   sql_statement2 VARCHAR;
   
   temp INTEGER;

BEGIN

 sql_statement := 'SELECT id FROM ' || _table || ' WHERE ' || _sys_name   || ' = ';

  FOREACH sn IN ARRAY _sys_names
     LOOP
     sql_statement2 := sql_statement || quote_literal(sn);
     EXECUTE sql_statement2 INTO temp;
     sys_ids := array_append(sys_ids, temp );
    END LOOP;

RETURN sys_ids;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE PARALLEL UNSAFE;


--SELECT get_ids_for_sys_names('{"PLT-1","PLT-2","PLT-3"}', 'plate', 'plate_sys_name');

---------Number of samples in a plate set-----------------------------------------------------------------

DROP FUNCTION get_number_samples_for_psid( _psid INTEGER );

CREATE OR REPLACE FUNCTION get_number_samples_for_psid( _psid INTEGER) 
  RETURNS integer AS
$BODY$
DECLARE
   num_samples INTEGER;
   sql_statement VARCHAR;
  --plate_layout_name_id INTEGER;

BEGIN

     --sql_statement := 'SELECT plate_layout_name_id FROM plate_set WHERE id = ' || _psid;
     --EXECUTE sql_statement INTO plate_layout_name_id;

      sql_statement := 'SELECT count(sample_id) FROM well_sample WHERE well_sample.well_id IN (SELECT well.id FROM well WHERE well.plate_id  IN (SELECT plate_id FROM plate_plate_set WHERE plate_plate_set.plate_set_id = ' || _psid || '))'; 
      EXECUTE sql_statement INTO num_samples;

RETURN num_samples;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE PARALLEL UNSAFE;


------new plate layout

DROP FUNCTION new_plate_layout(  VARCHAR(30), VARCHAR(30), INTEGER,  VARCHAR[][]);

CREATE OR REPLACE FUNCTION new_plate_layout( _plate_layout_name VARCHAR(30), _descr VARCHAR(30), _plate_format_id INTEGER, _data VARCHAR[][])
  RETURNS integer AS
$BODY$
DECLARE
   src_id integer;
   dest_id INTEGER;
   dest_name VARCHAR(30);
BEGIN


   INSERT INTO plate_layout_name(name, descr, plate_format_id)
   VALUES (_plate_layout_name, _descr, _plate_format_id)
   RETURNING id INTO src_id;

dest_name := _plate_layout_name || '-dest';

   INSERT INTO plate_layout_name(name, descr, plate_format_id)
   VALUES (_plate_layout_name, _descr, _plate_format_id)
   RETURNING id INTO dest_id;

INSERT INTO layout_source_dest(src, dest) VALUES (src_id, dest_id);


 
RETURN plname_id;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


----reformat



DROP FUNCTION IF exists reformat_plate_set(source_plate_set_id INTEGER, source_num_plates INTEGER, n_reps_source INTEGER, dest_descr VARCHAR(30), dest_plate_set_name VARCHAR(30), dest_num_plates INTEGER, dest_plate_format_id INTEGER, dest_plate_type_id INTEGER, project_id INTEGER, dest_plate_layout_name_id INTEGER );

CREATE OR REPLACE FUNCTION reformat_plate_set(source_plate_set_id INTEGER, source_num_plates INTEGER, n_reps_source INTEGER, dest_descr VARCHAR(30), dest_plate_set_name VARCHAR(30), dest_num_plates INTEGER, dest_plate_format_id INTEGER, dest_plate_type_id INTEGER, project_id INTEGER, dest_plate_layout_name_id INTEGER )
 RETURNS integer AS
$BODY$
DECLARE

dest_plate_set_id INTEGER;
all_source_well_ids INTEGER[];
all_dest_well_ids INTEGER[];
 w INTEGER;
holder INTEGER;

BEGIN
--here I am creating the destination plate set, no samples included
SELECT new_plate_set(dest_descr ,dest_plate_set_name, dest_num_plates, dest_plate_format_id, dest_plate_type_id, project_id, dest_plate_layout_name_id, false) INTO dest_plate_set_id;

RAISE notice 'dest_plate_set_id: (%)', dest_plate_set_id;

CREATE TEMP TABLE temp1(plate_id INT, well_name VARCHAR(10), well_id INT);

FOR i IN 1..n_reps_source LOOP
INSERT INTO temp1 select well.plate_id, well.well_name, well.id AS well_id FROM plate_plate_set, well  WHERE plate_plate_set.plate_set_id = source_plate_set_id AND plate_plate_set.plate_id = well.plate_id   ORDER BY plate_plate_set.plate_order, well.ID;
END LOOP;

SELECT ARRAY (SELECT well_id FROM temp1) INTO all_source_well_ids;


SELECT ARRAY (SELECT  dest.id  FROM ( SELECT plate_plate_set.plate_ID, well.well_name,  well.id  FROM well, plate_plate_set  WHERE plate_plate_set.plate_set_id = dest_plate_set_id  AND plate_plate_set.plate_id = well.plate_id) AS dest JOIN (SELECT well_numbers.well_name, well_numbers.by_col, well_numbers.quad FROM well_numbers WHERE well_numbers.plate_format=dest_plate_format_id)  AS foo ON (dest.well_name=foo.well_name) ORDER BY plate_id, quad, by_col) INTO all_dest_well_ids;


FOR w IN 1..array_length(all_source_well_ids,1)  LOOP
SELECT sample.id FROM sample, well, well_sample WHERE well_sample.well_id=well.id AND well_sample.sample_id=sample.id AND well.id= all_source_well_ids[w] INTO holder;
INSERT INTO well_sample (well_id, sample_id) VALUES (all_dest_well_ids[w], holder );


--RAISE notice  'w: (%)', w;
--RAISE notice  'all_source_well_ids[w]: (%)', all_source_well_ids[w];
--RAISE notice  'all_dest_well_ids[w]: (%)', all_dest_well_ids[w];

END LOOP;

DROP TABLE temp1;

RETURN dest_plate_set_id;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


-------update raw data with normalized


DROP FUNCTION IF exists process_assay_run_data(_assay_run_id integer);

CREATE OR REPLACE FUNCTION process_assay_run_data(_assay_run_id integer)
  RETURNS void AS
$BODY$
DECLARE
   plates INTEGER[];   
   background decimal;
   positives decimal;
   negatives DECIMAL;
   unk_max DECIMAL;
   norm_factor DECIMAL;
   format INTEGER;
BEGIN

CREATE TEMP TABLE data_set  ON COMMIT DROP AS SELECT assay_result.assay_run_id, assay_result.plate_order, assay_result.well, assay_result.response, assay_result.bkgrnd_sub, assay_result.norm, assay_result.norm_pos, plate_layout.well_by_col, plate_layout.well_type_id, plate_layout.replicates, plate_layout.target FROM assay_result JOIN plate_layout  ON (assay_result.well = plate_layout.well_by_col)  WHERE assay_result.assay_run_id = _assay_run_id AND  plate_layout.plate_layout_name_id = (SELECT plate_layout_name_id FROM assay_run WHERE assay_run.ID = _assay_run_id);

SELECT ARRAY (SELECT distinct plate_order FROM data_set WHERE data_set.assay_run_id = _assay_run_id  ORDER BY plate_order) INTO plates;

FOR plate_var IN 1..array_length(plates,1) LOOP

SELECT AVG(data_set.response) FROM data_set WHERE data_set.plate_order = plate_var AND data_set.well_type_id=2 INTO positives;
SELECT AVG(data_set.response) FROM data_set WHERE data_set.plate_order = plate_var AND data_set.well_type_id=3 INTO negatives;
SELECT AVG(data_set.response) FROM data_set WHERE data_set.plate_order = plate_var AND data_set.well_type_id=4 INTO background;
SELECT MAX(data_set.response) FROM data_set WHERE data_set.plate_order = plate_var AND data_set.well_type_id=1 INTO unk_max;

SELECT plate_layout_name.plate_format_id FROM plate_layout_name, assay_run WHERE assay_run.plate_layout_name_id=plate_layout_name.ID AND assay_run.id=_assay_run_id INTO format;

       FOR well_var IN 1..format LOOP

          UPDATE assay_result SET bkgrnd_sub  = (assay_result.response-background), norm = ((assay_result.response-background)/unk_max), norm_pos = ((response-background)/positives) WHERE assay_result.assay_run_id=_assay_run_id AND assay_result.plate_order=plate_var AND assay_result.well = well_var;

   END LOOP;

END LOOP;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

