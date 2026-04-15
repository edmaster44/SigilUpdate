#include "ps_inc_functions"
/*This is a Function and a rewrite of Epic Spell DC calculations*/
const int PRACTICED_CASTER_CLERIC           = 1247;
const int PRACTICED_CASTER_DRUID            = 1248;
const int PRACTICED_CASTER_SORC        = 1251;
const int PRACTICED_CASTER_WIZ          = 1252;
const int PRACTICED_CASTER_SHAMAN			= 2003;
const int PRACTICED_CASTER_FS            = 2068;
const int PRACTICED_CASTER_WL          = 2842;
const int PRACTICED_CASTER_PSION           = 3684;

int GetIsEpicSpellEligibleClass(int nClass){
	if (nClass == CLASS_TYPE_CLERIC || nClass == CLASS_TYPE_DRUID || nClass == CLASS_TYPE_FAVORED_SOUL ||
		nClass == CLASS_TYPE_PSION || nClass == CLASS_TYPE_SPIRIT_SHAMAN || nClass == CLASS_TYPE_SORCERER ||
		nClass == CLASS_TYPE_WARLOCK || nClass == CLASS_TYPE_WIZARD)
			return TRUE;

	return FALSE;
}

// new version by FlattedFifth based on math by Ed, + addition of spell focus feats
int PS_GetEpicSpellSaveDC(object oPC = OBJECT_SELF){
	//if no class is found or if not epic or if engine computes higher than we do
	//we can return the original dc
	int nOGDC = GetSpellSaveDC(); 
	int nId = GetSpellId();
	int nInnate = StringToInt(Get2DAString("spells", "Innate", nId));
	if (nInnate < 10) return nOGDC; // if not an epic spell return the og dc
	
    int nDC = 25;
	// Get the highest caster class the caster has and match to proper modifier
	int nHighestClass, nCurrentClass, nCurrentCL, nMod;
	int nHighestCL = 0;
	int i;
	for (i = 1; i <= 4; i++){
		nCurrentClass = GetClassByPosition(i, oPC);
		if (GetIsEpicSpellEligibleClass(nCurrentClass)){
			nCurrentCL = PS_GetCasterLevel(oPC, nCurrentClass);
			if (nCurrentCL > nHighestCL){
				nHighestCL = nCurrentCL;
				nHighestClass = nCurrentClass;
			}
		}
	}
	int nPrac = 0;
	switch (nHighestClass){
		case CLASS_TYPE_CLERIC:{
			nMod = ABILITY_WISDOM;
			nPrac = PRACTICED_CASTER_CLERIC;
			break;
		}
		case CLASS_TYPE_DRUID:{
			nMod = ABILITY_WISDOM;
			nPrac = PRACTICED_CASTER_DRUID;
			break;
		}
		case CLASS_TYPE_SPIRIT_SHAMAN:{
			nMod = ABILITY_WISDOM;
			nPrac = PRACTICED_CASTER_SHAMAN;
			break;
		}
		case CLASS_TYPE_SORCERER:{
			nMod = ABILITY_CHARISMA;
			nPrac = PRACTICED_CASTER_SORC;
			break;
		}
		case CLASS_TYPE_WARLOCK:{
			nMod = ABILITY_CHARISMA;
			nPrac = PRACTICED_CASTER_WL;
			break;
		}
		case CLASS_TYPE_FAVORED_SOUL:{
			nMod = ABILITY_CHARISMA;
			nPrac = PRACTICED_CASTER_FS;
			break;
		}
		case CLASS_TYPE_PSION:{
			nMod = ABILITY_INTELLIGENCE;
			nPrac = PRACTICED_CASTER_PSION;
			break;
		}
		case CLASS_TYPE_WIZARD:{
			nMod = ABILITY_INTELLIGENCE;
			nPrac = PRACTICED_CASTER_WIZ;
			break;
		}
		default:{
			return nOGDC; //no class found, return nwscript dc
		}
	}
	//add ability modifier if CL is 17 or more
	if (nHighestCL >= 17) nDC += GetAbilityModifier(nMod);
	
	// add epic CL bonus
	int nBonus = (nHighestCL - 20) / 3; //+1DC every 3 CL after 20
    if (nBonus < 0) nBonus = 0;
	nDC += nBonus;
	
	//now lets add in the feats
	//starting with spellcasting prodigy
	nDC += GetHasFeat(FEAT_SPELLCASTING_PRODIGY);
	// get the spell school
	int nFocus, nGrFocus, nEpFocus;
	string sSchool = GetStringUpperCase(Get2DAString("spells", "School", nId));
	if (sSchool == "A"){
		nEpFocus = FEAT_EPIC_SPELL_FOCUS_ABJURATION;
		nGrFocus = FEAT_GREATER_SPELL_FOCUS_ABJURATION;
		nFocus = FEAT_SPELL_FOCUS_ABJURATION;
	} else if (sSchool == "C"){
		nEpFocus = FEAT_EPIC_SPELL_FOCUS_CONJURATION;
		nGrFocus = FEAT_GREATER_SPELL_FOCUS_CONJURATION;
		nFocus = FEAT_SPELL_FOCUS_CONJURATION;
	} else if (sSchool == "D"){
		nEpFocus = FEAT_EPIC_SPELL_FOCUS_DIVINATION;
		nGrFocus = FEAT_GREATER_SPELL_FOCUS_DIVINIATION;
		nFocus = FEAT_SPELL_FOCUS_DIVINATION;
	} else if (sSchool == "E"){
		nEpFocus = FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT;
		nGrFocus = FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT;
		nFocus = FEAT_SPELL_FOCUS_ENCHANTMENT;
	} else if (sSchool == "V"){
		nEpFocus = FEAT_EPIC_SPELL_FOCUS_EVOCATION;
		nGrFocus = FEAT_GREATER_SPELL_FOCUS_EVOCATION;
		nFocus = FEAT_SPELL_FOCUS_EVOCATION;
	} else if (sSchool == "I"){
		nEpFocus = FEAT_EPIC_SPELL_FOCUS_ILLUSION;
		nGrFocus = FEAT_GREATER_SPELL_FOCUS_ILLUSION;
		nFocus = FEAT_SPELL_FOCUS_ILLUSION;
	} else if (sSchool == "N"){
		nEpFocus = FEAT_EPIC_SPELL_FOCUS_NECROMANCY;
		nGrFocus = FEAT_GREATER_SPELL_FOCUS_NECROMANCY;
		nFocus = FEAT_SPELL_FOCUS_NECROMANCY;
	} else if (sSchool == "T"){
		nEpFocus = FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION;
		nGrFocus = FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION;
		nFocus = FEAT_SPELL_FOCUS_TRANSMUTATION;
	} else sSchool = "";
	
	if (sSchool != ""){
		if (GetHasFeat(nEpFocus, oPC)) nDC += 3;
		else if (GetHasFeat(nGrFocus, oPC)) nDC += 2;
		else if (GetHasFeat(nFocus, oPC)) nDC += 1;
	}
	// +1 for practiced spellcaster
	if (GetHasFeat(nPrac, oPC)) nDC += 1;
	
	if (nOGDC > nDC) nDC = nOGDC;
    
    return nDC;
}
/*
int isEpicWizard(object oPC);
int isEpicSorcerer(object oPC);
int isEpicCleric(object oPC);
int isEpicDruid(object oPC);
int isEpicFavoredSoul(object oPC);
int isEpicSpiritShaman(object oPC);
int isEpicWarlock(object oPC);
*/
	//this was in the above function in place of my means of getting the mod
	/*
    if (isEpicWizard(oPC))
		nDC += GetAbilityModifier(ABILITY_INTELLIGENCE);
    else if (isEpicSorcerer(oPC) ||isEpicWarlock(oPC) || isEpicFavoredSoul(oPC))
		nDC += GetAbilityModifier(ABILITY_CHARISMA);
    else if (isEpicCleric(oPC) || isEpicSpiritShaman(oPC) || isEpicDruid(oPC))
		nDC += GetAbilityModifier(ABILITY_WISDOM);
	*/
/*
int isEpicWizard(object oPC = OBJECT_SELF)
{
    int nCasterLevel = GetWizardTRUECasterlevel(oPC);

    if (nCasterLevel >= 17)
    {
        return TRUE;
    }
    return FALSE;
}

int isEpicSorcerer(object oPC)
{
    int nCasterLevel = GetSorcererTRUECasterlevel(oPC);

    if (nCasterLevel >= 18)
    {
        return TRUE;
    }
    return FALSE;
}

int isEpicCleric(object oPC)
{
    int nCasterLevel = GetClericTRUECasterlevel(oPC);

    if (nCasterLevel >= 17)
    {
        return TRUE;
    }
    return FALSE;
}

int isEpicDruid(object oPC)
{
    int nCasterLevel = GetDruidTRUECasterlevel(oPC);

    if (nCasterLevel >= 17)
    {
        return TRUE;
    }
    return FALSE;
}

int isEpicFavoredSoul(object oPC)
{
    int nCasterLevel = GetFavoredSoulTRUECasterlevel(oPC);

    if (nCasterLevel >= 18)
    {
        return TRUE;
    }
    return FALSE;
}

int isEpicSpiritShaman(object oPC)
{
    
    int nCasterLevel = GetSpiritShamanTRUECasterlevel(oPC);

    if (nCasterLevel >= 16)
    {
        return TRUE;
    }
    return FALSE;
}
int isEpicWarlock(object oPC)
{
    int nCasterLevel = GetWarlockCasterLevel(oPC);

    if (nCasterLevel >= 16)
    {
        return TRUE;
    }
    return FALSE;
}
*/