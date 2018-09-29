//::///////////////////////////////////////////////
//:: Incendiary Cloud
//:: NW_S0_IncCloud.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Person within the AoE take 4d6 fire damage
    per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: March 2003: Removed movement speed penalty
#include "X0_I0_SPELLS"
#include "ps_inc_onhit" 

void main()
{
    int nDamage;
    effect eDam;
    object oTarget;
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
    float fDelay;
    //Capture the first target object in the shape.
    oTarget = GetEnteringObject();
    //Declare the spell shape, size and the location.
	object oCaster = GetOnHitAbilityCaster(GetAreaOfEffectCreator());
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE,oCaster))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_INCENDIARY_CLOUD));
        //Make SR check, and appropriate saving throw(s).
       // if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget, fDelay))
      //  {
            fDelay = GetRandomDelay(0.5, 2.0);
            //Roll damage.
            nDamage = d6(4);
			
            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetOnHitAbilityDC(GetAreaOfEffectCreator()), SAVING_THROW_TYPE_FIRE, oCaster);
            // Apply effects to the currently selected target.
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
            if(nDamage > 0)
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				string sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> damages "+GetName(oTarget)+": "+IntToString(nDamage)+"</color>";
				DelayCommand(fDelay, SendMessageToPC(oCaster, sReport));
            }
       // }
    }
}