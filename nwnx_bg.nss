
///  Constants
const string XP_BG_PLUGIN_NAME	= "BG";

// New EFFECT_TYPE_* constants for use with the EnableGetEffectTypeFix
const int EFFECT_TYPE_SCALE  = 111;
const int EFFECT_TYPE_KNOCKDOWN = 112;



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
void nxnx_bg_fistdmg_set(int nDiceNumber, int nDiceValue)
{
	// TO DO: Sanity checks on inputs before passing?
	NWNXSetInt(XP_BG_PLUGIN_NAME, "SetInts", "", nDiceNumber, nDiceValue);
}


// Set Unarmed Damage Dice.  Will only work if used in
// nwnx_bg_fistdmg.nss which will be called by the engine
// when checking if an item is finessable if enabled in the plug-in.
void nxnx_bg_finesse_set(int bIsFinessable)
{
	// TO DO: Sanity checks on inputs before passing?
	NWNXSetInt(XP_BG_PLUGIN_NAME, "nxnx_bg_finesse_set", "", bIsFinessable, 0);
}

// Item to check if it can be finessed.
object nwnx_bg_finesse_GetItem()
{
	return IntToObject(NWNXGetInt(XP_BG_PLUGIN_NAME, "nwnx_bg_finesse_GetItem", "", 0));
}

/// Skip Feat Mod Functions for nwnx_bg_skill_featmod.nss

int nwnx_bg_skill_featmod_GetSkill()
{
	return NWNXGetInt(XP_BG_PLUGIN_NAME, "nwnx_bg_skill_featmod_GetSkill", "", 0);
}


void nwnx_bg_skill_featmod_set(int nBaseSkillModifier)
{
	// TO DO: Sanity checks on inputs before passing?
	NWNXSetInt(XP_BG_PLUGIN_NAME, "nwnx_bg_skill_featmod_set", "", nBaseSkillModifier, 0);
}