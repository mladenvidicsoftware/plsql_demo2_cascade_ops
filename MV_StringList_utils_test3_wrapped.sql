/* Author: Mladen Vidic
   E-mail: mladen.vidic@gmail.com
   Date Signed: 7.5.2021.
   Scope: Testing MV_StringList_utils package APIs after wrapping PL/SQL code of the package body.
*/

-- TEST 3. after package body was wrapped, It was checked does it works correctly just like before wrapping, in test 2.

DEMO2_OWNER@DEMO_INSTANCE> @G:\MladenMV_NaNovomLaptopu_2\MladenMV_Jobs\NITES_testing\demo2\MV_StringList_utils_pkgb.plb

Package body created.

set serveroutput on

declare 
	List1 MV_StringList_Type:=MV_StringList_Type();
	List2 MV_StringList_Type:=MV_StringList_Type();
	List3 MV_StringList_Type:=MV_StringList_Type();
begin 
	List1:=MV_StringList_utils.CommaStringToList('A1,A2');
	List2:=MV_StringList_utils.CommaStringToList('V1,V2');
	
	DEMO_MESSAGE.ADD_LINE('Comma list string 1: <'||MV_StringList_utils.ListToCommaString(List1)||'>');	
	DEMO_MESSAGE.ADD_LINE('Comma list string 2: <'||MV_StringList_utils.ListToCommaString(List2)||'>');
	DEMO_MESSAGE.ADD_LINE('Comma list string: <'||MV_StringList_utils.ListToCommaStrEncloseEl(List1,'"')||'>');
	DEMO_MESSAGE.ADD_LINE('Comma list string: <'||MV_StringList_utils.ListToCommaStrEnclosePrefixEl(List2,'"',':OLD.')||'>');
	DEMO_MESSAGE.ADD_LINE('Comma list string: <'||MV_StringList_utils.ListsEncloseRPrefixOperate(List1, '"', ':NEW.', List2, '=')||'>');
	
	DEMO_MESSAGE.ADD_LINE('Comma list string first element: <'||MV_StringList_utils.getFirstElFromCommaString('A1,A2')||'>');

	DEMO_MESSAGE.ADD_LINE('Comma list string is empty: <'||MV_StringList_utils.isEmptyCommaString('A1,A2')||'>');
	DEMO_MESSAGE.ADD_LINE('Comma list string is empty: <'||MV_StringList_utils.isEmptyCommaString(' ')||'>');
	DEMO_MESSAGE.ADD_LINE('Comma list string is empty: <'||MV_StringList_utils.isEmptyCommaString('')||'>');
	
	DEMO_MESSAGE.ADD_LINE('List is empty: <'||MV_StringList_utils.isEmptyList(List1)||'>');
	DEMO_MESSAGE.ADD_LINE('List is empty: <'||MV_StringList_utils.isEmptyList(List3)||'>');	
end;
/

DEMO2_OWNER@DEMO_INSTANCE> set serveroutput on
DEMO2_OWNER@DEMO_INSTANCE>
DEMO2_OWNER@DEMO_INSTANCE> declare
  2     List1 MV_StringList_Type:=MV_StringList_Type();
  3     List2 MV_StringList_Type:=MV_StringList_Type();
  4     List3 MV_StringList_Type:=MV_StringList_Type();
  5  begin
  6     List1:=MV_StringList_utils.CommaStringToList('A1,A2');
  7     List2:=MV_StringList_utils.CommaStringToList('V1,V2');
  8
  9     DEMO_MESSAGE.ADD_LINE('Comma list string 1: <'||MV_StringList_utils.List
ToCommaString(List1)||'>');
 10     DEMO_MESSAGE.ADD_LINE('Comma list string 2: <'||MV_StringList_utils.List
ToCommaString(List2)||'>');
 11     DEMO_MESSAGE.ADD_LINE('Comma list string: <'||MV_StringList_utils.ListTo
CommaStrEncloseEl(List1,'"')||'>');
 12     DEMO_MESSAGE.ADD_LINE('Comma list string: <'||MV_StringList_utils.ListTo
CommaStrEnclosePrefixEl(List2,'"',':OLD.')||'>');
 13     DEMO_MESSAGE.ADD_LINE('Comma list string: <'||MV_StringList_utils.ListsE
ncloseRPrefixOperate(List1, '"', ':NEW.', List2, '=')||'>');
 14
 15     DEMO_MESSAGE.ADD_LINE('Comma list string first element: <'||MV_StringLis
t_utils.getFirstElFromCommaString('A1,A2')||'>');
 16
 17     DEMO_MESSAGE.ADD_LINE('Comma list string is empty: <'||MV_StringList_uti
ls.isEmptyCommaString('A1,A2')||'>');
 18     DEMO_MESSAGE.ADD_LINE('Comma list string is empty: <'||MV_StringList_uti
ls.isEmptyCommaString(' ')||'>');
 19     DEMO_MESSAGE.ADD_LINE('Comma list string is empty: <'||MV_StringList_uti
ls.isEmptyCommaString('')||'>');
 20
 21     DEMO_MESSAGE.ADD_LINE('List is empty: <'||MV_StringList_utils.isEmptyLis
t(List1)||'>');
 22     DEMO_MESSAGE.ADD_LINE('List is empty: <'||MV_StringList_utils.isEmptyLis
t(List3)||'>');
 23  end;
 24  /
Comma list string 1: <A1,A2>
Comma list string 2: <V1,V2>
Comma list string: <"A1","A2">
Comma list string: <:OLD."V1",:OLD."V2">
Comma list string: <"A1"=:NEW."V1","A2"=:NEW."V2">
Comma list string first element: <A1>
Comma list string is empty: <0>
Comma list string is empty: <1>
Comma list string is empty: <1>
List is empty: <0>
List is empty: <1>

PL/SQL procedure successfully completed.

DEMO2_OWNER@DEMO_INSTANCE>

-- TEST 3. SUCCESS!