//::///////////////////////////////////////////////
//:: Sunburst
//:: X0_S0_Sunburst
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Brilliant globe of heat
// All creatures in the globe are blinded and
// take 6d6 damage
// Undead creatures take 1d6 damage (max 25d6)
// The blindness is permanent unless cast to remove it
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 23 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 14, 2003
//:: Notes: Changed damage to non-undead to 6d6
//:: 2003-10-09: GZ Added Subrace check for vampire special case, bugfix

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "ps_inc_onhit" 

float nSize =  RADIUS_SIZE_COLOSSAL;

void main()
{
    //Declare major variables
    location lTarget = GetLocation(OBJECT_SELF);
	object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);
    int nCasterLvl = PS_GetCasterLevel(oCaster);
	int nDC = GetOnHitAbilityDC(OBJECT_SELF);
	int nID = GetOnHitAbilityID(OBJECT_SELF);
    int nDamage = 0;
    int nOrgDam = 0;
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
    effect eHitVis = EffectVisualEffect( VFX_HIT_SPELL_HOLY );
    effect eLOS = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
    effect eDam;
	
    //Limit Caster level for the purposes of damage
    if (nCasterLvl > 25)
    {
        nCasterLvl = 25;
    }
	
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eLOS, lTarget);
    int bDoNotDoDamage = FALSE;


    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SUNBURST));
            //This visual effect is applied to the target object not the location as above.  This visual effect
            //represents the flame that erupts on the target not on the ground.
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHitVis, oTarget);

            if (!OnHitResistSpell(oCaster, oTarget))
            {
                if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
                {
                    //Roll damage for each target
                    nDamage = MaximizeOrEmpower(6, nCasterLvl, 0);
                }
                else
                {
                    nDamage = MaximizeOrEmpower(6, 6, 0);
               	}

                //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                nOrgDam = nDamage;
                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_SPELL);

                // * if a vampire then destroy it
                if ( GetAppearanceType(oTarget) == APPEARANCE_TYPE_VAMPIRE_MALE || GetAppearanceType(oTarget) == APPEARANCE_TYPE_VAMPIRE_FEMALE /*|| GetStringLowerCase(GetSubRace(oTarget)) == "vampire"*/ )
                {
                    // SpeakString("I vampire");
                    // * if reflex saving throw fails no blindness
                    //if (!ReflexSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SPELL))
                    if (nDamage == nOrgDam || ( nDamage > 0 && GetHasFeat(FEAT_IMPROVED_EVASION, oTarget) ))
                    {
                        effect eDead = EffectDamage(GetCurrentHitPoints(oTarget));
                        //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_M), oTarget);

                        //Apply epicenter explosion on caster
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplode, oTarget);

                        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDead, oTarget));
						string sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> kills "+GetName(oTarget)+"</color>";
						DelayCommand(0.5, SendMessageToPC(oCaster, sReport));
                        bDoNotDoDamage = TRUE;
                    }
                }
                //if (bDoNotDoDamage == FALSE)
                //    Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                //    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SPELL);

                // * Do damage
                if ((nDamage > 0) && (bDoNotDoDamage == FALSE))
                {
                    //Set the damage effect
                    eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);

                    // Apply effects to the currently selected target.
                    DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					string sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> damages "+GetName(oTarget)+": "+IntToString(nDamage)+"</color>";
					SendMessageToPC(oCaster, sReport);

                     // * if reflex saving throw fails apply blindness
                    //if (!ReflexSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_SPELL))
                    if (nDamage == nOrgDam || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
                    {
                        effect eBlindness = EffectNewBlindness();
                        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBlindness, oTarget);
						string sReport = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> blinds "+GetName(oTarget)+"</color>";
						DelayCommand(fDelay, SendMessageToPC(oCaster, sReport));
                    }
                } // nDamage > 0
             }

             //-----------------------------------------------------------------
             // GZ: Bugfix, reenable damage for next object
             //-----------------------------------------------------------------
             bDoNotDoDamage = FALSE;
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}