//ps_styx_all v1.02
#include "ps_inc_functions"
#include "aaa_constants"
#include "ps_adjust_knight"
#include "ps_adjust_barbarian"
#include "nwnx_sql"
#include "aaa_racial_ability_inc"

void SetXPpools(object oPC,int nAmount)
{ 
	SendMessageToPC(oPC, "Adding "+IntToString(nAmount)+" to your RP and DM exp pools");
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
	if (oItem == OBJECT_INVALID) return;
	
	string sID = IntToString(GetLocalInt(oItem,"ID"));
	SQLExecDirect("SELECT dm_pool,rp_pool FROM characterdata WHERE id=" + sID);
	if (SQLFetch() == SQL_ERROR) return;
	
	int dm_pool;
	int rp_pool;
	
	if (GetIsChristmas()) {
		dm_pool = StringToInt(SQLGetData(1)) + nAmount;
		rp_pool = StringToInt(SQLGetData(2));
	} else {
		dm_pool = StringToInt(SQLGetData(1)) + FloatToInt(nAmount * 0.25);
		rp_pool = StringToInt(SQLGetData(2)) + FloatToInt(nAmount * 0.25);
	}

	SQLExecDirect("UPDATE characterdata SET dm_pool=" + IntToString(dm_pool) + ",rp_pool=" + IntToString(rp_pool) + " WHERE id=" + sID);		
	SQLExecDirect("INSERT INTO logging (account,name,event,type) VALUES ('" + 
		SQLEncodeSpecialChars(GetPCPlayerName(oPC)) + "','" + 
		SQLEncodeSpecialChars(GetName(oPC)) + 
		"','Player lost ALL levels to Styx, increased pools with: " + FloatToString(nAmount * 0.25) + "',107)");
}

void Finalize(object oPC)
{
string name = SQLEncodeSpecialChars(GetName(oPC));
string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
SQLExecDirect("DELETE FROM `generalability_tracking` WHERE `name`='"+name+"' AND `act`='"+act+"';");

}


void PS_lose_one_level(object oPC)
{	
	int xp = GetXP(oPC);	
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
			return;
		}
		nextlvl = nextlvl + 1000;
	}
}

void PS_set_level(object oPC, int iLevel)
{
	int xp = GetXP(oPC);
	int nextlvl = 1000;
	int totalxp = 0;
		
	if (iLevel == 0) iLevel = 1; // increase level by 1
	if (iLevel == 1) // make level 1
	{	SetXP(oPC, 1);
		SetXPpools(oPC, xp);
		return;		}

	// set your level
	int i;
	for (i = 1; i < iLevel; i++) 
	{	totalxp += nextlvl;
		nextlvl += 1000;	}
	SetXPpools(oPC, xp - totalxp);
	SetXP(oPC, totalxp + 1);
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
//		case 9: DoPsyProgression(oPC); break;
//		case 10:PS_KnightLevels(oPC); break;
//		case 11:PS_BarbarianLevels(oPC); break;
		default: return;
	}
	DelayCommand(0.0f, DelayedFixes(oPC, oItem, nSTEP + 1));
}

void main()
{


	object oPC = GetPCSpeaker();
	object oItem = GetItemPossessedBy(oPC, "ps_essence");
	int iRacelevels = 0;
	
	if ((GetClassByPosition(1,oPC) > 11 && GetClassByPosition(1,oPC) < 27) || GetClassByPosition(1,oPC) == 38) //Prevent delevelling of outsider++ type levels
	{	
		iRacelevels = GetLevelByPosition(1,oPC);
		if (GetLevelByPosition(2, oPC) < 1) return;
	}
	
	WriteTimestampedLogEntry(GetName(oPC)+" is releveling! All levels are about to be removed.");
	
	ForceRest(oPC);
	
	if (iRacelevels > 0) PS_set_level(oPC, iRacelevels);
	else PS_set_level(oPC, 1);
	
	if (GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) > 0) GetWarlockCasterLevel(oPC);

	// Remove any temporary appearance changes
	PS_RestoreOriginalAppearance(oPC);
	
	// Check for earlier wings, etc.
	if (GetHasFeat(2781) && !GetLocalInt(oItem, "DarkFlight" )) PS_Ability_DarkFlight(oPC);
	
	PS_CalculateECL(oPC);
	
	//Launch the delayed commands
	DelayCommand(0.0f, DelayedFixes(oPC, oItem, 0));	
	Finalize(oPC);
}