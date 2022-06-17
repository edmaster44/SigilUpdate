
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



object LastSpcAttacker()
{

	return IntToObject(
			NWNXGetInt(XP_BG_PLUGIN_NAME, "LastSpcAttacker", "", 0)
		);

}

object LastSpcTarget()
{

	return IntToObject(
			NWNXGetInt(XP_BG_PLUGIN_NAME, "LastSpcTarget", "", 0)
		);

}


int LastSpcFeatId()
{
	return NWNXGetInt(XP_BG_PLUGIN_NAME, "LastSpcFeatId", "", 0);
}

void SetLastSpcDmg(int nAmount)
{
	NWNXSetInt(XP_BG_PLUGIN_NAME, "SetLastSpcDmg", "", nAmount, 0);
}