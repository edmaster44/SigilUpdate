#include "ps_inc_functions"
#include "nwnx_sql"


void main(){

	object oPC = GetPCSpeaker();
	if (oPC == OBJECT_INVALID) oPC = OBJECT_SELF;

	if (!ALLOW_INSTANT_REBUILD){
		SendMessageToPC(oPC, "This feature is only available after major server changes.");
	}
	string sID = PS_GetCharID(oPC);
	if (sID == "NULL"){
		SendMessageToPC(oPC, "Error retrieving data");
		return;
	}
	int nXP = 0;
	SQLExecDirect("SELECT dm_pool,rp_pool FROM characterdata WHERE id=" + sID);
	if (SQLFetch() == SQL_ERROR){
		object oSpeaker = GetLastSpeaker();
		nXP += PS_GetLocalInt(oSpeaker, sID+"dm");
		nXP += PS_GetLocalInt(oSpeaker, sID+"rp");
	} else {
		nXP += StringToInt(SQLGetData(1));
		nXP += StringToInt(SQLGetData(2));
	}
	if (nXP != 0){
		SetXPpools(oPC, 0, TRUE, TRUE);
		SetXP(oPC, nXP + GetXP(oPC));
	} else {
		SendMessageToPC(oPC, "Error getting data. No changes made.");
	}
}