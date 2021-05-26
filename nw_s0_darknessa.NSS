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

void main()
{

    int nMetaMagic = GetMetaMagicFeat();
    effect eInvis = EffectConcealment(20, MISS_CHANCE_TYPE_NORMAL);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_EVIL);

    effect eLink2 =  EffectLinkEffects(eInvis, eDur);
	SetEffectSpellId(eLink2, SPELL_DARKNESS); 
	
    effect eBlindness = EffectBlindness();
	SetEffectSpellId(eBlindness, SPELL_DARKNESS); 

    int nDuration = GetCasterLevel(OBJECT_SELF);
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND) {
        nDuration = nDuration *2; //Duration is +100%
    }
	
    object oTarget = GetEnteringObject();

    if(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        }
        else
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
        }
		
        // Creatures immune to the darkness spell are not affected.
		if (GetIsEnemy(oTarget, OBJECT_SELF)) {
	        if ( ResistSpell(OBJECT_SELF,oTarget) != 2 )
	        {
	            //Fire cast spell at event for the specified target
	            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlindness, oTarget, RoundsToSeconds(20));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
	        }
		} else {
	     	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(20));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
		}
    }
}