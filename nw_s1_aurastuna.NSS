//::///////////////////////////////////////////////
//:: Aura Stunning On Enter
//:: NW_S1_AuraStunA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the player
    must make a will save or be stunned.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
	object oCaster = GetAreaOfEffectCreator();
	int nHD = GetHitDice(oCaster);
    object oTarget = GetEnteringObject();
    effect eVis = EffectVisualEffect( VFX_HIT_SPELL_ENCHANTMENT );
    effect eVis2 = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
    effect eDeath = EffectStunned();
    effect eLink = EffectLinkEffects(eVis2, eDeath);
    int nDuration = d4(2);
    int nDC = 10 + nHD / 3;
    nDuration = GetScaledDuration(nDuration, oTarget);
	
	effect eImm = EffectSpellImmunity(202);
	eImm = ExtraordinaryEffect(eImm);
	
	if(!GetIsFriend(oTarget))
	{
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELLABILITY_AURA_STUN));
        //Make a saving throw check
        if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
        {
            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
		else 
		{		
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImm, oTarget, RoundsToSeconds(10));
		}
    }
}