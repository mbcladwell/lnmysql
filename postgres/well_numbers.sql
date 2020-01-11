DROP  FUNCTION IF EXISTS calc_by_row_num_func()  CASCADE;

CREATE FUNCTION calc_by_row_num_func()
  RETURNS trigger AS
  $BODY$

BEGIN
 NEW.by_row := NEW.total_col_count*(NEW.row_num -1) + CAST(NEW.col AS INTEGER);

IF  (CAST(NEW.col AS INTEGER)%2 = 1) AND ( NEW.row_num%2 = 1)  THEN
    NEW.quad :=1;
    elsif (CAST(NEW.col AS INTEGER)%2 = 0) AND ( NEW.row_num%2 = 1)  THEN
    NEW.quad :=2;
    ELSIF (CAST(NEW.col AS INTEGER)%2 = 1) AND ( NEW.row_num%2 = 0)  THEN
    NEW.quad :=3;
    ELSE
    NEW.quad :=4;
    END IF;
    
 RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS calculate_by_row_number ON well_numbers;

DROP TABLE IF EXISTS well_numbers CASCADE;
CREATE TABLE well_numbers(plate_size INTEGER,
			well_name VARCHAR(5), 
                           row VARCHAR(2),
			   row_num INTEGER,
                           col VARCHAR(2),
			   total_col_count INTEGER,
                           by_row INTEGER,
                           by_col INTEGER,
                           quad INTEGER,
			   parent_well VARCHAR(5));

CREATE TRIGGER calculate_by_row_number
before INSERT ON well_numbers
FOR EACH row EXECUTE PROCEDURE calc_by_row_num_func();



-----well_numbers-------------------------


SELECT fill_well_numbers_a();
SELECT * FROM well_numbers WHERE plate_size = 96;



