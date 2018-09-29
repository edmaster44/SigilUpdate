//::///////////////////////////////////////////////
//:: Balagarn's Iron Horn
//::
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Create a virbration that shakes creatures off their feet.
// Make a strength check as if caster has strength 20
// against all enemies in area
// Changes it so its not a cone but a radius.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 22 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 01, 2003

#include "X0_I0_SPELLS"
#include "ps_inc_onhit" 
#include "x2_inc_spellhook" 

void main()
{

    //Declare major variables
    object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);
    int nCasterLvl = GetCasterLevel(oCaster);
    float fDelay;
	float fMaxDelay;
    float nSize =  RADIUS_SIZE_HUGE;	
    effect eVis = EffectVisualEffect( VFX_HIT_SPELL_BALAGARN_IRON_HORN );	// NWN2 VFX
    effect eShake = EffectVisualEffect(VFX_FNF_SCREEN_BUMP);
    location lTarget = GetLocation(OBJECT_SELF);
	
    //Limit Caster level for the purposes of damage
    if (nCasterLvl > 20)
    {
        nCasterLvl = 20;
    }
	
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, OBJECT_SELF, RoundsToSeconds(d3()));
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        // * spell should not affect the caster
     	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
    	{
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, 436));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
			if (fDelay > fMaxDelay)
			{
				fMaxDelay = fDelay;
			}
			
            if (!OnHitResistSpell(oCaster, oTarget))
    	    {
                effect eTrip = EffectKnockdown();
                // * DO a strength check vs. Strength 20
				int nRoll = d20();
				int nValue = 20+d20();
                if (nRoll + GetAbilityScore(oTarget, ABILITY_STRENGTH) <= nValue)
                {
					string report = "<Color="+enemyColor+">"+GetName(oTarget)+"</color><Color="+saveColor+"> : Strength Check: *success* :("+IntToString(nRoll)+" + "+IntToString(GetAbilityScore(oTarget, ABILITY_STRENGTH))+" = "+IntToString(nRoll+GetAbilityScore(oTarget, ABILITY_STRENGTH))+")</color>";
					SendMessageToPC(oCaster, report);
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTrip, oTarget, 6.0));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					report = "<Color="+casterColor+">"+GetName(oCaster)+"</color><Color="+reportColor+"> knocks down "+GetName(oTarget)+"</color>";
					SendMessageToPC(oCaster, report);
                }
                else {
					string report = "<Color="+enemyColor+">"+GetName(oTarget)+"</color><Color="+saveColor+"> : Strength Check: *failure* :("+IntToString(nRoll)+" + "+IntToString(GetAbilityScore(oTarget, ABILITY_STRENGTH))+" = "+IntToString(nRoll+GetAbilityScore(oTarget, ABILITY_STRENGTH))+")</color>";
					SendMessageToPC(oCaster, report);
				}
             }
        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
	
	fMaxDelay += 0.5f;
	effect eCone = EffectVisualEffect( VFX_FNF_MYSTICAL_EXPLOSION );
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, OBJECT_SELF, fMaxDelay);
	DelayCommand(0.5f, ClearOnHitInfo(OBJECT_SELF));
}