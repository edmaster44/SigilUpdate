//::///////////////////////////////////////////////
//:: Blades of Fire
//:: nx2_s0_blades_of_fire.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
   	Blades of Fire
	Conjuration (Creation) [Fire]
	Level: Ranger 1, sorceror/wizard 1
	Components: V
	Range: Touch
	Targets: Up to two melee weapons you are weilding
	Duration: 2 rounds
	Saving throw: None
	Spell Resistance: None
	 
	Your melee weapons each deal an extra 1d8 points of fire damage.  
	This damage stacks with any energy damage your weapons already deal.

*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 08/28/2007
//:://////////////////////////////////////////////
//:: RPGplayer1 11/22/2008: Added support for metamagic
//:: RPGplayer1 11/22/2008: Tweaked duration, so caster can use improved weapons as long as other targets
 
#include "nwn2_inc_spells"
#include "x2_inc_spellhook"
#include "x2_inc_itemprop"
#include "ps_inc_functions"

void main()
{
    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
//	SpawnScriptDebugger();
	// Get necessary objects
	object oTarget			= GetSpellTargetObject();
	object oCaster			= OBJECT_SELF;
	object oWEAPON = IPGetTargetedOrEquippedMeleeWeapon();
	// Spell Duration
	float fDuration;
	
	if (GetLastSpellCastClass() == CLASS_TYPE_RANGER)
		fDuration = RoundsToSeconds(PS_GetCasterLevel(oCaster));
	else
		fDuration = RoundsToSeconds(2);
	
	fDuration			= ApplyMetamagicDurationMods(fDuration);
	// Effects
	itemproperty ipFire 	= ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d8);
	
	//without this, one round is lost because caster can't attack in same round he cast the spell
	if (oTarget == oCaster)
	{
		fDuration += 6.0; 
	}
	
	// Make sure spell target is valid
	if (GetIsObjectValid(oTarget))
	{
		// check to see if ally
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster)) 
		{
				//Adds the Fire Damage
				IPSafeAddItemProperty(oWEAPON, ipFire, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

			//Fire cast spell at event for the specified target
    		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
		}
	}
	
}