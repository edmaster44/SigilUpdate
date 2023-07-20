#include "x0_i0_position"
#include "aaa_constants"
#include "ps_inc_advscript"
#include "x0_i0_match"
#include "ServerExts"
#include "x0_i0_petrify"
#include "nwnx_sql"
#include "x2_inc_itemprop"
#include "ps_inc_ecl"

// String name of local variable on essence for storing the original race of the oPC.
const string VAR_OLD_RACE = "OldRace";
// String name of local variable on essence for storing ECL.
const string VAR_ECL = "ECL";

const float BASEXP = 65.0; //base xp for creature
const float PARTYBONUS_XP_DIVIDER = 3.0; // multiplier is 1 + log(partysize)/divider
const int MAXPARTYRANGE = 7; //PC's that are less than this number from highest level in group
					   		 //don't count for calculations of party average level
const float MAXMONSTERXP = 500.0; //The absolute maximum xp any monster can yield
const float CRBONUS = 0.5; //decides what multiplier to use for when party faces
							//CR > Avg level.  (CR - Avg) * CRBONUS = CR modified XP
							
const int SERVER_VERSION_ROW = 1;
const int FACTION_VERSION_ROW = 2;
const int HOLIDAY_VERSION_ROW = 3;

const string HOLIDAY_NONE = "Holiday_Ordinary";
const string HOLIDAY_XMAS = "Holiday_Xmas";

const int FEAT_MYSTICTHEURGE_SPELLCASTING_WARLOCK 		= 1678;
const int FEAT_PALE_MASTER_SPELLCASTING_WARLOCK 		= 1803;
const int FEAT_ARCANE_TRICKSTER_SPELLCASTING_WARLOCK 	= 1677;
const int FEAT_BRACHINA_SPELLCASTING_WARLOCK 			= 2789;
const int FEAT_SUCCUBUS_SPELLCASTING_WARLOCK 			= 2821;
const int FEAT_HEAVY_ARMOR_OPTIMIZATION 				= 2836;
const int FEAT_HEAVY_ARMOR_OPTIMIZATION_GREATER 		= 2837;
const int FEAT_HEAVY_ARMOR_OPTIMIZATION_EPIC			= 2838;
const int FEAT_SUCCUBUS_SPELLCASTING_BARD 				= 2841;
const int FEAT_MOTC_SPELLCASTING_WARLOCK				= 2570;
const int FEAT_GRAY_SLAAD_SPELLCASTING_WARLOCK			= 4011;
const int FEAT_EPIC_ELDRITCH_ADEPT						= 3621;
const int FEAT_PRACTICED_INVOKER						= 2842;
const int SPELLLIKE_HEAVY_ARMOR_OPTIMIZATION			= 1833;
const int SPELLLIKE_HEAVY_ARMOR_OPTIMIZATION_GREATER	= 1834;
const int SPELLLIKE_HEAVY_ARMOR_OPTIMIZATION_EPIC		= 1835;

//
// For use with PS_GetPCFlags/PS_SetPCFlags.
//

const int PS_PC_FLAG_COLOR_EMOTES = 0x00000001;

const string PS_PC_FLAGS_VAR = "PS_PC_FLAGS";

// Call this function to get the oPC's essence object.
object PS_GetEssence(object oPC = OBJECT_SELF);

int GetHasSpiritShamanProgression(object oPC, int iClass);

int GetSpiritShamanTRUECasterlevel(object oPC);

int GetHasKnightProgression(object oPC, int iClass);

int GetPaladinAndPRCClassLevels(object oPC);

int GetHasRangerProgression(object oPC, int iClass);

int GetRangerAndPRCClassLevels(object oPC);

int PS_IsEquippableCW(object oItem);

int PS_GetCasterLevel(object oPC);

int PS_GetGolemCasterLevel(object oPC);

int GetIsHighBabClass(int classid);

int MonkLevels(object oPC, int BAB = 0);

int GetRacialBonus(object oPC, int category);

int MonkUnarmedDamage(object oPC, int iMonk);

int IncreasedUnarmedDamageBonus(object oPC, object oItem);

int PS_GetEssenceECL(object oPC);

int PS_GetLevel(object oPC);

int PS_GetMaxPartylevel(object oPC);

int PS_GetNumPC(object oPC);

effect PS_EffectDamage(int nDamageAmount, int nDamageType = DAMAGE_TYPE_BLUDGEONING, int nDamagePower = DAMAGE_POWER_NORMAL, int IgnoreResistance = FALSE);

float PS_GetAvgPartylevel(object oPC, int iMAX);

float PS_GetXPModifier(int iECL);

int PS_GetXPForLevel(int iLevel);

int PS_GetPureMageLevels(int PML);

int GetWarlockCasterLevel(object oPC);

//void StackEldBlast(object oPC);	

int GetClassBspLevel(object oPC, int nClass);

int GetHasWarlockProgression(object oPC, int iClass);

void DoPsiDeLevelCheck(object oPC);

string PS_ConvertDamageTypeToString(int iDamageType);

void PS_SpellSneakDamageMessage(object oPC, object oTarget, int iDamageType, int iDamage);

int PS_ConvertDamageTypeToSaveType(int iDamageType);

int PS_CalcSneakDamage(object oPC, object oTarget, int iDamageType);

int PS_AddSneakDmgToSpell(object oCaster, object oTarget, int iDamageType);

string ParseTellDescription(string sDesc);

struct CreatureCoreAppearance GetNewFormAppearance(string sResRef, object oPC = OBJECT_INVALID);

void Assumenewform(object oCaster, struct CreatureCoreAppearance Appearance) ;

int PS_GetPCFlags(object PCObject);

void PS_SetPCFlags(object PCObject, int PCFlags);

int PS_TogglePlayerChatColoring(object PCObject);

void PS_LoadEssenceState(object PCObject, object EssenceItem);

void PS_CopyIntVar(object To, string Var, object From);

string PS_ExpandStringEnclosures(string Text, string FindOpen, string FindClose, string EncloseOpen, string EncloseClose);

string PS_ColorizeChatMessage(string Text);

int GetBardicClassLevelForUses(object oPC);

int GetBardicClassLevelForSongs(object oPC);

int GetDisallowedLevelDownPRC(object oPC);

void DoPsyProgression(object oPC);

int PsyWarLevels(object oPC);

void StackBardicUses(object oPC);

void StackBardMusicUses(object oPC);

void PS_UndeadRaceFix(object oPC);

void PS_RefreshAppearance(object oPC);

void PS_SaveOriginalAppearance(object oPC);

void PS_RestoreOriginalAppearance(object oPC);

void PS_RacialDeleveling(object oPC);

struct CreatureCoreAppearance PS_RetrieveStoredCreatureCoreAppearance(object ObjectId, string Prefix);

int GetAbilityRacialBonus(object oPC, int iAbility);

int GetAbilityBonuses(object oPC, int iAbility);

int GetIsFinessable(object oItem);
//Gets the Classes without Practiced Spell caster, for Qualifer Feats
int GetClericWithoutFeat(object oPC);
//Gets the Classes without Practiced Spell caster, for Qualifer Feats
int	GetDruidWithoutFeat(object oPC);
//Gets the Classes without Practiced Spell caster, for Qualifer Feats
int GetBardWithoutFeat(object oPC);
//Gets the Classes without Practiced Spell caster, for Qualifer Feats
int	GetSorcererWithoutFeat(object oPC);
//Gets the Classes without Practiced Spell caster, for Qualifer Feats
int	GetRangerWithOutFeats(object oPC);
//Gets the Classes without Practiced Spell caster, for Qualifer Feats
int GetPaladinWithoutFeat(object oPC);
//Gets the Classes without Practiced Spell caster, for Qualifer Feats
int	GetSpiritShamanWithoutFeat(object oPC);
//Gets the Classes without Practiced Spell caster, for Qualifer Feats
int	GetFavoredSoulWithoutFeat(object oPC);

void PS_ApplyTemplateClassAbilityFix(object oPC, object oItem);

void DebugMessageToPC(object oPC, string sMessage);

int DevMode = GetLocalInt(GetModule(), "SIGIL_DEV_MODE");

object PS_GetEssence(object oPC = OBJECT_SELF)
{
	return GetItemPossessedBy(oPC, "ps_essence");
}

//Calculates Monk Unarmed Damage Based on Monk Class +PRC
int MonkUnarmedDamage(object oPC, int iMonk)
{
	if(iMonk >= 30) return 16;
	else if(iMonk >= 24) return 13;
	else if(iMonk >= 20) return 11;
	else if(iMonk >= 16) return 9;
	else if(iMonk >= 12) return 7;
	else if(iMonk >= 8) return 6;
	else if(iMonk >= 4) return 5;
	else if(iMonk >= 1) return 4;
	else return 0;
}
//Increases Unarmed Damage
int IncreasedUnarmedDamageBonus(object oPC, object oItem)
{
	int iDmgAvg = 2;
	int iMonk = MonkLevels(oPC);

	int iBonus;
	
	if(iMonk >= 28) iBonus = 10;
	else if(iMonk >= 24) iBonus = 8;
	else if(iMonk >= 20) iBonus = 6;
	else if(iMonk >= 16) iBonus = 5;
	else if(iMonk >= 12) iBonus = 4;
	else if(iMonk >= 8) iBonus = 3;
	else iBonus = 2;
	
	return iBonus + iDmgAvg + MonkUnarmedDamage(oPC,iMonk);
}
//Gets Racial bonuses and adjusts according 
int GetRacialBonus(object oPC, int category)
{
	return 0;

	int iResult;
	if (category == 0)
		iResult = StringToInt(Get2DAString("racialsubtypes", "StrAdjust", GetSubRace(oPC)));
	else if (category == 1)
		iResult = StringToInt(Get2DAString("racialsubtypes", "DexAdjust", GetSubRace(oPC)));
	else if (category == 2)
		iResult = StringToInt(Get2DAString("racialsubtypes", "ConAdjust", GetSubRace(oPC)));
	else if (category == 3)
		iResult = StringToInt(Get2DAString("racialsubtypes", "IntAdjust", GetSubRace(oPC)));
	else if (category == 4)
		iResult = StringToInt(Get2DAString("racialsubtypes", "WisAdjust", GetSubRace(oPC)));
	else if (category == 5)
		iResult = StringToInt(Get2DAString("racialsubtypes", "ChaAdjust", GetSubRace(oPC)));
	else
		return 0;

	return iResult;
}


//Counts Spellcasting Progression from bsplvl file
int GetClassBspLevel(object oPC, int nClass)
{
	//Counts spellcasting progression from bsplvl file.
	string BspLevelTable = Get2DAString("classes","BonusSpellCasterLevelTable",nClass);
	
//	SendMessageToPC(oPC,"Debug BSP level table name "+BspLevelTable);	
	
	int iMax = GetLevelByClass(nClass,oPC);
	int iTotal; int iLoop; int iBSP;
	
	if(iMax == 1) iTotal = StringToInt(Get2DAString(BspLevelTable,"GrantsBonusSpellcasterLevel",1));	
	else
	{
		while(iMax > iLoop)
		{
			iBSP = StringToInt(Get2DAString(BspLevelTable,"GrantsBonusSpellcasterLevel",iLoop));
			if(iBSP == 1)
			{
				iTotal++;
			//	SendMessageToPC(oPC,"BspLevel "+IntToString(iTotal)+" gained at level "+IntToString(iLoop));	
			}
			iLoop++;
		}
	}
	
//	SendMessageToPC(oPC,"Debug cleric: BSPlevel progression of class ID "+IntToString(nClass)+" came to "+IntToString(iTotal)+".");
	
	return iTotal;
}


//Checks if the Class is a High BAB One
int GetIsHighBabClass(int classid)
{
	if(Get2DAString("classes","AttackBonusTable",classid) == "CLS_ATK_1") return TRUE;
	else return FALSE;
}


int MonkLevels(object oPC, int BAB = 0)
{
	int iMonk = GetLevelByClass(5,oPC); //Monk
	
	if(GetHasFeat(1556,oPC,TRUE))
	{
		if(BAB == 0 || BAB == 1 && !GetIsHighBabClass(45))	iMonk = iMonk + GetLevelByClass(45,oPC); //Sacred Fist
	}
	
	if (GetHasFeat(3209,oPC,TRUE))
	iMonk = iMonk + GetLevelByClass(214,oPC); // Austere One
	

	return iMonk;
}


int GetHasWarlockProgression(object oPC, int iClass)
{
	string BspCasterFeat = Get2DAString("classes","BonusCasterFeatByClassMap",iClass);
	if(BspCasterFeat == "") return FALSE;
	
	if(GetHasFeat(StringToInt(Get2DAString(BspCasterFeat,"SpellcasterFeat",39)),oPC,TRUE)) return TRUE;
	else return FALSE;
}

int GetWarlockAndPRCClassLevels(object oPC)
{
	int iSlotNumber; int iClass;
	int iTotal; int iTrue;

	if(GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) == 0) return 0;		
		
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_WARLOCK || GetHasWarlockProgression(oPC,iClass)) iTotal = iTotal + GetLevelByClass(iClass,oPC);
	}
		if(GetHasFeat(FEAT_FIENDISH_POWER,oPC,TRUE)) iTotal = iTotal + 1;
	if(GetHasFeat(FEAT_SPELL_PENETRATION,oPC,TRUE)) iTotal = iTotal + 2;
	if(GetHasFeat(FEAT_GREATER_SPELL_PENETRATION,oPC,TRUE)) iTotal = iTotal + 2;
	if (GetHasFeat(FEAT_EPIC_SPELL_PENETRATION, oPC, TRUE)) iTotal = iTotal +2;
	return iTotal;
}

//Breaking this out for clarity
void GiveEssenceBlastShapes(object oPC) {

	FeatRemove(oPC, FEAT_WARLOCK_SPEAR_DRAINING);
	FeatRemove(oPC, FEAT_WARLOCK_SPEAR_FRIGHTFUL);
	FeatRemove(oPC, FEAT_WARLOCK_SPEAR_BSHADOWED);
	FeatRemove(oPC, FEAT_WARLOCK_SPEAR_BRIMSTONE);
	FeatRemove(oPC, FEAT_WARLOCK_SPEAR_HELLRIME);
	FeatRemove(oPC, FEAT_WARLOCK_SPEAR_BWITCHING);
	FeatRemove(oPC, FEAT_WARLOCK_SPEAR_NOXIOUS);
	FeatRemove(oPC, FEAT_WARLOCK_SPEAR_VITRIOLIC);
	FeatRemove(oPC, FEAT_WARLOCK_SPEAR_UTTERDARK);
	FeatRemove(oPC, FEAT_WARLOCK_SPEAR_BLACKBOLT);
	FeatRemove(oPC, FEAT_WARLOCK_SPEAR_BINDING);

	FeatRemove(oPC, FEAT_WARLOCK_BLOW_DRAINING);
	FeatRemove(oPC, FEAT_WARLOCK_BLOW_FRIGHTFUL);
	FeatRemove(oPC, FEAT_WARLOCK_BLOW_BSHADOWED);
	FeatRemove(oPC, FEAT_WARLOCK_BLOW_BRIMSTONE);
	FeatRemove(oPC, FEAT_WARLOCK_BLOW_HELLRIME);
	FeatRemove(oPC, FEAT_WARLOCK_BLOW_BWITCHING);
	FeatRemove(oPC, FEAT_WARLOCK_BLOW_NOXIOUS);
	FeatRemove(oPC, FEAT_WARLOCK_BLOW_VITRIOLIC);
	FeatRemove(oPC, FEAT_WARLOCK_BLOW_UTTERDARK);
	FeatRemove(oPC, FEAT_WARLOCK_BLOW_BLACKBOLT);
	FeatRemove(oPC, FEAT_WARLOCK_BLOW_BINDING);

	FeatRemove(oPC, FEAT_WARLOCK_SHIELD_DRAINING);
	FeatRemove(oPC, FEAT_WARLOCK_SHIELD_FRIGHTFUL);
	FeatRemove(oPC, FEAT_WARLOCK_SHIELD_BSHADOWED);
	FeatRemove(oPC, FEAT_WARLOCK_SHIELD_BRIMSTONE);
	FeatRemove(oPC, FEAT_WARLOCK_SHIELD_HELLRIME);
	FeatRemove(oPC, FEAT_WARLOCK_SHIELD_BWITCHING);
	FeatRemove(oPC, FEAT_WARLOCK_SHIELD_NOXIOUS);
	FeatRemove(oPC, FEAT_WARLOCK_SHIELD_VITRIOLIC);
	FeatRemove(oPC, FEAT_WARLOCK_SHIELD_UTTERDARK);
	FeatRemove(oPC, FEAT_WARLOCK_SHIELD_BLACKBOLT);
	FeatRemove(oPC, FEAT_WARLOCK_SHIELD_BINDING);

	FeatRemove(oPC, FEAT_WARLOCK_CHAIN_DRAINING);
	FeatRemove(oPC, FEAT_WARLOCK_CHAIN_FRIGHTFUL);
	FeatRemove(oPC, FEAT_WARLOCK_CHAIN_BSHADOWED);
	FeatRemove(oPC, FEAT_WARLOCK_CHAIN_BRIMSTONE);
	FeatRemove(oPC, FEAT_WARLOCK_CHAIN_HELLRIME);
	FeatRemove(oPC, FEAT_WARLOCK_CHAIN_BWITCHING);
	FeatRemove(oPC, FEAT_WARLOCK_CHAIN_NOXIOUS);
	FeatRemove(oPC, FEAT_WARLOCK_CHAIN_VITRIOLIC);
	FeatRemove(oPC, FEAT_WARLOCK_CHAIN_UTTERDARK);
	FeatRemove(oPC, FEAT_WARLOCK_CHAIN_BLACKBOLT);
	FeatRemove(oPC, FEAT_WARLOCK_CHAIN_BINDING);

	FeatRemove(oPC, FEAT_WARLOCK_BURST_DRAINING);
	FeatRemove(oPC, FEAT_WARLOCK_BURST_FRIGHTFUL);
	FeatRemove(oPC, FEAT_WARLOCK_BURST_BSHADOWED);
	FeatRemove(oPC, FEAT_WARLOCK_BURST_BRIMSTONE);
	FeatRemove(oPC, FEAT_WARLOCK_BURST_HELLRIME);
	FeatRemove(oPC, FEAT_WARLOCK_BURST_BWITCHING);
	FeatRemove(oPC, FEAT_WARLOCK_BURST_NOXIOUS);
	FeatRemove(oPC, FEAT_WARLOCK_BURST_VITRIOLIC);
	FeatRemove(oPC, FEAT_WARLOCK_BURST_UTTERDARK);
	FeatRemove(oPC, FEAT_WARLOCK_BURST_BLACKBOLT);
	FeatRemove(oPC, FEAT_WARLOCK_BURST_BINDING);

	FeatRemove(oPC, FEAT_WARLOCK_DOOM_DRAINING);
	FeatRemove(oPC, FEAT_WARLOCK_DOOM_FRIGHTFUL);
	FeatRemove(oPC, FEAT_WARLOCK_DOOM_BSHADOWED);
	FeatRemove(oPC, FEAT_WARLOCK_DOOM_BRIMSTONE);
	FeatRemove(oPC, FEAT_WARLOCK_DOOM_HELLRIME);
	FeatRemove(oPC, FEAT_WARLOCK_DOOM_BWITCHING);
	FeatRemove(oPC, FEAT_WARLOCK_DOOM_NOXIOUS);
	FeatRemove(oPC, FEAT_WARLOCK_DOOM_VITRIOLIC);
	FeatRemove(oPC, FEAT_WARLOCK_DOOM_UTTERDARK);
	FeatRemove(oPC, FEAT_WARLOCK_DOOM_BLACKBOLT);
	FeatRemove(oPC, FEAT_WARLOCK_DOOM_BINDING);

	//Beshadowed
	if (GetSpellKnown(oPC,SPELL_I_BESHADOWED_BLAST)) {
		if (GetHasFeat(FEAT_WARLOCK_SPEAR_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_SPEAR_BSHADOWED,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_BLOW_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_BLOW_BSHADOWED,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_SHIELD_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_SHIELD_BSHADOWED,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_CHAIN_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_CHAIN_BSHADOWED,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_BURST_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_BURST_BSHADOWED,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_DOOM_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_DOOM_BSHADOWED,FALSE,FALSE,FALSE);
		}
	}

	//Bewitching
	if (GetSpellKnown(oPC,SPELL_I_BEWITCHING_BLAST)) {
		if (GetHasFeat(FEAT_WARLOCK_SPEAR_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_SPEAR_BWITCHING,FALSE,FALSE,FALSE);
		}
		if (GetHasFeat(FEAT_WARLOCK_BLOW_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_BLOW_BWITCHING,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_SHIELD_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_SHIELD_BWITCHING,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_CHAIN_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_CHAIN_BWITCHING,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_BURST_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_BURST_BWITCHING,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_DOOM_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_DOOM_BWITCHING,FALSE,FALSE,FALSE);
		}
	}

	//Blackbolt
	if (GetSpellKnown(oPC,SPELL_I_BLACKBOLT_BLAST)) {
		if (GetHasFeat(FEAT_WARLOCK_SPEAR_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_SPEAR_BLACKBOLT,FALSE,FALSE,FALSE);
		}
		if (GetHasFeat(FEAT_WARLOCK_BLOW_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_BLOW_BLACKBOLT,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_SHIELD_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_SHIELD_BLACKBOLT,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_CHAIN_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_CHAIN_BLACKBOLT,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_BURST_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_BURST_BLACKBOLT,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_DOOM_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_DOOM_BLACKBOLT,FALSE,FALSE,FALSE);
		}
	}

	//Brimstone
	if (GetSpellKnown(oPC,SPELL_I_BRIMSTONE_BLAST)) {
		if (GetHasFeat(FEAT_WARLOCK_SPEAR_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_SPEAR_BRIMSTONE,FALSE,FALSE,FALSE);
		}
		if (GetHasFeat(FEAT_WARLOCK_BLOW_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_BLOW_BRIMSTONE,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_SHIELD_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_SHIELD_BRIMSTONE,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_CHAIN_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_CHAIN_BRIMSTONE,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_BURST_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_BURST_BRIMSTONE,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_DOOM_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_DOOM_BRIMSTONE,FALSE,FALSE,FALSE);
		}
	}

	//Draining
	if (GetSpellKnown(oPC,SPELL_I_DRAINING_BLAST)) {
		if (GetHasFeat(FEAT_WARLOCK_SPEAR_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_SPEAR_DRAINING,FALSE,FALSE,FALSE);
		}
		if (GetHasFeat(FEAT_WARLOCK_BLOW_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_BLOW_DRAINING,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_SHIELD_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_SHIELD_DRAINING,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_CHAIN_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_CHAIN_DRAINING,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_BURST_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_BURST_DRAINING,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_DOOM_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_DOOM_DRAINING,FALSE,FALSE,FALSE);
		}
	}

	//Frightful
	if (GetSpellKnown(oPC,SPELL_I_FRIGHTFUL_BLAST)) {
		if (GetHasFeat(FEAT_WARLOCK_SPEAR_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_SPEAR_FRIGHTFUL,FALSE,FALSE,FALSE);
		}
		if (GetHasFeat(FEAT_WARLOCK_BLOW_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_BLOW_FRIGHTFUL,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_SHIELD_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_SHIELD_FRIGHTFUL,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_CHAIN_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_CHAIN_FRIGHTFUL,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_BURST_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_BURST_FRIGHTFUL,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_DOOM_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_DOOM_FRIGHTFUL,FALSE,FALSE,FALSE);
		}
	}

	//Hellrime
	if (GetSpellKnown(oPC,SPELL_I_HELLRIME_BLAST)) {
		if (GetHasFeat(FEAT_WARLOCK_SPEAR_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_SPEAR_HELLRIME,FALSE,FALSE,FALSE);
		}
		if (GetHasFeat(FEAT_WARLOCK_BLOW_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_BLOW_HELLRIME,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_SHIELD_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_SHIELD_HELLRIME,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_CHAIN_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_CHAIN_HELLRIME,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_BURST_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_BURST_HELLRIME,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_DOOM_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_DOOM_HELLRIME,FALSE,FALSE,FALSE);
		}
	}

	//Noxious
	if (GetSpellKnown(oPC,SPELL_I_NOXIOUS_BLAST)) {
		if (GetHasFeat(FEAT_WARLOCK_SPEAR_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_SPEAR_NOXIOUS,FALSE,FALSE,FALSE);
		}
		if (GetHasFeat(FEAT_WARLOCK_BLOW_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_BLOW_NOXIOUS,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_SHIELD_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_SHIELD_NOXIOUS,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_CHAIN_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_CHAIN_NOXIOUS,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_BURST_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_BURST_NOXIOUS,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_DOOM_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_DOOM_NOXIOUS,FALSE,FALSE,FALSE);
		}
	}

	//Utterdark
	if (GetSpellKnown(oPC,SPELL_I_UTTERDARK_BLAST)) {
		if (GetHasFeat(FEAT_WARLOCK_SPEAR_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_SPEAR_UTTERDARK,FALSE,FALSE,FALSE);
		}
		if (GetHasFeat(FEAT_WARLOCK_BLOW_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_BLOW_UTTERDARK,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_SHIELD_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_SHIELD_UTTERDARK,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_CHAIN_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_CHAIN_UTTERDARK,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_BURST_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_BURST_UTTERDARK,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_DOOM_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_DOOM_UTTERDARK,FALSE,FALSE,FALSE);
		}
	}

	//Vitriolic
	if (GetSpellKnown(oPC,SPELL_I_VITRIOLIC_BLAST)) {
		if (GetHasFeat(FEAT_WARLOCK_SPEAR_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_SPEAR_VITRIOLIC,FALSE,FALSE,FALSE);
		}
		if (GetHasFeat(FEAT_WARLOCK_BLOW_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_BLOW_VITRIOLIC,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_SHIELD_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_SHIELD_VITRIOLIC,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_CHAIN_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_CHAIN_VITRIOLIC,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_BURST_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_BURST_VITRIOLIC,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_DOOM_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_DOOM_VITRIOLIC,FALSE,FALSE,FALSE);
		}
	}

	//Binding
	if (GetSpellKnown(oPC,SPELL_I_BINDING_BLAST)) {
		if (GetHasFeat(FEAT_WARLOCK_SPEAR_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_SPEAR_BINDING,FALSE,FALSE,FALSE);
		}
		if (GetHasFeat(FEAT_WARLOCK_BLOW_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_BLOW_BINDING,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_SHIELD_ELDRTICH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_SHIELD_BINDING,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_CHAIN_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_CHAIN_BINDING,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_BURST_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_BURST_BINDING,FALSE,FALSE,FALSE);
		} 
		if (GetHasFeat(FEAT_WARLOCK_DOOM_ELDRITCH, oPC, TRUE)) {
			FeatAdd(oPC, FEAT_WARLOCK_DOOM_BINDING,FALSE,FALSE,FALSE);
		}
	}
	
}

int GetWarlockCasterLevelBase(object oPC) {
	int iSlotNumber; int iClass;
	int iTotal; 
	
	if(GetLevelByClass(CLASS_TYPE_WARLOCK,oPC) == 0) return 0;
	
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_WARLOCK) iTotal = iTotal + GetLevelByClass(iClass,oPC);
		else if (GetHasWarlockProgression(oPC,iClass)) iTotal = iTotal + GetClassBspLevel(oPC,iClass);
	}
	
	
	if (GetHasFeat(FEAT_PRACTICED_INVOKER,oPC,TRUE)) iTotal = iTotal +4;
	if (iTotal > 30)
	iTotal = 30;
	
	return iTotal;
}

//Gets Warlock Caster Levels with Feats included 
int GetWarlockCasterLevel(object oPC)
{
	int iSlotNumber; int iClass;
	int iTotal; int iTrue;
	
	if(GetLevelByClass(CLASS_TYPE_WARLOCK,oPC) == 0) return 0;
	
	iTotal = GetWarlockCasterLevelBase(oPC);
	
	int nDice;
	int nCount;	
	
	//1411-1419 1-9
	//1948-1952 10-14
	if (GetHasFeat(FEAT_PRACTICED_INVOKER,oPC,TRUE)) iTotal = iTotal +4;
	
	if (iTotal >= 0)
	{
	if (!GetHasFeat(FEAT_INVOCATIONS_WARLOCK_I,oPC,TRUE))
		FeatAdd(oPC,FEAT_INVOCATIONS_WARLOCK_I,FALSE,FALSE,FALSE);
	}
	if (iTotal >= 5)
	{
		if (!GetHasFeat(FEAT_INVOCATIONS_WARLOCK_II,oPC,TRUE))
		FeatAdd(oPC,FEAT_INVOCATIONS_WARLOCK_II,FALSE,FALSE,FALSE);
	}
	
	
	if (iTotal >= 16)
	{
		if (!GetHasFeat(FEAT_EPIC_ELDRITCH_ADEPT,oPC,TRUE))
		FeatAdd(oPC,FEAT_EPIC_ELDRITCH_ADEPT,FALSE,FALSE,FALSE);
	}	
	if (iTotal > 20) //10-14
	{	nDice = (iTotal - 20) / 2;
		for (nCount = 0; nCount < nDice; nCount++)
		{	FeatAdd(oPC, nCount + 1948, FALSE);		}		
		FeatAdd(oPC, 1411, FALSE);
		FeatAdd(oPC, 1412, FALSE);	
		FeatAdd(oPC, 1413, FALSE);	
		FeatAdd(oPC, 1414, FALSE);	
		FeatAdd(oPC, 1415, FALSE);	
		FeatAdd(oPC, 1416, FALSE);	
		FeatAdd(oPC, 1417, FALSE);	
		FeatAdd(oPC, 1418, FALSE);	
		FeatAdd(oPC, 1419, FALSE);				
	}
	else
	if (iTotal > 11) //7-9
	{	nDice = (iTotal - 11) / 3;
		for (nCount = 0; nCount < nDice; nCount++)
		{	FeatAdd(oPC, nCount + 1417, FALSE);		}	
		FeatAdd(oPC, 1411, FALSE);
		FeatAdd(oPC, 1412, FALSE);	
		FeatAdd(oPC, 1413, FALSE);	
		FeatAdd(oPC, 1414, FALSE);	
		FeatAdd(oPC, 1415, FALSE);	
		FeatAdd(oPC, 1416, FALSE);										
	}
	else //1-6
	{	nDice = (iTotal + 1) / 2;
		for (nCount = 0; nCount < nDice; nCount++)
		{	FeatAdd(oPC, nCount + 1411, FALSE);		}
	}
	
	return iTotal;
}

// used to check for if new creature weapon as designed by Cere.
int PS_IsEquippableCW(object oItem)
{
	int iType = GetBaseItemType(oItem);

	if (iType >= 160 || iType <= 174)
	{	return TRUE;	}
	else
	{	return FALSE;	}
}
int GetHasSpiritShamanProgression(object oPC, int iClass)
{
	string BspCasterFeat = Get2DAString("classes","BonusCasterFeatByClassMap",iClass);
	if(BspCasterFeat == "") return FALSE;
	
//	SendMessageToPC(oPC,"Debug cleric: checking if class "+IntToString(iClass)+" has feat "+Get2DAString(BspCasterFeat,"SpellcasterFeat",2)+".");
	
	if(GetHasFeat(StringToInt(Get2DAString(BspCasterFeat,"SpellcasterFeat",55)),oPC,TRUE)) return TRUE;
	else return FALSE;
}

int GetSpiritShamanTRUECasterlevel(object oPC)
{
	int iSlotNumber; int iClass;
	int iTotal; int iTrue;

	if(GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oPC) == 0) return 0;	
		
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_SPIRIT_SHAMAN)	iTotal = iTotal + GetLevelByClass(iClass,oPC);
		else if (GetHasSpiritShamanProgression(oPC,iClass)) iTotal = iTotal + GetClassBspLevel(oPC,iClass);
	}
	
	if(GetHasFeat(2003,oPC,TRUE)) iTotal = iTotal + 4;
	if (iTotal >= 1)
	{
	if (!GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_I,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_SORCFAVSHAMAN_I,FALSE,FALSE,FALSE);
	}
	if (iTotal >= 3)
	{
	if (!GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_II,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_SORCFAVSHAMAN_II,FALSE,FALSE,FALSE);
	}
	
	if (iTotal >= 6)
	{
	if (!GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_III,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_SORCFAVSHAMAN_III,FALSE,FALSE,FALSE);
	}
		if (iTotal >= 9)
	{
	if (!GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_IV,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_SORCFAVSHAMAN_IV,FALSE,FALSE,FALSE);
	}
	
	
	
	return iTotal;
}
int GetSpiritShamanWithoutFeat(object oPC)
{

int iSlotNumber; int iClass;
	int iTotal; int iTrue;

	if(GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, oPC) == 0) return 0;	
		
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_SPIRIT_SHAMAN)	iTotal = iTotal + GetLevelByClass(iClass,oPC);
		else if (GetHasSpiritShamanProgression(oPC,iClass)) iTotal = iTotal + GetClassBspLevel(oPC,iClass);
	}
	
	if (iTotal >= 1)
	{
	if (!GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_I,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_SORCFAVSHAMAN_I,FALSE,FALSE,FALSE);
	}
	if (iTotal >= 3)
	{
	if (!GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_II,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_SORCFAVSHAMAN_II,FALSE,FALSE,FALSE);
	}
	
	if (iTotal >= 6)
	{
	if (!GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_III,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_SORCFAVSHAMAN_III,FALSE,FALSE,FALSE);
	}
		if (iTotal >= 9)
	{
	if (!GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_IV,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_SORCFAVSHAMAN_IV,FALSE,FALSE,FALSE);
	}
	
	
	
	return iTotal;


}
// Used in any spell scripts for Ranger/Paladin spells instead of GetCasterLevel in order that those spells get full caster level for Ranger/Paladin.

int GetHasPaladinProgression(object oPC, int iClass)
{
	string BspCasterFeat = Get2DAString("classes","BonusCasterFeatByClassMap",iClass);
	if(BspCasterFeat == "") return FALSE;
	
//	SendMessageToPC(oPC,"Debug cleric: checking if class "+IntToString(iClass)+" has feat "+Get2DAString(BspCasterFeat,"SpellcasterFeat",2)+".");
	
	if(GetHasFeat(StringToInt(Get2DAString(BspCasterFeat,"SpellcasterFeat",6)),oPC,TRUE)) return TRUE;
	else return FALSE;
}

int GetPaladinAndPRCClassLevels(object oPC)
{
	int iSlotNumber; int iClass;
	int iTotal; int iTrue;

	if(GetLevelByClass(CLASS_TYPE_PALADIN, oPC) == 0) return 0;		
		
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_PALADIN || GetHasPaladinProgression(oPC,iClass)) iTotal = iTotal + GetLevelByClass(iClass,oPC);
	}
	
	return iTotal;
}


int GetPaladinTRUECasterlevel(object oPC)
{
	int iSlotNumber; int iClass;
	int iTotal; int iTrue;

	if(GetLevelByClass(CLASS_TYPE_PALADIN, oPC) == 0) return 0;	
		
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_PALADIN) iTotal = iTotal + GetLevelByClass(iClass,oPC);
		else if (GetHasPaladinProgression(oPC,iClass)) iTotal = iTotal + GetClassBspLevel(oPC,iClass);
	}
	
	if(GetHasFeat(FEAT_PRACTICED_SPELLCASTER_PALADIN,oPC,TRUE)) iTotal = iTotal + 4;
	
	
		if (iTotal >= 0)
	{
	if (!GetHasFeat(FEAT_SPELL_PALRANG_I,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_PALRANG_I,FALSE,FALSE,FALSE);
	}
		if (iTotal >= 3)
	{
	if (!GetHasFeat(FEAT_SPELL_PALRANG_II,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_PALRANG_II,FALSE,FALSE,FALSE);
	}
		if (iTotal >= 7)
	{
	if (!GetHasFeat(FEAT_SPELL_PALRANG_III,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_PALRANG_III,FALSE,FALSE,FALSE);
	}
		if (iTotal >= 10)
	{
	if (!GetHasFeat(FEAT_SPELL_PALRANG_IV,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_PALRANG_IV,FALSE,FALSE,FALSE);
	}
	
	return iTotal;
}

int GetPaladinWithoutFeat(object oPC)
{

	int iSlotNumber; int iClass;
	int iTotal; int iTrue;

	if(GetLevelByClass(CLASS_TYPE_PALADIN, oPC) == 0) return 0;	
		
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_PALADIN) iTotal = iTotal + GetLevelByClass(iClass,oPC);
		else if (GetHasPaladinProgression(oPC,iClass)) iTotal = iTotal + GetClassBspLevel(oPC,iClass);
	}
	
	
		if (iTotal >= 0)
	{
	if (!GetHasFeat(FEAT_SPELL_PALRANG_I,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_PALRANG_I,FALSE,FALSE,FALSE);
	}
		if (iTotal >= 3)
	{
	if (!GetHasFeat(FEAT_SPELL_PALRANG_II,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_PALRANG_II,FALSE,FALSE,FALSE);
	}
		if (iTotal >= 7)
	{
	if (!GetHasFeat(FEAT_SPELL_PALRANG_III,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_PALRANG_III,FALSE,FALSE,FALSE);
	}
		if (iTotal >= 10)
	{
	if (!GetHasFeat(FEAT_SPELL_PALRANG_IV,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_PALRANG_IV,FALSE,FALSE,FALSE);
	}
	
	return iTotal;


}


int GetHasRangerProgression(object oPC, int iClass)
{
	string BspCasterFeat = Get2DAString("classes","BonusCasterFeatByClassMap",iClass);
	if(BspCasterFeat == "") return FALSE;
	
//	SendMessageToPC(oPC,"Debug cleric: checking if class "+IntToString(iClass)+" has feat "+Get2DAString(BspCasterFeat,"SpellcasterFeat",2)+".");
	
	if(GetHasFeat(StringToInt(Get2DAString(BspCasterFeat,"SpellcasterFeat",7)),oPC,TRUE)) return TRUE;
	else return FALSE;
}

int GetRangerAndPRCClassLevels(object oPC)
{
	int iSlotNumber; int iClass;
	int iTotal; int iTrue;

	if(GetLevelByClass(CLASS_TYPE_RANGER, oPC) == 0) return 0;	
		
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_RANGER || GetHasRangerProgression(oPC,iClass)) iTotal = iTotal + GetLevelByClass(iClass,oPC);
	}
	
	return iTotal;
}

int GetRangerTRUECasterlevel(object oPC)
{
	int iSlotNumber; int iClass;
	int iTotal; int iTrue;

	if(GetLevelByClass(CLASS_TYPE_RANGER, oPC) == 0) return 0;	
		
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_RANGER)	iTotal = iTotal + GetLevelByClass(iClass,oPC);
		else if (GetHasRangerProgression(oPC,iClass)) iTotal = iTotal + GetClassBspLevel(oPC,iClass);
	}
	
	if(GetHasFeat(FEAT_PRACTICED_SPELLCASTER_RANGER,oPC,TRUE)) iTotal = iTotal + 4;
	
	
	return iTotal;
}


int GetRangerWithOutFeats(object oPC)
{


	int iSlotNumber; int iClass;
	int iTotal; int iTrue;

	if(GetLevelByClass(CLASS_TYPE_RANGER, oPC) == 0) return 0;		
		
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_RANGER) iTotal = GetLevelByClass(CLASS_TYPE_RANGER,oPC);
		else if (GetHasRangerProgression(oPC,iClass)) iTotal = iTotal + GetClassBspLevel(oPC,iClass);
	}
	
	if (iTotal >= 1)
	{
	if (!GetHasFeat(FEAT_SPELL_PALRANG_I,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_PALRANG_I,FALSE,FALSE,FALSE);
	}
		if (iTotal >= 4)
	{
	if (!GetHasFeat(FEAT_SPELL_PALRANG_II,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_PALRANG_II,FALSE,FALSE,FALSE);
	}
		if (iTotal >= 8)
	{
	if (!GetHasFeat(FEAT_SPELL_PALRANG_III,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_PALRANG_III,FALSE,FALSE,FALSE);
	}
		if (iTotal >= 12)
	{	
	if (!GetHasFeat(FEAT_SPELL_PALRANG_IV,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_PALRANG_IV,FALSE,FALSE,FALSE);
	}
	return iTotal;


}

int GetHasWizardProgression(object oPC, int iClass)
{
	string BspCasterFeat = Get2DAString("classes","BonusCasterFeatByClassMap",iClass);
	if(BspCasterFeat == "") return FALSE;
	
//	SendMessageToPC(oPC,"Debug cleric: checking if class "+IntToString(iClass)+" has feat "+Get2DAString(BspCasterFeat,"SpellcasterFeat",2)+".");
	
	if(GetHasFeat(StringToInt(Get2DAString(BspCasterFeat,"SpellcasterFeat",10)),oPC,TRUE)) return TRUE;
	else return FALSE;
}

int GetWizardTRUECasterlevel(object oPC)
{
	int iSlotNumber; int iClass;
	int iTotal; int iTrue;

	if(GetLevelByClass(CLASS_TYPE_WIZARD, oPC) == 0) return 0;		
		
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_WIZARD)	iTotal = iTotal + GetLevelByClass(iClass,oPC);
		else if (GetHasWizardProgression(oPC,iClass)) iTotal = iTotal + GetClassBspLevel(oPC,iClass);
	}
	
	if(GetHasFeat(FEAT_PRACTICED_SPELLCASTER_WIZARD,oPC,TRUE)) iTotal = iTotal + 4;
	
	int iRedWizard = GetLevelByClass(53,oPC);
	if(iRedWizard > 0)
	{
		if(iRedWizard == 1) iTotal = iTotal + 1;
		else iTotal = iTotal + (iRedWizard / 2);
	}
	
	
	return iTotal;
}

int GetWizardWithoutFeat(object oPC)
{

	int iSlotNumber; int iClass;
	int iTotal; int iTrue;

	if(GetLevelByClass(CLASS_TYPE_WIZARD, oPC) == 0) return 0;		
		
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_WIZARD)	iTotal = iTotal + GetLevelByClass(iClass,oPC);
		else if (GetHasWizardProgression(oPC,iClass)) iTotal = iTotal + GetClassBspLevel(oPC,iClass);
	}
	
		if (iTotal >= 0)
	{
	if (!GetHasFeat(FEAT_SPELL_WIZARD_I,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_WIZARD_I,FALSE,FALSE,FALSE);
	}
		if (iTotal >= 2)
	{
	if (!GetHasFeat(FEAT_SPELL_WIZARD_II,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_WIZARD_II,FALSE,FALSE,FALSE);
	}
		if (iTotal >= 4)
	{
	if (!GetHasFeat(FEAT_SPELL_WIZARD_III,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_WIZARD_III,FALSE,FALSE,FALSE);
	}
		if (iTotal >= 6)
	{
	if (!GetHasFeat(FEAT_SPELL_WIZARD_IV,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_WIZARD_IV,FALSE,FALSE,FALSE);
	}

	return iTotal;
}

int GetHasSorcererProgression(object oPC, int iClass)
{
	string BspCasterFeat = Get2DAString("classes","BonusCasterFeatByClassMap",iClass);
	if(BspCasterFeat == "") return FALSE;
	
//	SendMessageToPC(oPC,"Debug cleric: checking if class "+IntToString(iClass)+" has feat "+Get2DAString(BspCasterFeat,"SpellcasterFeat",2)+".");
	
	if(GetHasFeat(StringToInt(Get2DAString(BspCasterFeat,"SpellcasterFeat",9)),oPC,TRUE)) return TRUE;
	else return FALSE;
}

int GetSorcererTRUECasterlevel(object oPC)
{
	int iSlotNumber; int iClass;
	int iTotal; int iTrue;

	if(GetLevelByClass(CLASS_TYPE_SORCERER, oPC) == 0) return 0;		
		
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_SORCERER)	iTotal = iTotal + GetLevelByClass(iClass,oPC);
		else if (GetHasSorcererProgression(oPC,iClass)) iTotal = iTotal + GetClassBspLevel(oPC,iClass);
	}
	
	if(GetHasFeat(FEAT_PRACTICED_SPELLCASTER_SORCERER,oPC,TRUE)) iTotal = iTotal + 4;
	

	return iTotal;
}

int GetSorcererAndPRCClassLevels(object oPC)
{
	int iSlotNumber; int iClass;
	int iTotal; int iTrue;

	if(GetLevelByClass(CLASS_TYPE_SORCERER, oPC) == 0) return 0;		
		
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_SORCERER || GetHasSorcererProgression(oPC,iClass))
		{
			iTotal = iTotal + GetLevelByClass(iClass,oPC);
		}
	}
	
	return iTotal;
}
int GetSorcererWithoutFeat(object oPC)
{



int iSlotNumber; int iClass;
	int iTotal; int iTrue;

	if(GetLevelByClass(CLASS_TYPE_SORCERER, oPC) == 0) return 0;		
		
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_SORCERER)	iTotal = iTotal + GetLevelByClass(iClass,oPC);
		else if (GetHasSorcererProgression(oPC,iClass)) iTotal = iTotal + GetClassBspLevel(oPC,iClass);
	}
	

	
		if (iTotal >= 1)
	{
	if (!GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_I,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_SORCFAVSHAMAN_I,FALSE,FALSE,FALSE);
	}
	if (iTotal >= 3)
	{
	if (!GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_II,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_SORCFAVSHAMAN_II,FALSE,FALSE,FALSE);
	}
	
	if (iTotal >= 6)
	{
	if (!GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_III,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_SORCFAVSHAMAN_III,FALSE,FALSE,FALSE);
	}
		if (iTotal >= 9)
	{
	if (!GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_IV,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_SORCFAVSHAMAN_IV,FALSE,FALSE,FALSE);
	}
	
	return iTotal;



}
int GetHasBardProgression(object oPC, int iClass)
{
	string BspCasterFeat = Get2DAString("classes","BonusCasterFeatByClassMap",iClass);
	if(BspCasterFeat == "") return FALSE;
	
//	SendMessageToPC(oPC,"Debug cleric: checking if class "+IntToString(iClass)+" has feat "+Get2DAString(BspCasterFeat,"SpellcasterFeat",2)+".");
	
	if(GetHasFeat(StringToInt(Get2DAString(BspCasterFeat,"SpellcasterFeat",1)),oPC,TRUE)) return TRUE;
	else return FALSE;
}

int GetBardAndPRCClassLevels(object oPC)
{
	int iSlotNumber; int iClass;
	int iTotal; int iTrue;

	if(GetLevelByClass(CLASS_TYPE_BARD, oPC) == 0) return 0;		
		
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_BARD || GetHasBardProgression(oPC,iClass)) iTotal = iTotal + GetLevelByClass(iClass,oPC);
	}
	
	return iTotal;
}

int GetBardTRUECasterlevel(object oPC)
{
	int iSlotNumber; int iClass;
	int iTotal; int iTrue;

	if(GetLevelByClass(CLASS_TYPE_BARD, oPC) == 0) return 0;	
		
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_BARD) iTotal = iTotal + GetLevelByClass(iClass,oPC);
		else if (GetHasBardProgression(oPC,iClass)) iTotal = iTotal + GetClassBspLevel(oPC,iClass);
	}
	
	if(GetHasFeat(FEAT_PRACTICED_SPELLCASTER_BARD,oPC,TRUE)) iTotal = iTotal + 4;
	
	return iTotal;
}


int GetBardWithoutFeat(object oPC)
{


	int iSlotNumber; int iClass;
	int iTotal; int iTrue;

	if(GetLevelByClass(CLASS_TYPE_BARD, oPC) == 0) return 0;	
		
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_BARD) iTotal = iTotal + GetLevelByClass(iClass,oPC);
		else if (GetHasBardProgression(oPC,iClass)) iTotal = iTotal + GetClassBspLevel(oPC,iClass);
	}
	

	
	
			if (iTotal >= 1)
	{
	if (!GetHasFeat(FEAT_SPELL_BARD_I,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_BARD_I,FALSE,FALSE,FALSE);
	}
	if (iTotal >=3)
	{
	if (!GetHasFeat(FEAT_SPELL_BARD_II,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_BARD_II,FALSE,FALSE,FALSE);
	}
	
	if (iTotal >= 6)
	{
	if (!GetHasFeat(FEAT_SPELL_BARD_III,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_BARD_III,FALSE,FALSE,FALSE);
	}
		if (iTotal >= 9)
	{
	if (!GetHasFeat(FEAT_SPELL_BARD_IV,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_BARD_IV,FALSE,FALSE,FALSE);
	}
	
	
	return iTotal;




}
int GetHasDruidProgression(object oPC, int iClass)
{
	string BspCasterFeat = Get2DAString("classes","BonusCasterFeatByClassMap",iClass);
	if(BspCasterFeat == "") return FALSE;
	
//	SendMessageToPC(oPC,"Debug cleric: checking if class "+IntToString(iClass)+" has feat "+Get2DAString(BspCasterFeat,"SpellcasterFeat",2)+".");
	
	if(GetHasFeat(StringToInt(Get2DAString(BspCasterFeat,"SpellcasterFeat",3)),oPC,TRUE)) return TRUE;
	else return FALSE;
}

int GetDruidAndPRCClassLevels(object oPC)
{
	int iSlotNumber; int iClass;
	int iTotal; int iTrue;
	
	if(GetLevelByClass(CLASS_TYPE_DRUID, oPC) == 0) return 0;	
	
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_DRUID || GetHasDruidProgression(oPC,iClass)) iTotal = iTotal + GetLevelByClass(iClass,oPC);
	}
	
	return iTotal;
}

int GetDruidTRUECasterlevel(object oPC)
{
	int iSlotNumber; int iClass;
	int iTotal; int iTrue;
	
	if(GetLevelByClass(CLASS_TYPE_DRUID, oPC) == 0) return 0;		
	
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_DRUID) iTotal = iTotal + GetLevelByClass(iClass,oPC);
		else if (GetHasDruidProgression(oPC,iClass)) iTotal = iTotal + GetClassBspLevel(oPC,iClass);
	}
	
	if(GetHasFeat(FEAT_PRACTICED_SPELLCASTER_DRUID,oPC,TRUE)) iTotal = iTotal + 4;
	
	return iTotal;
}


int GetDruidWithoutFeat(object oPC)
{
	int iSlotNumber; int iClass;
	int iTotal; int iTrue;
	
	if(GetLevelByClass(CLASS_TYPE_DRUID, oPC) == 0) return 0;		
	
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_DRUID) iTotal = iTotal + GetLevelByClass(iClass,oPC);
		else if (GetHasDruidProgression(oPC,iClass)) iTotal = iTotal + GetClassBspLevel(oPC,iClass);
	}
	

	
	
		if (iTotal >= 0)
	{
	if (!GetHasFeat(FEAT_SPELL_CLERDRU_I,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_CLERDRU_I,FALSE,FALSE,FALSE);
	}
	if (iTotal >=2)
	{
	if (!GetHasFeat(FEAT_SPELL_CLERDRU_II,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_CLERDRU_II,FALSE,FALSE,FALSE);
	}
	
	if (iTotal >= 4)
	{
	if (!GetHasFeat(FEAT_SPELL_CLERDRU_III,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_CLERDRU_III,FALSE,FALSE,FALSE);
	}
		if (iTotal >= 6)
	{
	if (!GetHasFeat(FEAT_SPELL_CLERDRU_IV,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_CLERDRU_IV,FALSE,FALSE,FALSE);
	}
	
	
	
	return iTotal;



}

int GetHasFavoredSoulProgression(object oPC, int iClass)
{
	string BspCasterFeat = Get2DAString("classes","BonusCasterFeatByClassMap",iClass);
	if(BspCasterFeat == "") return FALSE;
	
//	SendMessageToPC(oPC,"Debug cleric: checking if class "+IntToString(iClass)+" has feat "+Get2DAString(BspCasterFeat,"SpellcasterFeat",2)+".");
	
	if(GetHasFeat(StringToInt(Get2DAString(BspCasterFeat,"SpellcasterFeat",58)),oPC,TRUE)) return TRUE;
	else return FALSE;
}


int GetFavoredSoulAndPRCClassLevels(object oPC)
{
	int iSlotNumber; int iClass;
	int iTotal; int iTrue;

	if(GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oPC) == 0) return 0;		
		
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_FAVORED_SOUL || GetHasFavoredSoulProgression(oPC,iClass)) iTotal = iTotal + GetLevelByClass(iClass,oPC);
	}
	
	return iTotal;
}

int GetFavoredSoulTRUECasterlevel(object oPC)
{
	int iSlotNumber; int iClass;
	int iTotal; int iTrue;
	
	if(GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oPC) == 0) return 0;	
	
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_FAVORED_SOUL) iTotal = iTotal + GetLevelByClass(iClass,oPC);
		else if (GetHasFavoredSoulProgression(oPC,iClass)) iTotal = iTotal + GetClassBspLevel(oPC,iClass);
	}
	
	if(GetHasFeat(2068,oPC,TRUE)) iTotal = iTotal + 4;
		if (iTotal >= 1)
	{
	if (!GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_I,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_SORCFAVSHAMAN_I,FALSE,FALSE,FALSE);
	}
	if (iTotal >= 3)
	{
	if (!GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_II,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_SORCFAVSHAMAN_II,FALSE,FALSE,FALSE);
	}
	
	if (iTotal >= 6)
	{
	if (!GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_III,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_SORCFAVSHAMAN_III,FALSE,FALSE,FALSE);
	}
		if (iTotal >= 9)
	{
	if (!GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_IV,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_SORCFAVSHAMAN_IV,FALSE,FALSE,FALSE);
	}
	
	
	return iTotal;
}


int GetFavoredSoulWithoutFeat(object oPC)
{

	int iSlotNumber; int iClass;
	int iTotal; int iTrue;
	
	if(GetLevelByClass(CLASS_TYPE_FAVORED_SOUL, oPC) == 0) return 0;	
	
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_FAVORED_SOUL) iTotal = iTotal + GetLevelByClass(iClass,oPC);
		else if (GetHasFavoredSoulProgression(oPC,iClass)) iTotal = iTotal + GetClassBspLevel(oPC,iClass);
	}
	
		if (iTotal >= 1)
	{
	if (!GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_I,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_SORCFAVSHAMAN_I,FALSE,FALSE,FALSE);
	}
	if (iTotal >= 3)
	{
	if (!GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_II,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_SORCFAVSHAMAN_II,FALSE,FALSE,FALSE);
	}
	
	if (iTotal >= 6)
	{
	if (!GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_III,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_SORCFAVSHAMAN_III,FALSE,FALSE,FALSE);
	}
		if (iTotal >= 9)
	{
	if (!GetHasFeat(FEAT_SPELL_SORCFAVSHAMAN_IV,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_SORCFAVSHAMAN_IV,FALSE,FALSE,FALSE);
	}
	
	
	return iTotal;



}
int GetHasClericProgression(object oPC, int iClass)
{
	string BspCasterFeat = Get2DAString("classes","BonusCasterFeatByClassMap",iClass);
	if(BspCasterFeat == "") return FALSE;
	
//	SendMessageToPC(oPC,"Debug cleric: checking if class "+IntToString(iClass)+" has feat "+Get2DAString(BspCasterFeat,"SpellcasterFeat",2)+".");
	
	if(GetHasFeat(StringToInt(Get2DAString(BspCasterFeat,"SpellcasterFeat",2)),oPC,TRUE)) return TRUE;
	else return FALSE;
}

int GetTrueClericLevel(int nLevel)
{
	//Gets true spell casting level based on tallying up spellcasting progression feat + levels in cleric.
	int nSpellLevel = StringToInt(Get2DAString("cls_spgn_cler","SpellLevel9",nLevel));
	if(nSpellLevel > 0) return 9;

	nSpellLevel = StringToInt(Get2DAString("cls_spgn_cler","SpellLevel8",nLevel));
	if(nSpellLevel > 0) return 8;
	
	nSpellLevel = StringToInt(Get2DAString("cls_spgn_cler","SpellLevel7",nLevel));
	if(nSpellLevel > 0) return 7;
	
	nSpellLevel = StringToInt(Get2DAString("cls_spgn_cler","SpellLevel6",nLevel));
	if(nSpellLevel > 0) return 6;
	
	nSpellLevel = StringToInt(Get2DAString("cls_spgn_cler","SpellLevel5",nLevel));
	if(nSpellLevel > 0) return 5;
	
	nSpellLevel = StringToInt(Get2DAString("cls_spgn_cler","SpellLevel4",nLevel));
	if(nSpellLevel > 0) return 4;
	
	nSpellLevel = StringToInt(Get2DAString("cls_spgn_cler","SpellLevel3",nLevel));
	if(nSpellLevel > 0) return 3;
	
	nSpellLevel = StringToInt(Get2DAString("cls_spgn_cler","SpellLevel2",nLevel));
	if(nSpellLevel > 0) return 2;

	nSpellLevel = StringToInt(Get2DAString("cls_spgn_cler","SpellLevel1",nLevel));
	if(nSpellLevel > 0) return 1;		
	
	return 0;	
}

int GetClericLevel(object oPC)
{
	int iSlotNumber; int iClass;
	int iTotal; int iTrue;

	if(GetLevelByClass(CLASS_TYPE_CLERIC, oPC) == 0) return 0;	
		
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_CLERIC)	iTotal = iTotal + GetLevelByClass(iClass,oPC);
		else if (GetHasClericProgression(oPC,iClass)) iTotal = iTotal + GetClassBspLevel(oPC,iClass);
	}
	
	if(iTotal > 0)
	{
//		SendMessageToPC(oPC,"Debug cleric: Caster levels tallied out to: "+IntToString(iTotal)+".");
		iTrue = GetTrueClericLevel(iTotal);
		return iTrue;
//		SendMessageToPC(oPC,"Debug cleric:  Calculated Spell Level of Cleric Casting is: "+IntToString(iTrue)+".");
	}
	
	return 0;
}

int GetClericTRUECasterlevel(object oPC)
{
	int iSlotNumber; int iClass;
	int iTotal; int iTrue;

	if(GetLevelByClass(CLASS_TYPE_CLERIC, oPC) == 0) return 0;	
		
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_CLERIC)	iTotal = iTotal + GetLevelByClass(iClass,oPC);
		else if (GetHasClericProgression(oPC,iClass)) iTotal = iTotal + GetClassBspLevel(oPC,iClass);
	}
	
	if(GetHasFeat(FEAT_PRACTICED_SPELLCASTER_CLERIC,oPC,TRUE)) iTotal = iTotal + 4;
	if (iTotal >= 0)
	{
	if (!GetHasFeat(FEAT_SPELL_CLERDRU_I,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_CLERDRU_I,FALSE,FALSE,FALSE);
	}
	if (iTotal >=2)
	{
	if (!GetHasFeat(FEAT_SPELL_CLERDRU_II,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_CLERDRU_II,FALSE,FALSE,FALSE);
	}
	
	if (iTotal >= 4)
	{
	if (!GetHasFeat(FEAT_SPELL_CLERDRU_III,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_CLERDRU_III,FALSE,FALSE,FALSE);
	}
		if (iTotal >= 6)
	{
	if (!GetHasFeat(FEAT_SPELL_CLERDRU_IV,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_CLERDRU_IV,FALSE,FALSE,FALSE);
	}
	
	
	return iTotal;
}

int GetClericAndPRCClassLevels(object oPC)
{
	int iSlotNumber; int iClass;
	int iTotal; int iTrue;

	if(GetLevelByClass(CLASS_TYPE_CLERIC, oPC) == 0) return 0;		
		
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_CLERIC || GetHasClericProgression(oPC,iClass)) iTotal = iTotal + GetLevelByClass(iClass,oPC);}

	
	return iTotal;
}

int GetClericWithoutFeat(object oPC)
{

int iSlotNumber; int iClass;
	int iTotal; int iTrue;

	if(GetLevelByClass(CLASS_TYPE_CLERIC, oPC) == 0) return 0;	
		
	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
	{
		iClass = GetClassByPosition( iSlotNumber, oPC);
		
		if ( iClass == 255 ) break;
			
		if(iClass == CLASS_TYPE_CLERIC)	iTotal = iTotal + GetLevelByClass(iClass,oPC);
		else if (GetHasClericProgression(oPC,iClass)) iTotal = iTotal + GetClassBspLevel(oPC,iClass);
	}
	

	if (iTotal >= 0)
	{
	if (!GetHasFeat(FEAT_SPELL_CLERDRU_I,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_CLERDRU_I,FALSE,FALSE,FALSE);
	}
	if (iTotal >=2)
	{
	if (!GetHasFeat(FEAT_SPELL_CLERDRU_II,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_CLERDRU_II,FALSE,FALSE,FALSE);
	}
	
	if (iTotal >= 4)
	{
	if (!GetHasFeat(FEAT_SPELL_CLERDRU_III,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_CLERDRU_III,FALSE,FALSE,FALSE);
	}
		if (iTotal >= 6)
	{
	if (!GetHasFeat(FEAT_SPELL_CLERDRU_IV,oPC,TRUE))
		FeatAdd(oPC,FEAT_SPELL_CLERDRU_IV,FALSE,FALSE,FALSE);
	}
	
	
	return iTotal;


}
int PS_GetCasterLevel(object oPC)
{
 int iClass = GetLastSpellCastClass();
 int iCasterLevelTrue = GetCasterLevel(oPC);
 int iLevel;
if(GetSpellCastItem() != OBJECT_INVALID) return iCasterLevelTrue;

	if (iClass == CLASS_TYPE_RANGER) iLevel = GetRangerTRUECasterlevel(oPC);
	else if (iClass == CLASS_TYPE_PALADIN)iLevel = GetPaladinTRUECasterlevel(oPC);
	else if (iClass == CLASS_TYPE_SPIRIT_SHAMAN)iLevel = GetSpiritShamanTRUECasterlevel(oPC);
	else if (iClass == CLASS_TYPE_WIZARD)iLevel = GetWizardTRUECasterlevel(oPC);
	else if (iClass == CLASS_TYPE_SORCERER)iLevel = GetSorcererTRUECasterlevel(oPC);
	else if (iClass == CLASS_TYPE_BARD)iLevel =GetBardTRUECasterlevel(oPC);
	else if (iClass == CLASS_TYPE_DRUID)iLevel = GetDruidTRUECasterlevel(oPC);
	else if (iClass == CLASS_TYPE_FAVORED_SOUL)iLevel =GetFavoredSoulTRUECasterlevel(oPC);
	else if (iClass == CLASS_TYPE_WARLOCK)iLevel = GetWarlockCasterLevelBase(oPC);
	else if (iClass == CLASS_TYPE_CLERIC)iLevel = GetClericTRUECasterlevel(oPC);
	
	if(iCasterLevelTrue > iLevel) iLevel = iCasterLevelTrue;
	
	return iLevel;
}

/* 	Used to calculate full caster level for golem masters. Combines all arcane or all divine caster level classes
	for the calculation, and selects whichever number is higher */
int PS_GetGolemCasterLevel(object oPC)
{
	return PS_GetCasterLevel(oPC);
}

int PS_GetEssenceECL(object oPC)
{
	return StringToInt(GetLocalString(PS_GetEssence(oPC), VAR_ECL));

	//if (sECL == "")
	//{
 		//if (GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC) == TRUE)
 		//{	effect eEffect = GetFirstEffect(oPC);
 			//while (GetIsEffectValid(eEffect))
 			//{	if (GetEffectType(eEffect) == EFFECT_TYPE_POLYMORPH) RemoveEffect(oPC, eEffect);
   				//eEffect = GetNextEffect(oPC); }
 		//}
 		
		//object oESS = GetItemPossessedBy(oPC,"ps_essence");
 		//if (GetLocalInt(oESS, "SPECIAL_ECL") == 1)
 		//{	sECL = GetLocalString(oESS, "ECL"); //For old Special Characters
 			//SendMessageToPC(oPC, "This is an old special character."); 	}
 		//else
 		//{	int nRACE = GetSubRace(oPC);
 			//sECL = Get2DAString("racialsubtypes", "LA", nRACE);
 			//SendMessageToPC(oPC, "Initial racial LA: " + sECL);
 			//int nECL = StringToInt(sECL);
 			//int nCLASS;
 			//int nPOSITION = 2;
 			//while (nPOSITION < 5)
 			//{	nCLASS = GetClassByPosition(nPOSITION, oPC);
   				//if (nCLASS == CLASS_TYPE_INVALID) break;
   				//switch (nCLASS)
   				//{	case 78:
   					//case 79:
   					//case 91:
   					//case 92:
   					//case 93: nECL = nECL + 3;		}
   				//nPOSITION = nPOSITION + 1;	}
 			//sECL = IntToString(nECL);		}
 		//SetLocalString(oPC, "NEW_ECL", sECL);
 		//SendMessageToPC(oPC, "Final LA: " + sECL);	}
}


string PS_GetScryStatus(object oPC)
{
	string sStatus = "";
	
	sStatus = GetLocalString(oPC,"SCRY");
	if(sStatus != "")
		return sStatus;
		
	object oEssence = PS_GetEssence(oPC);
	if(GetIsObjectValid(oEssence))
	{	sStatus = GetLocalString(oEssence,"SCRY");
		SetLocalString(oPC,"SCRY",sStatus);
		return sStatus;		}
	
	return "";
}

int PS_GetLevel(object oPC) //get level of PC including ECL
{
//	***New version by Clangeddin**	
	int iHD 	= GetHitDice(oPC);
	int iLA 	= PS_GetEssenceECL(oPC);
	if (iHD <= iLA)
	{	iLA = iHD-1;	} // discount for low levels

	int iRet = iHD + iLA;
	if (iRet < 1) 
	{	iRet = 30;	} // failsafe for bugged characters
	//SendMessageToPC(oPC, "Debug: Adjusted level " + IntToString(iRet));
	return iRet;
}

int PS_GetMaxPartylevel(object oPC) //finds highest level in party (with ECL)
{
	int iMaxlevel = 1;
	int iMemberlevel = 0;
	object oPartyMember = GetFirstFactionMember(oPC, TRUE);
	
    while(GetIsObjectValid(oPartyMember) == TRUE)
    {	iMemberlevel = PS_GetLevel(oPartyMember);
		if(iMemberlevel>iMaxlevel)
			iMaxlevel = iMemberlevel;

        oPartyMember = GetNextFactionMember(oPC, TRUE);		}
	
	return iMaxlevel;
}

int PS_GetNumPC(object oPC) //find the total number of PCs in party
{
	int iCount = 0;
	object oPartyMember = GetFirstFactionMember(oPC, TRUE);
	
    while(GetIsObjectValid(oPartyMember) == TRUE && GetArea(oPC) == GetArea(oPartyMember))
    {	
		if (GetIsPC(oPartyMember)) iCount++;
        oPartyMember = GetNextFactionMember(oPC, TRUE);	    }

	return iCount;
}

float PS_GetAvgPartylevel(object oPC, int iMAX) //Gets modified average level which
{												//only counts the levels of the ones
	float fTotal=0.0;							//in the 5 top range of party
	float fMembers=0.0;
	int iMemberlevel=0;
	
	object oPartyMember = GetFirstFactionMember(oPC, TRUE);
	
    while(GetIsObjectValid(oPartyMember) == TRUE)
    {	iMemberlevel = PS_GetLevel(oPartyMember);
		if(iMemberlevel>=iMAX-MAXPARTYRANGE && GetArea(oPC) == GetArea(oPartyMember))
		{	fMembers += 1.0;
			fTotal += iMemberlevel;		}

        oPartyMember = GetNextFactionMember(oPC, TRUE);		}
	
	if(fMembers==0.0)
	{	return 0.0;		}
	else
	{	return fTotal / fMembers;	}
}

float PS_GetXPModifier(int iECL)
{
	switch (iECL)
	{	case 0: return 1.0;
		case 1: return 0.975;
		case 2: return 0.950;
		case 3: return 0.925;
		case 4: return 0.9;
		default: return 0.9;	}
	return 1.0;
	//return (435000.0-(29500-500*iECL)*iECL)/435000.0;
}

int PS_GetXPForLevel(int iLevel)
{
	int nextlvl = 1000;
	int totalxp = 1;
	int i=0;
	
	for (i = 1; i < iLevel; i++) 
	{	totalxp += nextlvl;
	 	nextlvl = nextlvl + 1000;	}
	
	return totalxp;
}

string PS_GetCharID(object oPC)
{
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
    if(GetIsObjectValid(oItem))
    {	return IntToString(GetLocalInt(oPC,"ID"));	}
	return "0";
}

int GetTime()
{
    return GetTimeSecond()+60*GetTimeMinute()+3600*GetTimeHour();
}

void TimeStamp(object oObject=OBJECT_SELF, string sTimeStampVariable = "")
{
	if (sTimeStampVariable == "") 
		sTimeStampVariable = GetTag(oObject)+"_s";
		
  	SetLocalInt(oObject, sTimeStampVariable, GetTime());
}

int CheckTimeStamp(object oObject=OBJECT_SELF, string sTimeStampVariable = "")
{
  	if (sTimeStampVariable == "") 
		sTimeStampVariable = GetTag(oObject)+"_s";
		
  	int iOld = GetLocalInt(oObject, sTimeStampVariable);
  	int iNew = GetTime();
  
  	if (iNew < iOld) {	
		TimeStamp(oObject,sTimeStampVariable);
		return iNew;	
	} else {	
		return (iNew-iOld);	
	}
}


void DoPsiDeLevelCheck(object oPC)
{
	if (GetLevelByClass(90, oPC) > 0)
	{	int nIlMentalist = GetLevelByClass(100, oPC); 
		int nPsion = GetLevelByClass(90, oPC);
		int nCerebremancer = GetLevelByClass(152, oPC);
		int nPsyKnight = GetLevelByClass(109, oPC);
		int nGemDragon = GetLevelByClass(128, oPC);
		if (nIlMentalist > 1)
		{	nPsion = nPsion + (nIlMentalist - 1);	}
		if (nCerebremancer > 1)
		{	nPsion = nPsion + nCerebremancer;	}
		if (nPsyKnight > 1)
		{ nPsion = nPsion + (nPsyKnight - 1);}
		if (nGemDragon > 1)
		{	nPsion = nPsion + (nGemDragon/2 + 1);	}
		int n9FeatTotal = 0;
		if(GetHasFeat(21331, oPC))
		{	n9FeatTotal++;	}
		if(GetHasFeat(21332, oPC))
		{	n9FeatTotal++;	}
		if(GetHasFeat(21333, oPC))
		{	n9FeatTotal++;	}
		if(GetHasFeat(21335, oPC))
		{	n9FeatTotal++;	}
		if(GetHasFeat(21336, oPC))
		{	n9FeatTotal++;	}
		if(GetHasFeat(21337, oPC))
		{	n9FeatTotal++;	}
		
		if (GetLocalInt(OBJECT_SELF, "METAPSI_AUGMENT") == 1)
		{	SetLocalInt(OBJECT_SELF, "METAPSI_AUGMENT", 0);
			SendMessageToPC(OBJECT_SELF, "Metapsionics Deactivated: Augment Power");	}
		if (GetLocalInt(OBJECT_SELF, "METAPSI_EMPOWER") == 1)
		{	SetLocalInt(OBJECT_SELF, "METAPSI_EMPOWER", 0);
			SendMessageToPC(OBJECT_SELF, "Metapsionics Deactivated: Empower Power");	}
		if (GetLocalInt(OBJECT_SELF, "METAPSI_EXTEND") == 1)
		{	SetLocalInt(OBJECT_SELF, "METAPSI_EXTEND", 0);
			SendMessageToPC(OBJECT_SELF, "Metapsionics Deactivated: Extend Power");		}
		if (GetLocalInt(OBJECT_SELF, "METAPSI_MAXIMIZE") == 1)
		{	SetLocalInt(OBJECT_SELF, "METAPSI_MAXIMIZE", 0);	
			SendMessageToPC(OBJECT_SELF, "Metapsionics Deactivated: Maximize Power");	}
		if (GetLocalInt(OBJECT_SELF, "METAPSI_TWIN") == 1)
		{	SetLocalInt(OBJECT_SELF, "METAPSI_TWIN", 0);
			SendMessageToPC(OBJECT_SELF, "Metapsionics Deactivated: Twin Power");		}
			
		//Manifesting Tier Tracking Feats
		if (GetHasFeat(21433, oPC) && nPsion < 17)
		{
			FeatRemove(oPC, 21433);
		}
		if (GetHasFeat(21432, oPC) && nPsion < 15)
		{
			FeatRemove(oPC, 21432);
		}
		if (GetHasFeat(21431, oPC) && nPsion < 13)
		{
			FeatRemove(oPC, 21431);
		}
		if (GetHasFeat(21430, oPC) && nPsion < 11)
		{
			FeatRemove(oPC, 21430);
		}
		if (GetHasFeat(21429, oPC) && nPsion < 9)
		{
			FeatRemove(oPC, 21429);
		}
		if (GetHasFeat(21428, oPC) && nPsion < 7)
		{
			FeatRemove(oPC, 21428);
		}
		if (GetHasFeat(21427, oPC) && nPsion < 5)
		{
			FeatRemove(oPC, 21427);
		}
		if (GetHasFeat(21426, oPC) && nPsion < 3)
		{
			FeatRemove(oPC, 21426);
		}
		if (GetHasFeat(21425, oPC) && nPsion < 1)
		{
			FeatRemove(oPC, 21425);
		}	
			
		switch (nPsion)
		{	case 1:
			{	if (GetHasFeat(20998, oPC) && !GetHasFeat(21409, oPC))
				{	int nPowerProg = FeatAdd(oPC, 21409, TRUE, TRUE, FALSE);
						nPowerProg = TRUE;	}
				else
				{	return;	}
					break;	}
			case 2: case 3:
			{	if (GetHasFeat(20998, oPC) && !GetHasFeat(21395, oPC))
				{	int nPowerProg = FeatAdd(oPC, 21395, TRUE, TRUE, FALSE);
						nPowerProg = TRUE;	}
				else
				{	return;	}
					break;	}
			case 4: case 5:
			{	if (GetHasFeat(20998, oPC) && !GetHasFeat(21396, oPC))
				{	int nPowerProg = FeatAdd(oPC, 21396, TRUE, TRUE, FALSE);
						nPowerProg = TRUE;	}
				else
				{	return;	}
					break;	}
			case 6: case 7:
			{	if (GetHasFeat(20998, oPC) && !GetHasFeat(21397, oPC))
				{	int nPowerProg = FeatAdd(oPC, 21397, TRUE, TRUE, FALSE);
						nPowerProg = TRUE;	}
				else
				{	return;	}
					break;	}
			case 8: case 9:
			{	if (GetHasFeat(20998, oPC) && !GetHasFeat(21398, oPC))
				{	int nPowerProg = FeatAdd(oPC, 21398, TRUE, TRUE, FALSE);
						nPowerProg = TRUE;	}
				else
				{	return;	}
					break;	}
			case 10: case 11:
			{	if (GetHasFeat(20998, oPC) && !GetHasFeat(21399, oPC))
				{	int nPowerProg = FeatAdd(oPC, 21399, TRUE, TRUE, FALSE);
						nPowerProg = TRUE;	}
				else
				{	return;	}
					break;	}
			case 12: case 13:
			{	if (GetHasFeat(20998, oPC) && !GetHasFeat(21400, oPC))
				{	int nPowerProg = FeatAdd(oPC, 21400, TRUE, TRUE, FALSE);
						nPowerProg = TRUE;	}
				else
				{	return;	}
					break;	}
			case 14: case 15:
			{	if (GetHasFeat(20998, oPC) && !GetHasFeat(21401, oPC))
				{	int nPowerProg = FeatAdd(oPC, 21401, TRUE, TRUE, FALSE);
						nPowerProg = TRUE;	}
				else
				{	return;	}
					break;	}
			case 16: case 17: case 18: case 19: case 20:
			{	if (GetHasFeat(20998, oPC) && !GetHasFeat(21402, oPC) && n9FeatTotal != 4)
				{	int nPowerProg = FeatAdd(oPC, 21402, TRUE, TRUE, FALSE);
						nPowerProg = TRUE;	}
				else
				{	return;	}
					break;	}
}	}	}

const int PROB_DEFENDER    	= 13;
const int PROB_AMBUSHER     = 13;
const int PROB_ARCHER       = 0; // just doesn't really do anything if the monster isn't an archer to begin with
const int PROB_BLOCKER      = 13;
const int PROB_MARAUDER      = 13;
const int PROB_FLANKER      = 12;
const int PROB_HOSER        = 12;
const int PROB_SPOTTER      = 12;
const int PROB_FRENZIER     = 12;

const int PROB_UND_RESILIENT = 34;
const int PROB_UND_SPELL = 33;
const int PROB_UND_ROTTER = 33;

const int ANIMAL_RABID = 50;
const int ANIMAL_DIRE = 50;

string GetEliteType (int RacialType)
{
	//finds suitable elite item for monster based on average party level
	string elitetype="defender";

	int nRandom = d100();
	
	if(RacialType == RACIAL_TYPE_UNDEAD)
	{	if (nRandom <= PROB_UND_RESILIENT)
		{	elitetype="resilient";		}
		else if (nRandom <= PROB_UND_RESILIENT + PROB_UND_SPELL)
		{	elitetype="spellstitched";	}
		else if (nRandom <= PROB_UND_RESILIENT + PROB_UND_SPELL + PROB_UND_ROTTER)
		{	elitetype="rotter";			}
	}
	else if(RacialType == RACIAL_TYPE_ANIMAL || RacialType == RACIAL_TYPE_MAGICAL_BEAST || RacialType == RACIAL_TYPE_BEAST || RacialType == RACIAL_TYPE_VERMIN)
	{	if (nRandom <= ANIMAL_RABID)
		{	elitetype="rabid";			}
		else if (nRandom <= ANIMAL_RABID + ANIMAL_DIRE)
		{	elitetype="dire";			}
	}
	else
	{	if (nRandom <= PROB_DEFENDER)
		{	elitetype="defender";	}
		else if (nRandom <= PROB_DEFENDER + PROB_AMBUSHER)
		{	elitetype="ambusher";	}
		else if (nRandom <= PROB_DEFENDER + PROB_AMBUSHER + PROB_ARCHER)
		{	elitetype="archer";		}
		else if (nRandom <= PROB_DEFENDER + PROB_AMBUSHER + PROB_ARCHER + PROB_BLOCKER)
		{	elitetype="blocker";	}
		else if (nRandom <= PROB_DEFENDER + PROB_AMBUSHER + PROB_ARCHER + PROB_BLOCKER + PROB_MARAUDER)
		{	elitetype="marauder";	}
		else if (nRandom <= PROB_DEFENDER + PROB_AMBUSHER + PROB_ARCHER + PROB_BLOCKER + PROB_MARAUDER + PROB_FLANKER)
		{	elitetype="flanker";	}
		else if (nRandom <= PROB_DEFENDER + PROB_AMBUSHER + PROB_ARCHER + PROB_BLOCKER + PROB_MARAUDER + PROB_FLANKER + PROB_HOSER)
		{	elitetype="hoser";		}
		else if (nRandom <= PROB_DEFENDER + PROB_AMBUSHER + PROB_ARCHER + PROB_BLOCKER + PROB_MARAUDER + PROB_FLANKER + PROB_HOSER + PROB_SPOTTER)
		{	elitetype="spotter";	}
		else if (nRandom <= PROB_DEFENDER + PROB_AMBUSHER + PROB_ARCHER + PROB_BLOCKER + PROB_MARAUDER + PROB_FLANKER + PROB_HOSER + PROB_SPOTTER + PROB_FRENZIER)
		{	elitetype="frenzier";	}
	}
		
	return elitetype;
}

string GetEliteLevel (float avg)
{
	//finds suitable elite item for monster based on average party level
	string elitelevel="1";
	if (avg > 20.0)
	{	elitelevel="3";		}
	else if (avg > 13.0)
	{	elitelevel="2";		}
	
	return elitelevel;
}

// for PS_SpellSneakDamageMessage to return formatted coloured text for the sneak damage info
// probably got some of these colours wrong...
string PS_ConvertDamageTypeToString(int iDamageType)
{
	if (iDamageType == DAMAGE_TYPE_BLUDGEONING) return "<COLOR=AntiqueWhite>Bludgeoning</COLOR>";
	else if (iDamageType == DAMAGE_TYPE_PIERCING) return  "<COLOR=AntiqueWhite>AntiqueWhite</COLOR>";
	else if (iDamageType == DAMAGE_TYPE_SLASHING) return  "<COLOR=AntiqueWhite>AntiqueWhite</COLOR>";
	else if (iDamageType == DAMAGE_TYPE_MAGICAL) return "<COLOR=DarkMagenta>Magical</COLOR>";
	else if (iDamageType == DAMAGE_TYPE_ACID) return "<COLOR=Lime>Acid</COLOR>";
	else if (iDamageType == DAMAGE_TYPE_COLD) return "<COLOR=Cyan>Cold</COLOR>";
	else if (iDamageType == DAMAGE_TYPE_DIVINE) return "<COLOR=Yellow>Divine</COLOR>";
	else if (iDamageType == DAMAGE_TYPE_ELECTRICAL) return "<COLOR=Blue>Electrical</COLOR>";
	else if (iDamageType == DAMAGE_TYPE_FIRE) return "<COLOR=Red>Fire</COLOR>";
	else if (iDamageType == DAMAGE_TYPE_NEGATIVE) return "<COLOR=Gray>Negative</COLOR>";
	else if (iDamageType == DAMAGE_TYPE_POSITIVE) return "<COLOR=White>Positive</COLOR>";
	else if (iDamageType == DAMAGE_TYPE_SONIC) return "<COLOR=Orange>Sonic</COLOR>";
	else return "<COLOR=GreenYellow>Unknown</COLOR>";
}

// reports how much damage is going to be applied to target if a spell based sneak attack
// only for use in spell scripts
void PS_SpellSneakDamageMessage(object oPC, object oTarget, int iDamageType, int iDamage)
{
	SendMessageToPC(oPC, "Sucessful spell based sneak attack adds " + IntToString(iDamage) + " points of " + PS_ConvertDamageTypeToString(iDamageType) + " damage to the spell.");
	FloatingTextStringOnCreature("Sneak Attack!!!", oPC, FALSE);
}

// For use by PS_Do_Sneak_Damage. Takes the int value of damage type and returns the int value of the corresponding save type.
// used specifically for Death Attack Fort Save.
int PS_ConvertDamageTypeToSaveType(int iDamageType)
{
	if (iDamageType == DAMAGE_TYPE_BLUDGEONING) return SAVING_THROW_TYPE_NONE;
	else if (iDamageType == DAMAGE_TYPE_PIERCING) return  SAVING_THROW_TYPE_NONE;
	else if (iDamageType == DAMAGE_TYPE_SLASHING) return  SAVING_THROW_TYPE_NONE;
	else if (iDamageType == DAMAGE_TYPE_MAGICAL) return SAVING_THROW_TYPE_NONE;
	else if (iDamageType == DAMAGE_TYPE_ACID) return SAVING_THROW_TYPE_ACID;
	else if (iDamageType == DAMAGE_TYPE_COLD) return SAVING_THROW_TYPE_COLD;
	else if (iDamageType == DAMAGE_TYPE_DIVINE) return SAVING_THROW_TYPE_DIVINE;
	else if (iDamageType == DAMAGE_TYPE_ELECTRICAL) return SAVING_THROW_TYPE_ELECTRICITY;
	else if (iDamageType == DAMAGE_TYPE_FIRE) return SAVING_THROW_TYPE_FIRE;
	else if (iDamageType == DAMAGE_TYPE_NEGATIVE) return SAVING_THROW_TYPE_NEGATIVE;
	else if (iDamageType == DAMAGE_TYPE_POSITIVE) return SAVING_THROW_TYPE_POSITIVE;
	else if (iDamageType == DAMAGE_TYPE_SONIC) return SAVING_THROW_TYPE_SONIC;
	else return SAVING_THROW_TYPE_NONE;
}

// oPC is used to calculate how much sneak damage the do and whether they have Epic precision, oTarget is used to check the target for immunity and to apply damage to
// iDamageType is to determine what type of damage to apply, eg Ray of Frost should have DAMAGE_TYPE_COLD
// Note, immunities and resistances to the damage type still apply
// Invisible blade gets 1d6 per level of bleeding wounds instead
int PS_CalcSneakDamage(object oPC, object oTarget, int iDamageType)
{
	int iTargetImmune = FALSE;
	int iCasterHasEpicPrec = FALSE;
	int iTargetIsSneakable = FALSE;
	int iSneakDamage = 0;
	int iSpellID = GetSpellId();
	object oItem = GetItemPossessedBy(oPC,"ps_essence");

	if (GetIsObjectValid(GetSpellCastItem()))
	{
		//SendMessageToPC(oPC, "Sneak not allowed from objects"); // fall out with zero because from an item (or possibly feat)
	}
	else if (iSpellID == SPELL_I_HIDEOUS_BLOW || iSpellID == SPELL_I_ELDRITCH_CHAIN || 
		iSpellID == SPELL_I_ELDRITCH_CONE || iSpellID == SPELL_I_ELDRITCH_DOOM ||
		iSpellID == 931)
	{
		//SendMessageToPC(oPC, "<COLOR=RED>DEBUG: Blast shapes (except spear) and hideous blow cannot sneak"); 
	}
	else if (GetDistanceToObject(oTarget) > 9.2) // just a little over 30 foot - out of range for sneak attack	
	{
		//SendMessageToPC(oPC, "<COLOR=RED>DEBUG: Target is too far away to sneak"); // fall out with zero because too far
	}
	else
	{
		// messy, but it will work
		int iLevelsAT = GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, oPC);
		int iLevelsAss = GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC) + GetLevelByClass(41, oPC);
		int iLevelsBG = GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC);
		int iLevelsRogue = GetLevelByClass(CLASS_TYPE_ROGUE, oPC);
		int iLevelsSToA = GetLevelByClass(CLASS_TYPE_SHADOWTHIEFOFAMN, oPC);
		int iLevelsNW9 = GetLevelByClass(CLASS_NWNINE_WARDER, oPC);
		int iLevelsIB = GetLevelByClass(CLASS_TYPE_INVISIBLE_BLADE, oPC);
		int iLevelsVL = GetLevelByClass(CLASS_TYPE_VAMPIRE_LUP_PRC, oPC);
		int iLevelsMC = GetLevelByClass(CLASS_TYPE_MARQUIS_CAMBION, oPC);
		int iLevelsLrat;
		if (GetHasFeat(2593, oPC))
		{	iLevelsLrat = GetLevelByClass(CLASS_TYPE_LYCAN_PRC, oPC);	}
	
		if (iLevelsAT || iLevelsAss || iLevelsBG || iLevelsRogue || iLevelsSToA || iLevelsNW9 || iLevelsIB || iLevelsVL || iLevelsMC || iLevelsLrat)
		{
			//SendMessageToPC(oPC, "<COLOR=RED>DEBUG: Has levels in appropriate class");
			// now we need to check if target is immune to sneak damage, and whether the caster has epic preceision
			if (GetIsImmune(oTarget, IMMUNITY_TYPE_SNEAK_ATTACK) || GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT))
			{	iTargetImmune = TRUE;
				//SendMessageToPC(oPC, "<COLOR+RED>DEBUG: Target is immune to sneak");
				// so immune, so need to check for Epic Prec - feat number 2128
				if (GetHasFeat(2128, oPC))
				{	//SendMessageToPC(oPC, "<COLOR+RED>DEBUG: But we have epic precision, so sneak damage will be halved");
					iCasterHasEpicPrec = TRUE;		}
			}
			
			if (iTargetImmune == FALSE || (iTargetImmune == TRUE && iCasterHasEpicPrec == TRUE))
			{	// now we check for status effects and other conditions as to whether the target can be sneak attacked
				if (GetHasFeatEffect(FEAT_KNOCKDOWN, oTarget) || GetHasFeatEffect(FEAT_IMPROVED_KNOCKDOWN, oTarget) || GetHasSpellEffect(SPELL_I_BESHADOWED_BLAST, oTarget)) 
				{	// GetHasFeatEffect is not working as expected
					iTargetIsSneakable = TRUE;
					//SendMessageToPC(oPC, "<COLOR+RED>DEBUG: Target is under effect of feint or impromptu sneak attack or beshadowed blast");
				}
				// now we check for status effects
				else
				{	effect eEffect = GetFirstEffect(oTarget);
		   			int iEffectType;
					
					while(GetIsEffectValid(eEffect))
		   			{	iEffectType = GetEffectType(eEffect);
		      			if (iEffectType == EFFECT_TYPE_STUNNED || iEffectType == EFFECT_TYPE_SLEEP
							|| iEffectType == EFFECT_TYPE_PARALYZE || iEffectType == EFFECT_TYPE_BLINDNESS)
						{	iTargetIsSneakable = TRUE;
							//SendMessageToPC(oPC, "<COLOR=RED>Target is under an effect that allows sneak");	
						}
		      			eEffect = GetNextEffect(oTarget);
					}
				}
				//SendMessageToPC(oPC, "<COLOR=RED>Checked for status effect passed, target is sneakable? " + IntToString(iTargetIsSneakable));
			
				if (iTargetIsSneakable == FALSE) // so its not under an effect, so we need to see if we can backstab.
				{	// now check for if attacker is in a flanking position
					vector vPC = GetPosition(oPC);
					vector vTarget = GetPosition(oTarget);
					vector vPCtoTarget = vPC - vTarget;
					float fAngleOfVector = VectorToAngle(vPCtoTarget);
					float fTargetFacing = GetFacing(oTarget);
					float fAngleToPC = fAngleOfVector - fTargetFacing;
					//SendMessageToPC(oPC, "<COLOR=RED>DEBUG: You are " + FloatToString(fAngleToPC, 18, 1) + " degrees from target facing");
					
					if (fAngleToPC > 90.0 && fAngleToPC < 270.0 || fAngleToPC < -90.0 && fAngleToPC >= -270.0)
					{	iTargetIsSneakable = TRUE;
						//SendMessageToPC(oPC, "<COLOR=RED>Target is attacked from flank");
					}
					//else
					//	SendMessageToPC(oPC, "<COLOR=RED>Target is NOT flanked");
				}
		
				// now check for if attacker is not percieved (eg: invisible or stealthed)
				// this is the last condition we should check as if we check before the angle the stupid perception routine can think the target
				// can actually see them, even with their back turned.
				if (iTargetIsSneakable == FALSE)
				{	int iIsSeen = GetObjectSeen(oPC, oTarget);
					//SendMessageToPC(oPC, "<COLOR=RED>DEBUG: Target can see PC? " + IntToString(iIsSeen));
					if (iIsSeen == FALSE)
					{	iTargetIsSneakable = TRUE;	}
				}
				
				// now we can calculate damage
				if (iTargetIsSneakable == TRUE)
				{	//SendMessageToPC(oPC, "<COLOR=RED>DEBUG: A sneak attack is going to be made, calculating damage");
					int iSneakDie = 0;
					// calc to determine how many sneak die should be applied
					// we will use class levels where possible (ie: except for Imp Sneak Attack) as quicker and easier, although then possible problem if we ever change sneak progression
					
					// Rogue calc - need to check if non-zero to avoid divide by zero error.
					if (iLevelsRogue) iSneakDie += (iLevelsRogue / 2) + 1; // so 1 = 1, 2 = 1, 3 = 2, etc.
					// Ass calc
					if (iLevelsAss)
					{	iSneakDie += (iLevelsAss / 2) + 1;
						// and let's see if Death Attack applies
						if (iTargetImmune == 0 && GetIsInCombat(oTarget) == 0) //Death attack paralysis doesn't work against immunes, even with epic prec. Also creature can't be in combat
						{	//SendMessageToPC(oPC, "<COLOR=RED>Debug: Trying to make a death attack");
							int iDC = 10 + iLevelsAss + GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
							if (FortitudeSave(oTarget, iDC, PS_ConvertDamageTypeToSaveType(iDamageType)) == SAVING_THROW_CHECK_FAILED)
							{	//SendMessageToPC(oPC, "<COLOR=RED>Debug: Target failed save, applying paralysis effect");
								effect eParal = EffectParalyze(iDC, SAVING_THROW_FORT);
								effect eHit = EffectVisualEffect( VFX_DUR_SPELL_HOLD_MONSTER );
								eParal = EffectLinkEffects( eParal, eHit );
								ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParal, oTarget, RoundsToSeconds(d6(1) + iLevelsAss));
							}
							/*else
							{
								SendMessageToPC(oPC, "<COLOR=RED>Debug: Target succeeding in making Fort save");
							}*/
						}
						/*else
						{
							SendMessageToPC(oPC, "<COLOR=RED>Debug: Target is either immune to sneak or is in combat, so can't apply death attack paralysis");
						}*/
					}
					// AT calc
					if (iLevelsAT) iSneakDie += (iLevelsAT / 2) + 1;
					// BG calc
					if (iLevelsBG == 10) iSneakDie += 3;
					else if (iLevelsBG >= 7) iSneakDie += 2;
					else if (iLevelsBG >= 4) iSneakDie += 1;
					// SToA calc
					if (iLevelsSToA) iSneakDie += (iLevelsSToA / 2) + 1;
					// IB calc
					if (iLevelsIB) iSneakDie += (iLevelsIB / 2) + 1;
					// NW9 calc
					if (iLevelsNW9 >= 3) iSneakDie += 2;
					// Marquis Cambion calc
					if (iLevelsMC == 6) iSneakDie += 3;
					else if (iLevelsMC >= 4) iSneakDie += 2;
					else if (iLevelsMC >= 4) iSneakDie += 1;
					// Vampire Lupus calc
					if (iLevelsVL >= 6) iSneakDie += 3;
					else if (iLevelsVL >= 4) iSneakDie += 2;
					else if (iLevelsVL >= 2) iSneakDie += 1;
					// Lycan Wererat calc
					if (iLevelsLrat >= 1 && GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC))
					{	iSneakDie += 2;	}
					else if (iLevelsLrat >= 1 && GetLocalInt(oItem, "Hybrid") == 1)
					{	iSneakDie += 2;	}
					
					// and now for improved sneak attack - feats 834 to 843.
					if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_10, oPC)) iSneakDie += 10;
					else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_9, oPC)) iSneakDie += 9;
					else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_8, oPC)) iSneakDie += 8;
					else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_7, oPC)) iSneakDie += 7;
					else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_6, oPC)) iSneakDie += 6;
					else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_5, oPC)) iSneakDie += 5;
					else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_4, oPC)) iSneakDie += 4;
					else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_3, oPC)) iSneakDie += 3;
					else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_2, oPC)) iSneakDie += 2;
					else if (GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_1, oPC)) iSneakDie += 1;
		
					// now calc and apply
					iSneakDamage = d6(iSneakDie);
					
					// iCasterHasEpicPrec is only true if the target is immune, so no worries about accidentally halving
					if (iCasterHasEpicPrec == TRUE) iSneakDamage = iSneakDamage / 2;
				}
			}
		}
	}
	return iSneakDamage;
}

// This is the wrapper function for adding sneak damage to spells
// Only use this function for spells unless for some reason you don't want
// to report the sneak damage separately or for some reason need to call separately.
int PS_AddSneakDmgToSpell(object oCaster, object oTarget, int iDamageType)
{
	int iSneakDmg = PS_CalcSneakDamage(oCaster, oTarget, iDamageType);
	
	if (iSneakDmg != 0)
	{	PS_SpellSneakDamageMessage(oCaster, oTarget, iDamageType, iSneakDmg);	}

	return iSneakDmg;
}

// replaces special formatting as old ReplaceAllSubStrings doesnt seen to be working.
// replaces square brackets [] with < and > and $ with new line.
string ParseTellDescription(string sDesc)
{
	string sCRLF = GetStringByStrRef(16777631);
	string sNewDesc;
	string sTemp;
	int iCountMax = GetStringLength(sDesc);
	int iCount;
	
	for(iCount = 0; iCount < iCountMax; iCount++)
	{	sTemp = GetSubString(sDesc, iCount, 1);
		
		if (sTemp == "[") sNewDesc += "<";
		else if (sTemp == "]") sNewDesc += ">";
		else if (sTemp == "$") sNewDesc += sCRLF;
		else sNewDesc += sTemp;		}
	
	return sNewDesc;
}

// returns the critical multiplier of a weapon
// if bCheckWM is true it checks to see if the wielder (or posessor) has the associated weapon master feat for that weapon and increased multiplier and increases the return value by 1.
// if item passed is not a weapon or on any error it will return zero
int GetWeaponCriticalMultiplier(object oWeapon, int bCheckWM=FALSE)
{
	object oPC;
	
	if (GetWeaponType(oWeapon) == WEAPON_TYPE_NONE)
	{	return 0;	}
	else
	{	oPC = GetItemPossessor(oWeapon);
		int iWoCFeat;
		// get the crit value first
		int iRow = GetBaseItemType(oWeapon);
	
		int iMulti = StringToInt(Get2DAString("baseitems", "CritHitMult", iRow));
		
		if (GetLevelByClass(CLASS_TYPE_WEAPON_MASTER, oPC) > 4)
		{	// Let's see if the weapon is of the same type as their WM feat.
			switch (iRow)
			{	case BASE_ITEM_BASTARDSWORD: iWoCFeat = FEAT_WEAPON_OF_CHOICE_BASTARDSWORD;
				case BASE_ITEM_BATTLEAXE: iWoCFeat = FEAT_WEAPON_OF_CHOICE_BATTLEAXE;
				case BASE_ITEM_CLUB: iWoCFeat = FEAT_WEAPON_OF_CHOICE_CLUB;
				case BASE_ITEM_DAGGER: iWoCFeat = FEAT_WEAPON_OF_CHOICE_DAGGER;
				case BASE_ITEM_DIREMACE: iWoCFeat = FEAT_WEAPON_OF_CHOICE_DIREMACE;
				case BASE_ITEM_DOUBLEAXE: iWoCFeat =FEAT_WEAPON_OF_CHOICE_DOUBLEAXE; 
				case BASE_ITEM_DWARVENWARAXE: iWoCFeat = FEAT_WEAPON_OF_CHOICE_DWAXE;
				case BASE_ITEM_FALCHION: iWoCFeat = 1596;
				case BASE_ITEM_FLAIL: iWoCFeat = FEAT_WEAPON_OF_CHOICE_HEAVYFLAIL;
				case BASE_ITEM_GREATAXE: iWoCFeat = FEAT_WEAPON_OF_CHOICE_GREATAXE;
				case BASE_ITEM_GREATSWORD: iWoCFeat = FEAT_WEAPON_OF_CHOICE_GREATSWORD;
				case BASE_ITEM_HALBERD: iWoCFeat = FEAT_WEAPON_OF_CHOICE_HALBERD;
				case BASE_ITEM_HANDAXE: iWoCFeat = FEAT_WEAPON_OF_CHOICE_HANDAXE;
				case BASE_ITEM_HEAVYFLAIL: iWoCFeat = FEAT_WEAPON_OF_CHOICE_HEAVYFLAIL;
				case BASE_ITEM_KAMA: iWoCFeat = FEAT_WEAPON_OF_CHOICE_KAMA;
				case BASE_ITEM_KATANA: iWoCFeat = FEAT_WEAPON_OF_CHOICE_KATANA;
				case BASE_ITEM_KUKRI: iWoCFeat = FEAT_WEAPON_OF_CHOICE_KUKRI;
				case BASE_ITEM_LIGHTFLAIL: iWoCFeat = FEAT_WEAPON_OF_CHOICE_LIGHTFLAIL;
				case BASE_ITEM_LIGHTHAMMER: iWoCFeat = FEAT_WEAPON_OF_CHOICE_LIGHTHAMMER;
				case BASE_ITEM_LIGHTMACE: iWoCFeat = FEAT_WEAPON_OF_CHOICE_LIGHTMACE;
				case BASE_ITEM_LONGSWORD: iWoCFeat = FEAT_WEAPON_OF_CHOICE_LONGSWORD;
				case BASE_ITEM_MACE: iWoCFeat = FEAT_WEAPON_OF_CHOICE_LIGHTMACE;
				case BASE_ITEM_MORNINGSTAR: iWoCFeat = FEAT_WEAPON_OF_CHOICE_MORNINGSTAR;
				case BASE_ITEM_QUARTERSTAFF: iWoCFeat = FEAT_WEAPON_OF_CHOICE_QUARTERSTAFF;
				case BASE_ITEM_RAPIER: iWoCFeat = FEAT_WEAPON_OF_CHOICE_RAPIER;
				case BASE_ITEM_SCIMITAR: iWoCFeat = FEAT_WEAPON_OF_CHOICE_SCIMITAR;
				case BASE_ITEM_SCYTHE: iWoCFeat = FEAT_WEAPON_OF_CHOICE_SCYTHE;
				case BASE_ITEM_SHORTSPEAR: iWoCFeat = FEAT_WEAPON_OF_CHOICE_SHORTSPEAR;
				case BASE_ITEM_SHORTSWORD: iWoCFeat = FEAT_WEAPON_OF_CHOICE_SHORTSWORD;
				case BASE_ITEM_SICKLE: iWoCFeat = FEAT_WEAPON_OF_CHOICE_SICKLE;
				case BASE_ITEM_SPEAR: iWoCFeat = FEAT_WEAPON_OF_CHOICE_SHORTSPEAR;
				case BASE_ITEM_WARHAMMER: iWoCFeat = FEAT_WEAPON_OF_CHOICE_WARHAMMER;
				case BASE_ITEM_WARMACE: iWoCFeat = 1828;
						
				default: iWoCFeat = 0; // zero is Alertness feat so no possible problem with conflict here.
			}
			if (GetHasFeat(iWoCFeat, oPC) == TRUE)
			{	iMulti++;	}
		}
		return iMulti;
	}
}

int PS_IsObjectImmuneToSpell(object Target, int SpellId)
{
	int Refs;

	//
	// Enumerate effects on the object to check for immunity to the spell and
	// return TRUE if one is found.  First check the internal immunity list as
	// item properties do not result in script enumerable effects being created.
	//

	Refs = GetLocalInt(Target, "SIM_" + IntToString(SpellId));

//	WriteTimestampedLogEntry("PS_IsObjectImmuneToSpell: Spell " + IntToString(SpellId) + " immunity refs: " + IntToString(Refs));

	if (Refs > 0)
	{
		return TRUE;
	}

	effect e = GetFirstEffect(Target);
	while (GetIsEffectValid(e))
	{
		if (GetEffectType(e) == EFFECT_TYPE_SPELL_IMMUNITY)
		{
			if (GetEffectInteger(e, 0) == SpellId)
			{
				return TRUE;
			}
		}

		e = GetNextEffect(Target);
	}

	return FALSE;
}

void PS_InitializeItemImmunityLookup()
{
	object Module = GetModule();

	//
	// Generate a lookup table that maps spell immunity ite mproperty constants
	// to spell IDs so that the 2DA does not need to be referenced (slowly).
	//
	// IPI_<ImmunityConstantValue> maps to spell ID.
	//
	// Note that it is assumed that no items exist with invalid references to
	// immunity constants (out of range in the 2DA) as these would be treated as
	// spell 0, "Acid Fog".  This could be accommodated at the cost of more work
	// done in the primary lookup path.
	//

	int ImmunityValue = 0;
	do
	{
		string SpellIndexValue;
		
		SpellIndexValue = Get2DAString("iprp_spellcost", "SpellIndex", ImmunityValue);

		if (GetStringLength(SpellIndexValue) > 1)
		{
			SetLocalInt(Module, "IPI_" + IntToString(ImmunityValue), StringToInt(SpellIndexValue));
		}
		else if (GetStringLength(Get2DAString("iprp_spellcost", "Label", ImmunityValue)) < 1)
		{
			//
			// Only terminate the search once an empty Label is found as there
			// are deleted rows that would result in a premature termination.
			//

			break;
		}

		ImmunityValue += 1;
	} while (TRUE);
}

int PS_GetSpellIdFromImmunityValue(int ImmunityValue, object Module)
{
	return GetLocalInt(Module, "IPI_" + IntToString(ImmunityValue));
}

void PS_ManageItemImmunities(object oItem, object EquippedTo, int Equipping)
{
	object Module = GetModule();
	itemproperty ip = GetFirstItemProperty(oItem);
	int RefDelta = (Equipping ? 1 : -1);

	//
	// Sweep through item properties on the item and record in a local on the
	// object which spell immunities it actually has.  These are unfortunately
	// not made visible as a script enumerable effect so a side table must be
	// built to look up from spell scripts.  A reference count of items that
	// have applied the given spell immunity is used so that if two items have
	// the same immunity, unequipping one doesn't kill the immunity prematurely.
	//

	while (GetIsItemPropertyValid(ip) != FALSE)
	{
		if (GetItemPropertyType(ip) == ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL)
		{
			int ImmunityValue;
			int SpellId;
			string SpellImmunityName;
			int RefCount;

			ImmunityValue = GetItemPropertyCostTableValue(ip);
			SpellId = PS_GetSpellIdFromImmunityValue(ImmunityValue, Module);
			SpellImmunityName = "SIM_" + IntToString(SpellId);

			RefCount = GetLocalInt(EquippedTo, SpellImmunityName);
			SetLocalInt(EquippedTo, SpellImmunityName, RefCount + RefDelta);

//			WriteTimestampedLogEntry("PS_ManageItemImmunities: Set " + SpellImmunityName + " from " + IntToString(RefCount) + " to " + IntToString(RefCount + RefDelta));
		}

		ip = GetNextItemProperty(oItem);
	}
}


void SAFE_ApplyEffectToObject(int nSpellId, int nDurationType, effect eEffect, object oTarget, float fDuration=0.0f) 
{
	if (GetHasSpellEffect(nSpellId,oTarget))
	{
		return;
	}	
	else
	{
		ApplyEffectToObject(nDurationType, eEffect, oTarget, fDuration);
	}
}

int PS_GetPCFlags(object PCObject)
{
	object OwnedCharacter = GetOwnedCharacter(PCObject);

	if (OwnedCharacter != OBJECT_INVALID)
	{
		PCObject = OwnedCharacter;
	}

	//
	// Just read the flags directly from the value cached on the PC object.
	//

	return GetLocalInt(PCObject, PS_PC_FLAGS_VAR);
}

void PS_SetPCFlags(object PCObject, int PCFlags)
{
	object EssenceItem;
	object OwnedCharacter = GetOwnedCharacter(PCObject);

	if (OwnedCharacter != OBJECT_INVALID)
	{
		PCObject = OwnedCharacter;
	}

	//
	// Update the cached flags on the PC object and the persistent flags on the
	// essence item.
	//

	if (PCFlags != 0)
	{
		SetLocalInt(PCObject, PS_PC_FLAGS_VAR, PCFlags);
	}
	else
	{
		DeleteLocalInt(PCObject, PS_PC_FLAGS_VAR);
	}

	EssenceItem = GetItemPossessedBy(PCObject, "ps_essence");
	if (EssenceItem != OBJECT_INVALID)
	{
		if (PCFlags != 0)
		{
			SetLocalInt(EssenceItem, PS_PC_FLAGS_VAR, PCFlags);
		}
		else
		{
			DeleteLocalInt(EssenceItem, PS_PC_FLAGS_VAR);
		}
	}
}

int PS_TogglePlayerChatColoring(object PCObject)
{
	//
	// Compute new PC flags and return previous PC flags state.
	//

	int PCFlags = PS_GetPCFlags(PCObject) ^ PS_PC_FLAG_COLOR_EMOTES;
	int PreviouslyEnabled = (PCFlags & PS_PC_FLAG_COLOR_EMOTES) ? FALSE : TRUE;

	PS_SetPCFlags(PCObject, PCFlags);

	if (PreviouslyEnabled == FALSE)
	{
		SendMessageToPC(PCObject, PS_ColorizeChatMessage("Chat (( OOC )) and * emote * text coloring enabled."));
	}
	else
	{
		SendMessageToPC(PCObject, "Chat (( OOC )) and * emote * text coloring disabled.");
	}

	return PreviouslyEnabled;
}

void PS_LoadEssenceState(object PCObject, object EssenceItem)
{
	PS_CopyIntVar(PCObject, PS_PC_FLAGS_VAR, EssenceItem);
}

void PS_CopyIntVar(object To, string Var, object From)
{
	int Value = GetLocalInt(From, Var);

	if (Value == 0)
	{
		DeleteLocalInt(To, Var);
	}
	else
	{
		SetLocalInt(To, Var, Value);
	}
}

string PS_ExpandStringEnclosures(string Text, string FindOpen, string FindClose, string EncloseOpen, string EncloseClose)
{
	string NewText;
	int Found;
	int FindOpenLen;
	int FindCloseLen;
	int MsgLen;
	int Offset;

	FindOpenLen = GetStringLength(FindOpen);
	FindCloseLen = GetStringLength(FindClose);
	MsgLen = GetStringLength(Text);
	Offset = 0;
	do {
		int Start;
		int End;

		Found = FALSE;
		Start = -1;
		End = -1;

		//
		// Search for an opening and closing instance of "Find".
		//

		Start = FindSubString(Text, FindOpen, Offset);
		if (Start != -1) {
			End = FindSubString(Text, FindClose, Start + FindOpenLen);
		}

//		PrintInteger(Start);
//		PrintInteger(End);

		if (End != -1) {
		
			//
			// Found a string bracketed by a pair of "Find" strings.  Splice in
			// the new text and remember that we need to keep on scanning the
			// rest of the string for more instances.
			//

			Found = TRUE;

			//
			// Append the text before the opening instance of "Find", then the
			// "EncloseOpen" string, then text in between the opening instance of
			// "Find" and the closing instance of "Find", and then the
			// "EncloseClose" string.
			//

			NewText += GetSubString(Text, Offset, Start - Offset);
			NewText += EncloseOpen;
			NewText += GetSubString(Text, Start + FindOpenLen, End - (Start + FindOpenLen));
			NewText += EncloseClose;

			//
			// Continue scanning after the closing instance of "Find".
			//

			Offset = End + FindCloseLen;
		}
		else {

			//
			// There are no more instances to replace in this string, so just copy
			// the remaining part wholesale and consider it done.
			//

			NewText += GetSubString(Text, Offset, MsgLen - Offset);
		}

	} while (Found != FALSE);

	return NewText;
}

string PS_ColorizeChatMessage(string Text)
{
	string ExpandedText;

	ExpandedText = PS_ExpandStringEnclosures(Text, "*", "*", "<C=darkkhaki>*", "*</C>");
	ExpandedText = PS_ExpandStringEnclosures(ExpandedText, "((", "))", "<C=darkseagreen>((", "))</C>");

	return ExpandedText;
}

//For simple uses/day
int GetBardicClassLevelForUses(object oPC)
{
	int nBARD = GetLevelByClass(CLASS_TYPE_BARD, oPC); //FloatToInt(IntToFloat(nBrachina)*0.8f)
	if (GetHasFeat(2481, oPC, TRUE) == TRUE) nBARD = nBARD + (GetLevelByClass(CLASS_TYPE_FIRRE_PRC,oPC));
	if (GetHasFeat(2787, oPC, TRUE) == TRUE) nBARD = nBARD + (FloatToInt(IntToFloat(GetLevelByClass(CLASS_TYPE_BRACHINA, oPC))*0.8f));
	if (GetHasFeat(2678, oPC, TRUE) == TRUE) nBARD = nBARD + (GetLevelByClass(CLASS_TYPE_MONADIC_DEVA_PRC, oPC) / 2);
	if (GetHasFeat(2841, oPC, TRUE) == TRUE) nBARD = nBARD + (GetLevelByClass(CLASS_TYPE_SUCCUBUS_INCUBUS, oPC));
	if (GetHasFeat(2572, oPC, TRUE) == TRUE) nBARD = nBARD + (FloatToInt(IntToFloat(GetLevelByClass(CLASS_TYPE_VAMPIRE_MAL_PRC, oPC))*0.8));
	return nBARD;
}

//For classes that advance songs known
int GetBardicClassLevelForSongs(object oPC)
{	
	int nBARD = GetLevelByClass(CLASS_TYPE_BARD, oPC);
	nBARD = nBARD + GetLevelByClass(CLASS_TYPE_FIRRE_PRC, oPC);
	if (GetHasFeat(2678, oPC, TRUE) == TRUE) nBARD = nBARD + (GetLevelByClass(CLASS_TYPE_MONADIC_DEVA_PRC, oPC) / 2);
	return nBARD;
	if (GetHasFeat(2841, oPC, TRUE) == TRUE) nBARD = nBARD + (GetLevelByClass(CLASS_TYPE_SUCCUBUS_INCUBUS, oPC));
	return nBARD;
}

void StackBardicUses(object oPC)
{
	int nBardicUses =  GetBardicClassLevelForUses(oPC);
	if (GetHasFeat(FEAT_ARTIST, oPC))
		nBardicUses += 3;
	
	if (nBardicUses > 20)
		nBardicUses = 20;
		
	//1 = 257 No need to add 1 use, no bardic prc can be taken without Bard levels
	//2-20 = 355 - 373
	int nMax = nBardicUses - 1 + 355;
	int iFeatCurrent;
	
	if (nMax == 0) return;

	for (iFeatCurrent = 355; iFeatCurrent< nMax; iFeatCurrent++)
	{
		FeatAdd(oPC, iFeatCurrent,FALSE);
	}		
}

void StackBardMusicUses(object oPC)
{

	int nBard = GetLevelByClass(CLASS_TYPE_BARD, oPC);
	int nBardLevel =  GetBardicClassLevelForSongs(oPC);
	
/*
2 - 1467
3 - 1475
5 - 1468
6 - 1476
7 - 1469
8 - 1470
9 - 1477
11 - 1471
12 - 1478
14 - 1472
15 - 1479
18 - 1480	
*/
	
	if (nBardLevel > nBard)
	{
		if (nBardLevel > 17)
		{
			if (!GetHasFeat(1480, oPC, TRUE))
				FeatAdd(oPC, 1480, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1479, oPC, TRUE))
				FeatAdd(oPC, 1479, FALSE, FALSE, FALSE);	
			if (!GetHasFeat(1472, oPC, TRUE))
				FeatAdd(oPC, 1472, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1478, oPC, TRUE))
				FeatAdd(oPC, 1478, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1471, oPC, TRUE))
				FeatAdd(oPC, 1471, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1477, oPC, TRUE))
				FeatAdd(oPC, 1477, FALSE, FALSE, FALSE);														
			if (!GetHasFeat(1470, oPC, TRUE))
				FeatAdd(oPC, 1470, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1469, oPC, TRUE))
				FeatAdd(oPC, 1469, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1476, oPC, TRUE))
				FeatAdd(oPC, 1476, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1468, oPC, TRUE))
				FeatAdd(oPC, 1468, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1475, oPC, TRUE))
				FeatAdd(oPC, 1475, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);																																	
				
		} else
		if (nBardLevel > 14)
		{
			if (!GetHasFeat(1479, oPC, TRUE))
				FeatAdd(oPC, 1479, FALSE, FALSE, FALSE);	
			if (!GetHasFeat(1472, oPC, TRUE))
				FeatAdd(oPC, 1472, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1478, oPC, TRUE))
				FeatAdd(oPC, 1478, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1471, oPC, TRUE))
				FeatAdd(oPC, 1471, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1477, oPC, TRUE))
				FeatAdd(oPC, 1477, FALSE, FALSE, FALSE);														
			if (!GetHasFeat(1470, oPC, TRUE))
				FeatAdd(oPC, 1470, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1469, oPC, TRUE))
				FeatAdd(oPC, 1469, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1476, oPC, TRUE))
				FeatAdd(oPC, 1476, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1468, oPC, TRUE))
				FeatAdd(oPC, 1468, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1475, oPC, TRUE))
				FeatAdd(oPC, 1475, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);	
		} else
		if (nBardLevel > 13)
		{
			if (!GetHasFeat(1472, oPC, TRUE))
				FeatAdd(oPC, 1472, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1478, oPC, TRUE))
				FeatAdd(oPC, 1478, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1471, oPC, TRUE))
				FeatAdd(oPC, 1471, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1477, oPC, TRUE))
				FeatAdd(oPC, 1477, FALSE, FALSE, FALSE);														
			if (!GetHasFeat(1470, oPC, TRUE))
				FeatAdd(oPC, 1470, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1469, oPC, TRUE))
				FeatAdd(oPC, 1469, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1476, oPC, TRUE))
				FeatAdd(oPC, 1476, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1468, oPC, TRUE))
				FeatAdd(oPC, 1468, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1475, oPC, TRUE))
				FeatAdd(oPC, 1475, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);	
		} else		
		if (nBardLevel > 11)
		{
			if (!GetHasFeat(1478, oPC, TRUE))
				FeatAdd(oPC, 1478, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1471, oPC, TRUE))
				FeatAdd(oPC, 1471, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1477, oPC, TRUE))
				FeatAdd(oPC, 1477, FALSE, FALSE, FALSE);														
			if (!GetHasFeat(1470, oPC, TRUE))
				FeatAdd(oPC, 1470, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1469, oPC, TRUE))
				FeatAdd(oPC, 1469, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1476, oPC, TRUE))
				FeatAdd(oPC, 1476, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1468, oPC, TRUE))
				FeatAdd(oPC, 1468, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1475, oPC, TRUE))
				FeatAdd(oPC, 1475, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);	
		} else
		if (nBardLevel > 10)
		{
			if (!GetHasFeat(1471, oPC, TRUE))
				FeatAdd(oPC, 1471, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1477, oPC, TRUE))
				FeatAdd(oPC, 1477, FALSE, FALSE, FALSE);														
			if (!GetHasFeat(1470, oPC, TRUE))
				FeatAdd(oPC, 1470, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1469, oPC, TRUE))
				FeatAdd(oPC, 1469, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1476, oPC, TRUE))
				FeatAdd(oPC, 1476, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1468, oPC, TRUE))
				FeatAdd(oPC, 1468, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1475, oPC, TRUE))
				FeatAdd(oPC, 1475, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);	
		} else
		if (nBardLevel > 8)
		{
			if (!GetHasFeat(1477, oPC, TRUE))
				FeatAdd(oPC, 1477, FALSE, FALSE, FALSE);														
			if (!GetHasFeat(1470, oPC, TRUE))
				FeatAdd(oPC, 1470, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1469, oPC, TRUE))
				FeatAdd(oPC, 1469, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1476, oPC, TRUE))
				FeatAdd(oPC, 1476, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1468, oPC, TRUE))
				FeatAdd(oPC, 1468, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1475, oPC, TRUE))
				FeatAdd(oPC, 1475, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);		
		} else
		if (nBardLevel > 7)
		{
			if (!GetHasFeat(1470, oPC, TRUE))
				FeatAdd(oPC, 1470, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1469, oPC, TRUE))
				FeatAdd(oPC, 1469, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1476, oPC, TRUE))
				FeatAdd(oPC, 1476, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1468, oPC, TRUE))
				FeatAdd(oPC, 1468, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1475, oPC, TRUE))
				FeatAdd(oPC, 1475, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);	
		} else							
		if (nBardLevel > 6)
		{
			if (!GetHasFeat(1469, oPC, TRUE))
				FeatAdd(oPC, 1469, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1476, oPC, TRUE))
				FeatAdd(oPC, 1476, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1468, oPC, TRUE))
				FeatAdd(oPC, 1468, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1475, oPC, TRUE))
				FeatAdd(oPC, 1475, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);	
		} else		
		if (nBardLevel > 5)
		{
			if (!GetHasFeat(1476, oPC, TRUE))
				FeatAdd(oPC, 1476, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1468, oPC, TRUE))
				FeatAdd(oPC, 1468, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1475, oPC, TRUE))
				FeatAdd(oPC, 1475, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);	
		} else		
		if (nBardLevel > 4)
		{
			if (!GetHasFeat(1468, oPC, TRUE))
				FeatAdd(oPC, 1468, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1475, oPC, TRUE))
				FeatAdd(oPC, 1475, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);	
		} else	
		if (nBardLevel > 2)
		{
			if (!GetHasFeat(1475, oPC, TRUE))
				FeatAdd(oPC, 1475, FALSE, FALSE, FALSE);
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);	
		} else	
		if (nBardLevel > 2)
		{
			if (!GetHasFeat(1467, oPC, TRUE))
				FeatAdd(oPC, 1467, FALSE, FALSE, FALSE);	
		}						
	}		

}

// If the PC has been made Undead by a Template class, revert them to their original race if
// they no longer have levels in that template class!
void PS_UndeadRaceFix(object oPC)
{
	object oItem = GetItemPossessedBy(oPC, "ps_essence");
	if (GetIsObjectValid(oItem))
	{
		int nUndead = GetLocalInt(oItem, "IsUndead");
		if (nUndead == 1)
		{
			//int iOldECL	= GetLocalInt(oItem, "OldECL");
			//string sOldECL = IntToString(iOldECL);
			int iOldRace = GetLocalInt(oItem, VAR_OLD_RACE);
			int iOldSub = GetLocalInt(oItem, "OldSubrace");
			int iOldGoodEvil = GetLocalInt(oItem, "OldGoodEvil");
			
			// Fix for Liches and Vampires
			if (GetLocalString(oItem, "Template") == "Lich" || GetLocalString(oItem, "Template") == "Vampire")
			{	int iUndeadLevel = 0;
				if (GetLevelByClass(CLASS_TYPE_LICH_PRC, oPC) > 0 )
				{	iUndeadLevel = GetLevelByClass(CLASS_TYPE_LICH_PRC, oPC);	}
				if (GetLevelByClass(CLASS_TYPE_LICH_D_PRC, oPC) > 0 )
				{	iUndeadLevel = GetLevelByClass(CLASS_TYPE_LICH_D_PRC, oPC);	}
				if (GetLevelByClass(CLASS_TYPE_LICH_W_PRC, oPC) > 0 )
				{	iUndeadLevel = GetLevelByClass(CLASS_TYPE_LICH_W_PRC, oPC);	}
				if (GetLevelByClass(CLASS_TYPE_VAMPIRE_LUP_PRC, oPC) > 0 )
				{	iUndeadLevel = GetLevelByClass(CLASS_TYPE_VAMPIRE_LUP_PRC, oPC);	}
				if (GetLevelByClass(CLASS_TYPE_VAMPIRE_DRA_PRC, oPC) > 0 )
				{	iUndeadLevel = GetLevelByClass(CLASS_TYPE_VAMPIRE_DRA_PRC, oPC);	}
				if (GetLevelByClass(CLASS_TYPE_VAMPIRE_MAL_PRC, oPC) > 0 )
				{	iUndeadLevel = GetLevelByClass(CLASS_TYPE_VAMPIRE_MAL_PRC, oPC);	}
				
				if (iUndeadLevel == 0)
				{	//SetLocalString(oItem, "ECL", sOldECL);
					//SetLocalString(oPC, "ECL", sOldECL);
					PS_SetRacialType(oPC, iOldRace);
					PS_SetSubRacialType(oPC, iOldSub);
					if(iOldGoodEvil >= 31)
					{
						AdjustAlignment(oPC, ALIGNMENT_GOOD, 35);
					}
					DeleteLocalInt(oItem, "OldGoodEvil");
					DeleteLocalString(oItem, "Template");
					DeleteLocalInt(oItem, "IsUndead");
					//DeleteLocalInt(oItem, "OldECL");
					DeleteLocalInt(oItem, VAR_OLD_RACE);
					SetFirstName(oItem, "Your Essence");
					SetItemIcon(oItem, 122);
				}
			}
			// Fix for Death Knights
			if (GetLocalString(oItem, "Template") == "DeathKnight")
			{	int iUndeadLevel = 0;
				if (GetLevelByClass(CLASS_TYPE_DEATH_KNIGHT_PRC, oPC) > 0)
				{	iUndeadLevel = GetLevelByClass(CLASS_TYPE_DEATH_KNIGHT_PRC, oPC);	}
				
				if (iUndeadLevel == 0)					
				{	//SetLocalString(oItem, "ECL", sOldECL);
					//SetLocalString(oPC, "ECL", sOldECL);
					PS_SetRacialType(oPC, iOldRace);
					PS_SetSubRacialType(oPC, iOldSub);
					if(iOldGoodEvil >= 31)
					{
						int iGoodEvil = GetGoodEvilValue(oPC);
						int iGEVar = (iOldGoodEvil - iGoodEvil);
						AdjustAlignment(oPC, ALIGNMENT_GOOD, iGEVar);
					}
					DeleteLocalInt(oItem, "OldGoodEvil");
					DeleteLocalString(oItem, "Template");
					DeleteLocalInt(oItem, "IsUndead");
					//DeleteLocalInt(oItem, "OldECL");
					DeleteLocalInt(oItem, VAR_OLD_RACE);
				}
			}
		}
	ActionRest(0);
	}
}

struct CreatureCoreAppearance PS_RetrieveStoredCreatureCoreAppearance(object ObjectId, string Prefix)
{
    // Retrieve the stored appearance and re-initialize the stored local
    // variables that are removed by PS_ScriptVariableToCreatureCoreAppearance.

    // Then, return the struct-constituted version of the appearance data.
    struct CreatureCoreAppearance Appearance = PS_ScriptVariablesToCreatureCoreAppearance(ObjectId, Prefix);
    PS_CreatureCoreAppearanceToScriptVariables(ObjectId, Prefix, Appearance);
    return Appearance;
}

void PS_RefreshAppearance(object oPC)
{

	ServerExts_RefreshCreatureAppearance(oPC, oPC);
}

void PS_SaveOriginalAppearance(object oPC)
{
	struct CreatureCoreAppearance Appearance = PS_GetCreatureCoreAppearance(oPC); 
	// Set all the masks so that if we reset the appearance, we set everything.
	Appearance.Tint_Mask = PS_CCA_TINT_ALL;
	Appearance.HeadTint_Mask = PS_CCA_TINT_ALL;
	Appearance.HairTint_Mask = PS_CCA_TINT_ALL;
	
	object oEssence = PS_GetEssence(oPC);
	
	PS_CreatureCoreAppearanceToScriptVariables(oEssence, "OriginalApp", Appearance);
	SetLocalInt(oEssence, "TempChange", 0);
	SendMessageToPC(oPC, "Core appearance information saved.");
}

void PS_RestoreOriginalAppearance(object oPC)
{
	object oEssence = PS_GetEssence(oPC);
	struct CreatureCoreAppearance Appearance = PS_RetrieveStoredCreatureCoreAppearance(oEssence, "OriginalApp");
	PS_SetCreatureCoreAppearance(oPC, Appearance);
	SendMessageToPC(oPC, "Original appearance restored");
	ServerExts_RefreshCreatureAppearance(oPC,oPC);
	SetLocalInt(oEssence, "TempChange", 0);
}

void PS_ClassAppearanceDeleveling(object oPC)
{
	object oItem = PS_GetEssence(oPC);
	
	// Add a new entry to this list for each necessary reversion.
	
	if ((GetLocalInt(oItem, "DarkFlight") != 0) && (!GetHasFeat(2781, oPC)))
	{	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
		app.WingVariation = 0;
		PS_SetCreatureCoreAppearance(oPC, app);
		ServerExts_RefreshCreatureAppearance(oPC,oPC);
		DelayCommand(0.1f, DeleteLocalInt(oItem, "DarkFlight"));
		DelayCommand(0.2f, PS_SaveOriginalAppearance(oPC));	}

	if ((GetLocalInt(oItem, "DragonFlight") != 0) && (!GetHasFeat(288, oPC)))
	{	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
		app.WingVariation = 0;
		PS_SetCreatureCoreAppearance(oPC, app);
		ServerExts_RefreshCreatureAppearance(oPC,oPC);
		DelayCommand(0.1f, DeleteLocalInt(oItem, "DragonFlight"));
		DelayCommand(0.2f, PS_SaveOriginalAppearance(oPC));	}
	
	if ((GetLocalInt(oItem, "AltFormSet") != 0) && (!GetHasFeat(2828)))
	{	PS_RestoreOriginalAppearance(oPC);
		DelayCommand(0.1f, DeleteLocalInt(oItem, "AltFormSet"));	}
	
	if ((GetLocalInt(oItem, "UnholyApothesis") != 0) && (!GetHasFeat(2833, oPC)))
	{	struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
		app.WingVariation = 0;
		PS_SetCreatureCoreAppearance(oPC, app);
		ServerExts_RefreshCreatureAppearance(oPC,oPC);
		FeatRemove(oPC, FEAT_LILITUS_GIFT);
		DelayCommand(0.1f, DeleteLocalInt(oItem, "UnholyApothesis"));
		DelayCommand(0.2f, PS_SaveOriginalAppearance(oPC));	}
		
	if ((GetLocalString(oItem, "Template") == "DeathKnight") && (!GetHasFeat(2690)))
	{	int iAppearance = GetLocalInt(oItem, "OldAppearance");
		struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
		app.AppearanceType = iAppearance;
		PS_SetCreatureCoreAppearance(oPC, app);
		ServerExts_RefreshCreatureAppearance(oPC,oPC);
		DelayCommand(0.2f, PS_SaveOriginalAppearance(oPC));		}
		
	if ((GetLocalInt(oItem, "Diminution") != 0) && (!GetHasFeat(4012, oPC)))
	{	int iAppearance = 3411;
		struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oPC);
		app.AppearanceType = iAppearance;
		PS_SetCreatureCoreAppearance(oPC, app);
		ServerExts_RefreshCreatureAppearance(oPC,oPC);
		DelayCommand(0.1f, DeleteLocalInt(oItem, "Diminution"));
		DelayCommand(0.2f, PS_SaveOriginalAppearance(oPC));	}
}

//DEPRECATED: TemplateRacialAdjust already takes care of it.
// Determine the racial bonuses for a ability based upon the character's original subrace.
// Use this ONLY in conjunction with PS_ApplyTemplateClassAbilityFix.
// iAbility values: 0 = Str, 1 = Dex, 2 = Con, 3 = Int, 4 = Wis, 5 = Cha
int GetAbilityOriginalRacialBonus(object oPC, int iAbility)
{
	string sColumn;
	switch (iAbility)
	{
		case ABILITY_STRENGTH: 		sColumn = "StrAdjust"; break;
		case ABILITY_DEXTERITY: 	sColumn = "DexAdjust"; break;
		case ABILITY_CONSTITUTION: 	sColumn = "ConAdjust"; break;
		case ABILITY_INTELLIGENCE: 	sColumn = "IntAdjust"; break;
		case ABILITY_WISDOM: 		sColumn = "WisAdjust"; break;
		case ABILITY_CHARISMA: 		sColumn = "ChaAdjust"; break;
		default: return 0;
	}
	// SendMessageToPC(oPC, "Ability to pull: " + sColumn);
	
	object 	oItem		= GetItemPossessedBy(oPC,"ps_essence");
	int iOldSub			= GetLocalInt(oItem, "OldSubrace");
	string sRacialBonus = Get2DAString("racialsubtypes", sColumn, iOldSub);
	int iRacialBonus	= StringToInt(sRacialBonus);
	// SendMessageToPC(oPC, "Racial bonus: " + sRacialBonus + " to Ability #" + sColumn);
	return iRacialBonus;
}

int PS_NeedsTemplateClassAbilityFix(object oPC)
{
	if (GetLevelByClass(CLASS_TYPE_HALFDRAGON_PRC, oPC) >= 6) return TRUE;
	if (GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC, oPC) >= 6) return TRUE;
	if (GetLevelByClass(CLASS_TYPE_HALFOUTSIDERMAGE_PRC, oPC) >= 7) return TRUE;
	if (GetLevelByClass(CLASS_TYPE_LICH_PRC, oPC) > 0) return TRUE;
	if (GetLevelByClass(CLASS_TYPE_LICH_D_PRC, oPC) > 0) return TRUE;
	if (GetLevelByClass(CLASS_TYPE_LICH_W_PRC, oPC) > 0) return TRUE;
	if (GetLevelByClass(CLASS_TYPE_DEATH_KNIGHT_PRC, oPC) > 0) return TRUE;
	if (GetLevelByClass(CLASS_TYPE_VAMPIRE_LUP_PRC, oPC) > 0) return TRUE;
	if (GetLevelByClass(CLASS_TYPE_VAMPIRE_DRA_PRC, oPC) > 0) return TRUE;
	if (GetLevelByClass(CLASS_TYPE_VAMPIRE_MAL_PRC, oPC) > 0) return TRUE;
	return FALSE;
}

//The new function used for template adjustment, replaces most of the old commands.
void TemplateRacialAdjust(object oPC, object oESSENCE, int nREVERSE)
{
	int nSUBRACE;
	int nVAR = GetLocalInt(oESSENCE, "TemplateFix");
	if (nREVERSE == TRUE)
	{
		if (nVAR != TRUE) return;
		nSUBRACE = GetLocalInt(oESSENCE, "OldSubrace");
		DelayCommand(0.0f, DeleteLocalInt(oESSENCE, "TemplateFix"));
	}
	else
	{
		if (nVAR == TRUE) return;
		nSUBRACE = GetSubRace(oPC);
		SetLocalInt(oESSENCE, "OldSubrace", nSUBRACE);
		SetLocalInt(oESSENCE, "TemplateFix", TRUE);
	}
	string s2DA = "racialsubtypes";
	string sSTAT;
	int nCACHE = GetNum2DARows(s2DA);	
	int nSTAT;
	int nSTAT_AD;
	int nABILITY = ABILITY_STRENGTH;
	while (nABILITY <= ABILITY_CHARISMA)
	{
		switch (nABILITY)
		{
			case ABILITY_STRENGTH: 		sSTAT = "StrAdjust"; break;
			case ABILITY_DEXTERITY: 	sSTAT = "DexAdjust"; break;
			case ABILITY_CONSTITUTION: 	sSTAT = "ConAdjust"; break;
			case ABILITY_INTELLIGENCE: 	sSTAT = "IntAdjust"; break;
			case ABILITY_WISDOM: 		sSTAT = "WisAdjust"; break;
			case ABILITY_CHARISMA: 		sSTAT = "ChaAdjust"; break;
		}
		nSTAT_AD = StringToInt(Get2DAString(s2DA, sSTAT, nSUBRACE));
		if (nSTAT_AD != 0)
		{
			nSTAT = GetAbilityScore(oPC, nABILITY, TRUE);
			if (nREVERSE == TRUE) nSTAT_AD = 0 - nSTAT_AD;
			SetBaseAbilityScore(oPC, nABILITY, nSTAT + nSTAT_AD);
		}
		nABILITY = nABILITY + 1;
	}
}

// Apply racial bonuses to template classes AFTER the class has been taken.
// oPC is the creature (PC) for the fix to apply to; oItem should be the ps_essence item.
// - Ceremorph 4/12/16
void PS_ApplyTemplateClassAbilityFix(object oPC, object oItem)
{
	TemplateRacialAdjust(oPC, oItem, FALSE);

}

// Remove racial bonuses to if the character delevels to no longer have a template class.
// New template class local variables from the essence will need to be added to this script to function.
// oPC is the creature (PC) for the fix to apply to; oItem should be the ps_essence item.
// Do not call this directly! Use 	
// - Ceremorph 4/12/16
void PS_RemoveTemplateClassAbilityFix(object oPC, object oItem)
{
	TemplateRacialAdjust(oPC, oItem, TRUE);

}

void PS_Template_DelevelFix(object oPC, object oItem)
{
	if (PS_NeedsTemplateClassAbilityFix(oPC) == TRUE) return;
	PS_RemoveTemplateClassAbilityFix(oPC, oItem);

}

void PS_VampMal_DelevelFix(object oPC, object oItem)
{
	int iVMal			= GetLocalInt(oItem, "VML5");
	if (GetLevelByClass(CLASS_TYPE_VAMPIRE_MAL_PRC, oPC) < 5 && iVMal == 1 )
	{	SetLocalInt(oItem, "VML5", 0);	}
}





void PS_TintFixer(object PCObject)
{
   //
   // Copy the head tint value 0 to all body tint values.
   //
   // Replacement for the Retint functionality in xp_character.
   //

   struct CreatureCoreAppearance Appearance = PS_GetCreatureCoreAppearance(PCObject);

   Appearance.Tint_Color0 = Appearance.HeadTint_Color0;
   Appearance.Tint_Color1 = Appearance.HeadTint_Color0;
   Appearance.Tint_Color2 = Appearance.HeadTint_Color0;

   Appearance.Tint_Mask = PS_CCA_TINT_ALL;

   PS_SetCreatureCoreAppearance(PCObject, Appearance);

   PS_SaveOriginalAppearance(PCObject);
}

void PS_PullAggro(object oPC, object oTarget)
{
	int nDC = GetHitDice(oPC) + GetAbilityBonuses(oPC, ABILITY_CHARISMA);

	if (GetIsEnemy(oTarget, oPC))
	{	if (WillSave(oTarget, nDC) == 0)
		{	AssignCommand(oTarget, ActionAttack(oPC));	}
	}
}


// 	Removes an item's current visual effect and permanently replaces it with 
//	a new one.
//	sSEF: actual name of SEF file must be used, and must be capable of
//	being applied to a weapon.
void PS_WeaponSEFApply(object oPC, object oWeapon, string sNewSEF)
{
	string sSEF = PS_GetObjectAppearanceSEF(oWeapon);
	RemoveSEFFromObject(oWeapon, sSEF);
	PS_SetObjectAppearanceSEF(oWeapon, sNewSEF);
	
	AssignCommand(oPC, ClearAllActions(TRUE));
	AssignCommand(oPC, ActionUnequipItem(oWeapon));
	AssignCommand(oPC, ActionEquipItem(oWeapon, INVENTORY_SLOT_RIGHTHAND));
}

// If a half-dragon delevels, this will remove any and all draconic magic feats
void PS_RemoveDraconicMagic(object oPC)
{
	if (GetHasFeat(2518)) FeatRemove(oPC, 2518);
	if (GetHasFeat(2519)) FeatRemove(oPC, 2519);
	if (GetHasFeat(2520)) FeatRemove(oPC, 2520);
	if (GetHasFeat(2521)) FeatRemove(oPC, 2521);
	if (GetHasFeat(2522)) FeatRemove(oPC, 2522);
	if (GetHasFeat(2523)) FeatRemove(oPC, 2523);
	if (GetHasFeat(2524)) FeatRemove(oPC, 2524);
	if (GetHasFeat(2525)) FeatRemove(oPC, 2525);
	if (GetHasFeat(2526)) FeatRemove(oPC, 2526);
	if (GetHasFeat(2527)) FeatRemove(oPC, 2527);
	if (GetHasFeat(2528)) FeatRemove(oPC, 2528);
	if (GetHasFeat(2529)) FeatRemove(oPC, 2529);
	if (GetHasFeat(2530)) FeatRemove(oPC, 2530);
	if (GetHasFeat(2531)) FeatRemove(oPC, 2531);
	if (GetHasFeat(2532)) FeatRemove(oPC, 2532);
	if (GetHasFeat(2533)) FeatRemove(oPC, 2533);
	if (GetHasFeat(2534)) FeatRemove(oPC, 2534);
	SendMessageToPC(oPC, "Draconic Magic removed.");	
}

// If the PC has been made a half-dragon by a Template class, revert them to their original race if
// they no longer have levels in that template class!
void PS_HalfDragonRaceFix(object oPC)
{
	object oItem 			= GetItemPossessedBy(oPC, "ps_essence");
	string sTemplate		= GetLocalString(oItem, "Template");
	int iGEDiff, iLCDiff;
	if (GetIsObjectValid(oItem))
	{	if (sTemplate == "HalfDragon") 
		{	//string sECL			= GetLocalString(oItem, "ECL");
			//int iECL			= StringToInt(sECL);
			string sRaceChg		= GetLocalString(oItem, "RaceChange");
			int iOldRace 		= GetLocalInt(oItem, VAR_OLD_RACE);
			int iOldSub 		= GetLocalInt(oItem, "OldSubrace");
			int iOldGoodEvil 	= GetLocalInt(oItem, "OldGoodEvil");
			string sInBlood		= GetLocalString(oItem, "InBlood");
			int iHeritage		= GetLocalInt(oItem, "Draconic_Heritage");
			int iNewGoodEvil	= GetAlignmentGoodEvil(oPC);
			int iOldLawChaos 	= GetLocalInt(oItem, "OldLawChaos"); 
			int iNewLawChaos	= GetAlignmentLawChaos(oPC);
			int iHDLevel 		= GetLevelByClass(CLASS_TYPE_HALFDRAGON_PRC, oPC);
			int iFlight		= GetLocalInt(oItem, "DragonFlight");
			int iWingless		= GetLocalInt(oItem, "Wingless");
			int iMagic			= GetLocalInt(oItem, "Draconic Magic");
			
			if (iHDLevel != 6 && sRaceChg != "")
			{	PS_SetRacialType(oPC, iOldRace);
				PS_SetSubRacialType(oPC, iOldSub);
				DeleteLocalString(oItem, "RaceChange");
				DeleteLocalInt(oItem, VAR_OLD_RACE);
				DeleteLocalInt(oItem, "OldSubrace");
				SendMessageToPC(oPC, "Racial type and subtype reverting to original");	}
			
			if (iHDLevel != 6)
			{	PS_RemoveDraconicMagic(oPC);
				DeleteLocalInt(oItem, "Draconic Magic");	}
				
			if (iHDLevel != 6 && iFlight == 1)
			{	FeatRemove(oPC, 288);
				FeatRemove(oPC, 2120);
				SendMessageToPC(oPC, "Wings removed");	}
				
			if (iHDLevel < 6 && iWingless == 1)
			{	FeatRemove(oPC, 220);
				FeatRemove(oPC, 2170);
				SendMessageToPC(oPC, "Steadfast Determination and Remain Wingless feats removed");
				DeleteLocalInt(oItem, "Wingless");	}
									
			if (iHDLevel < 6 && iHDLevel >= 1)
			{	if (sInBlood == "HD+2")
				{	//iECL = iECL - 1;
					//SetLocalString(oItem, "ECL", IntToString(iECL));
					//SetLocalString(oPC, "ECL", IntToString(iECL));
					SetLocalString(oItem, "InBlood", "HD+1");
					SendMessageToPC(oPC, "Half-dragon level adjustment is now +1");	}	}
			
			if (iHDLevel == 0)
			{	if (sInBlood == "HD+2")
				{	//iECL = iECL - 2;
					//SetLocalString(oItem, "ECL", IntToString(iECL));
					//SetLocalString(oPC, "ECL", IntToString(iECL));
					DeleteLocalString(oItem, "InBlood");
					SendMessageToPC(oPC, "Half-dragon level adjustment removed.");	}
				else if (sInBlood == "HD+1")
				{	//iECL = iECL - 1;
					//SetLocalString(oItem, "ECL", IntToString(iECL));
					//SetLocalString(oPC, "ECL", IntToString(iECL));
					DeleteLocalString(oItem, "InBlood");
					SendMessageToPC(oPC, "Half-dragon level adjustment removed.");	}
				
				if (iNewGoodEvil > iOldGoodEvil)
				{	iGEDiff = iNewGoodEvil - iOldGoodEvil;
					AdjustAlignment(oPC, ALIGNMENT_EVIL, iGEDiff);	}
				if (iNewGoodEvil < iOldGoodEvil)
				{	iGEDiff = iOldGoodEvil - iNewGoodEvil;
					AdjustAlignment(oPC, ALIGNMENT_GOOD, iGEDiff);	}
				if (iNewLawChaos > iOldLawChaos)
				{	iLCDiff = iNewLawChaos - iOldLawChaos;
					AdjustAlignment(oPC, ALIGNMENT_LAWFUL, iLCDiff);	}
				if (iNewLawChaos < iOldLawChaos)
				{	iLCDiff = iOldLawChaos - iNewLawChaos;
					AdjustAlignment(oPC, ALIGNMENT_CHAOTIC, iLCDiff);	}
				//SendMessageToPC(oPC, "Alignment reverted to original");
				DeleteLocalInt(oItem, "OldGoodEvil");
				DeleteLocalInt(oItem, "OldLawChaos");
				DeleteLocalInt(oItem, "HD_Align");
				DeleteLocalString(oItem, "Template");
				//DeleteLocalInt(oItem, "OldECL");
				DeleteLocalInt(oItem, "Draconic_Heritage");
				
				FeatRemove(oPC, iHeritage);
				FeatRemove(oPC, iMagic);
				FeatRemove(oPC, 288);
				FeatRemove(oPC, 220);
			}
		}
	ActionRest(0);
	}
}

// If the PC has been made an Outsider by a Template class, revert them to their original race if
// they no longer have levels in that template class!
void PS_HalfOutsiderRaceFix(object oPC)
{
	object oItem 			= GetItemPossessedBy(oPC, "ps_essence");
	string sTemplate		= GetLocalString(oItem, "Planar");
	int iGEDiff, iLCDiff;
	if (GetIsObjectValid(oItem))
	{	if (sTemplate == "HalfFiend" || sTemplate == "HalfCelestial") 
		{	//string sECL			= GetLocalString(oItem, "ECL");
			//int iECL			= StringToInt(sECL);
			//int iOldECL			= GetLocalInt(oItem, "OldECL");
			//string sOldECL 		= IntToString(iOldECL);
			string sRaceChg		= GetLocalString(oItem, "RaceChange");
			int iOldRace 		= GetLocalInt(oItem, VAR_OLD_RACE);
			int iOldSub 		= GetLocalInt(oItem, "OldSubrace");
			int iHDLevel 		= GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC, oPC);
			int iFlight			= GetLocalInt(oItem, "DarkFlight");
			int iSight			= GetLocalInt(oItem, "SupSight");
			
			if (iHDLevel != 6 && sRaceChg != "")
			{	PS_SetRacialType(oPC, iOldRace);
				PS_SetSubRacialType(oPC, iOldSub);
				DeleteLocalString(oItem, "RaceChange");
				DeleteLocalInt(oItem, VAR_OLD_RACE);
				DeleteLocalInt(oItem, "OldSubrace");
				SendMessageToPC(oPC, "Racial type and subtype reverting to original");	}
			
			if (iHDLevel != 6 && iFlight == 1)
			{	FeatRemove(oPC, 288);
				FeatRemove(oPC, 2120);
				SendMessageToPC(oPC, "Wings removed");	}
				
			if (iHDLevel != 6 && iSight == 1)
			{	FeatRemove(oPC, 2556);
				SendMessageToPC(oPC, "Supernatural Sight removed");
				DeleteLocalInt(oItem, "SupSight");	}
			
			if (iHDLevel == 0)
			{	//SetLocalString(oItem, "ECL", sOldECL);
				//SetLocalString(oPC, "ECL", sOldECL);
				DeleteLocalString(oItem, "Planar");
				DeleteLocalString(oItem, "Template");
				//DeleteLocalInt(oItem, "OldECL");
				DeleteLocalInt(oItem, "HalfFiend");
				DeleteLocalInt(oItem, "HalfCelestial");
			}
		}
	ActionRest(0);
	}
}

// Returns the wing type of oPC
int PS_GetAppWingType(object oPC)
{	
	object oItem = GetItemPossessedBy(oPC, "ps_essence");
	int iWing = GetLocalInt(oItem, "OriginalApp.WingVariation");
	return iWing;
}

// Determines if the selected target has a discernible anatomy
// int PS_GetHasDiscernableAnatomy(object oTarget);
int PS_GetHasDiscernableAnatomy(object oTarget)
{
	int nRace		= GetRacialType(oTarget);
	int nAppr		= GetAppearanceType(oTarget);
	
	if (GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
	{	return FALSE;	}
	
	switch (nRace)
	{	case RACIAL_TYPE_CONSTRUCT:		return FALSE;
		case RACIAL_TYPE_PLANT:			return FALSE;
		case RACIAL_TYPE_UNDEAD:		return FALSE;
		case RACIAL_TYPE_OOZE:			return FALSE;
		case RACIAL_TYPE_INCORPOREAL:	return FALSE;
	}
	switch (nAppr)
	{	case 27: /*Will-o-Wisp*/		return FALSE;
		case 52: /*Air Elemental*/		return FALSE;
		case 53: /*Elder AE*/			return FALSE;
		case 56: /*Earth Elemental*/	return FALSE;
		case 57: /*Elder EE*/			return FALSE;
		case 60: /*Fire Elemental*/		return FALSE;
		case 61: /*Elder FE*/			return FALSE;
		case 68: /*Elder WE*/			return FALSE;
		case 69: /*Water Elemental*/	return FALSE;
		case 90: /*Marut*/				return FALSE;
		case 493: /*Blade Golem*/		return FALSE;
		case 496: /*Shadow*/			return FALSE;
		case 497: /*Nightwalker*/		return FALSE;
		case 537: /*Skeleton*/			return FALSE;
		case 554: /*Huge AE*/			return FALSE;
		case 555: /*Greater AE*/		return FALSE;
		case 556: /*Huge EE*/			return FALSE;
		case 557: /*Greater EE*/		return FALSE;
		case 558: /*Huge FE*/			return FALSE;
		case 559: /*Greater FE*/		return FALSE;
		case 560: /*Huge WE*/			return FALSE;
		case 561: /*Greater WE*/		return FALSE;
		case 586: /*King of Shadows*/	return FALSE;
		case 995: /*Bonebat*/			return FALSE;
		case 1011: /*One of Many*/		return FALSE;
		case 1012: /*Shambling Mound*/	return FALSE;
		case 1027: /*Treant*/			return FALSE;
		case 2032: /*Flying Book*/		return FALSE;
		case 2045: /*Monodrone*/		return FALSE;
		case 3204: /*Swarm Lesser*/		return FALSE;
		case 3205: /*Swarm Regular*/	return FALSE;
		case 3206: /*Swarm Greater*/	return FALSE;
	}
	return TRUE;
}

void PS_CollisionControl(object oPC, int iValue)
{ if (GetIsObjectValid(oPC))
	SetCollision(oPC,iValue);
}

effect EffectRandomNerf()
{
	int nEffect = Random(13);
	effect eEffect;
	
	switch (nEffect)
	{	case 0: eEffect = EffectSlow();			break;
		case 1: eEffect = EffectBlindness();	break;
		case 2: eEffect = EffectConfused();		break;
		case 3: eEffect = EffectDazed();		break;
		case 4: eEffect = EffectDeaf();			break;
		case 5: eEffect = EffectFrightened();	break;
		case 6: eEffect = EffectInsane();		break;
		case 7:	eEffect = EffectJarring();		break;
		case 8: eEffect = EffectParalyze();		break;
		case 9: eEffect = EffectPetrify();		break;
		case 10: eEffect = EffectSilence();		break;
		case 11: eEffect = EffectSleep();		break;
		case 12: eEffect = EffectStunned();		break;
	}
	return (eEffect);
}

effect EffectElementalPiercingDamage(object oPC, int nDamage, int nDamageType)
{	
	int nLevel = GetLevelByClass(9999, oPC); //"9999" to be replace with Elemental Adept class ID
	int nDamageA = nDamage * nLevel / 10;
	int nDamageB = nDamage - nDamageA;
	
	effect eDamageA = EffectDamage(nDamageA, nDamageType, DAMAGE_POWER_NORMAL, TRUE);
	effect eDamageB = EffectDamage(nDamageB, nDamageType, DAMAGE_POWER_NORMAL, FALSE);
	effect ePiercing = EffectLinkEffects(eDamageA, eDamageB);
	
	return (ePiercing);
}

void DebugMessageToPC(object oPC, string sMessage)
{
	int DevMode = GetLocalInt(GetModule(), "SIGIL_DEV_MODE");
	
	if (DevMode == FALSE)
	{	return;		}

	SendMessageToPC(oPC, sMessage);
}

//wrapper for the standard exp script, makes sure you don't keep getting exp past level 30
int PS_GiveXPReward(object oPC, int nXP) {

	if (PS_GetLevel(oPC) >= 30)
		return FALSE;
		
	GiveXPToCreature(oPC, nXP);
	return TRUE;

}

struct CreatureCoreAppearance GetNewFormAppearance(string sResRef, object oPC = OBJECT_INVALID) {

     object oWP = GetWaypointByTag("WP_APPEARANCE_SPAWNER");
    if (GetIsObjectValid(oPC)) {
        SendMessageToPC(oPC, "Found oWP = "+GetFirstName(oWP));
    } else {
        SendMessageToPC(oPC, "Failed to find WP");
    }
    
    object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sResRef, GetLocation(oWP));
    
    struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oCreature);
    
    DestroyObject(oCreature, 1.0f);
    return app;
}

void Assumenewform(object oPC, struct CreatureCoreAppearance Appearance) {

    if (!GetIsPC(oPC)) {
        SendMessageToPC(oPC, "NPC support not included.");
        return;
    }

    object oEssence = GetItemPossessedBy(oPC, "ps_essence");
    struct CreatureCoreAppearance originalApp = PS_RetrieveStoredCreatureCoreAppearance(oEssence, "OriginalApp");
    SendMessageToPC(oPC, "Original Appearance type: "+IntToString(originalApp.AppearanceType)); //checking what we even have saved here
    
    Appearance.Tint_Mask = PS_CCA_TINT_ALL;
    Appearance.HeadTint_Mask = PS_CCA_TINT_ALL;
    Appearance.HairTint_Mask = PS_CCA_TINT_ALL;
    
    PS_SetCreatureCoreAppearance(oPC, Appearance);
    ServerExts_RefreshCreatureAppearance(oPC,oPC);
    SetLocalInt(oEssence, "TempChange", 1);
}

void FiendformBoni(object oPC, string sVFX = "") {
	effect eBoost = EffectAbilityIncrease(ABILITY_STRENGTH, 8);
	eBoost = EffectLinkEffects(eBoost, EffectAbilityIncrease(ABILITY_DEXTERITY, 8));
	eBoost = EffectLinkEffects(eBoost, EffectAbilityIncrease(ABILITY_CONSTITUTION, 8));
	eBoost = EffectLinkEffects(eBoost, EffectRegenerate(5, 6.0f));
		
	
	if (sVFX != "") {
		eBoost = EffectLinkEffects(eBoost, EffectNWN2SpecialEffectFile(sVFX));
	}
		
	eBoost = SetEffectSpellId(eBoost, 1657);
	eBoost = SupernaturalEffect(eBoost);
		
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBoost, oPC);
}	

//Saves the PC's name + CD key under the variable given
//Can track multiple PCs - array like
void RecordPCAction(object oTarget, string sVar, object oPC) {

	string sName = GetPCPublicCDKey(oPC)+GetFirstName(oPC);
	int nMax = GetLocalInt(oTarget, sVar+"_Num");
	int nIndex = nMax+1;
	SetLocalString(oTarget, sVar+"_"+IntToString(nIndex), sName);
	SetLocalInt(oTarget, sVar+"_Num", nIndex);
}

//Calculuates Psychic Warrior Levels

int PsyWarLevels(object oPC)
{
	int nPsywar = GetLevelByClass(CLASS_PSYCHIC_WARRIOR, oPC);
	int nWarMind = GetLevelByClass(CLASS_TYPE_WARMIND,oPC);
	int nGemDragon = GetLevelByClass(128, oPC) / 2 + 1; 
	int	iTotal = nPsywar + nWarMind + nGemDragon;
	
	return iTotal;	
}
//This Determines Psychic Warrior Progression
void DoPsyProgression(object oPC)
{	

int iPsy = PsyWarLevels(oPC);
if (iPsy >=21)
	{FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_VI);}
	 else if (iPsy >= 16 && GetHasFeat(POWER_POINT_POOL_PSYWAR,oPC,TRUE)) {
		  FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_V);
  		FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_VI, FALSE, FALSE, FALSE);}
else if (iPsy >= 14 && GetHasFeat(POWER_POINT_POOL_PSYWAR,oPC,TRUE)){    
  FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_IV);
  FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_V, FALSE, FALSE, FALSE);
}
 else if (iPsy >= 11 && GetHasFeat(POWER_POINT_POOL_PSYWAR,oPC,TRUE)) {    
	FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_III);
	FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_IV, FALSE, FALSE, FALSE);
}
 else if (iPsy >= 7 && GetHasFeat(POWER_POINT_POOL_PSYWAR,oPC,TRUE))
{FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_II);
                FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_III, FALSE, FALSE, FALSE);}
else if (iPsy >= 4 && GetHasFeat(POWER_POINT_POOL_PSYWAR,oPC,TRUE)){ 
FeatRemove(oPC,FEAT_PSYWAR_PROGRESSION_I);
FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_II, FALSE, FALSE, FALSE);
            }
else if (iPsy >= 1 && GetHasFeat(POWER_POINT_POOL_PSYWAR,oPC,TRUE)){    
FeatAdd(oPC, FEAT_PSYWAR_PROGRESSION_I, FALSE, FALSE, FALSE);}
	
if (GetLocalInt(OBJECT_SELF, "METAPSI_AUGMENT") == 1)
{	SetLocalInt(OBJECT_SELF, "METAPSI_AUGMENT", 0);
SendMessageToPC(OBJECT_SELF, "Metapsionics Deactivated: Augment Power");	}
if (GetLocalInt(OBJECT_SELF, "METAPSI_EMPOWER") == 1)
	{	SetLocalInt(OBJECT_SELF, "METAPSI_EMPOWER", 0);
		SendMessageToPC(OBJECT_SELF, "Metapsionics Deactivated: Empower Power");	}
if (GetLocalInt(OBJECT_SELF, "METAPSI_EXTEND") == 1)
		{	SetLocalInt(OBJECT_SELF, "METAPSI_EXTEND", 0);
			SendMessageToPC(OBJECT_SELF, "Metapsionics Deactivated: Extend Power");		}
if (GetLocalInt(OBJECT_SELF, "METAPSI_MAXIMIZE") == 1)
		{	SetLocalInt(OBJECT_SELF, "METAPSI_MAXIMIZE", 0);	
			SendMessageToPC(OBJECT_SELF, "Metapsionics Deactivated: Maximize Power");	}
if (GetLocalInt(OBJECT_SELF, "METAPSI_TWIN") == 1)
		{	SetLocalInt(OBJECT_SELF, "METAPSI_TWIN", 0);
			SendMessageToPC(OBJECT_SELF, "Metapsionics Deactivated: Twin Power");		}

}

void DoPsyFeatProgression(object oPC)
{


int iPsy = PsyWarLevels(oPC);
if (iPsy >= 1  && GetHasFeat(FEAT_PSYWAR_LURK,oPC))
{FeatAdd(oPC,21079,FALSE,FALSE,FALSE);//Chameleon
FeatAdd(oPC,21003,FALSE,FALSE,FALSE);//Coneal Thought
FeatAdd(oPC,21011,FALSE,FALSE,FALSE);//Dissipating Touch
}
if (iPsy >= 9  && GetHasFeat(FEAT_PSYWAR_LURK,oPC))
{
FeatAdd(oPC,21472,FALSE,FALSE,FALSE);//Shadow Play
}



if (iPsy >= 1  && GetHasFeat(FEAT_PSYWAR_FERAL,oPC))
{
FeatAdd(oPC,21027,FALSE,FALSE,FALSE);//Vigor
}

if (iPsy >= 3  && GetHasFeat(FEAT_PSYWAR_FERAL,oPC))
{
FeatAdd(oPC,289,FALSE,FALSE,FALSE);//Weapon Prof. Creature
FeatAdd(oPC,291,FALSE,FALSE,FALSE);//Weapon Focus. Creature
}

if (iPsy >= 5  && GetHasFeat(FEAT_PSYWAR_FERAL,oPC))
{
FeatAdd(oPC,290,FALSE,FALSE,FALSE);//Weapon creature, Specialization

}
if (iPsy >= 7  && GetHasFeat(FEAT_PSYWAR_FERAL,oPC))
{
FeatAdd(oPC,1157,FALSE,FALSE,FALSE);//Greater Weapon Focus, Creature

}
if (iPsy >= 14  && GetHasFeat(FEAT_PSYWAR_FERAL,oPC))
{
FeatAdd(oPC,1383,FALSE,FALSE,FALSE);//Power Critical, Creature

}
if (iPsy >= 15  && GetHasFeat(FEAT_PSYWAR_FERAL,oPC))
{
FeatAdd(oPC,1197,FALSE,FALSE,FALSE);//Greater Weapon Specialization, Creature

}
if (iPsy >= 20 )
{
FeatAdd(oPC,21477,FALSE,FALSE,FALSE);//Eternal Warrior
}

}

//Counts levels in low bab arcane classes
int GetPureMageLevels(object oPC)
{
	 
int iWIZ =	GetLevelByClass(CLASS_TYPE_WIZARD, oPC);     
int	iSOR =	GetLevelByClass(CLASS_TYPE_SORCERER, oPC);
int iBRA =	GetLevelByClass(CLASS_TYPE_BRACHINA, oPC); 
int iLIC =	GetLevelByClass(CLASS_TYPE_LICH_PRC, oPC);
int iSUC =	GetLevelByClass(CLASS_TYPE_SUCCUBUS_INCUBUS, oPC);
int iPAL =	GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC);
int iGOL =	GetLevelByClass(CLASS_TYPE_GOLEMMASTER, oPC);
int iARC =	GetLevelByClass(CLASS_TYPE_ARCANE_SCHOLAR, oPC);
int iMYS =	GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oPC);
int iRWZ = 	GetLevelByClass(CLASS_TYPE_RED_WIZARD, oPC);
int iGSD =  GetLevelByClass(CLASS_TYPE_GRAY_SLAAD, oPC);
int iRSC =  GetLevelByClass(CLASS_TYPE_RAKSHASA_SORCERER, oPC);
int iWDA =  GetLevelByClass(CLASS_TYPE_WORD_ARCHON_PRC, oPC);
int iCER =  GetLevelByClass(CLASS_TYPE_CEREBREMANCER, oPC);

	
int PML = (iWIZ + iSOR + iBRA + iLIC + iSUC + iPAL + iGOL + iARC + iMYS + iRWZ + iRSC + iGSD + iWDA + iCER);

return PML;
}

//Get whether this PC has done this action (defined by variable given) this reset
//Can track multiple PCs - array like
int GetPCActionRecorded(object oTarget, string sVar, object oPC) {

	string sName = GetPCPublicCDKey(oPC)+GetFirstName(oPC);
	int nMax = GetLocalInt(oTarget, sVar+"_Num");
	
	int n = 0;
	for(n = 1; n <= nMax; n++) {
		string sFound = GetLocalString(oTarget, sVar+"_"+IntToString(n));
		//SendMessageToPC(oPC, "found: "+sFound);
		if (sFound == sName) 
			return TRUE;
	}
	
	return FALSE;
}

effect PS_EffectDamage(int nDamageAmount, int nDamageType = DAMAGE_TYPE_BLUDGEONING, int nDamagePower = DAMAGE_POWER_NORMAL, int IgnoreResistance = FALSE)
{
	return EffectDamage(nDamageAmount, nDamageType, nDamagePower, IgnoreResistance);
	
	//object oCaster = OBJECT_SELF;
	//int SpellID = GetSpellId();
	
	//nDamageAmount = GetSQLDamageBonuses(oCaster, SpellID, nDamageAmount);

	//effect eDamage = EffectDamage(nDamageAmount, nDamageType, nDamagePower, IgnoreResistance);	
	//return eDamage;
}

effect PS_EffectDamagePiercing(int nDamageAmount, int nDamageType=DAMAGE_TYPE_BLUDGEONING, int nDamagePower=DAMAGE_POWER_NORMAL, int nPiercePercent=0)
{
	if(nPiercePercent <= 0)
		return PS_EffectDamage(nDamageAmount, nDamageType, nDamagePower, FALSE);
	else if(nPiercePercent >= 100)
		return PS_EffectDamage(nDamageAmount, nDamageType, nDamagePower, TRUE);
	else
	{
		// some of the damage is piercing, some is normal
		// link them together
		float fPercentage = IntToFloat(nPiercePercent) * 0.01;
		int nNormalDamage = FloatToInt(nDamageAmount * (1.0 - fPercentage));
		int nPiercingDamage = nDamageAmount - nNormalDamage;
		effect eNormal = PS_EffectDamage(nNormalDamage, nDamageType, nDamagePower, FALSE);
		effect ePiercing = PS_EffectDamage(nPiercingDamage, nDamageType, nDamagePower, TRUE);
		return EffectLinkEffects(eNormal, ePiercing);
	}
}

//check server settings
string CheckServerVersion(int versionRow) {
	string sQuery = "SELECT version FROM server_version WHERE row_id = "+IntToString(versionRow);
	
	SQLExecDirect(sQuery);
	
	if (SQLFetch() != SQL_ERROR) { //Fetch sql id's and store it
		string version = SQLGetData(1);
		return version;
	}
	
	return "";
	
}

int GetIsChristmas() {

	object oMod = GetModule();
	string version = GetLocalString(oMod, "HOLIDAY_MODE");
	if (version == "")
		version = CheckServerVersion(HOLIDAY_VERSION_ROW);
		
	SetLocalString(oMod, "HOLIDAY_MODE", version);
	
	return (version == HOLIDAY_XMAS);
	
}