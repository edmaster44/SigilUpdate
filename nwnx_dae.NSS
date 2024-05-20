//  Constants
const string XP_DAE_PLUGIN_NAME	= "DAE";

// New EFFECT_TYPE_* constants for use with the EnableGetEffectTypeFix
const int EFFECT_TYPE_SCALE                     = 111;
const int EFFECT_TYPE_KNOCKDOWN                 = 112;
const int EFFECT_TYPE_MODIFY_ATTACKS            = 113;


//// Internal helper functions

int check_ushort(int nNumber, string sParamName, string sModule)
{
	// Max range for feat ids.
	if(nNumber < 0 || nNumber > 65535)
	{
		WriteTimestampedLogEntry("Attempted to set " + sParamName + " outside of unsigned short range for " + sModule);
		return FALSE;
	}

	return TRUE;
}

////  Character Sheet Functions

// Experimental functions for retrieving some character sheet combat information.
// If a problem happens (INVALID_OBJECT, etc.) these will probably return 0, assuming the whole server doesn't crash.

// Theory: This is AB from all sources except for BAB.  Sources subject to the 20 cap might not be respecting the cap?
// Does this also contain ability score mod and all feat bonuses?
// To get total AB add the built-in function GetBaseAttackBonus(oCreature) to this.
int dae_GetOnHandAttackModifier(object oCreature)
{
	return NWNXGetInt(XP_DAE_PLUGIN_NAME, "GetOnHandAttackModifier", "", ObjectToInt(oCreature));
}

// Theory: Same as OnHand except for the offhand.
int dae_GetOffHandAttackModifier(object oCreature)
{
	return NWNXGetInt(XP_DAE_PLUGIN_NAME, "GetOffHandAttackModifier", "", ObjectToInt(oCreature));
}

// Theory: Number of attacks the creature has.  Does this include haste and other bonus attacks?
int dae_GetNumAttacks(object oCreature)
{
	return NWNXGetInt(XP_DAE_PLUGIN_NAME, "GetNumAttacks", "", ObjectToInt(oCreature));
}

// Theory: Total weapon damage from mainhand?
int dae_GetMainHandDamage(object oCreature)
{
	return NWNXGetInt(XP_DAE_PLUGIN_NAME, "GetMainHandDamage", "", ObjectToInt(oCreature));
}

//// UUID Functions


// Retrieves the UUID for an oPC, does not work on other objects.
// Returns an empty string on failure.
string dae_GetUuid(object oPC)
{
	if(!GetIsObjectValid(oPC))
	{
		return "";
	}
	else if(!GetIsPC(oPC))
	{
		return "";
	}

	// UUID is stored on oPC's TemplateResRef field.
	string uuid = GetResRef(oPC);

	// Sanity Check length, should always be 32.
	if(GetStringLength(uuid) != 32)
	{
		return "";
	}

	return uuid;
}


// Returns the number of remaining uses of feat with
// feat.2da row of nFeat (you can also use the FEAT_* 
// constants if one is defined) that oCreature has left.
//
// Returns 0 if oCreature does not have the feat.
//
// Returns 0 if nFeat is negative or greater than 65,535.
// Note: this is because internal to the engine the nFeat 
// int is cast to unsigned short.  
//
int dae_GetRemainingFeatUses(object oCreature, int nFeat)
{
	if(nFeat < 0 || nFeat > 65535) return 0;
	NWNXSetInt(XP_DAE_PLUGIN_NAME, "SetInts", "", nFeat, 0);
	return NWNXGetInt(XP_DAE_PLUGIN_NAME, "GetRemainingFeatUses", "", ObjectToInt(oCreature));
}



//// Resolve Special Attack Bonus functions for use in special script nwnx_dae_rsab.nss

// Gets the object that is performing the special attack.
object rsadb_Attacker()
{
	return IntToObject(NWNXGetInt(XP_DAE_PLUGIN_NAME, "nwnx_dae_rsadb_Attacker", "", 0));
}

// Gets the object that is the target of the special attack.
object rsadb_Target()
{
	return IntToObject(NWNXGetInt(XP_DAE_PLUGIN_NAME, "nwnx_dae_rsadb_Target", "", 0));
}

// Gets the FeatID associated with the special attack.
int rsadb_FeatId()
{
	return NWNXGetInt(XP_DAE_PLUGIN_NAME, "nwnx_dae_rsadb_FeatId", "", 0);
}


// Sets the amount of damage that you would like to be added for the special attack.
void rsadb_SetDamage(int nAmount)
{
	NWNXSetInt(XP_DAE_PLUGIN_NAME, "rsadb_SetDamage", "", nAmount, 0);
}

// Make a base item finessable at engine level.
// Optionally, only finessable if they also have nFeatId
// If nFeatId is FEAT_INVALID then only feat id 42 (Weapon Finesse) is required.
//		Sets up rules for baseitems:
//
//		nBaseItem1 ->  (nFeatID1, bIgnoreSize), (nFeatID2, bIgnoreSize), (nFeatID3, bIgnoreSize), ...
//		nBaseItem2 ->  ...
//		nBaseItem3 ->  ...
//		...
//
//		If the creature has the feat and meets the size check (or ignores size check for that feat) for
//		at least one of the entries for the given base item equipped then the item is finessable.
//
//		FEAT_INVALID is a catchall meaning no feat is required, but we still do the size check unless 
//		you've set it to ignore.
void dae_CreateFinesseRule(int nBaseItem, int nFeat=FEAT_INVALID, int bIgnoreSize=FALSE)
{
	if( check_ushort(nFeat, "nFeat", "nwnx_dae_CreateFinesseRule") )
	{
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "SetInts", "", nFeat, bIgnoreSize>0);
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "MakeFinessable", "", nBaseItem, 0);
	}
}

// Logs to xp_dae.txt the current mappings made through nwnx_dae_CreateFinesseRule.
void dae_LogFinesseRules()
{
	NWNXGetInt(XP_DAE_PLUGIN_NAME, "LogFinesseRules", "", 0);
}

// Retrieve from engine if finesse conditions for a weapon are currently met.
// Returns:
//  0 --> oWeapon for oTarget of iCreatureSize category is not finessable.
//  1 --> oWeapon for oTarget of iCreatureSize category is finessable.
// -1 --> Bad inputs.  (E.g. invalid object, size, etc.)
// To get unarmed use OBJECT_INVALID for oWeapon.
int dae_GetIsFinessable(object oTarget, object oWeapon, int iCreatureSize)
{
	if( !GetIsObjectValid(oTarget)
		|| iCreatureSize < CREATURE_SIZE_TINY
		|| iCreatureSize > CREATURE_SIZE_HUGE
	  )
	{
		return -1;
	}

	NWNXSetInt(XP_DAE_PLUGIN_NAME, "SetInts", "", ObjectToInt(oWeapon), iCreatureSize);
	return NWNXGetInt(XP_DAE_PLUGIN_NAME, "GetIsFinessable", "", ObjectToInt(oTarget));
}


void dae_CreateSkillFeat(int nFeat, int nSkill, int nAmount)
{
	string sModule = "nwnx_dae_CreateSkillFeat";

	if( check_ushort(nFeat, "nFeat", sModule) && 
		check_ushort(nSkill, "nSkill", sModule) &&
		nFeat < GetNum2DARows("feat") &&
		nSkill < GetNum2DARows("skills")
		)
	{
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "SetInts", "", nSkill, nFeat);
		NWNXGetInt(XP_DAE_PLUGIN_NAME, "CreateSkillFeat", "", nAmount);
	}
}

void dae_CreateSkillSynergy(int nSkill, int nSynergySkill, int nAmount=2, int nThreshold=4)
{
	string sModule = "nwnx_dae_CreateSkillSynergy";

	if( check_ushort(nSynergySkill, "nSynergySkill", sModule) && 
		check_ushort(nSkill, "nSkill", sModule) &&
		nSkill < GetNum2DARows("skills") &&
		nSynergySkill < GetNum2DARows("skills") &&
		nThreshold <= 33 && nThreshold >= 0 //Threshold shouldn't be some crazy amount of ranks.
		)
	{
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "SetInts", "", nSkill, nSynergySkill);
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "SetInts2", "", nAmount, nThreshold);
		NWNXGetInt(XP_DAE_PLUGIN_NAME, "CreateSkillSynergy", "", 0);
	}
}


// Logs to xp_dae.txt the current mapping of nSkills to (nfeat, nAmount).
// This shows what you've added with nwnx_dae_CreateSkillFeat.
void dae_LogSkillFeats()
{
	NWNXGetInt(XP_DAE_PLUGIN_NAME, "LogSkillFeats", "", 0);
}

// Logs to xp_dae.txt the current mapping of nSkills to (nfeat, nAmount).
// This shows what you've added with nwnx_dae_CreateSkillFeat.
void dae_LogSkillSynergies()
{
	NWNXGetInt(XP_DAE_PLUGIN_NAME, "LogSkillSynergies", "", 0);
}



// Add a base item to the monk validity list.
void dae_AddMonkWeapon(int nBaseItem)
{
	if( check_ushort(nBaseItem, "nBaseItem", "nwnx_dae_AddMonkWeapon") )
	{
		NWNXSetInt(XP_DAE_PLUGIN_NAME, "AddMonkWeapon", "", nBaseItem, 0);
	}
}

// AC_TYPE_*
const int AC_TYPE_TOTAL = 0;
const int AC_TYPE_NATURAL_BASE = 1;
const int AC_TYPE_ARMOR_BASE = 2;
const int AC_TYPE_SHIELD_BASE = 3;
const int AC_TYPE_ARMOR_MOD = 4;
const int AC_TYPE_ARMOR_NEG = 5;
const int AC_TYPE_DEFLECTION_MOD = 6;
const int AC_TYPE_DEFLECTION_NEG = 7;
const int AC_TYPE_SHIELD_MOD = 8;
const int AC_TYPE_SHIELD_NEG = 9;
const int AC_TYPE_NATURAL_MOD = 10;
const int AC_TYPE_NATURAL_NEG = 11;
const int AC_TYPE_DODGE_MOD = 12;
const int AC_TYPE_DODGE_NEG = 13;
const int AC_TYPE_INNATE = 14;

// Obtains information about the AC component of oCreature.
// These only consider AC that would add all up on the sheet.
// Not "versus AC" which takes into account other combat/racial rules
// against a target during a combat round.
// 
// Use the AC_TYPE_* constants defined above to get different 
// AC "categories".
int dae_GetAC(object oCreature, int AC_TYPE)
{
	NWNXSetInt(XP_DAE_PLUGIN_NAME, "SetInts", "", ObjectToInt(oCreature), AC_TYPE);
	return NWNXGetInt(XP_DAE_PLUGIN_NAME, "GetAC", "", 0);
}

// Assign FEAT_ID as giving nValue amount of innate AC (always as long as creature has feat).
// All such feats stack together.
// Default feats in plug-in: {FEAT_LUCK_OF_HEROES, 1}, {FEAT_CONSTRUCT_UPGRADE_AC, 3}
void dae_AddInnateACFeat(int FEAT_ID, int nValue)
{
	NWNXSetInt(XP_DAE_PLUGIN_NAME, "AddInnateACFeat", "", FEAT_ID, nValue);
}

// Assign FEAT_ID as giving nValue amount of base natural AC (always as long as creature has feat).
// All such feats stack together.
// Default feats in plug-in: {FEAT_EPIC_ARMOR_SKIN, 1}, {FEAT_HAGSPAWN_NATURAL_ARMOR, 2}, {FEAT_RACIAL_NATURAL_ARMOR, 1}
void dae_AddBaseNAACFeat(int FEAT_ID, int nValue)
{
	NWNXSetInt(XP_DAE_PLUGIN_NAME, "AddBaseACFeat", "", FEAT_ID, nValue);
}

int dae_LogEffects(object oCreature)
{
	return NWNXGetInt(XP_DAE_PLUGIN_NAME, "LogEffects", "", ObjectToInt(oCreature));
}