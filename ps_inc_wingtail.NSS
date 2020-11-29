#include "ps_inc_functions"
#include "ps_inc_advscript"
#include "aaa_constants"

void PS_SetWingNumber(object oPC, int nVar);
int PS_GetWingNumber(object oPC);
void PS_SetTailNumber(object oPC, int nVar);
int PS_GetTailNumber(object oPC);
void PS_ApplyPCWings(object oPC);
void PS_ApplyPCTail(object oPC);
int PS_GetRacialWingType(object oPC);
int PS_GetWing_Fiend(object oPC);
int PS_GetWing_Celestial(object oPC);
int PS_GetFeatWingType(object oPC);
int PS_GetWing_HalfDragon(object oPC);
int PS_GetWing_Template(object oPC);
int PS_Get_WingRace(object oPC);
void PS_WingTailSetup(object oPC);

// Sets the essence variable PC_Wing
// nVar = numeric wing variation, or WING_TYPE_*
void PS_SetWingNumber(object oPC, int nVar)
{
	object oEssence = GetItemPossessedBy(oPC,"ps_essence");
	SetLocalInt(oEssence, "PC_Wing", nVar);
}

// Returns the value from the essence variable PC_Wing
int PS_GetWingNumber(object oPC)
{
	object oEssence = GetItemPossessedBy(oPC,"ps_essence");
	int nWing		= GetLocalInt(oEssence, "PC_Wing");
	return nWing;
}

// Sets the essence variable PC_Tail
// nVar = numeric wing variation, or WING_TYPE_*
void PS_SetTailNumber(object oPC, int nVar)
{
	object oEssence = GetItemPossessedBy(oPC,"ps_essence");
	SetLocalInt(oEssence, "PC_Tail", nVar);
}

// Returns the value from the essence variable PC_Tail
int PS_GetTailNumber(object oPC)
{
	object oEssence = GetItemPossessedBy(oPC,"ps_essence");
	int nTail		= GetLocalInt(oEssence, "PC_Tail");
	return nTail;
}

// Determines if the PC should have wings based on their racial subtype and gender
// Uses the MWING and FWING fields from racialsubtype.2da and returns the wing variation
int PS_GetRacialWingType(object oPC)
{
	int nGender		= GetGender(oPC);
	int nSub		= GetSubRace(oPC);
	string sMWing	= Get2DAString("racialsubtypes", "MWING", nSub);
	int nMWing		= StringToInt(sMWing);
	string sFWing	= Get2DAString("racialsubtypes", "FWING", nSub);
	int nFWing		= StringToInt(sFWing);

	if (nGender == GENDER_MALE)
	{	return nMWing;	}
	else 
	{	return nFWing;	}
}

//Helper function determines the race for wing variation determination based on original race or subrace
int PS_Get_WingRace(object oPC)
{
	object oEssence = GetItemPossessedBy(oPC,"ps_essence");
	int nRace		= GetLocalInt(oEssence, "OldRace");
	int nSubrace	= GetLocalInt(oEssence, "OldSubrace");
	switch (nRace)
	{	
		case 0: return WING_VARIATION_DWARF;
		case 1: return WING_VARIATION_HUMAN;
		case 2: return WING_VARIATION_GNOME;
		case 3: return WING_VARIATION_HUMAN;
		case 4:	return WING_VARIATION_HUMAN;
		case 5: return WING_VARIATION_ORC;
		case 6: return WING_VARIATION_HUMAN;
		case 14: return WING_VARIATION_ORC;
		case 15: return WING_VARIATION_HUMAN;
		case 21: return WING_VARIATION_HUMAN;
		case 31: return WING_VARIATION_HUMAN;
		case 32: return WING_VARIATION_ORC;
		case 33: return WING_VARIATION_HUMAN;
	}
	switch (nSubrace)
	{
		case 47: return WING_VARIATION_HUMAN;
		case 61: return WING_VARIATION_HUMAN;
		case 74: return WING_VARIATION_HUMAN;
		case 251: return WING_VARIATION_HUMAN;
	}
	return -1;
}

//Determine what wing a Half-Fiend gets based on original subrace
int PS_GetWing_Fiend(object oPC)
{
	int nWingRace = PS_Get_WingRace(oPC);
	
	if (GetHasFeat(2556, oPC)) // If they select the "supernatural sight" feat instead of wings...
	{	return 0;	}
	
	if (GetHasFeat(FEAT_ERINYES_WINGS,oPC))
	{	if (GetGender(oPC) == GENDER_FEMALE)
		{	switch (nWingRace)
			{	case WING_VARIATION_DWARF: return 36;
				case WING_VARIATION_GNOME: return 38;
				case WING_VARIATION_HUMAN: return 14;
				case WING_VARIATION_ORC: return 40;
			}}
		else
		{	switch (nWingRace)
			{	case WING_VARIATION_DWARF: return 35;
				case WING_VARIATION_GNOME: return 37;
				case WING_VARIATION_HUMAN: return 59;
				case WING_VARIATION_ORC: return 39;
			}}} 
	else
	{	if (GetGender(oPC) == GENDER_FEMALE)
		{	switch (nWingRace)
			{	case WING_VARIATION_DWARF: return 44;
				case WING_VARIATION_GNOME: return 46;
				case WING_VARIATION_HUMAN: return 56;
				case WING_VARIATION_ORC: return 48;
			}}
		else
		{	switch (nWingRace)
			{	case WING_VARIATION_DWARF: return 43;
				case WING_VARIATION_GNOME: return 45;
				case WING_VARIATION_HUMAN: return 55;
				case WING_VARIATION_ORC: return 37;
			}}}
	return 0; 
}

//Determine what wing a Half-Celestial gets based on original subrace
int PS_GetWing_Celestial(object oPC)
{
	int nWingRace = PS_Get_WingRace(oPC);
	
	if (GetHasFeat(2556, oPC)) // If they select the "supernatural sight" feat instead of wings...
	{	return 0;	}

	if (GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL)
	{	if (GetGender(oPC) == GENDER_FEMALE)
		{	switch (nWingRace)
			{	case WING_VARIATION_DWARF: return 28;
				case WING_VARIATION_GNOME: return 31;
				case WING_VARIATION_HUMAN: return 26;
				case WING_VARIATION_ORC: return 40;
			}}
		else
		{	switch (nWingRace)
			{	case WING_VARIATION_DWARF: return 27;
				case WING_VARIATION_GNOME: return 51;
				case WING_VARIATION_HUMAN: return 25;
				case WING_VARIATION_ORC: return 39;
			}}} 
	else
	{	if (GetGender(oPC) == GENDER_FEMALE)
		{	switch (nWingRace)
			{	case WING_VARIATION_DWARF: return 50;
				case WING_VARIATION_GNOME: return 52;
				case WING_VARIATION_HUMAN: return 21;
				case WING_VARIATION_ORC: return 33;
			}}
		else
		{	switch (nWingRace)
			{	case WING_VARIATION_DWARF: return 49;
				case WING_VARIATION_GNOME: return 69;
				case WING_VARIATION_HUMAN: return 60;
				case WING_VARIATION_ORC: return 32;
			}}}
	return 0; 
}

//Determine what wing a Half-Dragon gets based on original subrace
int PS_GetWing_HalfDragon(object oPC)
{
	int nWingRace = PS_Get_WingRace(oPC);
	
	if (GetHasFeat(220 , oPC)) // This is the "remain wingless" feat.
	{	return 0;	}
	
	if (GetGender(oPC) == GENDER_FEMALE)
	{	switch (nWingRace)
		{	case WING_VARIATION_DWARF: return 44;
			case WING_VARIATION_GNOME: return 46;
			case WING_VARIATION_HUMAN: return 56;
			case WING_VARIATION_ORC: return 48;
		}}
	else
	{	switch (nWingRace)
		{	case WING_VARIATION_DWARF: return 43;
			case WING_VARIATION_GNOME: return 45;
			case WING_VARIATION_HUMAN: return 55;
			case WING_VARIATION_ORC: return 37;
		}}
	return 0;
}

// For use with template classes that may change the race of a character who previously had wings
// Determines the wing type of their original subrace
int PS_GetWing_Template(object oPC)
{
	object oEssence = GetItemPossessedBy(oPC,"ps_essence");
	int nWingRace = GetLocalInt(oEssence, "OldSubrace");
	
	string sMWing	= Get2DAString("racialsubtypes", "MWING", nWingRace);
	int nMWing		= StringToInt(sMWing);
	string sFWing	= Get2DAString("racialsubtypes", "FWING", nWingRace);
	int nFWing		= StringToInt(sFWing);

	if (GetGender(oPC) == GENDER_MALE)
	{	return nMWing;	}
	else 
	{	return nFWing;	}
}

// Determines if the PC should have a tail based class/feat choices
// Returns the proper wing variation
int PS_GetFeatWingType(object oPC)
{
	int nWing = 0;
	
	if (GetHasFeat(FEAT_MEZZOWINGS,oPC))
		{ nWing = 62;}
	
	
	if (GetHasFeat(3008, oPC)) {
		if (GetGender(oPC) == GENDER_MALE) nWing = 79;
		else nWing = 78;
	}
	
	if (GetHasFeat(288, oPC))
	{	if (GetLevelByClass(CLASS_TYPE_HALFDRAGON_PRC, oPC) >= 6)
		{	nWing = PS_GetWing_HalfDragon(oPC);		}	}
	
	if (GetHasFeat(2781, oPC))
	{	if (GetLevelByClass(CLASS_TYPE_TRUMPET_ARCHON_PRC, oPC) >= 1)
		{	if (GetGender(oPC) == GENDER_FEMALE)
			{	nWing = WING_TYPE_HEZEBEL_F;	}
			else
			{	nWing = WING_TYPE_HEZEBEL_M;	}	}
			
		if (GetLevelByClass(CLASS_TYPE_WORD_ARCHON_PRC, oPC) >= 1)
		{	if (GetGender(oPC) == GENDER_FEMALE)
			{	nWing = WING_TYPE_HEZEBEL_F;	}
			else
			{	nWing = WING_TYPE_HEZEBEL_M;	}	}	}
	
	if (GetHasFeat(2781, oPC))
		if (GetLevelByClass(CLASS_TYPE_BRACHINA, oPC) != 0)
		{	if (GetGender(oPC) == GENDER_FEMALE)
			{	nWing = WING_TYPE_RAVEN_F;		}
			else
			{	nWing = WING_TYPE_RAVEN_M;		}	}
			
		if (GetLevelByClass(CLASS_TYPE_ERINYES, oPC) != 0)
		{	if (GetGender(oPC) == GENDER_FEMALE)
			{	nWing = WING_TYPE_ERINYES_F;	}
			else
			{	nWing = WING_TYPE_ERINYES_M;	}	}
			
		if (GetLevelByClass(CLASS_TYPE_SUCCUBUS_INCUBUS, oPC) != 0)
		{	if (GetHasFeat(2834, oPC)) // Lilitu's Gift
			{	if (GetGender(oPC) == GENDER_FEMALE)
				{	nWing = WING_TYPE_LILITU_F;	}
				else
				{	nWing = WING_TYPE_LILITU_M;	}	}
			else
			{	if (GetGender(oPC) == GENDER_FEMALE)
				{	nWing = WING_TYPE_BAT_F;	}
				else
				{	nWing = WING_TYPE_BAT_M;	}	}	}
	
		if (GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC, oPC) >= 6)
		{	if (GetHasFeat(2537, oPC) && GetHasFeat(2781, oPC))
			{	nWing = PS_GetWing_Fiend(oPC);		}
			if (GetHasFeat(2538, oPC) && GetHasFeat(2179, oPC))
			{	nWing = PS_GetWing_Celestial(oPC);	}	}
		
	return nWing;
}

// Perform setup of wings
// To be called during PC load, rest, levelup, delevel, and any other process that may need refreshing of this data
void PS_WingTailSetup(object oPC)
{
	int nWing;
	
	object oEssence		= GetItemPossessedBy(oPC,"ps_essence");
	int nOverride		= GetLocalInt(oEssence, "WingOverride");
	int nRacialWing		= PS_GetRacialWingType(oPC);
	int nTemplateWing	= PS_GetWing_Template(oPC);
	int nFeatWing		= PS_GetFeatWingType(oPC);
	int nTail			= PS_GetTailNumber(oPC);
	
	if (nRacialWing != 0)
	{	nWing = nRacialWing;	}

	else if (nFeatWing != 0)
	{	nWing = nFeatWing;		}
	
	else if (nTemplateWing != 0)
	{	nWing = nTemplateWing;	}

	else if (nOverride != 0)
	{	nWing = 0;	}
	
	PS_SetWingNumber(oPC, nWing);
	PS_SetTailNumber(oPC, nTail);
}

// Apply the proper wings to the PC based on data saved in the essence variable PC_Wings
void PS_ApplyPCWings(object oPC)
{
	int nWing		= PS_GetWingNumber(oPC);
	object oEssence	= GetItemPossessedBy(oPC,"ps_essence");	
	
	if (GetLocalInt(oEssence, "WingSwitch") == 1)
	{	return;		}
	if (GetLocalInt(oEssence, "TempChange") == 1)
	{	return;		}

	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	app.WingVariation = nWing;
	PS_SetCreatureCoreAppearance(oPC, app);
	PS_RefreshAppearance(oPC);
	//DelayCommand(0.1f, PS_SaveOriginalAppearance(oPC));
	SendMessageToPC(oPC, "Wing variation changed to " + IntToString(nWing) + ".");
}

// Apply the proper tail to the PC based on data saved in the essence variable PC_Tail
void PS_ApplyPCTail(object oPC)
{
	object oEssence = GetItemPossessedBy(oPC, "ps_essence");
	PS_TintFixer(oPC); //Fix the tint first!
	
	if (GetLocalInt(oEssence, "TempChange") == 1)
	{	return;		}

	int nTail = PS_GetTailNumber(oPC);
	
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	app.TailVariation = nTail;
	PS_SetCreatureCoreAppearance(oPC, app);
	PS_RefreshAppearance(oPC);
	//DelayCommand(0.1f, PS_SaveOriginalAppearance(oPC));
	SendMessageToPC(oPC, "Tail variation changed to " + IntToString(nTail) + ".");
}

void PS_DragonGlitchFix(object oPC)
{
	object oEssence = GetItemPossessedBy(oPC, "ps_essence");
	int nSubrace	= GetSubRace(oPC);
	string sApp		= Get2DAString("racialsubtypes", "AppearanceIndex", nSubrace);
	int nAppVar		= StringToInt(sApp);
	
	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
	app.AppearanceType = nAppVar;
	PS_SetCreatureCoreAppearance(oPC, app);
	PS_RefreshAppearance(oPC);
	PS_SaveOriginalAppearance(oPC);
}