#include "ff_safevar"

// Tag Tean on hit script. Marks the target, then if the target has
// the mark of a linked Tag Team on it, consume it to deal 3d6 damage
// By Electrohydra
// Last edit 19/09/2015

void main()
{
	object tagteam = GetSpellCastItem();
	object oPC = GetItemPossessor(tagteam);
	object oTarget = GetSpellTargetObject();
	string linkedName = PS_GetLocalString(oPC, "tagteamtarget");
	string linkedMarkString = "tagteammark" + linkedName;
	string markString = "tagteammark" + GetName(oPC);
	
	PS_SetLocalInt(oTarget, markString, TRUE);
	if (PS_GetLocalInt(oTarget, linkedMarkString))
	{
		PS_SetLocalInt(oTarget, linkedMarkString, FALSE);
		effect dmg = EffectDamage(d6(3)); 
		ApplyEffectToObject(DURATION_TYPE_INSTANT, dmg, oTarget, 0.0f);
	}
}