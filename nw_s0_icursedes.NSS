//:: Warlock Lesser Invocation: Curse of Despair
//:: nw_s0_icursedes.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/12/05
//::////////////////////////////////////////////////
/*
        5.7.2.4	Curse of Despair
        Complete Arcane, pg. 132
        Spell Level:	4
        Class: 		Misc

        This is the equivalent to the Bestow Curse spell (4th level wizard). 
        But even if the target makes their save, 
        they still suffer a -1 penalty to hit for 10 rounds.

*/
// RPGplayer1 02/04/2009: Made SpellCastAt event pass proper caster, so that caster drops invisibility as he should
/*
rapsam2003 03/16/2018: Remove save against NPCs
	and Hexer feats reduce the AC of the target.
Mimifearthegn 8/16/2020 - changing this to "Dreaful Aura" (aura of despair)
*/

#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "srcalc"

void main()
{
    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
	
	object oTarget = OBJECT_SELF; //caster
	SendMessageToPC(oTarget, "casting dreadful aura");

	// Strip any Auras first
	effect eTest = GetFirstEffect(oTarget);
	while(GetIsEffectValid(eTest))
	{
		if (GetEffectType(eTest) == EFFECT_TYPE_AREA_OF_EFFECT && GetEffectSpellId(eTest) == SPELLABLILITY_AURA_OF_DESPAIR)
		{
			RemoveEffect(oTarget, eTest);
		}
		eTest = GetNextEffect(oTarget);
	}
	
	// strip any extra aura objects, but not from other blackguards
	object o = GetFirstObjectInArea(GetArea(oTarget));
	while(GetIsObjectValid(o))
	{
		if (GetObjectType(o)==OBJECT_TYPE_AREA_OF_EFFECT)
		{
			//SpeakString("FOUND AOE OBJECT WITH SPELL ID: "+IntToString(GetAreaOfEffectSpellId(o)));
			if (  GetAreaOfEffectSpellId(o)==SPELLABLILITY_AURA_OF_DESPAIR && GetAreaOfEffectCreator(o) == oTarget )
			{
				//SpeakString("FOUND/DESTROY OLD AOE OBJECT");
				DestroyObject(o);
			}
		}	
		o = GetNextObjectInArea(GetArea(oTarget));
	}
	
	
	
	effect eAOE = EffectAreaOfEffect(AOE_PER_AURA_OF_DESPAIR);
	SetEffectSpellId(eAOE, SPELLABLILITY_AURA_OF_DESPAIR);
	
	//Create an instance of the AOE Object using the Apply Effect function
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABLILITY_AURA_OF_DESPAIR, FALSE));
	DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oTarget));
}