//ps_styx_all v1.02
#include "ps_inc_functions"
#include "aaa_constants"
#include "nwnx_sql"

//Check whether you have multiple entries in the DB
int GetHasMultipleEntries(object oPC);

//Removing extra entry in the DB
void RemoveExtraEntries(object oPC);

//Updating / resetting PC ID
void UpdatePCID(object oPC);

void main()
{
	object oPC = GetPCSpeaker();
	
	//SendMessageToPC(oPC, "Current ID: "+PS_GetCharID(oPC));
	
	if (GetHasMultipleEntries(oPC)) {
		RemoveExtraEntries(oPC);
	}
	
	//If we removed the old id, time to update!
	UpdatePCID(oPC);
	
	//SendMessageToPC(oPC, "New ID: "+PS_GetCharID(oPC));
	
	string sID = PS_GetCharID(oPC);
	
	string sQuery = "SELECT rp_pool, dm_pool FROM characterdata WHERE id='" + sID + "'";
	
	SQLExecDirect(sQuery);
	if (SQLFetch() != SQL_ERROR) {
	
		string sRPXP = SQLGetData(1);
		string sDMXP = SQLGetData(2);
		
		SetCustomToken(4001, sRPXP);
		SetCustomToken(4002, sDMXP);
		
	} else {
	
		SetCustomToken(4001, "0");
		SetCustomToken(4002, "0");
		
	}
	
}


int GetHasMultipleEntries(object oPC) {
	
	string sAccount = GetPCPlayerName(oPC);
	string sName = GetName(oPC);

	string sQuery = "SELECT COUNT(*) FROM characterdata WHERE account='" + sAccount+"' AND name='"+sName+"'";
	
	//SendMessageToPC(oPC, "Checking number of entries: "+sQuery);
	
	SQLExecDirect(sQuery);
	if (SQLFetch() != SQL_ERROR) {
		int nCount = StringToInt(SQLGetData(1));
		
		//SendMessageToPC(oPC, "Entries found: "+IntToString(nCount));
		
		return (nCount > 1);
	}
	
	return FALSE;
}

void RemoveExtraEntries(object oPC) {
	
	string sAccount = GetPCPlayerName(oPC);
	string sName = GetName(oPC);

	string sQuery = "SELECT id, rp_pool, dm_pool FROM characterdata WHERE account='" + sAccount+"' AND name='"+sName+"'";
	
	//SendMessageToPC(oPC, "Finding 'low' entry: "+sQuery);
	
	int nRPXP = 0;
	int nDMXP = 0;
	string sID = "";
	
	SQLExecDirect(sQuery);
	while (SQLFetch() != SQL_ERROR) {
		string id = SQLGetData(1);
		int thisRPXP = StringToInt(SQLGetData(2));
		int thisDMXP = StringToInt(SQLGetData(3));
		
		//SendMessageToPC(oPC, "Entry: "+IntToString(thisRPXP)+", "+IntToString(thisDMXP)+", ID - "+id);
		
		if (thisRPXP < nRPXP || sID == "") {
			nRPXP = thisRPXP;
			nDMXP = thisDMXP;
			sID = id;
		}
	}
	
	//SendMessageToPC(oPC, "'Low' entry found: "+sID);
	
	if (sID != "") {
		sQuery = "DELETE FROM characterdata WHERE id='" + sID + "'";
		SQLExecDirect(sQuery);
		
		//SendMessageToPC(oPC, "Removing extra entry.");
	}
}

void UpdatePCID(object oPC) {
	
	string sAccount = GetPCPlayerName(oPC);
	string sName = GetName(oPC);
	
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
    if(!GetIsObjectValid(oItem)) {
		SendMessageToPC(oPC, "Essence invalid");
		return;
	}

	string sQuery = "SELECT id FROM characterdata WHERE account='" + sAccount+"' AND name='"+sName+"'";
	SQLExecDirect(sQuery);
	
	if (SQLFetch() != SQL_ERROR) {
		int nID = StringToInt(SQLGetData(1));
		
		SetLocalInt(oItem,"ID",nID);
		SetLocalInt(oPC,"ID",nID);
	}
}