//ps_styx_all v1.02
#include "ps_inc_functions"
//#include "aaa_constants" - inherited from ps_inc_functions
#include "ps_adjust_knight"
#include "ps_adjust_barbarian"
#include "nwnx_sql"
#include "aaa_racial_ability_inc"


void Finalize(object oPC)
{
string name = SQLEncodeSpecialChars(GetName(oPC));
string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
SQLExecDirect("DELETE FROM `generalability_tracking` WHERE `name`='"+name+"' AND `act`='"+act+"';");

}
void PS_set_level(object oPC, int nLvl)
{
	int nXP = GetXP(oPC);
	int nNewXP;
	int nextlvl = 1000;
	int totalxp = 0;
		
	if (nLvl < 1) nLvl = 1;
	if (nLvl == 1){
		if (nXP >= 1000) nNewXP = 999;
		else return;
	} else {
		nNewXP = PS_GetXPForLevel(nLvl);
	}
	int nPool = nXP - nNewXP;
	if (nNewXP > nXP) nPool = 0;
	SetXPpools(oPC, nPool);
	SetXP(oPC, nNewXP);
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
	object oItem = PS_GetEssence(oPC);
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