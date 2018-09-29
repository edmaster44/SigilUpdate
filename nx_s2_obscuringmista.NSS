//////////////////////////////////////////////
// On Enter script for Obscuring Mist AOE	//
// Ceremorph 4/26/16						//
//////////////////////////////////////////////

#include "x0_i0_spells"
#include "x2_inc_spellhook"

void main()
{
    object oTarget = GetEnteringObject();	
	object oCreator = GetAreaOfEffectCreator();
	int oCreatorLevels = GetHitDice(oCreator);
	effect eConceal;
	
	if (oTarget == oCreator)
	{	eConceal = EffectConcealment(50);	}
	else
	{	eConceal = EffectConcealment(10 + FloatToInt(IntToFloat(oCreatorLevels)/2));	}
	
    effect eDur   = EffectVisualEffect(VFX_DUR_SPELL_SHROUDING_FOG);
    effect eLink = EffectLinkEffects(eConceal, eDur);

    if(GetIsObjectValid(oTarget))
    {	SignalEvent(oTarget, EventSpellCastAt(oCreator, 1248, FALSE));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);	}
}