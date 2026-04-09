//::///////////////////////////////////////////////
//:: Darkness: On Enter
//:: NW_S0_DarknessA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 28, 2002
//:://////////////////////////////////////////////
// ChazM 1/18/07 - EvenFlw modifications -  evenflw edited to stop AI lockups

#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "ps_inc_onhit" 

void main()
{

    effect eInvis = EffectConcealment(20, MISS_CHANCE_TYPE_NORMAL);//EffectInvisibility(INVISIBILITY_TYPE_DARKNESS);
    //effect eDark = EffectDarkness();
	object oCaster = GetOnHitAbilityCaster(GetAreaOfEffectCreator());
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
   // effect eLink = EffectLinkEffects(eDark, eDur);

    effect eLink2 =  EffectLinkEffects(eInvis, eDur);
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_EVIL);

    int nDuration = PS_GetCasterLevel(oCaster);
	
    object oTarget = GetEnteringObject();

    // * July 2003: If has darkness then do not put it on it again
    /*if (GetHasEffect(EFFECT_TYPE_DARKNESS, oTarget) == TRUE)
    {
        return;
    }*/

    if(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DARKNESS));
        }
        else
        {
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DARKNESS, FALSE));
        }
        // Creatures immune to the darkness spell are not affected.
        if ( !OnHitResistSpell(oCaster,oTarget) )
        {
            //Fire cast spell at event for the specified target
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(20));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
        }
    }
}