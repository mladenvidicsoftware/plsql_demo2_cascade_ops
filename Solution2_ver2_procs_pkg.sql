/* Author: Mladen Vidic
   E-mail: mladen.vidic@gmail.com
   Date Signed: 7.5.2021.
   Scope:  Demo solution for cascade delete and update triggers for semi-automatic and ddl trigger-driven automatic creation/update
           of CASCADE DELETE and CASCADE UPDATE triggers with single column constraints, string list constraints or comma 
		   separated list of columns in constraint.
		   
	Note: Procedures and function could have shorter names. These names are used for self describing purposes for better readability 
	and easier following of code development pathway.
	
	LICENCE: The licensing rules from the 'license.txt' or '..\license.txt' file apply to this file, solution and its parts.
*/
   
/* MV_cascade_table_utils - Package that is implemented to support adding CASCADE DELETE and UPDATE triggers in Task2 demo by procs seni/automatically or by DDL triggers
                            on dependant tables.

*/

--@@MV_StringList_Type.sql

CREATE OR REPLACE Package &&DEMO_OWNER..MV_cascade_table_utils IS	
	
	/*  addTrgDELETECASCADEForTable 
			- This procedure adds trigger to table "p_ukSchemaName"."p_ukTName" with name "p_fkSchemaName"."<p_ukColumnName>_<p_fkTName>_<p_fkColumnName>_DELCAS"
			for delete cascade on parent to the FK dependant table. It can exist 
			with referential ON DELETE RESTRICT or ON DELETE CASCADE constraints. In first case use carefully 
            because it deletes dependants rows even constraint says to be restricted.
            In second case it does deletion before systems raises deletion of dependant rows. 			  
		
		Parameters: 
			p_ukSchemaName - owner schema for parent table
			p_ukTName - name of the parent table with PK/UK 
			p_ukColumnName - PK/UK column
			p_fkSchemaName - owner schema for dependant child table
			p_fkTName - name of the dependant child table with PK/UK 
			p_fkColumnName - FK column
		Output:
			status - 	0 	- 	trigger created.
						1	-	trigger has been created in the past.
						-1 	- 	unkown UK column parameter for PK/UK table
						-2 	- 	unkown FK column parameter for FK table
						-10	-	there is no UK column with that name in PK/UK table
						-11	-	there is no FK column with that name in FK table
						-20	-	Some other Oracle error was happened.
				
		Restriction: This implementation works with single column PK/UK//FK. In case of several columns
		than should have to be used lists of columns. Use of lists in simpler manner is shown in solution 1.
	*/	
	-- RESTRICTION: FK Constraint is with JUST ONE column p_fkColumnName to p_ukColumnName.
	-- For more than one column in comma separated list use addTrgDELETECASCADEForTableCCCSSL
	procedure addTrgDELETECASCADEForTable(p_ukSchemaName IN varchar2, p_ukTName IN varchar2, p_ukColumnName in varchar2,
								p_fkSchemaName IN varchar2, p_fkTName IN varchar2, p_fkColumnName in varchar2,
								status out integer);
	
	-- Similar to addTrgDELETECASCADEForTable, with string list of columns rather than just one column in referential constraints
	-- CCSL means "Constraint columns are string list" 	
	procedure addTrgDELETECASCADEForTableCCSL(p_ukSchemaName IN varchar2, p_ukTName IN varchar2, p_ukColumnList in MV_StringList_Type,
								p_fkSchemaName IN varchar2, p_fkTName IN varchar2, p_fkColumnList in MV_StringList_Type,
								status out integer);

	procedure dropTrgDELETECASCADEForTableCCSL(p_ukSchemaName IN varchar2, p_ukTName IN varchar2, p_ukColumnList in MV_StringList_Type,
								p_fkSchemaName IN varchar2, p_fkTName IN varchar2, p_fkColumnList in MV_StringList_Type,
								status out integer);
								
	-- Similar to addTrgDELETECASCADEForTable, with comma string list of columns rather than just one column in referential constraints
	-- CCCSSL means "Constraint columns are comma separated string list" 	
	procedure addTrgDELETECASCADEForTableCCCSSL(p_ukSchemaName IN varchar2, p_ukTName IN varchar2, p_ukColumnCSSList in varchar2,
								p_fkSchemaName IN varchar2, p_fkTName IN varchar2, p_fkColumnCSSList in varchar2,
								status out integer);

	procedure dropTrgDELETECASCADEForTableCCCSSL(p_ukSchemaName IN varchar2, p_ukTName IN varchar2, p_ukColumnCSSList in varchar2,
								p_fkSchemaName IN varchar2, p_fkTName IN varchar2, p_fkColumnCSSList in varchar2,
								status out integer);
								
								
	/*  addTrgUPDATECASCADEForTable 
			- This procedure adds trigger to table "p_ukSchemaName"."p_ukTName" with name "p_fkSchemaName"."<p_ukColumnName>_<p_fkTName>_<p_fkColumnName>_UPDCAS" 
			for update cascade on parent to the FK dependant table. It can exist 
			with referential ON UPDATE RESTRICT or ON UPDATE CASCADE constraints. 
			  
		Parameters: 
			p_ukSchemaName - owner schema for parent table
			p_ukTName - name of the parent table with PK/UK 
			p_ukColumnName - PK/UK column
			p_fkSchemaName - owner schema for dependant child table
			p_fkTName - name of the dependant child table with PK/UK 
			p_fkColumnName - FK column
		Output:
			status - 	0 	- 	trigger created.
						1	-	trigger has been created in the past.
						-1 	- 	unkown UK column parameter for PK/UK table
						-2 	- 	unkown FK column parameter for FK table
						-10	-	there is no UK column with that name in PK/UK table
						-11	-	there is no FK column with that name in FK table
						-20	-	Some other Oracle error was happened.
				
		Restriction: This implementation works with single column PK/UK//FK. In case of several columns
		than should have to be used lists of columns. Use of lists in simpler manner is shown in solution 1.
	*/
	-- RESTRICTION: FK Constraint is with JUST ONE column p_fkColumnName to p_ukColumnName.
	-- For more than one column in comma separated list use addTrgUPDATECASCADEForTableCCCSSL
	procedure addTrgUPDATECASCADEForTable(p_ukSchemaName IN varchar2, p_ukTName IN varchar2, p_ukColumnName in varchar2,
								p_fkSchemaName IN varchar2, p_fkTName IN varchar2, p_fkColumnName in varchar2,
								status out integer);
	
	-- Similar to addTrgUPDATECASCADEForTable, with string list of columns rather than just one column in referential constraints
	-- CCSL means "Constraint columns are string list"
	procedure addTrgUPDATECASCADEForTableCCSL(p_ukSchemaName IN varchar2, p_ukTName IN varchar2, p_ukColumnList in MV_StringList_Type,
								p_fkSchemaName IN varchar2, p_fkTName IN varchar2, p_fkColumnList in MV_StringList_Type,
								status out integer);

	procedure dropTrgUPDATECASCADEForTableCCSL(p_ukSchemaName IN varchar2, p_ukTName IN varchar2, p_ukColumnList in MV_StringList_Type,
								p_fkSchemaName IN varchar2, p_fkTName IN varchar2, p_fkColumnList in MV_StringList_Type,
								status out integer);
								
	-- Similar to addTrgUPDATECASCADEForTable, with comma string list of columns rather than just one column in referential constraints
	-- CCCSSL means "Constraint columns are comma separated string list"							
	procedure addTrgUPDATECASCADEForTableCCCSSL(p_ukSchemaName IN varchar2, p_ukTName IN varchar2, p_ukColumnCSSList in varchar2,
								p_fkSchemaName IN varchar2, p_fkTName IN varchar2, p_fkColumnCSSList in varchar2,
								status out integer);
								
	procedure dropTrgUPDATECASCADEForTableCCCSSL(p_ukSchemaName IN varchar2, p_ukTName IN varchar2, p_ukColumnCSSList in varchar2,
								p_fkSchemaName IN varchar2, p_fkTName IN varchar2, p_fkColumnCSSList in varchar2,
								status out integer);

	function getConsColumnsCommaSepStrList(p_SchemaName IN varchar2, p_TName IN varchar2, p_ConsName in varchar2) return varchar2;
	
	-- Find all existing enabled FKs of table, and for them create/relace delete/update cascade triggers as it is requested
	procedure addForAllRefsByTableCascadeTrgsToSchemas(	p_TOwner IN varchar2, p_TName IN varchar2, 
														p_ON_ForDelete in boolean default true, p_ON_ForUpdate in boolean default true); 
	
	-- Find all cascade delete/update triggers of not exisitng ref constraints an drops tem if requested
	procedure dropForAllNotExistingRefsByTableCascadeTrgsOnSchemas(	p_TOwner IN varchar2, p_TName IN varchar2, 
														p_OFF_ForDelete in boolean default true, p_OFF_ForUpdate in boolean default true); 
														
	procedure addANDcleanForAllRefsByTableCascadeTrgsToSchemas(	p_TOwner IN varchar2, p_TName IN varchar2, 
														p_ForDelete in boolean default true, p_ForUpdate in boolean default true); 
	
	-- For debug delay in DDL trigger of FK creation.
	procedure printForAllRefsByTableInfos(p_TOwner IN varchar2, p_TName IN varchar2);
	
	---------------------------------------------------------------------------------
	function getTriggerNameMVUtilCascadeDELCAS(p_ukCol IN varchar2, p_TName IN varchar2, p_fkCol in varchar2) return varchar2;
	
	function getTriggerNameMVUtilCascadeUPDCAS(p_ukCol IN varchar2, p_TName IN varchar2, p_fkCol in varchar2) return varchar2;
	
	function isTriggerNameMVUtilCascadeDELCAS(p_triggerName IN varchar2, p_ukCol IN varchar2, p_TName IN varchar2, p_fkCol in varchar2) return integer;
	
	function isTriggerNameMVUtilCascadeUPDCAS(p_triggerName IN varchar2, p_ukCol IN varchar2, p_TName IN varchar2, p_fkCol in varchar2) return integer;
	
	function isTriggerNameMVUtilUPDCASorDELCAS(p_triggerName IN varchar2, p_ukCol IN varchar2, p_TName IN varchar2, p_fkCol in varchar2) return integer;
	
	function isTriggerNameMVUtilLikeUPDCASorDELCAS(p_triggerName IN varchar2, p_TName IN varchar2) return integer;
	
END;
/

--@@MV_StringList_utils_pkg.sql


CREATE OR REPLACE Package Body &&DEMO_OWNER..MV_cascade_table_utils IS	


	procedure addForAllRefsByTableCascadeTrgsToSchemas(	p_TOwner IN varchar2, p_TName IN varchar2, 
														p_ON_ForDelete in boolean default true, p_ON_ForUpdate in boolean default true)
	is
		lr_table_name all_constraints.table_name%TYPE; --varchar2(50);		
		lr_owner all_constraints.r_owner%TYPE;
		lr_constraint_name all_constraints.r_constraint_name%TYPE;
		
		-- Find all existing enabled FKs of table
		cursor curTabRefFKs is
			select owner, constraint_name, constraint_type, table_name, r_owner, 
			r_constraint_name, status, last_change
			from all_constraints
			where owner= p_TOwner
			and   table_name = p_TName
			and constraint_type='R'
			and status='ENABLED' -- da li treba ovaj enabled, da li je prisutan u toku opaljenja ddl trigera?
			;
	
		l_ukColumnsCSSL varchar2(2500);
		l_fkColumnsCSSL varchar2(2500);
		l_status integer;
	begin
		--demo_message.add_debugline('C21.');
		
		--demo_message.add_debugline('C21.Vars:'||p_TOwner||','||p_TName||';');
		
		for itemFK in curTabRefFKs
			LOOP
				lr_owner:=itemFK.r_owner;
				lr_constraint_name:=itemFK.r_constraint_name;
				
				--demo_message.add_debugline('C211.');
							
				select table_name into lr_table_name
				from all_constraints
				where owner=itemFK.r_owner
				and   constraint_name = itemFK.r_constraint_name
				and constraint_type in ('P','U');
				
				--demo_message.add_debugline('C212.');
				
				--demo_message.add_debugline('1. Vars:'||lr_owner||','||lr_constraint_name||','||lr_table_name);
				
				l_ukColumnsCSSL:= getConsColumnsCommaSepStrList(itemFK.r_owner, lr_table_name, itemFK.r_constraint_name);
				l_fkColumnsCSSL:= getConsColumnsCommaSepStrList(itemFK.owner, itemFK.table_name, itemFK.constraint_name);
				
				--demo_message.add_debugline('2. Vars:'||l_ukColumnsCSSL);
				--demo_message.add_debugline('3. Vars:'||l_fkColumnsCSSL);
				
				-- Next part doesn't depend of constraints. Columns have been already found.
				-- It is responsible for triggers.
				if p_ON_ForDelete then
				
					--demo_message.add_debugline('C213.');
					addTrgDELETECASCADEForTableCCCSSL(itemFK.r_owner, lr_table_name, l_ukColumnsCSSL,
									itemFK.owner, itemFK.table_name, l_fkColumnsCSSL, l_status);
				end if;
				
				if p_ON_ForUpdate then				
					--demo_message.add_debugline('C214.');
					addTrgUPDATECASCADEForTableCCCSSL(itemFK.r_owner, lr_table_name, l_ukColumnsCSSL,
									itemFK.owner, itemFK.table_name, l_fkColumnsCSSL, l_status);
				end if;				
			END LOOP;	
			
		--demo_message.add_debugline('C22.');
		
		exception
			when no_data_found then
				DEMO_MESSAGE.ADD_LINE('Error:Cannot find table name for PK/UK constraint "'||lr_owner||'"."'||lr_constraint_name||'".' );
				return;
			when others then			
				DEMO_MESSAGE.ADD_LINE('SQL returned error message: '||SQLERRM||'.');
				return;
	end;
	
	procedure dropForAllNotExistingRefsByTableCascadeTrgsOnSchemas(	p_TOwner IN varchar2, p_TName IN varchar2, 
														p_OFF_ForDelete in boolean default true, p_OFF_ForUpdate in boolean default true)
	is
		sql_trigger_name varchar2(500);		
				
		-- drop triggers DELCAS or UPDCAS that exists and not exists related FK enabled
		
		cursor curTgsForDrop is	
			select trigger_name, table_owner, table_name, triggering_event
			from all_triggers at1
			where at1.owner = p_TOwner
			and at1.triggering_event in ('DELETE','UPDATE')
			and MV_cascade_table_utils.isTriggerNameMVUtilLikeUPDCASorDELCAS(at1.trigger_name, p_TName)=1 
			and not exists 
				(select 1
				from all_constraints acFK join all_constraints acUK 
				ON acUK.owner=acFK.r_owner and acUK.constraint_name = acFK.r_constraint_name
				where acFK.owner = at1.owner
				and   acFK.table_name = p_TName
				and acFK.constraint_type='R'
				and acFK.status='ENABLED'
				and acUK.constraint_type in ('P','U') 
				and MV_cascade_table_utils.isTriggerNameMVUtilUPDCASorDELCAS(at1.trigger_name,
						MV_StringList_utils.getFirstElFromCommaString(
							MV_cascade_table_utils.getConsColumnsCommaSepStrList(acUK.owner, acUK.table_name, acUK.constraint_name)),
						acFK.table_name,
						MV_StringList_utils.getFirstElFromCommaString(
							MV_cascade_table_utils.getConsColumnsCommaSepStrList(acFK.owner, acFK.table_name, acFK.constraint_name))
							)=1
				);		
	
		sql_trigger_ddl varchar2(550);
		l_status integer;
	begin
		for itemTGR in curTgsForDrop
		LOOP
			if (itemTGR.triggering_event='DELETE' and p_OFF_ForDelete) or (itemTGR.triggering_event='UPDATE' and p_OFF_ForUpdate) then 
				sql_trigger_name:='"'||p_TOwner||'"."'||itemTGR.trigger_name;
				sql_trigger_name:=sql_trigger_name||'"';
			
				sql_trigger_ddl:='DROP TRIGGER '||sql_trigger_name||' ';	
				EXECUTE IMMEDIATE sql_trigger_ddl;
				
				DEMO_MESSAGE.ADD_LINE('Info: Didn''t find related FK from table "'||p_TOwner||'"."'||p_TName||'" to "'||itemTGR.table_owner||'"."'||itemTGR.table_name||'". Trigger '||sql_trigger_name||' on "'||itemTGR.table_owner||'"."'||itemTGR.table_name||'" for CASCADE '||itemTGR.triggering_event||' to the table "'||p_TOwner||'"."'||p_TName||'" is dropped.');
			end if;
		END LOOP;	
			
		exception
			--when no_data_found then
				--return;
			when others then			
				DEMO_MESSAGE.ADD_LINE('SQL returned error message: '||SQLERRM||'.');
				return;
	end;													

	procedure addANDcleanForAllRefsByTableCascadeTrgsToSchemas(	p_TOwner IN varchar2, p_TName IN varchar2, 
														p_ForDelete in boolean default true, p_ForUpdate in boolean default true)
	is
	begin
		--demo_message.add_debugline('C2.');
		addForAllRefsByTableCascadeTrgsToSchemas(p_TOwner,p_TName, p_ForDelete, p_ForUpdate);
		dropForAllNotExistingRefsByTableCascadeTrgsOnSchemas(p_TOwner,p_TName, p_ForDelete, p_ForUpdate);
	end;
														
	-- For debuging FK creation delay in DDL trigger.
	procedure printForAllRefsByTableInfos(p_TOwner IN varchar2, p_TName IN varchar2)
	is
		lr_table_name all_constraints.table_name%TYPE; --varchar2(50);		
		lr_owner all_constraints.r_owner%TYPE;
		lr_constraint_name all_constraints.r_constraint_name%TYPE;
		
		cursor curTabRefFKs is
			select owner, constraint_name, constraint_type, table_name, r_owner, 
			r_constraint_name, status, last_change
			from all_constraints
			where owner= p_TOwner
			and   table_name = p_TName
			and constraint_type='R'
			--and status='ENABLED' -- da li treba ovaj enabled, da li je prisutan u toku opaljenja ddl trigera?
			;
	
		l_ukColumnsCSSL varchar2(2500);
		l_fkColumnsCSSL varchar2(2500);
		l_status integer;
	begin
		for itemFK in curTabRefFKs
			LOOP
				lr_owner:=itemFK.r_owner;
				lr_constraint_name:=itemFK.r_constraint_name;
				
				select table_name into lr_table_name
				from all_constraints
				where owner=itemFK.r_owner
				and   constraint_name = itemFK.r_constraint_name
				and constraint_type in ('P','U');
				
				l_ukColumnsCSSL:=MV_cascade_table_utils.getConsColumnsCommaSepStrList(itemFK.r_owner, lr_table_name, itemFK.r_constraint_name);
				l_fkColumnsCSSL:=MV_cascade_table_utils.getConsColumnsCommaSepStrList(itemFK.owner, itemFK.table_name, itemFK.constraint_name);
				
				-- Next part doesn't depend of constraints. Columns have been already found.
				-- It is responsible for triggers.				
				DEMO_MESSAGE.ADD_LINE(	'Found FK "'||itemFK.constraint_name||'" in table '||
											'"'||itemFK.owner||'"."'||itemFK.table_name||
											' for columns ('||l_fkColumnsCSSL||') on to table '||
											'"'||itemFK.r_owner||'"."'||lr_table_name||'" columns ('||l_ukColumnsCSSL||')');	
			END LOOP;	
			
		exception
			when no_data_found then
				DEMO_MESSAGE.ADD_LINE('Error:Cannot find table name for PK/UK constraint "'||lr_owner||'"."'||lr_constraint_name||'".' );
				return;
			when others then			
				DEMO_MESSAGE.ADD_LINE('SQL returned error message: '||SQLERRM||'.');
				return;
	end;	
	
	-- Condition: p_fkSchemaName user needs create trigger privilege on p_ukSchemaName.p_ukTName table!	
	procedure addTrgDELETECASCADEForTable(p_ukSchemaName IN varchar2, p_ukTName IN varchar2, p_ukColumnName in varchar2,
								p_fkSchemaName IN varchar2, p_fkTName IN varchar2, p_fkColumnName in varchar2,
								status out integer) 
	is
		sql_trigger_name varchar2(200);
		sql_trigger_ddl varchar2(2000);
		select_code_step integer:=0;
		cnt integer;
	begin
		-- Check if is known parent UK column
		if p_ukColumnName is null then
			status:=-1;
			DEMO_MESSAGE.ADD_LINE('Error:Unknown UK column for table "'||p_ukSchemaName||'"."'||p_ukTName||'".');
			return;
		end if;
		
		-- Check if is known child FK column
		if p_fkColumnName is null then
			status:=-2;
			DEMO_MESSAGE.ADD_LINE('Error:Unknown FK column for table "'||p_fkSchemaName||'"."'||p_fkTName||'".');
			return;
		end if;		
		
		-- Check existence of parent UK column
		select 0 into status from all_tab_columns
		where owner=p_ukSchemaName
		and table_name=p_ukTName
		and column_name=p_ukColumnName;
		
		select_code_step:=1;
		
		-- Check existence of child FK column
		select 0 into status from all_tab_columns
		where owner=p_fkSchemaName
		and table_name=p_fkTName
		and column_name=p_fkColumnName;
		
		select_code_step:=2;		
		
		select count(*) into cnt 
		from
		(select 0 from all_triggers
		where owner=p_fkSchemaName
		and --trigger_name like *******************************************************
			isTriggerNameMVUtilCascadeDELCAS(trigger_name, p_ukColumnName, p_fkTName, p_fkColumnName)=1
		and table_owner=p_ukSchemaName
		and table_name=p_ukTName);
		
		-- DDL and DML commands are case sensitive in referenced objects only if "" are used for schema and object_name.
		sql_trigger_name:='"'||p_fkSchemaName||'"."'||getTriggerNameMVUtilCascadeDELCAS(p_ukColumnName, p_fkTName, p_fkColumnName);
		sql_trigger_name:=sql_trigger_name||'"';
		
		if cnt=0 then
			--sql_trigger_name:=sql_trigger_name||'"';
			null;
		else
			--sql_trigger_name:=sql_trigger_name||to_char(cnt+1)||'"';
			DEMO_MESSAGE.ADD_LINE('Info: Trigger '||sql_trigger_name||' on "'||p_ukSchemaName||'"."'||p_ukTName||'" for CASCADE DELETE to the table "'||p_fkSchemaName||'"."'||p_fkTName||'" has been created already.');
			status:=1;
			return;
		end if;
		
		-- before delete : cascade delete dependant indstances even has constraint with restrict options (USE CAREFULLY)
        -- after delete will not fire if has restricted constraint.		
		sql_trigger_ddl:= 
		'CREATE OR REPLACE TRIGGER '		
		||sql_trigger_name||' BEFORE DELETE ON "'||p_ukSchemaName||'"."'||p_ukTName||'" '|| 
		'REFERENCING NEW AS NEW OLD AS OLD
		FOR EACH ROW
		Begin
			delete "'||p_fkSchemaName||'"."'||p_fkTName||'"
			where "'||p_fkColumnName||'"= :OLD."'||p_ukColumnName||'";
		End;';	
		
		EXECUTE IMMEDIATE sql_trigger_ddl;	
		
		DEMO_MESSAGE.ADD_LINE('Info: Trigger '||sql_trigger_name||' on "'||p_ukSchemaName||'"."'||p_ukTName||'" for CASCADE DELETE to the table "'||p_fkSchemaName||'"."'||p_fkTName||'" is created.');
		
		status:=0;
				
		exception
			when no_data_found then
				if select_code_step=0 then
					DEMO_MESSAGE.ADD_LINE('Error:There is no accessible column with name "'||p_ukColumnName||'" in UK table "'||p_ukSchemaName||'"."'||p_ukTName||'".' );
					status:=-10;					
				elsif select_code_step=1 then
					DEMO_MESSAGE.ADD_LINE('Error:There is no accessible column with name "'||p_fkColumnName||'" in FK table "'||p_fkSchemaName||'"."'||p_fkTName||'".' );
					status:=-11;					
				end if;
				return;
			when others then			
				DEMO_MESSAGE.ADD_LINE('SQL returned error message: '||SQLERRM||'.');
				status:=-20;
				return;
	end;
	
	procedure addTrgDELETECASCADEForTableCCSL(p_ukSchemaName IN varchar2, p_ukTName IN varchar2, p_ukColumnList in MV_StringList_Type,
								p_fkSchemaName IN varchar2, p_fkTName IN varchar2, p_fkColumnList in MV_StringList_Type,
								status out integer) 
	is
		sql_trigger_name varchar2(200);
		sql_trigger_ddl varchar2(2000);
		cnt integer;
		cnt_temp integer;
		l_i integer;
	begin
		--demo_message.add_debugline('C215B1.');
		
		-- Check if is known parent UK column list
		if p_ukColumnList is null or p_ukColumnList.COUNT<1 then
			status:=-1;
			DEMO_MESSAGE.ADD_LINE('Error:Unknown UK column list for table "'||p_ukSchemaName||'"."'||p_ukTName||'".');
			return;
		end if;
		
		--demo_message.add_debugline('C215B2.');
		
		-- Check if is known child FK column list
		if p_fkColumnList is null or p_fkColumnList.COUNT<1 then
			status:=-2;
			DEMO_MESSAGE.ADD_LINE('Error:Unknown FK column list for table "'||p_fkSchemaName||'"."'||p_fkTName||'".');
			return;
		end if;		
		
		--demo_message.add_debugline('C215B3.');
		
		-- Check existence of all columns in UK key list for parent table
		cnt:=0;
		for l_i in 1..p_ukColumnList.count loop
			select count(*) into cnt_temp -- 0 or 1
			from (select 0 from all_tab_columns
				where owner=p_ukSchemaName
				and table_name=p_ukTName
				and column_name=p_ukColumnList(l_i)
				);
		    if cnt_temp=0 then
			    exit;
			else 
				cnt:=cnt+1;
			end if;
		end loop;
		
		--demo_message.add_debugline('C215B4.');
		
		if cnt< p_ukColumnList.count then
			DEMO_MESSAGE.ADD_LINE('Error:There is no accessible column with name "'||p_ukColumnList(l_i)||'" in UK table "'||p_ukSchemaName||'"."'||p_ukTName||'".' );
			status:=-10;
			return;		
		end if;	
		
		-- Check existence of all columns in FK key list for child table
		cnt:=0;
		for l_i in 1..p_fkColumnList.count loop
			select count(*) into cnt_temp -- 0 or 1
			from (select 0 from all_tab_columns
				where owner=p_fkSchemaName
				and table_name=p_fkTName
				and column_name=p_fkColumnList(l_i)
				);
		    if cnt_temp=0 then
			    exit;
			else 
				cnt:=cnt+1;
			end if;
		end loop;
		
		--demo_message.add_debugline('C215B5.');
		
		if cnt< p_fkColumnList.count then
			DEMO_MESSAGE.ADD_LINE('Error:There is no accessible column with name "'||p_fkColumnList(l_i)||'" in FK table "'||p_fkSchemaName||'"."'||p_fkTName||'".' );
			status:=-11;
			return;		
		end if;		
		
		select count(*) into cnt 
		from
		(select 0 from all_triggers
		where owner=p_fkSchemaName
		and --trigger_name like ***************************************************************
			isTriggerNameMVUtilCascadeDELCAS(trigger_name, p_ukColumnList(1), p_fkTName, p_fkColumnList(1))=1
		and table_owner=p_ukSchemaName
		and table_name=p_ukTName);
		
		--demo_message.add_debugline('C215B6.');
		
		-- DDL and DML commands are case sensitive in referenced objects only if "" are used for schema and object_name.
		sql_trigger_name:='"'||p_fkSchemaName||'"."'||getTriggerNameMVUtilCascadeDELCAS(p_ukColumnList(1), p_fkTName, p_fkColumnList(1));
		sql_trigger_name:=sql_trigger_name||'"';
		
		--demo_message.add_debugline('C215B7.');
		
		if cnt=0 then
			--sql_trigger_name:=sql_trigger_name||'"';
			null;
		else
			--sql_trigger_name:=sql_trigger_name||to_char(cnt+1)||'"';
			DEMO_MESSAGE.ADD_LINE('Info: Trigger '||sql_trigger_name||' on "'||p_ukSchemaName||'"."'||p_ukTName||'" for CASCADE DELETE to the table "'||p_fkSchemaName||'"."'||p_fkTName||'" has been created already.');
			status:=1;
			return;
		end if;
		
		--demo_message.add_debugline('C215B8.');
		
		-- before delete : cascade delete dependant indstances even has constraint with restrict options (USE CAREFULLY)
        -- after delete will not fire if has restricted constraint.		
		sql_trigger_ddl:= 
		'CREATE OR REPLACE TRIGGER '		
		||sql_trigger_name||' BEFORE DELETE ON "'||p_ukSchemaName||'"."'||p_ukTName||'" '|| 
		'REFERENCING NEW AS NEW OLD AS OLD
		FOR EACH ROW
		Begin
			delete "'||p_fkSchemaName||'"."'||p_fkTName||'"
			where ('||MV_StringList_utils.ListToCommaStrEncloseEl(p_fkColumnList, '"')||') in (('||MV_StringList_utils.ListToCommaStrEnclosePrefixEl(p_ukColumnList, '"', ':OLD.')||'));
		End;';		
		
		EXECUTE IMMEDIATE sql_trigger_ddl;	
		
		DEMO_MESSAGE.ADD_LINE('Info: Trigger '||sql_trigger_name||' on "'||p_ukSchemaName||'"."'||p_ukTName||'" for CASCADE DELETE to the table "'||p_fkSchemaName||'"."'||p_fkTName||'" is created.');
		
		status:=0;
				
		exception
			--when no_data_found then
				--return;
			when others then			
				DEMO_MESSAGE.ADD_LINE('SQL returned error message: '||SQLERRM||'.');
				status:=-20;
				return;
	end;
	
	procedure dropTrgDELETECASCADEForTableCCSL(p_ukSchemaName IN varchar2, p_ukTName IN varchar2, p_ukColumnList in MV_StringList_Type,
								p_fkSchemaName IN varchar2, p_fkTName IN varchar2, p_fkColumnList in MV_StringList_Type,
								status out integer) 
	is
		sql_trigger_name varchar2(200);
		sql_trigger_ddl varchar2(2000);
		cnt integer;
		cnt_temp integer;
		l_i integer;
	begin
		-- Check if is known parent UK column list
		if p_ukColumnList is null or p_ukColumnList.COUNT<1 then
			status:=-1;
			DEMO_MESSAGE.ADD_LINE('Error:Unknown UK column list for table "'||p_ukSchemaName||'"."'||p_ukTName||'".');
			return;
		end if;
		
		-- Check if is known child FK column list
		if p_fkColumnList is null or p_fkColumnList.COUNT<1 then
			status:=-2;
			DEMO_MESSAGE.ADD_LINE('Error:Unknown FK column list for table "'||p_fkSchemaName||'"."'||p_fkTName||'".');
			return;
		end if;		
		
		-- Check existence of all columns in UK key list for parent table
		cnt:=0;
		for l_i in 1..p_ukColumnList.count loop
			select count(*) into cnt_temp -- 0 or 1
			from (select 0 from all_tab_columns
				where owner=p_ukSchemaName
				and table_name=p_ukTName
				and column_name=p_ukColumnList(l_i)
				);
		    if cnt_temp=0 then
			    exit;
			else 
				cnt:=cnt+1;
			end if;
		end loop;
		
		if cnt< p_ukColumnList.count then
			DEMO_MESSAGE.ADD_LINE('Error:There is no accessible column with name "'||p_ukColumnList(l_i)||'" in UK table "'||p_ukSchemaName||'"."'||p_ukTName||'".' );
			status:=-10;
			return;		
		end if;	
		
		-- Check existence of all columns in FK key list for child table
		cnt:=0;
		for l_i in 1..p_fkColumnList.count loop
			select count(*) into cnt_temp -- 0 or 1
			from (select 0 from all_tab_columns
				where owner=p_fkSchemaName
				and table_name=p_fkTName
				and column_name=p_fkColumnList(l_i)
				);
		    if cnt_temp=0 then
			    exit;
			else 
				cnt:=cnt+1;
			end if;
		end loop;
		
		if cnt< p_fkColumnList.count then
			DEMO_MESSAGE.ADD_LINE('Error:There is no accessible column with name "'||p_fkColumnList(l_i)||'" in FK table "'||p_fkSchemaName||'"."'||p_fkTName||'".' );
			status:=-11;
			return;		
		end if;		
		
		select count(*) into cnt 
		from
		(select 0 from all_triggers
		where owner=p_fkSchemaName
		and --trigger_name like ***************************************************************************
			isTriggerNameMVUtilCascadeDELCAS(trigger_name, p_ukColumnList(1), p_fkTName, p_fkColumnList(1))=1
		and table_owner=p_ukSchemaName
		and table_name=p_ukTName);
		
		-- DDL and DML commands are case sensitive in referenced objects only if "" are used for schema and object_name.
		sql_trigger_name:='"'||p_fkSchemaName||'"."'||getTriggerNameMVUtilCascadeDELCAS(p_ukColumnList(1), p_fkTName, p_fkColumnList(1));
		sql_trigger_name:=sql_trigger_name||'"';
		
		if cnt=0 then
			DEMO_MESSAGE.ADD_LINE('Info: Trigger '||sql_trigger_name||' on "'||p_ukSchemaName||'"."'||p_ukTName||'" for CASCADE DELETE to the table "'||p_fkSchemaName||'"."'||p_fkTName||'" has been dropped already.');
			status:=1;
			return;			
		end if;
				
		sql_trigger_ddl:='DROP TRIGGER '||sql_trigger_name||' ';		
		
		EXECUTE IMMEDIATE sql_trigger_ddl;	
		
		DEMO_MESSAGE.ADD_LINE('Info: Trigger '||sql_trigger_name||' on "'||p_ukSchemaName||'"."'||p_ukTName||'" for CASCADE DELETE to the table "'||p_fkSchemaName||'"."'||p_fkTName||'" is dropped.');
		
		status:=0;
				
		exception
			when no_data_found then
				return;
			when others then			
				DEMO_MESSAGE.ADD_LINE('SQL returned error message: '||SQLERRM||'.');
				status:=-20;
				return;
	end;
	
	procedure addTrgDELETECASCADEForTableCCCSSL(p_ukSchemaName IN varchar2, p_ukTName IN varchar2, p_ukColumnCSSList in varchar2,
								p_fkSchemaName IN varchar2, p_fkTName IN varchar2, p_fkColumnCSSList in varchar2,
								status out integer)
	is
		ListUKCs MV_StringList_Type:=MV_StringList_Type();
		ListFKCs MV_StringList_Type:=MV_StringList_Type();
	begin
	
		--demo_message.add_debugline('C215A.');
	    ListUKCs:=MV_StringList_utils.CommaStringToList(p_ukColumnCSSList);
		ListFKCs:=MV_StringList_utils.CommaStringToList(p_fkColumnCSSList);
		
		--demo_message.add_debugline('C215B.');
		addTrgDELETECASCADEForTableCCSL(p_ukSchemaName, p_ukTName, ListUKCs,
								p_fkSchemaName, p_fkTName, ListFKCs, status);	
	end;
	
	procedure dropTrgDELETECASCADEForTableCCCSSL(p_ukSchemaName IN varchar2, p_ukTName IN varchar2, p_ukColumnCSSList in varchar2,
								p_fkSchemaName IN varchar2, p_fkTName IN varchar2, p_fkColumnCSSList in varchar2,
								status out integer)
	is
		ListUKCs MV_StringList_Type:=MV_StringList_Type();
		ListFKCs MV_StringList_Type:=MV_StringList_Type();
	begin
	    ListUKCs:=MV_StringList_utils.CommaStringToList(p_ukColumnCSSList);
		ListFKCs:=MV_StringList_utils.CommaStringToList(p_fkColumnCSSList);
		
		dropTrgDELETECASCADEForTableCCSL(p_ukSchemaName, p_ukTName, ListUKCs,
								p_fkSchemaName, p_fkTName, ListFKCs, status);	
	end;
	
	
	-- Condition: p_fkSchemaName user needs create trigger privilege on p_ukSchemaName.p_ukTName table!
	procedure addTrgUPDATECASCADEForTable(p_ukSchemaName IN varchar2, p_ukTName IN varchar2, p_ukColumnName in varchar2,
								p_fkSchemaName IN varchar2, p_fkTName IN varchar2, p_fkColumnName in varchar2,
								status out integer) 
	is
		sql_trigger_name varchar2(200);
		sql_trigger_ddl varchar2(2000);
		select_code_step integer:=0;
		cnt integer;
	begin
		-- Check if is known parent UK column
		if p_ukColumnName is null then
			status:=-1;
			DEMO_MESSAGE.ADD_LINE('Error:Unknown UK column for table "'||p_ukSchemaName||'"."'||p_ukTName||'".');
			return;
		end if;
		
		-- Check if is known child FK column
		if p_fkColumnName is null then
			status:=-2;
			DEMO_MESSAGE.ADD_LINE('Error:Unknown FK column for table "'||p_fkSchemaName||'"."'||p_fkTName||'".');
			return;
		end if;		
		
		-- Check existence of parent UK column
		select 0 into status from all_tab_columns
		where owner=p_ukSchemaName
		and table_name=p_ukTName
		and column_name=p_ukColumnName;
		
		select_code_step:=1;
		
		-- Check existence of child FK column
		select 0 into status from all_tab_columns
		where owner=p_fkSchemaName
		and table_name=p_fkTName
		and column_name=p_fkColumnName;
		
		select_code_step:=2;		
		
		select count(*) into cnt 
		from
		(select 0 from all_triggers
		where owner=p_fkSchemaName
		and --trigger_name like ********************************************************************
			isTriggerNameMVUtilCascadeUPDCAS(trigger_name, p_ukColumnName, p_fkTName, p_fkColumnName)=1
		and table_owner=p_ukSchemaName
		and table_name=p_ukTName);
		
		-- DDL and DML commands are case sensitive in referenced objects only if "" are used for schema and object_name.
		sql_trigger_name:='"'||p_fkSchemaName||'"."'||getTriggerNameMVUtilCascadeUPDCAS(p_ukColumnName, p_fkTName, p_fkColumnName);
		sql_trigger_name:=sql_trigger_name||'"';
		
		if cnt=0 then 
			--sql_trigger_name:=sql_trigger_name||'"';
			null;
		else
			--sql_trigger_name:=sql_trigger_name||to_char(cnt+1)||'"';
			DEMO_MESSAGE.ADD_LINE('Info: Trigger '||sql_trigger_name||' on "'||p_ukSchemaName||'"."'||p_ukTName||'" for CASCADE UPDATE to the table "'||p_fkSchemaName||'"."'||p_fkTName||'" has been created already.');
			status:=1;
			return;
		end if;
			
		-- after update : cascade update		
		sql_trigger_ddl:= 
		'CREATE OR REPLACE TRIGGER '		
		||sql_trigger_name||' AFTER UPDATE OF "'||p_ukColumnName||'" ON "'||p_ukSchemaName||'"."'||p_ukTName||'" '|| 
		'REFERENCING NEW AS NEW OLD AS OLD
		FOR EACH ROW 
		Begin
			update "'||p_fkSchemaName||'"."'||p_fkTName||'"
			set "'||p_fkColumnName||'"= :NEW."'||p_ukColumnName||'"
			where "'||p_fkColumnName||'"= :OLD."'||p_ukColumnName||'";
		End;';		
		
		EXECUTE IMMEDIATE sql_trigger_ddl;	
		
		DEMO_MESSAGE.ADD_LINE('Info: Trigger '||sql_trigger_name||' on "'||p_ukSchemaName||'"."'||p_ukTName||'" for CASCADE UPDATE to the table "'||p_fkSchemaName||'"."'||p_fkTName||'" is created.');
		
		status:=0;
		
		exception
			when no_data_found then
				if select_code_step=0 then
					DEMO_MESSAGE.ADD_LINE('Error:There is no accessible column with name "'||p_ukColumnName||'" in UK table "'||p_ukSchemaName||'"."'||p_ukTName||'".' );
					status:=-10;			
					return;
				elsif select_code_step=1 then
					DEMO_MESSAGE.ADD_LINE('Error:There is no accessible column with name "'||p_fkColumnName||'" in FK table "'||p_fkSchemaName||'"."'||p_fkTName||'".' );
					status:=-11;			
					return;
				end if;
			when others then
				DEMO_MESSAGE.ADD_LINE('SQL returned error message: '||SQLERRM||'.');
				status:=-20;
				return;
			
	end;
	
	procedure addTrgUPDATECASCADEForTableCCSL(p_ukSchemaName IN varchar2, p_ukTName IN varchar2, p_ukColumnList in MV_StringList_Type,
								p_fkSchemaName IN varchar2, p_fkTName IN varchar2, p_fkColumnList in MV_StringList_Type,
								status out integer) 
	is
		sql_trigger_name varchar2(200);
		sql_trigger_ddl varchar2(2000);
		cnt integer;
		cnt_temp integer;
		l_i integer;
	begin
		-- Check if is known parent UK column list
		if p_ukColumnList is null or p_ukColumnList.COUNT<1 then
			status:=-1;
			DEMO_MESSAGE.ADD_LINE('Error:Unknown UK column list for table "'||p_ukSchemaName||'"."'||p_ukTName||'".');
			return;
		end if;
		
		-- Check if is known child FK column list
		if p_fkColumnList is null or p_fkColumnList.COUNT<1 then
			status:=-2;
			DEMO_MESSAGE.ADD_LINE('Error:Unknown FK column list for table "'||p_fkSchemaName||'"."'||p_fkTName||'".');
			return;
		end if;		
		
		-- Check existence of all columns in UK key list for parent table
		cnt:=0;
		for l_i in 1..p_ukColumnList.count loop
			select count(*) into cnt_temp -- 0 or 1
			from (select 0 from all_tab_columns
				where owner=p_ukSchemaName
				and table_name=p_ukTName
				and column_name=p_ukColumnList(l_i)
				);
		    if cnt_temp=0 then
			    exit;
			else 
				cnt:=cnt+1;
			end if;
		end loop;
		
		if cnt< p_ukColumnList.count then
			DEMO_MESSAGE.ADD_LINE('Error:There is no accessible column with name "'||p_ukColumnList(l_i)||'" in UK table "'||p_ukSchemaName||'"."'||p_ukTName||'".' );
			status:=-10;
			return;		
		end if;	
		
		-- Check existence of all columns in FK key list for child table
		cnt:=0;
		for l_i in 1..p_fkColumnList.count loop
			select count(*) into cnt_temp -- 0 or 1
			from (select 0 from all_tab_columns
				where owner=p_fkSchemaName
				and table_name=p_fkTName
				and column_name=p_fkColumnList(l_i)
				);
		    if cnt_temp=0 then
			    exit;
			else 
				cnt:=cnt+1;
			end if;
		end loop;
		
		if cnt< p_fkColumnList.count then
			DEMO_MESSAGE.ADD_LINE('Error:There is no accessible column with name "'||p_fkColumnList(l_i)||'" in FK table "'||p_fkSchemaName||'"."'||p_fkTName||'".' );
			status:=-11;
			return;		
		end if;		
		
		select count(*) into cnt 
		from
		(select 0 from all_triggers
		where owner=p_fkSchemaName
		and --trigger_name like *********************************************************************
			isTriggerNameMVUtilCascadeUPDCAS(trigger_name, p_ukColumnList(1), p_fkTName, p_fkColumnList(1))=1
		and table_owner=p_ukSchemaName
		and table_name=p_ukTName);
		
		-- DDL and DML commands are case sensitive in referenced objects only if "" are used for schema and object_name.
		sql_trigger_name:='"'||p_fkSchemaName||'"."'||getTriggerNameMVUtilCascadeUPDCAS(p_ukColumnList(1), p_fkTName, p_fkColumnList(1));
		sql_trigger_name:=sql_trigger_name||'"';
		
		if cnt=0 then
			--sql_trigger_name:=sql_trigger_name||'"';
			null;
		else
			--sql_trigger_name:=sql_trigger_name||to_char(cnt+1)||'"';
			DEMO_MESSAGE.ADD_LINE('Info: Trigger '||sql_trigger_name||' on "'||p_ukSchemaName||'"."'||p_ukTName||'" for CASCADE UPDATE to the table "'||p_fkSchemaName||'"."'||p_fkTName||'" has been created already.');
			status:=1;
			return;
		end if;
		
		-- before delete : cascade delete dependant indstances even has constraint with restrict options (USE CAREFULLY)
        -- after delete will not fire if has restricted constraint.		
		sql_trigger_ddl:= 
		'CREATE OR REPLACE TRIGGER '		
		||sql_trigger_name||' AFTER UPDATE OF '||MV_StringList_utils.ListToCommaStrEncloseEl(p_ukColumnList, '"')||' ON "'||p_ukSchemaName||'"."'||p_ukTName||'" '|| 
		'REFERENCING NEW AS NEW OLD AS OLD
		FOR EACH ROW
		Begin
			update "'||p_fkSchemaName||'"."'||p_fkTName||'"
			set '||MV_StringList_utils.ListsEncloseRPrefixOperate(p_fkColumnList,'"',':NEW.',p_ukColumnList,'=')||' 
			where ('||MV_StringList_utils.ListToCommaStrEncloseEl(p_fkColumnList, '"')||') in (('||MV_StringList_utils.ListToCommaStrEnclosePrefixEl(p_ukColumnList, '"', ':OLD.')||'));			
		End;';		
		
		EXECUTE IMMEDIATE sql_trigger_ddl;	
		
		DEMO_MESSAGE.ADD_LINE('Info: Trigger '||sql_trigger_name||' on "'||p_ukSchemaName||'"."'||p_ukTName||'" for CASCADE UPDATE to the table "'||p_fkSchemaName||'"."'||p_fkTName||'" is created.');
		
		status:=0;
				
		exception
			--when no_data_found then
				--return;
			when others then			
				DEMO_MESSAGE.ADD_LINE('SQL returned error message: '||SQLERRM||'.');
				status:=-20;
				return;
	end;
	
	procedure dropTrgUPDATECASCADEForTableCCSL(p_ukSchemaName IN varchar2, p_ukTName IN varchar2, p_ukColumnList in MV_StringList_Type,
								p_fkSchemaName IN varchar2, p_fkTName IN varchar2, p_fkColumnList in MV_StringList_Type,
								status out integer) 
	is
		sql_trigger_name varchar2(200);
		sql_trigger_ddl varchar2(2000);
		cnt integer;
		cnt_temp integer;
		l_i integer;
	begin
		-- Check if is known parent UK column list
		if p_ukColumnList is null or p_ukColumnList.COUNT<1 then
			status:=-1;
			DEMO_MESSAGE.ADD_LINE('Error:Unknown UK column list for table "'||p_ukSchemaName||'"."'||p_ukTName||'".');
			return;
		end if;
		
		-- Check if is known child FK column list
		if p_fkColumnList is null or p_fkColumnList.COUNT<1 then
			status:=-2;
			DEMO_MESSAGE.ADD_LINE('Error:Unknown FK column list for table "'||p_fkSchemaName||'"."'||p_fkTName||'".');
			return;
		end if;		
		
		-- Check existence of all columns in UK key list for parent table
		cnt:=0;
		for l_i in 1..p_ukColumnList.count loop
			select count(*) into cnt_temp -- 0 or 1
			from (select 0 from all_tab_columns
				where owner=p_ukSchemaName
				and table_name=p_ukTName
				and column_name=p_ukColumnList(l_i)
				);
		    if cnt_temp=0 then
			    exit;
			else 
				cnt:=cnt+1;
			end if;
		end loop;
		
		if cnt< p_ukColumnList.count then
			DEMO_MESSAGE.ADD_LINE('Error:There is no accessible column with name "'||p_ukColumnList(l_i)||'" in UK table "'||p_ukSchemaName||'"."'||p_ukTName||'".' );
			status:=-10;
			return;		
		end if;	
		
		-- Check existence of all columns in FK key list for child table
		cnt:=0;
		for l_i in 1..p_fkColumnList.count loop
			select count(*) into cnt_temp -- 0 or 1
			from (select 0 from all_tab_columns
				where owner=p_fkSchemaName
				and table_name=p_fkTName
				and column_name=p_fkColumnList(l_i)
				);
		    if cnt_temp=0 then
			    exit;
			else 
				cnt:=cnt+1;
			end if;
		end loop;
		
		if cnt< p_fkColumnList.count then
			DEMO_MESSAGE.ADD_LINE('Error:There is no accessible column with name "'||p_fkColumnList(l_i)||'" in FK table "'||p_fkSchemaName||'"."'||p_fkTName||'".' );
			status:=-11;
			return;		
		end if;		
		
		select count(*) into cnt 
		from
		(select 0 from all_triggers
		where owner=p_fkSchemaName
		and --trigger_name like ***************************************************************************
			isTriggerNameMVUtilCascadeUPDCAS(trigger_name, p_ukColumnList(1), p_fkTName, p_fkColumnList(1))=1
		and table_owner=p_ukSchemaName
		and table_name=p_ukTName);
		
		-- DDL and DML commands are case sensitive in referenced objects only if "" are used for schema and object_name.
		sql_trigger_name:='"'||p_fkSchemaName||'"."'||getTriggerNameMVUtilCascadeUPDCAS(p_ukColumnList(1), p_fkTName, p_fkColumnList(1));
		sql_trigger_name:=sql_trigger_name||'"';
		
		if cnt=0 then
			DEMO_MESSAGE.ADD_LINE('Info: Trigger '||sql_trigger_name||' on "'||p_ukSchemaName||'"."'||p_ukTName||'" for CASCADE UPDATE to the table "'||p_fkSchemaName||'"."'||p_fkTName||'" has been dropped already.');
			status:=1;
			return;			
		end if;
		
		sql_trigger_ddl:='DROP TRIGGER '||sql_trigger_name||' ';		
		
		EXECUTE IMMEDIATE sql_trigger_ddl;	
		
		DEMO_MESSAGE.ADD_LINE('Info: Trigger '||sql_trigger_name||' on "'||p_ukSchemaName||'"."'||p_ukTName||'" for CASCADE UPDATE to the table "'||p_fkSchemaName||'"."'||p_fkTName||'" is dropped.');
		
		status:=0;
				
		exception
			--when no_data_found then
				--return;
			when others then			
				DEMO_MESSAGE.ADD_LINE('SQL returned error message: '||SQLERRM||'.');
				status:=-20;
				return;
	end;
	
	
	procedure addTrgUPDATECASCADEForTableCCCSSL(p_ukSchemaName IN varchar2, p_ukTName IN varchar2, p_ukColumnCSSList in varchar2,
								p_fkSchemaName IN varchar2, p_fkTName IN varchar2, p_fkColumnCSSList in varchar2,
								status out integer)
	is
		ListUKCs MV_StringList_Type:=MV_StringList_Type();
		ListFKCs MV_StringList_Type:=MV_StringList_Type();
	begin
	    ListUKCs:=MV_StringList_utils.CommaStringToList(p_ukColumnCSSList);
		ListFKCs:=MV_StringList_utils.CommaStringToList(p_fkColumnCSSList);
		
		addTrgUPDATECASCADEForTableCCSL(p_ukSchemaName, p_ukTName, ListUKCs,
								p_fkSchemaName, p_fkTName, ListFKCs, status);	
	end;
	
	procedure dropTrgUPDATECASCADEForTableCCCSSL(p_ukSchemaName IN varchar2, p_ukTName IN varchar2, p_ukColumnCSSList in varchar2,
								p_fkSchemaName IN varchar2, p_fkTName IN varchar2, p_fkColumnCSSList in varchar2,
								status out integer)
	is
		ListUKCs MV_StringList_Type:=MV_StringList_Type();
		ListFKCs MV_StringList_Type:=MV_StringList_Type();
	begin
	    ListUKCs:=MV_StringList_utils.CommaStringToList(p_ukColumnCSSList);
		ListFKCs:=MV_StringList_utils.CommaStringToList(p_fkColumnCSSList);
		
		dropTrgUPDATECASCADEForTableCCSL(p_ukSchemaName, p_ukTName, ListUKCs,
								p_fkSchemaName, p_fkTName, ListFKCs, status);	
	end;
	
	function getConsColumnsCommaSepStrList(p_SchemaName IN varchar2, p_TName IN varchar2, p_ConsName in varchar2) return varchar2
	is
		cs varchar2(2500);
		cs_len Integer;
		d Integer;
		j Integer;
		
		l_col_name all_cons_columns.column_name%TYPE; --varchar2(50);		
		
		cursor curCols is
			select column_name 
			from all_cons_columns
			where owner				=p_SchemaName
			and   table_name		=p_TName
			and   constraint_name	=p_ConsName
			order by position asc;
	begin
		--cs:=' ';
		
		open curCols;
		fetch curCols into l_col_name;	
		
		if curCols%NOTFOUND then
			close curCols;
			return ' ';
		end if;
		
		cs:=l_col_name;
		cs_len:= length(cs);
				
		fetch curCols into l_col_name;
		while curCols%FOUND 
		loop		
			d:=length(l_col_name);
			j:=cs_len+1+d;
			if j<=MV_StringList_utils.commalist_max_len then 
				cs:=cs||','||l_col_name; 
				cs_len:=j;
			else 
				exit;
			end if;
			fetch curCols into l_col_name;			
		end loop;
		
		close curCols;
		
		return cs;	
	end;
	
	-- Define standard for name of delete cascade trigger
	function getTriggerNameMVUtilCascadeDELCAS(p_ukCol IN varchar2, p_TName IN varchar2, p_fkCol in varchar2) return varchar2
	is
	begin
		return p_ukCol||'_'||p_TName||'_'||p_fkCol||'_DELCAS'; /*  */
	end;
	
	-- Define standard for name of update cascade trigger
	function getTriggerNameMVUtilCascadeUPDCAS(p_ukCol IN varchar2, p_TName IN varchar2, p_fkCol in varchar2) return varchar2
	is
	begin
		return p_ukCol||'_'||p_TName||'_'||p_fkCol||'_UPDCAS';
	end;
	
	function isTriggerNameMVUtilCascadeDELCAS(p_triggerName IN varchar2, p_ukCol IN varchar2, p_TName IN varchar2, p_fkCol in varchar2) return integer
	is
	begin
		if p_triggerName= getTriggerNameMVUtilCascadeDELCAS(p_ukCol, p_TName, p_fkCol) then		
			return 1;
		else
			return 0;
		end if;
	end;
	
	function isTriggerNameMVUtilCascadeUPDCAS(p_triggerName IN varchar2, p_ukCol IN varchar2, p_TName IN varchar2, p_fkCol in varchar2) return integer
	is
	begin
		if p_triggerName= getTriggerNameMVUtilCascadeUPDCAS(p_ukCol, p_TName, p_fkCol) then
			return 1;
		else
			return 0;
		end if;
	end;	
	
	function isTriggerNameMVUtilUPDCASorDELCAS(p_triggerName IN varchar2, p_ukCol IN varchar2, p_TName IN varchar2, p_fkCol in varchar2) return integer
	is
	begin
		if isTriggerNameMVUtilCascadeDELCAS(p_triggerName, p_ukCol, p_TName, p_fkCol)=1 
			or isTriggerNameMVUtilCascadeUPDCAS(p_triggerName, p_ukCol, p_TName, p_fkCol)=1 then
			return 1;
		else
			return 0;
		end if;
	end;
	
	function isTriggerNameMVUtilLikeUPDCASorDELCAS(p_triggerName IN varchar2, p_TName IN varchar2) return integer
	is
	begin
		if (p_triggerName like '%_'||p_TName||'_%'||'_DELCAS' or
		    p_triggerName like '%_'||p_TName||'_%'||'_UPDCAS') then
			return 1;
		else
			return 0;
		end if;
	end;

END;
/


create or replace procedure CALLprintForAllRefsByTableInfos(p_TOwner IN varchar2, p_TName IN varchar2)
is
begin
	MV_cascade_table_utils.printForAllRefsByTableInfos(p_TOwner,p_TName);
end;
/

create or replace procedure CALLaddANDcleanForAllRefsByTableCascadeTrgsToSchemas(p_TOwner IN varchar2, p_TName IN varchar2, 
													p_ForDelete in boolean default true, p_ForUpdate in boolean default true)
is
begin
	--demo_message.add_debugline('C1.');
	--demo_message.add_debugline('C1.Vars:'||p_TOwner||','||p_TName||';');
	MV_cascade_table_utils.addANDcleanForAllRefsByTableCascadeTrgsToSchemas(p_TOwner,p_TName,p_ForDelete,p_ForUpdate);
end;
/

