/* Script Created by Ceremorph for SCoD PW. Determine if the PC has XP in their DM pool.*/

#include "ps_inc_functions"
#include "nwnx_sql"

int StartingConditional()
{
	object oPC = GetPCSpeaker();
	object oNPC = OBJECT_SELF;
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
	int nID = GetLocalInt(oItem,"ID");
	int dm_pool, rp_pool, availableXP;
	
	SQLExecDirect("SELECT id,dm_pool,rp_pool,Day(Now()) FROM characterdata WHERE id=" + IntToString(nID));
	if (SQLFetch() != SQL_ERROR) 
	{	//nID = StringToInt(SQLGetData(1));
		dm_pool = StringToInt(SQLGetData(2));
		rp_pool = StringToInt(SQLGetData(3));
		availableXP = dm_pool+rp_pool;

	}
	else
	{	SendMessageToPC(oPC, "Error with SQLExecDirect function!");	}

	//DebugMessageToPC(oPC, "dm pool xp: "+IntToString(dm_pool));
	//DebugMessageToPC(oPC, "rp pool xp: "+IntToString(rp_pool));
	//DebugMessageToPC(oPC, "combined xp: "+IntToString(availableXP));
	SendMessageToPC(oPC, "dm pool xp: "+IntToString(dm_pool));
	SendMessageToPC(oPC, "rp pool xp: "+IntToString(rp_pool));
	SendMessageToPC(oPC, "combined xp: "+IntToString(availableXP));		
	
	if (dm_pool >= 1) 
	{	SendMessageToPC(oPC, "You have XP in your DM pool.");
		return 1;	}
		
	else 
	{	SendMessageToPC(oPC, "No XP found in your DM pool.");
		return 0;	}

}