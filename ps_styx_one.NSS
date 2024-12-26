//ps_styx_one v1.02
#include "ps_inc_functions"
#include "nwnx_sql"
#include "aaa_racial_ability_inc"

void DelayedFixes(object oPC, object oItem, int nSTEP)
{
	switch (nSTEP)
	{
		case 0: PS_UndeadRaceFix(oPC); break;
		case 1: PS_HalfDragonRaceFix(oPC); break;
		case 2: PS_HalfOutsiderRaceFix(oPC); break;
		case 3: PS_VampMal_DelevelFix(oPC, oItem); break;
		case 4: PS_ClassAppearanceDeleveling(oPC); break;
		case 5: PS_Template_DelevelFix(oPC, oItem); break;
		case 6: ExportSingleCharacter(oPC); break;
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