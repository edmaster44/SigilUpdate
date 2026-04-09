//::///////////////////////////////////////////////
//:: [Fear]
//:: [NW_S0_Fear.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Causes an area of fear that reduces Will Saves
//:: and applies the frightened effect.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 23, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 30, 2001

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook" 
#include "ps_inc_onhit" 

void main()
{

    //Declare major variables
	object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);
    int nCasterLevel = PS_GetCasterLevel(oCaster);
    float fDuration = RoundsToSeconds(nCasterLevel);
    int nDamage;
    //effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);	// NWN1 VFX
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_FEAR );	// NWN2 VFX
    effect eFear = EffectFrightened();
	eFear = EffectLinkEffects( eFear, eVis );
    float fDelay;

    object oTarget;
    //Get first target in the spell cone
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), TRUE);
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
    	{
            fDelay = GetRandomDelay();
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_FEAR));
            //Make SR Check
            if(!OnHitResistSpell(oCaster, oTarget))
            {
                //Make a will save
				if (!MySavingThrow(SAVING_THROW_WILL, oTarget, GetOnHitAbilityDC(OBJECT_SELF), SAVING_THROW_TYPE_FEAR, oCaster, 0.1f, 54))
                {
                    //Apply the linked effects and the VFX impact
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFear, oTarget, fDuration));
					string report = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> frightens "+GetName(oTarget)+"</color>";
					DelayCommand(fDelay, SendMessageToPC(oCaster, report));
                }
            }
        }
        //Get next target in the spell cone
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), TRUE);
    }
}