//::///////////////////////////////////////////////
//:: Dragon Fire Trap On Enter
//:: scod_s3_firetrap_onenter.nss
//:://////////////////////////////////////////////
/*
    When triggered, all hostiles in the area of effect receive 10d8 points of fire damage and are knockeddown for one
	round. A successful reflex save (DC 18) reduces the damage by half and negates the knockdown. The knockdown 
	duration is increased by one round per five levels of Arcane Trickster (for a maxium of 3 rounds). 
	The damage and DC of the trap are increased by the Craft Trap skill at a rate of +1d8 damage per 2 points 
	and +1 DC per 5 points. The DC is further increased by the users casting attribute modifier.
*/
//:://////////////////////////////////////////////
//:: Created By: SingerFromTheMist
//:: Created On: October 15, 2021
//:://////////////////////////////////////////////

#include "x2_I0_SPELLS"
#include "x2_inc_spellhook"

#include "scod_inc_trapfeats"

void main()
{
	
    //Declare major variables
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
	
	location lTarget = GetLocation(oTarget);
	
    int nDamage;
	int nOrgDamage;
	//Base Dice 10
	int nDice = GetSkillAdjustedTrapDamageDice(10, oCaster, 2);
	//Base DC 18
	int nDC = GetSkillAdjustedTrapDC(18, oCaster, 5) + GetATTrapAbilityModifier(oCaster);
	int nKDDur = 1 + (GetArcaneTricksterLevels(oCaster) / 5);
    int nFire = GetLocalInt(OBJECT_SELF, "scod_firetrap");
    
	effect eVisTarget = EffectVisualEffect(VFX_IMP_FLAME_M);
	effect eVisArea = EffectVisualEffect(VFX_HIT_SPELL_FLAMESTRIKE);
	effect eVisArea2 = EffectVisualEffect(VFX_HIT_AOE_FIRE);
	effect eVisLink = EffectLinkEffects(eVisArea, eVisArea2);
	effect eKnockdown = EffectKnockdown();
	effect eDam;
    //Check the faction of the entering object to make sure the entering object is not in the casters faction
    if(nFire == 0)
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
        {
            SetLocalInt(OBJECT_SELF, "scod_firetrap",TRUE);

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ELEMENTAL_TRAP_FIRE));
			
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisLink, GetLocation(OBJECT_SELF));
			oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oTarget))
            {
				if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster)){
					nDamage = d8(nDice);
		            //Change damage according to Reflex, Evasion and Improved Evasion
					nOrgDamage = nDamage;
		            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_TRAP, GetAreaOfEffectCreator());
		            //Set up the damage effect
		            eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
					//Trigger visual regardless of if damage is done
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisTarget, oTarget);            
		            if(nDamage > 0)
		            {
		                //Apply damage effect
		                DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
						if (GetReflexFailed(oTarget, nOrgDamage, nDamage) && !GetIsImmune(oTarget, IMMUNITY_TYPE_KNOCKDOWN)) {
							DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, RoundsToSeconds(nKDDur)));
						}
		            }
				}
				//Get next target in the sequence
                oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
			}
            DestroyObject(OBJECT_SELF, 1.0);
        }
    }
}