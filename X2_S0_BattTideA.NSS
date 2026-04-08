//::///////////////////////////////////////////////
//:: Battletide
//:: X2_S0_BattTideA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    You create an aura that steals energy from your
    enemies. Your enemies suffer a -2 circumstance
    penalty on saves, attack rolls, and damage rolls,
    once entering the aura. On casting, you gain a
    +2 circumstance bonus to your saves, attack rolls,
    and damage rolls.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Dec 04, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs 06/06/03


#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x2_i0_spells"
#include "x2_inc_spellhook"

void main()
{
	
    //Declare major variables
	int nId = GetSpellId();
	object oTarget = GetEnteringObject();
    object oCreator = GetAreaOfEffectCreator();
	
	if (oTarget == oCreator) return;
	
    effect eBad = CreateBadTideEffectsLink();
	eBad = SetEffectSpellId(eBad, nId);
   // effect eGood = CreateGoodTideEffectsLink();
	//eGood = SetEffectSpellId(eGood, nId);
	
    //effect eVis = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);	// handled by CreateBadTideEffectsLink() and CreateGoodTideEffectsLink()
    float fDelay;
	

	PS_RemoveEffects(oTarget, 517, NULL, oCreator); // cleric spell
	PS_RemoveEffects(oTarget, 963, NULL, oCreator); //warpriest
	//just in case any other racial/prcs grant this in the future
	if (GetHasSpellEffect(nId, oTarget))
		PS_RemoveEffects(oTarget, nId, NULL, oCreator); 
	
	
	

    //Check faction of spell targets.
    if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCreator))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCreator, nId));
        //Make a SR check
        if(!MyResistSpell(oCreator, oTarget))
        {
            //Make a Fort Save
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NEGATIVE))
            {
               fDelay = GetRandomDelay(0.75, 1.75);
               //Apply the VFX impact and linked effects
               //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));	// handled by CreateBadTideEffectsLink() and CreateGoodTideEffectsLink()
               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBad, oTarget));
            }
        }
    }
	// this is unneccessary. The good effects were applied to caster on intial cast
	/*
    else if(oTarget == oCreator)
    {
        //Apply the VFX impact and linked effects
        SignalEvent(oTarget, EventSpellCastAt(oCreator, GetSpellId(), FALSE));
        //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);	// handled by CreateBadTideEffectsLink() and CreateGoodTideEffectsLink()
        //ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBad, oTarget);
    }
	*/
}