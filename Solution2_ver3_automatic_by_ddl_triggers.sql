/* Author: Mladen Vidic
   E-mail: mladen.vidic@gmail.com
   Date Signed: 7.5.2021.
   Scope: 3rd and final version of the Task 2. 
   
   LICENCE: The licensing rules from the 'license.txt' or '..\license.txt' file apply to this file, solution and its parts.
*/

/*
Task 2. Create DDL trigger, which implements automatic cascade update of dependent 
tables in a schema.

Task description
Any table with Foreign Key (FK) column, which is created by commands CREATE TABLE or 
ALTER TABLE … ADD CONSTRAINT, 
must have value in FK column updated automatically, when the value in referenced Primary 
Key (PK) column of a 
parent table is changed. 
FK values update shall work if several PK values are updated in single UPDATE statement. 
In short, create a DDL Trigger that will create DML triggers. Use dynamic SQL and DB Jobs 
to avoid recursive loop in DDL trigger, when creating DML triggers.
*/

/* SOLUTION 2 DEMO version 3: 
Author: Mladen Vidic
Location: Belgrade, Serbia
Date: 3.5.2021. "DD.MM.YYYY"
Scope: Demonstration that shows the way how can be solved task described above.
*/

/* Final solution for Task 2 is this 3. version: 
	
			In this script are developed cascade delete and update triggers on table "A3_PARENT" to "B3_CHILD" 
            by schema ddl trigger. 
			
			ATTENTION: This version with ddl trigger uses procedures from PL/SQL package 
			"MV_cascade_table_utils" implemented in SQL script file "Solution2_ver2_procs_pkg.sql".
			Use "start" command in SQL Plus or @Solution2_ver2_procs_pkg.sql to execute this script.
*/

conn sys@db_alias as sysdba
--grant execute on DBMS_SCHEDULER to <schema_owner>;
grant create job to <schema_owner>;

conn schema_owner@db_alias
-- A. Both triggers for delete cascade and update cascade are created in a single ddl trigger
CREATE OR REPLACE TRIGGER MV_DDL_CASCADE 
AFTER CREATE OR ALTER 
ON SCHEMA 
WHEN (ORA_DICT_OBJ_TYPE = 'TABLE')
declare
	l_job integer;
Begin
	--if ora_dict_obj_type='TABLE' then		
		
		/*
		--MV_cascade_table_utils.printForAllRefsByTableInfos(ora_dict_obj_owner,ora_dict_obj_name);
		-- OR by JOB
		--DBMS_OUTPUT.PUT_LINE('CALLprintForAllRefsByTableInfos('''||ora_dict_obj_owner||''','''||ora_dict_obj_name||''');');
		--dbms_job.submit(l_job,'CALLprintForAllRefsByTableInfos('''||ora_dict_obj_owner||''','''||ora_dict_obj_name||''');');		
				
		--MV_cascade_table_utils.addANDcleanForAllRefsByTableCascadeTrgsToSchemas(ora_dict_obj_owner,ora_dict_obj_name);
		-- OR by JOB*/
		
		--DBMS_OUTPUT.PUT_LINE('CALLaddANDcleanForAllRefsByTableCascadeTrgsToSchemas('''||ora_dict_obj_owner||''','''||ora_dict_obj_name||''');');
		dbms_job.submit(l_job,'CALLaddANDcleanForAllRefsByTableCascadeTrgsToSchemas('''||ora_dict_obj_owner||''','''||ora_dict_obj_name||''');');		
		
		-- Just for task 2. requirement, call of the procedure would have to be:
		-- MV_cascade_table_utils.addForAllRefsByTableCascadeTrgsToSchemas(ora_dict_obj_owner,ora_dict_obj_name, false, true);
		-- OR by JOB
		--dbms_job.submit(l_job,'MV_cascade_table_utils.addForAllRefsByTableCascadeTrgsToSchemas('''||ora_dict_obj_owner||''','''||ora_dict_obj_name||''', false, true);');
	
	--end if;
End;
/

-- B. There are separate DDL triggers for cascade delete and cascade updates (it is not task requirement, but good option for experiments)
/*
CREATE OR REPLACE TRIGGER MV_DDL_JUSTUPD_CASCADE 
AFTER CREATE OR ALTER 
ON SCHEMA
WHEN (ORA_DICT_OBJ_TYPE = 'TABLE')
declare
	l_job integer;
Begin
	--if ora_dict_obj_type='TABLE' then		
		--MV_cascade_table_utils.addANDcleanForAllRefsByTableCascadeTrgsToSchemas(ora_dict_obj_owner,ora_dict_obj_name, true, false);
		dbms_job.submit(l_job,'MV_cascade_table_utils.addANDcleanForAllRefsByTableCascadeTrgsToSchemas('''||ora_dict_obj_owner||''','''||ora_dict_obj_name||''', true, false);');
	--end if;
End;
/

CREATE OR REPLACE TRIGGER MV_DDL_JUSTDEL_CASCADE 
AFTER CREATE OR ALTER 
ON SCHEMA 
WHEN (ORA_DICT_OBJ_TYPE = 'TABLE')
FOLLOWS MV_DDL_JUSTUPD_CASCADE
declare
	l_job integer;
Begin
	--if ora_dict_obj_type='TABLE' then		
		--MV_cascade_table_utils.addANDcleanForAllRefsByTableCascadeTrgsToSchemas(ora_dict_obj_owner,ora_dict_obj_name, false, true);
		dbms_job.submit(l_job,'MV_cascade_table_utils.addANDcleanForAllRefsByTableCascadeTrgsToSchemas('''||ora_dict_obj_owner||''','''||ora_dict_obj_name||''', false, true);');
	--end if;
End;
/
*/


----------------------------
CREATE TABLE "A3_PARENT"(
  "A3" varchar2(5) NOT NULL,
  "A3Name" Varchar2(60)
)
/

ALTER TABLE "A3_PARENT" ADD CONSTRAINT "pk_A3" PRIMARY KEY ("A3")
/


CREATE TABLE "B3_CHILD"(
  "B3" varchar2(5) NOT NULL,
  "B3Name" Varchar2(30), 
  "FK_A3" varchar2(5)
)
/

ALTER TABLE "B3_CHILD" ADD CONSTRAINT "pk_B3" PRIMARY KEY ("B3")
/

ALTER TABLE "B3_CHILD" ADD CONSTRAINT "fk_B3_A3" FOREIGN KEY ("FK_A3") REFERENCES "A3_PARENT" ("A3")
/


insert into "A3_PARENT"("A3", "A3Name")
values ('a1','A1 name');

insert into "A3_PARENT"("A3", "A3Name")
values ('a2','A2 name');

insert into "A3_PARENT"("A3", "A3Name")
values ('a3','A3 name');

insert into "A3_PARENT"("A3", "A3Name")
values ('a4','A4 name');

commit;


insert into "B3_CHILD"("B3", "B3Name", "FK_A3")
values ('b11','B11 name', 'a1');

insert into "B3_CHILD"("B3", "B3Name", "FK_A3")
values ('b12','B12 name', 'a2');

insert into "B3_CHILD"("B3", "B3Name", "FK_A3")
values ('b21','B21 name', 'a1');


insert into "B3_CHILD"("B3", "B3Name", "FK_A3")
values ('b31','B31 name', 'a1');


insert into "B3_CHILD"("B3", "B3Name", "FK_A3")
values ('b41','B41 name', 'a1');


insert into "B3_CHILD"("B3", "B3Name", "FK_A3")
values ('b43','B41 name', 'a1');

commit;

select * from "A3_PARENT";
select * from "B3_CHILD";

delete "A3_PARENT"
where A3='a2';
-- nije puklo, a i nije trebalo da pukne jer DDL triger je kreirao dml CASCADE DELETe triger

--CREATE OR REPLACE TRIGGER for cascade delete is already created by DDL trigger on SCHEMA.
select owner, trigger_name, trigger_type, triggering_event, table_owner, table_name, column_name, status, action_type
from all_triggers 
where owner=USER
and table_name='A3_PARENT'
and (column_name is null or column_name='A3')
and triggering_event='DELETE';


--CREATE OR REPLACE TRIGGER for cascade update is already created by DDL trigger on SCHEMA.
select owner, trigger_name, trigger_type, triggering_event, table_owner, table_name, column_name, status, action_type
from all_triggers 
where owner=USER
and table_name='A3_PARENT'
and (column_name is null or column_name='A3')
and triggering_event='UPDATE';

select * from "A3_PARENT";
select * from "B3_CHILD";

delete "A3_PARENT"
where A3='a2';

commit;

-- vec je bila obrisana ova instanca

insert into "B3_CHILD"("B3", "B3Name", "FK_A3")
values ('b23','B23 name', 'a3');

insert into "B3_CHILD"("B3", "B3Name", "FK_A3")
values ('b13','B13 name', 'a3');

insert into "B3_CHILD"("B3", "B3Name", "FK_A3")
values ('b34','B34 name', 'a4');

insert into "B3_CHILD"("B3", "B3Name", "FK_A3")
values ('b44','B44 name', 'a4');

commit;

SQL> select * from "A3_PARENT";

A3    A3Name
----- ------------------------------------
a1    A1 name
a3    A3 name
a4    A4 name

3 rows selected.

SQL> select * from "B3_CHILD";

B3    B3Name                         FK_A3
----- ------------------------------ -----
b23   B23 name                       a3
b13   B13 name                       a3
b34   B34 name                       a4
b44   B44 name                       a4
b11   B11 name                       a1
b21   B21 name                       a1
b31   B31 name                       a1
b41   B41 name                       a1
b43   B41 name                       a1

9 rows selected.
 
update "A3_PARENT"
set A3='a5'
where A3='a4';

1 row updated.

commit;

Commit complete.

SQL> select * from "A3_PARENT";

A3    A3Name
----- ------------------------------------------------------------
a1    A1 name
a3    A3 name
a5    A4 name

SQL> select * from "B3_CHILD";

B3    B3Name                         FK_A3
----- ------------------------------ -----
b11   B11 name                       a1
b21   B21 name                       a1
b31   B31 name                       a1
b41   B41 name                       a1
b43   B41 name                       a1
b23   B23 name                       a3
b13   B13 name                       a3
b34   B34 name                       a5
b44   B44 name                       a5

9 rows selected.

SQL> prompt Task 2. finished.
Task 2. finished.






