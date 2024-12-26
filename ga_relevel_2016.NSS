#include "ps_inc_functions"
#include "nwnx_sql"


void main ()
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
	string sID = IntToString(GetLocalInt(oItem,"ID"));
	
	SQLExecDirect("SELECT id,dm_pool,rp_pool,Day(Now()) FROM characterdata WHERE id=" + sID);
	if (SQLFetch() != SQL_ERROR) 
	{	//nID = StringToInt(SQLGetData(1));
		int dm_pool = StringToInt(SQLGetData(2));
		int availableXP = dm_pool;
			DebugMessageToPC(oPC, "combined xp: "+IntToString(availableXP));
							
		if (dm_pool > 0 )
		{	DebugMessageToPC(oPC, "Exhausting pools");
			PS_GiveXPReward(oPC, availableXP);
			dm_pool = 0;
			DelayCommand(11.0, SendMessageToPC(oPC,"Your pool is now empty."));		
			DelayCommand(10.0, SendMessageToPC(oPC,"Your character has been awarded " + IntToString(availableXP) + " XP for previous roleplay (or from removing xp with Styx)"));
			SQLExecDirect("UPDATE characterdata SET dm_pool=" + IntToString(dm_pool) + " WHERE id=" + sID);
		}
		ForceRest(oPC);
		PS_CalculateECL(oPC);
	}
}