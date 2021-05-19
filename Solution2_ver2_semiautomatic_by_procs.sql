/* Author: Mladen Vidic
   E-mail: mladen.vidic@gmail.com
   Date Signed: 7.5.2021.
   Scope: 2nd version
   
   LICENCE: The licensing rules from the 'license.txt' or '..\license.txt' file apply to this file, solution and its parts.
*/

/*
2. version: In this script are developed cascade delete and update triggers on table "A2_PARENT" to "B2_CHILD" 
            by procedures.
			Script Solution2_ver2_procs_pkg.sql MUST be executed from SQL Plus or similar PL/SQL editor
			as DEMO_OWNER user.
*/

CREATE TABLE "A2_PARENT"(
  "A2" varchar2(5) NOT NULL,
  "A2Name" Varchar2(60)
)
/

ALTER TABLE "A2_PARENT" ADD CONSTRAINT "pk_A2" PRIMARY KEY ("A2")
/


CREATE TABLE "B2_CHILD"(
  "B2" varchar2(5) NOT NULL,
  "B2Name" Varchar2(30), 
  "FK_A2" varchar2(5)
)
/

ALTER TABLE "B2_CHILD" ADD CONSTRAINT "pk_B2" PRIMARY KEY ("B2")
/

ALTER TABLE "B2_CHILD" ADD CONSTRAINT "fk_A2_A2" FOREIGN KEY ("FK_A2") REFERENCES "A2_PARENT" ("A2")
/


insert into "A2_PARENT"("A2", "A2Name")
values ('a1','A1 name');

insert into "A2_PARENT"("A2", "A2Name")
values ('a2','A2 name');

insert into "A2_PARENT"("A2", "A2Name")
values ('a3','A3 name');

insert into "A2_PARENT"("A2", "A2Name")
values ('a4','A4 name');

commit;


insert into "B2_CHILD"("B2", "B2Name", "FK_A2")
values ('b11','B11 name', 'a1');

insert into "B2_CHILD"("B2", "B2Name", "FK_A2")
values ('b12','B12 name', 'a2');

insert into "B2_CHILD"("B2", "B2Name", "FK_A2")
values ('b21','B21 name', 'a1');


insert into "B2_CHILD"("B2", "B2Name", "FK_A2")
values ('b31','B31 name', 'a1');


insert into "B2_CHILD"("B2", "B2Name", "FK_A2")
values ('b41','B41 name', 'a1');


insert into "B2_CHILD"("B2", "B2Name", "FK_A2")
values ('b43','B41 name', 'a1');

commit;

delete "A2_PARENT"
where A2='a2';
-- error

--CREATE OR REPLACE TRIGGER for cascade delete
set serveroutput on

declare
	statout integer;
Begin 
	MV_cascade_table_utils.addTrgDELETECASCADEForTable(USER, 'A2_PARENT', 'A2', 
														USER, 'B2_CHILD', 'FK_A2', statout);
End;
/

--CREATE OR REPLACE TRIGGER for cascade update
set serveroutput on

declare
	statout integer;
Begin 
	MV_cascade_table_utils.addTrgUPDATECASCADEForTable(USER, 'A2_PARENT', 'A2', 
														USER, 'B2_CHILD', 'FK_A2', statout);
End;
/

select * from "A2_PARENT";
select * from "B2_CHILD";

delete "A2_PARENT"
where A2='a2';

commit;


-- sada nije puklo jer ima trigger

insert into "B2_CHILD"("B2", "B2Name", "FK_A2")
values ('b23','B23 name', 'a3');

insert into "B2_CHILD"("B2", "B2Name", "FK_A2")
values ('b13','B13 name', 'a3');

insert into "B2_CHILD"("B2", "B2Name", "FK_A2")
values ('b34','B34 name', 'a4');

insert into "B2_CHILD"("B2", "B2Name", "FK_A2")
values ('b44','B44 name', 'a4');

commit;

select * from "A2_PARENT";
select * from "B2_CHILD";
 
update "A2_PARENT"
set A2='a5'
where A2='a4';

1 row updated.

commit;

Commit complete.

SQL> select * from "A2_PARENT";

A2    A2Name
----- ------------------------------------
a1    A1 name
a3    A3 name
a5    A4 name

3 rows selected.

SQL> select * from "B2_CHILD";

B2    B2Name                         FK_A2
----- ------------------------------ -----
b23   B23 name                       a3
b13   B13 name                       a3
b34   B34 name                       a5
b44   B44 name                       a5
b11   B11 name                       a1
b21   B21 name                       a1
b31   B31 name                       a1
b41   B41 name                       a1
b43   B41 name                       a1

9 rows selected.

SQL>








