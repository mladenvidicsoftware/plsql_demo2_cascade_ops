/* Author: Mladen Vidic
   E-mail: mladen.vidic@gmail.com
   Date Signed: 7.5.2021.
   Scope: 1st version
   
   LICENCE: The licensing rules from the 'license.txt' or '..\license.txt' file apply to this file, solution and its parts.
*/

/*
1. version: In this script are developed cascade delete and update triggers on table "A_PARENT" to "B_CHILD"
            manually.
*/

CREATE TABLE "A_PARENT"(
  "A" varchar2(5) NOT NULL,
  "AName" Varchar2(60)
)
/

ALTER TABLE "A_PARENT" ADD CONSTRAINT "pk_A" PRIMARY KEY ("A")
/


CREATE TABLE "B_CHILD"(
  "B" varchar2(5) NOT NULL,
  "BName" Varchar2(30), 
  "FK_A" varchar2(5)
)
/

ALTER TABLE "B_CHILD" ADD CONSTRAINT "pk_B" PRIMARY KEY ("B")
/

ALTER TABLE "B_CHILD" ADD CONSTRAINT "fk_A_A" FOREIGN KEY ("FK_A") REFERENCES "A_PARENT" ("A")
/


insert into "A_PARENT"("A", "AName")
values ('a1','A1 name');

insert into "A_PARENT"("A", "AName")
values ('a2','A2 name');

insert into "A_PARENT"("A", "AName")
values ('a3','A3 name');

insert into "A_PARENT"("A", "AName")
values ('a4','A4 name');

commit;


insert into "B_CHILD"("B", "BName", "FK_A")
values ('b11','B11 name', 'a1');

insert into "B_CHILD"("B", "BName", "FK_A")
values ('b12','B12 name', 'a2');

insert into "B_CHILD"("B", "BName", "FK_A")
values ('b21','B21 name', 'a1');


insert into "B_CHILD"("B", "BName", "FK_A")
values ('b31','B31 name', 'a1');


insert into "B_CHILD"("B", "BName", "FK_A")
values ('b41','B41 name', 'a1');


insert into "B_CHILD"("B", "BName", "FK_A")
values ('b43','B41 name', 'a1');

commit;

delete "A_PARENT"
where A='a2';

-- puklo

--CREATE OR REPLACE TRIGGER
--CREATE TRIGGER
CREATE OR REPLACE TRIGGER
"A_B_DELCAS" BEFORE DELETE ON "A_PARENT"
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW 	
Begin
	delete "B_CHILD"
	where "FK_A"= :OLD."A";
End;
/

--CREATE OR REPLACE TRIGGER
--CREATE TRIGGER
CREATE OR REPLACE TRIGGER
"A_B_UPDCAS" AFTER UPDATE OF "A" ON "A_PARENT"
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW 	
Begin
	update "B_CHILD"
	set "FK_A"=:NEW."A"
	where "FK_A"=:OLD."A";
End;
/

select * from "A_PARENT";
select * from "B_CHILD";

delete "A_PARENT"
where A='a2';

commit;

-- sada nije puklo jer ima trigger

insert into "B_CHILD"("B", "BName", "FK_A")
values ('b23','B23 name', 'a3');

insert into "B_CHILD"("B", "BName", "FK_A")
values ('b13','B13 name', 'a3');

insert into "B_CHILD"("B", "BName", "FK_A")
values ('b34','B34 name', 'a4');

insert into "B_CHILD"("B", "BName", "FK_A")
values ('b44','B44 name', 'a4');

commit;


select * from "A_PARENT";
select * from "B_CHILD";

 
-- Treba proveriti da li ce raditi triger za update. Ako ne bude radio, staviti da bude 
-- defferd constraint, ili u transakciji ili za constraint da se kaze da je proveriv na kraju transakcije.

update "A_PARENT"
set A='a5'
where A='a4';

SQL> update "A_PARENT"
  2  set A='a5'
  3  where A='a4';

1 row updated.

SQL> commit;

Commit complete.

SQL> select * from "A_PARENT";

A     AName
----- ------------------------------------
a1    A1 name
a3    A3 name
a5    A4 name

3 rows selected.

SQL> select * from "B_CHILD";

B     BName                          FK_A
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

Kao sto se primeti, trigger radi posao za update u zavisnoj tabeli.








