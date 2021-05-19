/* Author: Mladen Vidic
   E-mail: mladen.vidic@gmail.com
   Date Signed: 7.5.2021.
   
   Note: Procedures and function could have shorter names. These names are used for self describing purposes for better readability 
   and easier following of code development pathway.
   
   LICENCE: The licensing rules from the 'license.txt' or '..\license.txt' file apply to this file, solution and its parts.
*/

@@MV_StringList_Type.sql

CREATE OR REPLACE Package &&DEMO_OWNER..MV_StringList_utils IS

	commalist_max_len Integer:=2500;
	
	FUNCTION ListToCommaString(p_list IN MV_StringList_Type) return varchar2;
	
	/* 
	NOTE: If you have source of the package for Task1. demo1, this 
	FUNCTION CommaStringToList(p_string IN varchar2) return MV_StringList_Type; 
	is same as
	function &&DEMO_OWNER..MV_string_utils.getShrededStringToList(p_string IN varchar2, p_delim IN varchar2, p_show_string_index IN integer) return MV_StringList_Type; 
	when it is called with p_delim==> ',' and p_show_string_index==>null values for the parameters. 
	
	return MV_string_utils.getShrededStringToList(p_string, ',', null);
	
	In this package, it is rather implemented.
	*/
	FUNCTION CommaStringToList(p_string IN varchar2) return MV_StringList_Type;	
	
	-- Converts list to comma string list with each element enclosed by input character
	FUNCTION ListToCommaStrEncloseEl(p_list IN MV_StringList_Type, p_enChar in char) return varchar2;
	
	-- Converts list to comma string list with each element enclosed by input character and then prefixed
	FUNCTION ListToCommaStrEnclosePrefixEl(p_list IN MV_StringList_Type, p_enChar in char, p_prefix in varchar2) return varchar2;
	
	-- Converts list to comma string list with each element enclosed by input character and then prefixed
	-- example: From lists leftL=(A1,A2) and rightL=(V1,V2) 
	-- call ListsEncloseRPrefixOperate(leftL, '"', 'Pref.', rightL, '=')
	-- creates comma list string '"A1"=Pref."V1", "A2"=Pref."V2"' 
	-- 			
	FUNCTION ListsEncloseRPrefixOperate(p_leftList IN MV_StringList_Type, p_enChar in char, p_prefixRightList in varchar2, p_rightList IN MV_StringList_Type, p_infixOperator in varchar2) return varchar2;
	
	
	FUNCTION isEmptyList (p_list IN MV_StringList_Type) return integer;
	FUNCTION isEmptyCommaString (p_commastring IN varchar2) return integer;
	
	FUNCTION getFirstElFromCommaString (p_commastring IN varchar2) return varchar2;
	
END;
/
