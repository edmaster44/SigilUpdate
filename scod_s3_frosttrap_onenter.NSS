//::///////////////////////////////////////////////
//:: Deathchill Trap On Enter
//:: scod_s3_frosttrap_onenter.nss
//:://////////////////////////////////////////////
/*
    TODO
*/
//:://////////////////////////////////////////////
//:: Created By: SingerFromTheMist
//:: Created On: October 24, 2021
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
	//Base Dice 6
	int nDice = GetSkillAdjustedTrapDamageDice(6, oCaster, 4);
	//Base DC 20
	int nDC = GetSkillAdjustedTrapDC(18, oCaster, 5) + GetATTrapAbilityModifier(oCaster);
    int nFire = GetLocalInt(OBJECT_SELF, "scod_frosttrap");
	int nATLevels = GetArcaneTricksterLevels(oCaster);
	int nLevelDrain = nATLevels / 2;
	if (nLevelDrain < 1) {
		nLevelDrain = 1;
	}
    
	effect eVisTarget = EffectVisualEffect(VFX_IMP_FROST_L);
	effect eVisArea = EffectVisualEffect(VFX_HIT_AOE_ICE);
	effect eVisArea2 = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
	effect eVisLink = EffectLinkEffects(eVisArea, eVisArea2);
	effect eLevelDrain = EffectNegativeLevel(nLevelDrain);
	effect eVisDrain = EffectVisualEffect(VFX_DUR_SPELL_ENERGY_DRAIN);
	effect eDrainLink = EffectLinkEffects(eVisDrain, eLevelDrain);
	effect eDam;
    //Check the faction of the entering object to make sure the entering object is not in the casters faction
    if(nFire == 0)
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
        {
            SetLocalInt(OBJECT_SELF, "scod_frosttrap",TRUE);

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ELEMENTAL_TRAP_ICE));
			
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisLink, GetLocation(OBJECT_SELF));
			oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oTarget))
            {
				if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster)){
					nDamage = d8(nDice);
		            //Set up the damage effect
		            eDam = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
					//Trigger visual regardless of if damage is done
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisTarget, oTarget);            
		            if(nDamage > 0)
		            {
		                //Apply damage effect
		                DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
						if (!GetIsImmune(oTarget, IMMUNITY_TYPE_NEGATIVE_LEVEL) && FortitudeSave(oTarget, nDC, SAVING_THROW_TYPE_TRAP, oCaster) == SAVING_THROW_CHECK_FAILED) {
							DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDrainLink, oTarget));
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