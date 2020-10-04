//::///////////////////////////////////////////////
//:: Hungry Darkness: On Enter
//:: scod_s_hgrydarkness_one.nss
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness that provides concealment to friends
	and eats enemies
*/
//:://////////////////////////////////////////////
//:: Created By: Mimi Fearthegn
//:: Created On: 8/11/2020
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "x2_inc_spellhook"

void main()
{

    int nMetaMagic = GetMetaMagicFeat();
    effect eInvis = EffectConcealment(20, MISS_CHANCE_TYPE_NORMAL);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink2 =  EffectLinkEffects(eInvis, eDur);
	SetEffectSpellId(eLink2, 821); 
	
    effect eBlindness = EffectBlindness();
	SetEffectSpellId(eBlindness, 821); 
	
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_EVIL);

    int nDuration = GetCasterLevel(OBJECT_SELF);
    object oTarget = GetEnteringObject();
	object oCaster =  GetAreaOfEffectCreator();
	
    if(GetIsObjectValid(oTarget))
    {
        if (GetIsEnemy(oTarget, oCaster)) {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
			
			//If you're an enemy, you get blinded!
		    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlindness, oTarget, RoundsToSeconds(20));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
        } else {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
			
			//If you're a friendly, you get concealment!
		    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(20));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
        }
		
    }
}