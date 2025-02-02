//::///////////////////////////////////////////////
//:: Dirge: On Enter
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "ps_inc_onhit" 

void main()
{
	object oCaster = GetOnHitAbilityCaster(GetAreaOfEffectCreator());
    object oTarget = GetEnteringObject();
	int nDC = GetOnHitAbilityDC(GetAreaOfEffectCreator());
	int nID = GetOnHitAbilityID(GetAreaOfEffectCreator());
    if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE,oCaster))
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(oCaster,nID));
        //Spell resistance check
        if(!OnHitResistSpell(oCaster, oTarget))
        {

            //Make a Fortitude Save to avoid the effects of the movement hit.
            if(!OnHitSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_ALL, oCaster))
            {
                int nGetLastPenalty = PS_GetLocalInt(oTarget, "X0_L_LASTPENALTY");
                // * increase penalty by 2
                nGetLastPenalty = nGetLastPenalty + 2;

                effect eStr = EffectAbilityDecrease(ABILITY_STRENGTH, nGetLastPenalty);
                effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, nGetLastPenalty);
                //change from sonic effect to bard song...
                //effect eVis =    EffectVisualEffect(VFX_HIT_SPELL_EVOCATION);	// NWN1 VFX
                effect eVis =    EffectVisualEffect( VFX_HIT_SPELL_SONIC );	// NWN2 VFX
                effect eLink = EffectLinkEffects(eDex, eStr);
				string report = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> drains the abilities of "+GetName(oTarget)+"</color>";
				SendMessageToPC(oCaster, report);

                //Apply damage and visuals
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                PS_SetLocalInt(oTarget, "X0_L_LASTPENALTY", nGetLastPenalty);
            }

        }
    }
}