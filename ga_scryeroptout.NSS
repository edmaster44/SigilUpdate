#include "nwnx_sql"
#include "ps_inc_functions"

void main()
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	
	string sID = PS_GetCharID(oPC);
	
	SQLExecDirect("UPDATE characterdata SET scryopt=1 WHERE id=" + sID);
}