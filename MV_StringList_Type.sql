/* Author: Mladen Vidic
   E-mail: mladen.vidic@gmail.com
   Date Signed: 7.5.2021.
   
   LICENCE: The licensing rules from the 'license.txt' or '..\license.txt' file apply to this file, solution and its parts.
*/
-- /* + */ This type helps to implement operations with comma string lists needed in "sets"  attribute of visibility by Oracle VARRAY.
create type &&DEMO_OWNER..MV_StringList_Type as 
   varray(50) of varchar2(50);
/


/* WARNING! - It has a restriction that the number of allowed elements in a shredding string is finite and each element can has the most 50 characters.
It is for demonstration purposes. In real production system it is better to use ASSOCIATEIVE VARRAY or NESTED TABLE types in Oracle
that have no restriction to declared number of elements.

Example:
CREATE OR REPLACE TYPE &&DEMO_OWNER..MV_StringListTable_Type 
IS TABLE OF VARCHAR2 (50)
/

*/
