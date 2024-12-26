//::///////////////////////////////////////////////
//:: Horrid Wilting
//:: NW_S0_HorrWilt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All living creatures (not undead or constructs)
    suffer 1d6 damage per caster level to a maximum
    of 20d6 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 12 , 2001
//:://////////////////////////////////////////////


// (Update JLR - OEI 07/22/05) -- Changed Dmg to 1d6 per lvl
// CGaw - OEI 6/26/06 -- Changed damage cap from 25d6 to 20d6
// AFW-OEI 04/05/2007: Change from RADIUS_SIZE_HUGE (20') to RADIUS_SIZE_COLOSSAL (30')

#include "NW_I0_SPELLS"    
#include "x2_inc_spellhook" 
#include "ps_inc_onhit" 

void main()
{

    //Declare major variables
    location lTarget = GetLocation(OBJECT_SELF);
	object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);
    int nCasterLvl = PS_GetCasterLevel(oCaster);
    int nDamage;
    float fDelay;
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
    effect eDam;
	
    //Limit Caster level for the purposes of damage
    if (nCasterLvl > 20)
    {
        nCasterLvl = 20;
    }
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        // GZ: Not much fun if the caster is always killing himself
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster) && oTarget != oCaster)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_HORRID_WILTING));
            //Get the distance between the explosion and the target to calculate delay
            
            if (!OnHitResistSpell(oCaster, oTarget))
            {
                if(GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT && GetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
                {
                    //Roll damage for each target
                    nDamage = d6(nCasterLvl);	// JLR - OEI 07/22/05 -- 3.5 Change
                    if(OnHitSavingThrow(SAVING_THROW_FORT, oTarget, GetOnHitAbilityDC(OBJECT_SELF), SAVING_THROW_TYPE_NONE, oCaster, fDelay))
                    {
                        nDamage = nDamage/2;
                    }
                    //Set the damage effect
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                    // Apply effects to the currently selected target.
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					string sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> damages "+GetName(oTarget)+": "+IntToString(nDamage)+"</color>";
					SendMessageToPC(oCaster, sReport);
                }
             }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
    }
}