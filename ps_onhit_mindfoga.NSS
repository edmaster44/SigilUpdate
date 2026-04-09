//::///////////////////////////////////////////////
//:: Mind Fog: On Enter
//:: NW_S0_MindFogA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a bank of fog that lowers the Will save
    of all creatures within who fail a Will Save by
    -10.  Affect lasts for 2d6 rounds after leaving
    the fog
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////
//:: RPGplayer1 03/19/2008: Fixed SR check to pass AOE creator properly

#include "X0_I0_SPELLS"
#include "ps_inc_onhit" 

void main()
{

    //Declare major variables
	object oCaster = GetOnHitAbilityCaster(GetAreaOfEffectCreator());
    int nCasterLevel = PS_GetCasterLevel(oCaster);
	int nDC = GetOnHitAbilityDC(GetAreaOfEffectCreator());
	int nID = GetOnHitAbilityID(GetAreaOfEffectCreator());
    object oTarget = GetEnteringObject();
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_MIND_FOG_VIC );
    effect eLower = EffectSavingThrowDecrease(SAVING_THROW_WILL, 10);
    effect eLink = EffectLinkEffects(eVis, eLower);
	SetEffectSpellId(eLink, SPELL_MIND_FOG);
    int bValid = FALSE;
    float fDelay = GetRandomDelay(1.0, 2.2);
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_MIND_FOG));
        //Make SR check
        effect eAOE = GetFirstEffect(oTarget);
        if(GetHasSpellEffect(SPELL_MIND_FOG, oTarget))
        {
            while (GetIsEffectValid(eAOE))
            {
                //If the effect was created by the Mind_Fog then remove it
                if (GetEffectSpellId(eAOE) == SPELL_MIND_FOG && oCaster == GetEffectCreator(eAOE))
                {
                    if(GetEffectType(eAOE) == EFFECT_TYPE_SAVING_THROW_DECREASE)
                    {
                        RemoveEffect(oTarget, eAOE);
                        bValid = TRUE;
                    }
                }
                //Get the next effect on the creation
                eAOE = GetNextEffect(oTarget);
            }
        //Check if the effect has been put on the creature already.  If no, then save again
        //If yes, apply without a save.
        }
        if(bValid == FALSE)
        {
            if(!OnHitResistSpell(oCaster, oTarget))
            {
                //Make Will save to negate
                if(!OnHitSavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, oCaster))
                {
                    if (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCaster))
                        return;
					//effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
                    //Apply VFX impact and lowered save effect
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget));
					string sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> fogs the mind of "+GetName(oTarget)+"</color>";
					DelayCommand(fDelay, SendMessageToPC(oCaster, sReport));
					//ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
                }
            }
        }
        else
        {
			//effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
            //Apply VFX impact and lowered save effect
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
			//ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
        }
    }
}