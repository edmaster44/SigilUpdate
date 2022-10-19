///  Constants
const string XP_BG_PLUGIN_NAME	= "BG";

// New EFFECT_TYPE_* constants for use with the EnableGetEffectTypeFix
const int EFFECT_TYPE_SCALE  = 111;
const int EFFECT_TYPE_KNOCKDOWN = 112;

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
int GetOnHandAttackModifier(object oCreature)
{
	return NWNXGetInt(XP_BG_PLUGIN_NAME, "GetOnHandAttackModifier", "", ObjectToInt(oCreature));
}

// Theory: Same as OnHand except for the offhand.
int GetOffHandAttackModifier(object oCreature)
{
	return NWNXGetInt(XP_BG_PLUGIN_NAME, "GetOffHandAttackModifier", "", ObjectToInt(oCreature));
}

// Theory: Number of attacks the creature has.  Does this include haste and other bonus attacks?
int GetNumAttacks(object oCreature)
{
	return NWNXGetInt(XP_BG_PLUGIN_NAME, "GetNumAttacks", "", ObjectToInt(oCreature));
}

// Theory: Total weapon damage from mainhand?
int GetMainHandDamage(object oCreature)
{
	return NWNXGetInt(XP_BG_PLUGIN_NAME, "GetMainHandDamage", "", ObjectToInt(oCreature));
}

//// UUID Functions


// Retrieves the UUID for an oPC, does not work on other objects.
// Returns an empty string on failure.
string GetUuid(object oPC)
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
int GetRemainingFeatUses(object oCreature, int nFeat)
{
	if(nFeat < 0 || nFeat > 65535) return 0;
	NWNXSetInt(XP_BG_PLUGIN_NAME, "SetInts", "", nFeat, 0);
	return NWNXGetInt(XP_BG_PLUGIN_NAME, "GetRemainingFeatUses", "", ObjectToInt(oCreature));
}



//// Resolve Special Attack Bonus functions for use in special script nwnx_bg_rsab.nss

// Gets the object that is performing the special attack.
object nwnx_bg_rsadb_Attacker()
{
	return IntToObject(NWNXGetInt(XP_BG_PLUGIN_NAME, "nwnx_bg_rsadb_Attacker", "", 0));
}

// Gets the object that is the target of the special attack.
object nwnx_bg_rsadb_Target()
{
	return IntToObject(NWNXGetInt(XP_BG_PLUGIN_NAME, "nwnx_bg_rsadb_Target", "", 0));
}

// Gets the FeatID associated with the special attack.
int nwnx_bg_rsadb_FeatId()
{
	return NWNXGetInt(XP_BG_PLUGIN_NAME, "nwnx_bg_rsadb_FeatId", "", 0);
}


// Sets the amount of damage that you would like to be added for the special attack.
void nwnx_bg_rsadb_SetDamage(int nAmount)
{
	NWNXSetInt(XP_BG_PLUGIN_NAME, "nwnx_bg_rsadb_SetDamage", "", nAmount, 0);
}

// Set Unarmed Damage Dice.
// Will only work if used in nwnx_bg_fistdmg.nss 
// Which will be called by the engine when checking for 
// fist damage rolls if enabled in the plug-in.
void nxnx_bg_fistdmg_setNum(int nDiceNumber)
{
	// These values are at most what a uchar can hold.
	if(nDiceNumber < 0) nDiceNumber = 0;
	if(nDiceNumber > 255) nDiceNumber = 255;

	NWNXSetInt(XP_BG_PLUGIN_NAME, "nxnx_bg_fistdmg_setNum", "", nDiceNumber, 0);
}

void nxnx_bg_fistdmg_setSides(int nDiceSides)
{
	// These values are at most what a uchar can hold.
	if(nDiceSides < 0) nDiceSides = 0;
	if(nDiceSides > 255) nDiceSides = 255;

	NWNXSetInt(XP_BG_PLUGIN_NAME, "nxnx_bg_fistdmg_setSides", "", nDiceSides, 0);
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
void nwnx_bg_CreateFinesseRule(int nBaseItem, int nFeat=FEAT_INVALID, int bIgnoreSize=FALSE)
{
	if( check_ushort(nFeat, "nFeat", "nwnx_bg_MakeFinessable") )
	{
		NWNXSetInt(XP_BG_PLUGIN_NAME, "SetInts", "", nFeat, bIgnoreSize>0);
		NWNXSetInt(XP_BG_PLUGIN_NAME, "MakeFinessable", "", nBaseItem, 0);
	}
}

// Logs to xp_bg.txt the current mappings made through nwnx_bg_CreateFinesseRule.
void nwnx_bg_LogFinesseRules()
{
	NWNXGetInt(XP_BG_PLUGIN_NAME, "LogFinesseRules", "", 0);
}

// Retrieve from engine if finesse conditions for a weapon are currently met.
// Returns:
//  0 --> oWeapon for oTarget of iCreatureSize category is not finessable.
//  1 --> oWeapon for oTarget of iCreatureSize category is finessable.
// -1 --> Bad inputs.  (E.g. invalid object, size, etc.)
// To get unarmed use OBJECT_INVALID for oWeapon.
int nwnx_bg_GetIsFinessable(object oTarget, object oWeapon, int iCreatureSize)
{
	if( !GetIsObjectValid(oTarget)
		|| iCreatureSize < CREATURE_SIZE_TINY
		|| iCreatureSize > CREATURE_SIZE_HUGE
	  )
	{
		return -1;
	}

	NWNXSetInt(XP_BG_PLUGIN_NAME, "SetInts", "", ObjectToInt(oWeapon), iCreatureSize);
	return NWNXGetInt(XP_BG_PLUGIN_NAME, "GetIsFinessable", "", ObjectToInt(oTarget));
}


void nwnx_bg_CreateSkillFeat(int nFeat, int nSkill, int nAmount)
{
	string sModule = "nwnx_bg_CreateSkillFeat";

	if( check_ushort(nFeat, "nFeat", sModule) && 
		check_ushort(nSkill, "nSkill", sModule) &&
		nFeat < GetNum2DARows("feat") &&
		nSkill < GetNum2DARows("skills")
		)
	{
		NWNXSetInt(XP_BG_PLUGIN_NAME, "SetInts", "", nSkill, nFeat);
		NWNXGetInt(XP_BG_PLUGIN_NAME, "CreateSkillFeat", "", nAmount);
	}
}

void nwnx_bg_CreateSkillSynergy(int nSkill, int nSynergySkill, int nAmount=2, int nThreshold=4)
{
	string sModule = "nwnx_bg_CreateSkillSynergy";

	if( check_ushort(nSynergySkill, "nSynergySkill", sModule) && 
		check_ushort(nSkill, "nSkill", sModule) &&
		nSkill < GetNum2DARows("skills") &&
		nSynergySkill < GetNum2DARows("skills") &&
		nThreshold <= 33 && nThreshold >= 0 //Threshold shouldn't be some crazy amount of ranks.
		)
	{
		NWNXSetInt(XP_BG_PLUGIN_NAME, "SetInts", "", nSkill, nSynergySkill);
		NWNXSetInt(XP_BG_PLUGIN_NAME, "SetInts2", "", nAmount, nThreshold);
		NWNXGetInt(XP_BG_PLUGIN_NAME, "CreateSkillSynergy", "", 0);
	}
}


// Logs to xp_bg.txt the current mapping of nSkills to (nfeat, nAmount).
// This shows what you've added with nwnx_bg_CreateSkillFeat.
void nwnx_bg_LogSkillFeats()
{
	NWNXGetInt(XP_BG_PLUGIN_NAME, "LogSkillFeats", "", 0);
}

// Logs to xp_bg.txt the current mapping of nSkills to (nfeat, nAmount).
// This shows what you've added with nwnx_bg_CreateSkillFeat.
void nwnx_bg_LogSkillSynergies()
{
	NWNXGetInt(XP_BG_PLUGIN_NAME, "LogSkillSynergies", "", 0);
}