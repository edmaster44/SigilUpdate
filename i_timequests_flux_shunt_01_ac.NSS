#include "ff_safevar"

// i_temp_ac
/*
   Template for an Activate item script.
   This script will run each time an item's "custom activation" is used.
   
   How to use this script:
   Item needs an item property that will cause a custom activation such as Cast Spell:Unique Power
   Replace the word "temp" (in line 1) with the tag of the item.  Rename the script with this name.  
    
   Additional Info:
   In general, all the item "tag-based" scripts will be named as follows:
   - a prefix ("i_" by defualt)
   - the tag of the item
   - a postfix indicating the item event.
   
   This script will be called automatically (by defualt) whether it exists or not.  If if does not exist, nothing happens.
   
   Note: this script runs on the module object, an important consideration for assigning actions.
      -ChazM
*/
// Name_Date

const string sIsFluxShunt = "isFluxShunted";

int stringStartsWith(string s, string r)
{
	return (GetStringLeft(s, GetStringLength(r)) == r);
}

int checkIsLarvaTag(string targetTag)
{
	return stringStartsWith(targetTag, "ps_monster_larva") || stringStartsWith(targetTag, "ps_monster_2larva");
}

void main()
{
    object oPC      = GetItemActivator();
    object oItem    = GetItemActivated();
    object oTarget  = GetItemActivatedTarget();
    location lTarget = GetItemActivatedTargetLocation();

	effect eBeam = EffectBeam(VFX_BEAM_WEB_OF_PURITY, oPC, BODY_NODE_HAND);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.5);

	string targetTag = GetTag(oTarget);
	if(checkIsLarvaTag(targetTag)) {
		if(PS_GetLocalInt(oTarget, sIsFluxShunt) == 0) {
			// Flag
			PS_SetLocalInt(oTarget, sIsFluxShunt, 1);
			// Item
			CreateItemOnObject("timequests_larva_head", oTarget);
			// Rename
			SetFirstName(oTarget, "Flux-shunted Larva");
			// Flux shunt visual
			effect eVisFluxshunt = EffectVisualEffect(VFX_DUR_BLUR);
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVisFluxshunt, oTarget);
			// Random effects
			int r = Random(100);
			if(r <= 33) {
				SendMessageToPC(oPC, "You activate the flux shunt. The larva seems to move faster suddenly!");
				effect eHaste = EffectHaste();
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eHaste, oTarget);
				effect eVisHaste = EffectVisualEffect(VFX_DUR_SPELL_HASTE);
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVisHaste, oTarget);
			}
			else if (r <= 66) {
				SendMessageToPC(oPC, "You activate the flux shunt. The larva seems to move slower suddenly!");
				effect eSlow = EffectSlow();
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget);
				effect eVisSlow = EffectVisualEffect(VFX_DUR_SPELL_SLOW);
				ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVisSlow, oTarget);
			}
			else {
				SendMessageToPC(oPC, "You activate the flux shunt. The larva shows no change apart from a slight glow.");
			}
		}
		else {
			SendMessageToPC(oPC, "That larva is already flux-shunted!");
		}
	}
	else {
		SendMessageToPC(oPC, "You activate the flux shunt but it has no effect.");
	}
}