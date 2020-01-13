


-- -*- mode: sql; sql-product: mysql; server: 192.254.187.215; user: plapan_ln_admin; password: welcome; database: plapan_lndb; -*-

DROP TABLE IF EXISTS lnuser_groups, lnuser, lnsession, project, assay_result, assay_run, assay_type, hit_list, hit_sample, layout_source_dest, plate, plate_set, well, sample, plate_format, plate_layout, plate_layout_name, plate_type, plate_plate_set, rearray_pairs, well_numbers, well_sample, well_type, worklists CASCADE;

--users------------------------------------------------------

DROP TABLE IF EXISTS lnuser_groups CASCADE;
CREATE TABLE lnuser_groups
(id SERIAL PRIMARY KEY,
        usergroup VARCHAR(250),
	updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

INSERT INTO lnuser_groups (usergroup) VALUES ('administrator');
INSERT INTO lnuser_groups (usergroup) VALUES ('user');

DROP TABLE IF EXISTS lnuser CASCADE;
CREATE TABLE lnuser
(id SERIAL PRIMARY KEY,
        usergroup_id INTEGER,
	lnuser_name VARCHAR(250) NOT NULL UNIQUE,
	tags VARCHAR(30) ,
        password VARCHAR(64) NOT NULL,
	updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (usergroup_id) REFERENCES lnuser_groups(id));

INSERT INTO lnuser ( lnuser_name, tags, usergroup_id, password) VALUES ('admin', '', 1, 'welcome');
INSERT INTO lnuser ( lnuser_name, tags, usergroup_id, password) VALUES ('user', '', 2, 'welcome');


select * from lnuser;


DROP TABLE IF EXISTS lnsession CASCADE;
DROP SEQUENCE IF EXISTS  lnsession_id_seq CASCADE;
DROP INDEX IF EXISTS lnsession_pkey CASCADE;
CREATE TABLE lnsession
(id SERIAL PRIMARY key,
        lnuser_id INTEGER,
	updated TIMESTAMP DEFAULT current_timestamp,
        FOREIGN KEY (lnuser_id) REFERENCES lnuser(id));



DROP TABLE IF EXISTS project CASCADE;
DROP SEQUENCE IF EXISTS  project_id_seq CASCADE;
DROP INDEX IF EXISTS project_pkey CASCADE;
CREATE TABLE project
(id SERIAL PRIMARY KEY,
        project_sys_name VARCHAR(30),
        descr VARCHAR(250),
	project_name VARCHAR(60),
        lnsession_id INTEGER,
	updated TIMESTAMP DEFAULT current_timestamp,
        FOREIGN KEY (lnsession_id) REFERENCES lnsession(id));


------------------------------------------------
DROP TABLE IF EXISTS plate_format CASCADE;
DROP TABLE IF EXISTS plate_type CASCADE;

CREATE TABLE plate_type
(id SERIAL PRIMARY KEY,
	plate_type_name VARCHAR(30));

INSERT INTO plate_type (plate_type_name) VALUES ('assay');
INSERT INTO plate_type (plate_type_name) VALUES ('rearray');
INSERT INTO plate_type (plate_type_name) VALUES ('master');
INSERT INTO plate_type (plate_type_name) VALUES ('daughter');
INSERT INTO plate_type (plate_type_name) VALUES ('archive');
INSERT INTO plate_type (plate_type_name) VALUES ('replicate');


CREATE TABLE plate_format (id INTEGER PRIMARY KEY,
	format VARCHAR(6), rownum INTEGER, colnum INTEGER);

INSERT INTO plate_format (id, format, rownum, colnum) VALUES ( 96, '96', 8, 12);
INSERT INTO plate_format (id, format, rownum, colnum) VALUES (384, '384',16, 24);
INSERT INTO plate_format (id, format, rownum, colnum) VALUES (1536, '1536', 32, 48);


----------------------------


DROP TABLE IF EXISTS plate_layout_name CASCADE;

CREATE TABLE plate_layout_name (
		id SERIAL PRIMARY KEY,
		sys_name VARCHAR(30),
                name VARCHAR(30),
                descr VARCHAR(30),
                plate_format_id INTEGER,
		replicates INTEGER,
		targets INTEGER,
		use_edge INTEGER,
		num_controls INTEGER,
		control_loc VARCHAR(30),
		source_dest VARCHAR(30),
		FOREIGN KEY (plate_format_id) REFERENCES plate_format(id));

CREATE INDEX pln_pfid ON plate_layout_name(plate_format_id);



-- 96 well plate 4 controls
INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-1','4 controls col 12', '1S1T', 96,1,1,1,4,'E12-H12','source');

INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-2','4 controls cols 23,24', '1S4T', 384, 1,4,1,4,'I23-P24','dest');
INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-3','4 controls cols 23,24', '1S2T', 384, 1,2,1,4,'I23-P24','dest');
INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-4','4 controls cols 23,24', '1S1T', 384, 1,1,1,4,'I23-P24','dest');



INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-5','4 controls cols 23,24', '2S2T', 384, 2,2,1,4,'I23-P24','dest');
INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-6','4 controls cols 23,24', '2S1T', 384, 2,1,1,4,'I23-P24','dest');


INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-7','4 controls cols 23,24', '4S1T', 384, 4,1,1,4,'I23-P24','dest');

-- 96 well plate 8 controls

INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-8','8 controls col 12', '1S1T', 96, 1,1,1,8,'A12-H12','source');

INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-9','8 controls cols 23,24', '1S4T', 384, 1,4,1,8,'A23-P24','dest');
INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-10','8 controls cols 23,24', '1S2T', 384, 1,2,1,8,'A23-P24','dest');
INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-11','8 controls cols 23,24', '1S1T', 384, 1,1,1,8,'A23-P24','dest');


INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-12','8 controls cols 23,24', '2S2T', 384, 2,2,1,8,'A23-P24','dest');
INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-13','8 controls cols 23,24', '2S1T', 384, 2,1,1,8,'A23-P24','dest');


INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-14','8 controls cols 23,24', '4S1T', 384, 4,1,1,8,'A23-P24','dest');

-- 384 well plate 8 controls

INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-15','8 controls col 24', '1S1T', 384, 1,1,1,8,'I24-P24','source');


INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-16','8 controls cols 47,48', '1S4T', 1536, 1,4,1,8,'Q47-AF48','dest');
INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-17','8 controls cols 47,48', '1S2T', 1536, 1,2,1,8,'Q47-AF48','dest');
INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-18','8 controls cols 47,48', '1S1T', 1536, 1,1,1,8,'Q47-AF48','dest');


INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-19','8 controls cols 47,48', '2S2T', 1536, 2,2,1,8,'Q47-AF48','dest');
INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-20','8 controls cols 47,48', '2S1T', 1536, 2,1,1,8,'Q47-AF48','dest');


INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-21','8 controls cols 47,48', '4S1T', 1536, 4,1,1,8,'Q47-AF48','dest');

-- 384 well plate 16 controls

INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-22','16 controls col 24', '1S1T', 384, 1,1,1,16,'A24-P24','source');


INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-23','16 controls cols 47,48', '1S4T', 1536, 1,4,1,16,'A47-AF48','dest');
INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-24','16 controls cols 47,48', '1S2T', 1536, 1,2,1,16,'A47-AF48','dest');
INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-25','16 controls cols 47,48', '1S1T', 1536, 1,1,1,16,'A47-AF48','dest');



INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-26','16 controls cols 47,48', '2S2T', 1536, 2,2,1,16,'A47-AF48','dest');
INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-27','16 controls cols 47,48', '2S1T', 1536, 2,1,1,16,'A47-AF48','dest');


INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-28','16 controls cols 47,48', '4S1T', 1536, 4,1,1,16,'A47-AF48','dest');


-- 384 well plate 7 controls no edge

INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-29','7 controls col 23', '1S1T', 384, 1,1,0,7,'I23-O23','source');


INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-30','7 controls cols 46,47', '1S4T', 1536, 1,4,0,7,'Q46-AE47','dest');
INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-31','7 controls cols 46,47', '1S2T', 1536, 1,2,0,7,'Q46-AE47','dest');
INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-32','7 controls cols 46,47', '1S1T', 1536, 1,1,0,7,'Q46-AE47','dest');


INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-33','7 controls cols 46,47', '2S2T', 1536, 2,2,0,7,'Q46-AE47','dest');
INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-34','7 controls cols 46,47', '2S1T', 1536, 2,1,0,7,'Q46-AE47','dest');


INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-35','7 controls cols 46,47', '4S1T', 1536, 4,1,0,7,'Q46-AE47','dest');

-- 384 well plate 14 controls no edge

INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-36','14 controls col 23', '1S1T', 384, 1,1,0,14,'B23-O23','source');

INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-37','14 controls cols 46,47', '1S4T', 1536, 1,4,0,14,'B46-AE47','dest');
INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-38','14 controls cols 46,47', '1S2T', 1536, 1,2,0,14,'B46-AE47','dest');
INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-39','14 controls cols 46,47', '1S1T', 1536, 1,1,0,14,'B46-AE47','dest');


INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-40','14 controls cols 46,47', '2S2T', 1536, 2,2,0,14,'B46-AE47','dest');
INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-41','14 controls cols 46,47', '2S1T', 1536, 2,1,0,14,'B46-AE47','dest');


INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-42','14 controls cols 46,47', '4S1T', 1536, 4,1,0,14,'B46-AE47','dest');


--1536 as source
INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-43','8 controls cols 47,48', '1S1T', 1536, 1,1,1,8,'Q47-AF48','source');
INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-44','16 controls cols 47,48', '1S1T', 1536, 1,1,1,16,'A47-AF48','source');

INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-45','7 controls cols 46,47', '1S1T', 1536, 1,1,0,7,'Q46-AE47','source');
INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-46','14 controls cols 46,47', '1S1T', 1536, 1,1,0,14,'B46-AE47','source');


INSERT INTO plate_layout_name (sys_name, name, descr, plate_format_id, replicates, targets, use_edge, num_controls, control_loc, source_dest) VALUES ('LYT-47','all blanks', 'not reformattable', 1536, 1,1,0,0,'none','dest');



DROP TABLE IF EXISTS layout_source_dest CASCADE;

CREATE TABLE layout_source_dest (
                src INTEGER NOT NULL,
                dest INTEGER NOT NULL);


INSERT INTO layout_source_dest( src, dest ) VALUES (1,2);
INSERT INTO layout_source_dest( src, dest ) VALUES (1,3);
INSERT INTO layout_source_dest( src, dest ) VALUES (1,4);
INSERT INTO layout_source_dest( src, dest ) VALUES (1,5);
INSERT INTO layout_source_dest( src, dest ) VALUES (1,6);
INSERT INTO layout_source_dest( src, dest ) VALUES (1,7);


INSERT INTO layout_source_dest( src, dest ) VALUES (8,9);
INSERT INTO layout_source_dest( src, dest ) VALUES (8,10);
INSERT INTO layout_source_dest( src, dest ) VALUES (8,11);
INSERT INTO layout_source_dest( src, dest ) VALUES (8,12);
INSERT INTO layout_source_dest( src, dest ) VALUES (8,13);
INSERT INTO layout_source_dest( src, dest ) VALUES (8,14);

INSERT INTO layout_source_dest( src, dest ) VALUES (15,16);
INSERT INTO layout_source_dest( src, dest ) VALUES (15,17);
INSERT INTO layout_source_dest( src, dest ) VALUES (15,18);
INSERT INTO layout_source_dest( src, dest ) VALUES (15,19);
INSERT INTO layout_source_dest( src, dest ) VALUES (15,20);
INSERT INTO layout_source_dest( src, dest ) VALUES (15,21);

INSERT INTO layout_source_dest( src, dest ) VALUES (22,23);
INSERT INTO layout_source_dest( src, dest ) VALUES (22,24);
INSERT INTO layout_source_dest( src, dest ) VALUES (22,25);
INSERT INTO layout_source_dest( src, dest ) VALUES (22,26);
INSERT INTO layout_source_dest( src, dest ) VALUES (22,27);
INSERT INTO layout_source_dest( src, dest ) VALUES (22,28);

INSERT INTO layout_source_dest( src, dest ) VALUES (29,30);
INSERT INTO layout_source_dest( src, dest ) VALUES (29,31);
INSERT INTO layout_source_dest( src, dest ) VALUES (29,32);
INSERT INTO layout_source_dest( src, dest ) VALUES (29,33);
INSERT INTO layout_source_dest( src, dest ) VALUES (29,34);
INSERT INTO layout_source_dest( src, dest ) VALUES (29,35);

INSERT INTO layout_source_dest( src, dest ) VALUES (36,37);
INSERT INTO layout_source_dest( src, dest ) VALUES (36,38);
INSERT INTO layout_source_dest( src, dest ) VALUES (36,39);
INSERT INTO layout_source_dest( src, dest ) VALUES (36,40);
INSERT INTO layout_source_dest( src, dest ) VALUES (36,41);
INSERT INTO layout_source_dest( src, dest ) VALUES (36,42);

INSERT INTO layout_source_dest( src, dest ) VALUES (43,44);
INSERT INTO layout_source_dest( src, dest ) VALUES (43,45);
INSERT INTO layout_source_dest( src, dest ) VALUES (43,46);
INSERT INTO layout_source_dest( src, dest ) VALUES (43,47);


-- ---------------------------
DROP TABLE IF EXISTS plate_set CASCADE;
DROP SEQUENCE IF EXISTS plate_set_id_seq;

CREATE TABLE plate_set
(id SERIAL PRIMARY KEY,
        barcode VARCHAR(30),
	plate_set_name VARCHAR(30),
        descr VARCHAR(250),
        plate_set_sys_name VARCHAR(30),
        num_plates INTEGER,
        plate_format_id INTEGER,
        plate_type_id INTEGER,
        project_id INTEGER,
	plate_layout_name_id INTEGER,
	lnsession_id INTEGER,
	updated TIMESTAMP DEFAULT current_timestamp,
        FOREIGN KEY (plate_type_id) REFERENCES plate_type(id),
        FOREIGN KEY (plate_format_id) REFERENCES plate_format(id),
        FOREIGN KEY (project_id) REFERENCES project(ID),
    FOREIGN KEY (lnsession_id) REFERENCES lnsession(ID),
	FOREIGN KEY (plate_layout_name_id) REFERENCES plate_layout_name(id));

CREATE INDEX ps_bc ON plate_set(barcode);
CREATE INDEX ps_pfid ON plate_set(plate_format_id);
CREATE INDEX ps_ptid ON plate_set(plate_type_id);
CREATE INDEX ps_prjid ON plate_set(project_id);



----------------------------
DROP TABLE IF EXISTS plate CASCADE;
DROP TABLE IF EXISTS well CASCADE;
DROP TABLE IF EXISTS sample CASCADE;

CREATE TABLE plate (id SERIAL PRIMARY KEY,
		plate_sys_name VARCHAR(30),
		barcode VARCHAR(250),
        	plate_type_id INTEGER,
		plate_format_id INTEGER,
		plate_layout_name_id INTEGER,
	        updated TIMESTAMP DEFAULT current_timestamp,
                FOREIGN KEY (plate_type_id) REFERENCES plate_type(id),
		FOREIGN KEY (plate_format_id) REFERENCES plate_format(id), 
		FOREIGN KEY (plate_layout_name_id) REFERENCES plate_layout_name(id));

CREATE INDEX p_ptid ON plate(plate_type_id);
CREATE INDEX p_pfid ON plate(plate_format_id);

-- --------------------------------------------------------------------------
DROP TABLE IF EXISTS plate_plate_set CASCADE;

CREATE TABLE plate_plate_set (
        	plate_set_id INTEGER,
        	plate_id INTEGER,
		plate_order INTEGER,
                FOREIGN KEY (plate_set_id) REFERENCES plate_set(id),
                FOREIGN KEY (plate_id) REFERENCES plate(id));

CREATE INDEX pps_psid ON plate_plate_set(plate_set_id);
CREATE INDEX pps_pid ON plate_plate_set(plate_id);
 
-- --------------------------------------------------------------------------

CREATE TABLE sample (id SERIAL PRIMARY KEY,
		sample_sys_name VARCHAR(20),
		project_id INTEGER,
                accs_id VARCHAR(250),
		FOREIGN KEY (project_id) REFERENCES project(id));

CREATE INDEX s_prjid ON sample(project_id);


DROP TABLE IF EXISTS well CASCADE;
CREATE TABLE well (id SERIAL PRIMARY KEY,
  		by_col integer,
		plate_id INTEGER,
		FOREIGN KEY (plate_id) REFERENCES plate(id));

CREATE INDEX w_pid ON well(plate_id);

-- --------------------------------------------------------------------------
DROP TABLE IF EXISTS well_sample CASCADE;

CREATE TABLE well_sample (
        	well_id INTEGER,
        	sample_id INTEGER,
                FOREIGN KEY (well_id) REFERENCES well(id),
                FOREIGN KEY (sample_id) REFERENCES sample(id));

CREATE INDEX ws_wid ON well_sample(well_id);
CREATE INDEX ws_sid ON well_sample(sample_id);


----------------------------
DROP TABLE IF EXISTS hit_list CASCADE;

CREATE TABLE hit_list (id SERIAL PRIMARY KEY,
                       hitlist_sys_name VARCHAR(30),
		       hitlist_name VARCHAR(250),
        descr VARCHAR(250),
	updated TIMESTAMP DEFAULT current_timestamp,
 lnsession_id INTEGER,
 assay_run_id INTEGER,
 n INTEGER,
 FOREIGN KEY (lnsession_id) REFERENCES lnsession(id),
 FOREIGN KEY (assay_run_id) REFERENCES assay_run(id));

CREATE INDEX hl_prjid ON hit_list(project_id);


DROP TABLE IF EXISTS hit_sample CASCADE;
CREATE TABLE hit_sample
(
 hitlist_id INTEGER,
  sample_id INTEGER,

 FOREIGN KEY (hitlist_id) REFERENCES hit_list(id),
 FOREIGN KEY (sample_id) REFERENCES sample(id));

CREATE INDEX hs_hlid ON hit_sample(hitlist_id);
CREATE INDEX hs_sid ON hit_sample(sample_id);

-- --------------------------


DROP TABLE IF EXISTS assay_run CASCADE;

CREATE TABLE assay_run (id serial PRIMARY KEY,
               assay_run_sys_name VARCHAR(30),
	       assay_run_name VARCHAR(30),
               descr VARCHAR(250),
		assay_type_id INTEGER,
                plate_set_id INTEGER,
		plate_layout_name_id INTEGER,
		lnsession_id INTEGER,
                updated  TIMESTAMP DEFAULT current_timestamp,
               FOREIGN KEY (plate_set_id) REFERENCES plate_set(id),
               FOREIGN KEY (plate_layout_name_id) REFERENCES plate_layout_name(id),
	       FOREIGN KEY (lnsession_id) REFERENCES lnsession(id),
	 	FOREIGN KEY (assay_type_id) REFERENCES assay_type(id));

CREATE INDEX ar_atid ON assay_run(assay_type_id);
CREATE INDEX ar_psid ON assay_run(plate_set_id);
CREATE INDEX ar_plnid ON assay_run(plate_layout_name_id);


DROP TABLE IF EXISTS assay_type CASCADE;
CREATE TABLE assay_type (id SERIAL PRIMARY KEY,
	assay_type_name VARCHAR(30));

INSERT INTO assay_type (assay_type_name) VALUES ('ELISA');
INSERT INTO assay_type (assay_type_name) VALUES ('Octet');
INSERT INTO assay_type (assay_type_name) VALUES ('SNP');
INSERT INTO assay_type (assay_type_name) VALUES ('HCS');
INSERT INTO assay_type (assay_type_name) VALUES ('NGS');
INSERT INTO assay_type (assay_type_name) VALUES ('FACS');		

DROP TABLE IF EXISTS assay_result CASCADE;

CREATE TABLE assay_result (
		assay_run_id INTEGER,
		plate_order INTEGER,
		well INTEGER,
                response REAL,
                bkgrnd_sub REAL,
		norm REAL,        -- max unknown signal set to 1
		norm_pos REAL,    -- positive control set to 1
		p_enhance REAL,
			updated TIMESTAMP DEFAULT current_timestamp,
		FOREIGN KEY (assay_run_id) REFERENCES assay_run(id));
		

CREATE INDEX ar_arid  ON assay_result(assay_run_id);


-- --------------------------


DROP TABLE IF EXISTS well_type CASCADE;
CREATE TABLE well_type (
		id SERIAL PRIMARY KEY,
                name VARCHAR(30));
    
INSERT INTO well_type (name) VALUES ('unknown');
INSERT INTO well_type (name) VALUES ('positive');
INSERT INTO well_type (name) VALUES ('negative');
INSERT INTO well_type (name) VALUES ('blank');
INSERT INTO well_type (name) VALUES ('edge');



DROP TABLE IF EXISTS plate_layout CASCADE;

CREATE TABLE plate_layout (
		plate_layout_name_id INTEGER,
                well_by_col INTEGER,
                well_type_id INTEGER,
		replicates INTEGER,
		target INTEGER,
		FOREIGN KEY (plate_layout_name_id) REFERENCES plate_layout_name(id),
                FOREIGN KEY (well_type_id) REFERENCES well_type(id));

CREATE INDEX pl_plnid  ON plate_layout(plate_layout_name_id);
CREATE INDEX pl_wtid ON plate_layout(well_type_id);
CREATE INDEX pl_wbc ON plate_layout(well_by_col);

DROP TABLE IF EXISTS rearray_pairs CASCADE;

CREATE TABLE rearray_pairs(
id SERIAL PRIMARY KEY,
src INTEGER,
dest INTEGER);

DROP TABLE IF EXISTS worklists CASCADE;

CREATE TABLE worklists(
rearray_pairs_id INTEGER,
                            sample_id INTEGER,
                           source_plate varchar(10),
                           source_well INTEGER,
                           dest_plate varchar(10),
                           dest_well INTEGER,
                           FOREIGN KEY (rearray_pairs_id) REFERENCES rearray_pairs(id)  ON DELETE CASCADE,
                           FOREIGN KEY (sample_id) REFERENCES sample(id));


DROP TABLE IF EXISTS well_numbers CASCADE;
 CREATE TABLE well_numbers(
                             plate_format INTEGER,
                           well_name varchar(5),
                            row_name varchar(5),
                           row_num INTEGER,
                           col varchar(5),
                           total_col_count INTEGER,
                           by_row INTEGER,
                           by_col INTEGER,
                           quad INTEGER,
                           parent_well INTEGER);

CREATE INDEX wn_bc ON well_numbers(by_col);
-- ---------------------------------

\. /home/mbc/projects/lnmysql/mysql/plate_layouts_for_import_mysql.SQL
\. /home/mbc/projects/lnmysql/mysql/well_numbers_for_import_mysql.SQL

