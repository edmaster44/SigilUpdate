//ps_styx_one v1.02
#include "ps_inc_functions"
#include "nwnx_sql"
#include "aaa_racial_ability_inc"

void SetXPpools(object oPC, int nAmount)
{
	SendMessageToPC(oPC, "Adding "+IntToString(nAmount)+" to your RP and DM exp pools");
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
	if (oItem == OBJECT_INVALID) return;
	
	string sID = IntToString(GetLocalInt(oItem,"ID"));
	SQLExecDirect("SELECT dm_pool,rp_pool FROM characterdata WHERE id=" + sID);
	if (SQLFetch() == SQL_ERROR) return;
	
	int dm_pool = StringToInt(SQLGetData(1)) + FloatToInt(nAmount * 0.25);
	int rp_pool = StringToInt(SQLGetData(2)) + FloatToInt(nAmount * 0.25);
	//int dm_pool = StringToInt(SQLGetData(1)) + nAmount; //krampus value
	//int rp_pool = StringToInt(SQLGetData(2)); //krampus value
	SQLExecDirect("UPDATE characterdata SET dm_pool=" + IntToString(dm_pool) + ",rp_pool=" + IntToString(rp_pool) + " WHERE id=" + sID);		
	SQLExecDirect("INSERT INTO logging (account,name,event,type) VALUES ('" + GetPCPlayerName(oPC) + "','" + GetName(oPC) + "','Player lost one level to Styx, increased pools with: " + FloatToString(nAmount * 0.25) + ",106)");
}

void PS_lose_one_level(object oPC)
{
	int xp = GetXP(oPC);
	int currentXP = GetXP(oPC);
	int nextlvl = 1000;
	int totalxp = 1;
	
	while (1)
	{
		totalxp = totalxp + nextlvl;
		if (totalxp >= xp)
		{   
			xp = totalxp - nextlvl;
			if (xp < 0) xp = 0; 
			SetXP(oPC, xp);
			int xpLost = currentXP-xp;
			SetXPpools(oPC, xpLost);
			return;
		}
		nextlvl = nextlvl + 1000;
	}
}

void DelayedFixes(object oPC, object oItem, int nSTEP)
{
	switch (nSTEP)
	{
		case 0: PS_UndeadRaceFix(oPC); break;
		case 1: PS_HalfDragonRaceFix(oPC); break;
		case 2: PS_HalfOutsiderRaceFix(oPC); break;
		case 3: PS_VampMal_DelevelFix(oPC, oItem); break;
		case 4: PS_ClassAppearanceDeleveling(oPC); break;
		case 5: DoPsiDeLevelCheck(oPC); break;
		case 6: PS_Template_DelevelFix(oPC, oItem); break;
		case 7: ExportSingleCharacter(oPC); break;
		case 8: BarbarianLevels(oPC); break;
		default: return;
	}
	DelayCommand(0.0f, DelayedFixes(oPC, oItem, nSTEP + 1));
}

void main()
{
	object oPC = GetPCSpeaker();
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
	
	if ((GetClassByPosition(1,oPC) > 11 && GetClassByPosition(1,oPC) < 27) || GetClassByPosition(1,oPC) == 38) //Prevent delevelling of outsider++ type levels
	{	
		if(GetLevelByPosition(2,oPC) == 0)
		return;	
	}
	
	ForceRest(oPC);
	
	WriteTimestampedLogEntry(GetName(oPC)+" is releveling! One level is about to be removed.");
	
	PS_lose_one_level(oPC);
	
	if (GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) > 0) GetWarlockCasterLevel(oPC);
	
	// Remove any temporary appearance changes
	PS_RestoreOriginalAppearance(oPC);
	
	// Check for earlier wings, etc.
	if (GetHasFeat(2781) && !GetLocalInt(oItem, "DarkFlight" )) PS_Ability_DarkFlight(oPC);
	
	PS_CalculateECL(oPC);
	
	//Launch the delayed commands
	DelayCommand(0.0f, DelayedFixes(oPC, oItem, 0));
}