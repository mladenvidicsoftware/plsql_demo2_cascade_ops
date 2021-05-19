/* Author: Mladen Vidic
   E-mail: mladen.vidic@gmail.com
   Date Signed: 7.5.2021.
   
   LICENCE: The licensing rules from the 'license.txt' or '..\license.txt' file apply to this file, solution and its parts.
*/


CREATE OR REPLACE
Package  &&DEMO_OWNER..demo_message  IS

/* Ideja je da u paketima koji se realizuju samo podesimo status na vrednost i pozovemo proceduru koj će generisati poruku.
   Tekst poruke ne treba da bude u kodu nego da se cita iz tabela za poruke ili neke druge konfiguracije. Tekst poruke
   
   DBMS_OUTPUT.PUT_LINE('Error:Current user doesn''t have  privilege to do <something>.' );
   status:=-6;
	return;
	
	treba biti zamenjen kodom (programer samo razmislja o programabilnom delu, o id paketa i kodu poruke, a tekst se izvlaci iz baze
	na raznim jezicima):
	
	package_id:=n;
	status:=-6;
	printline_message(package_id, status);
	return;
	
	Može biti i dopunjen trećim parametrom ili globalno da se u neku string varchar2 nisku vrati tekst poruke.
*/

	procedure printline_message(package_id in integer, status in integer);
	
	procedure clear_line;
	procedure create_line(message IN varchar2);
	procedure add_line(message IN varchar2);
	
	procedure clear_debugline;
	procedure create_debugline(message IN varchar2);
	procedure add_debugline(message IN varchar2);

END;
/

CREATE OR REPLACE
Package Body         &&DEMO_OWNER..demo_message IS

	debug_level integer:=9;
	
	procedure printline_error(package_id in integer, status in integer)
	is
	begin
		-- read message text.
		-- DBMS_OUTPUT.PUT_LINE(message);
		-- if need it then 
		--    put message into return string;
		-- end if;	
		null;
	end;
	
	procedure printline_info(package_id in integer, status in integer)
	is
	begin
		null;
	end;
	
	procedure printline_warning(package_id in integer, status in integer)
	is
	begin
		null;
	end;

	procedure printline_message(package_id in integer, status in integer)
	is
	begin
		if status>0 then 
			printline_warning(package_id, status);
		elsif status=0 then
			printline_info(package_id, status);
		else
			printline_error(package_id, status);
		end if;
	end;
	
	procedure clear_line is
	begin
		-- 1. For server output to client message.
		DBMS_OUTPUT.PUT_LINE('--------------- MESSAGE FOR USER -----------------------------------------------------------------------------');
		
		-- 2. For store in session message variables.
		-- ...
	end;
	
	procedure create_line(message IN varchar2) is 
	begin
		clear_line;
		-- 1. For server output to client message.
		DBMS_OUTPUT.PUT_LINE(message);
		
		-- 2. For store in session message variables.
		-- ...
	end;
	
	procedure add_line(message IN varchar2) is
	begin
		-- 1. For server output to client message.
		DBMS_OUTPUT.PUT_LINE(message);
		
		-- 2. For store in session message variables.
		-- ...
	end;
	
	procedure clear_debugline is
	begin
		-- 1. For server output debug message.
		DBMS_OUTPUT.PUT_LINE('--------------- DEBUG MESSAGE -----------------------------------------------------------------------------');
		
		-- 2. For store in session message variables.
		-- ...
	end;
	
	procedure create_debugline(message IN varchar2) is 
	begin
		clear_debugline;
		-- 1. For server output debug message.
		if debug_level>5 then
			DBMS_OUTPUT.PUT_LINE(message);
		end if;
		
		-- 2. For store in session message variables.
		-- ...
	end;
	
	procedure add_debugline(message IN varchar2) is
	begin
		-- 1. For server output debug message.
		if debug_level>5 then
			DBMS_OUTPUT.PUT_LINE(message);
		end if;
				
		-- 2. For store in session message variables.
		-- ...
	end;
END;
/
