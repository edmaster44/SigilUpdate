//::///////////////////////////////////////////////
//:: Corrosive Trap
//:: scod_s3_corrosivetrap.nss
//:://////////////////////////////////////////////
/*
    Creates a trapped area on the ground that unleashes a burst of corrosive acid. Deals 10d10 acid damage reduces AC by 2.
	Enemies are paralyzed for five rounds unless they make a DC 30 fortitude save. Reflex save for half damage. Reflex with
	Evasion and Improved Evasion can avoid all effects.
	Damage and DC increased by craft trap (+1d10 damage per 2 Craft Trap ranks and +1 DC per 4 Craft Trap ranks)
*/
//:://////////////////////////////////////////////
//:: Created By: SingerFromTheMist
//:: Created On: October 9, 2021
//:://////////////////////////////////////////////

#include "x2_I0_SPELLS"
#include "x2_inc_spellhook"

#include "scod_inc_trapfeats"

void main()
{
	
    //Declare major variables
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
	
	location lTarget = GetLocation(OBJECT_SELF);
	
    int nDamage;
	//Base Dice 5
	int nDice = GetSkillAdjustedTrapDamageDice(10, oCaster, 2);
	//Base DC 23
	int nDC = GetSkillAdjustedTrapDC(23, oCaster, 4);
	int nParaDur = 5;
    int nFire = PS_GetLocalInt(OBJECT_SELF, "scod_corrosivetrap");
    
	effect ePara = EffectParalyze();
	effect eACDown = ExtraordinaryEffect(EffectACDecrease(2, AC_NATURAL_BONUS));
	effect eVis = EffectVisualEffect(VFX_HIT_AOE_ACID);
	effect eVis2 = EffectVisualEffect(VFX_DUR_PARALYZED);
	effect eLink = ExtraordinaryEffect(EffectLinkEffects(ePara, eVis2));
	effect eDam;
    //Check the faction of the entering object to make sure the entering object is not in the casters faction
    if(nFire == 0)
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
        {
            PS_SetLocalInt(OBJECT_SELF, "scod_corrosivetrap",TRUE);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CORROSIVE_TRAP));
			
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
			oTarget = GetFirstObjectInShape(SHAPE_SPHERE, TRAP_RADIUS, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oTarget))
            {
				if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster)){
					nDamage = GetReflexAdjustedDamage(d10(nDice), oTarget, nDC, SAVING_THROW_TYPE_TRAP, GetAreaOfEffectCreator());
		            //Set up the damage effect
		            eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
					//Trigger visual regardless of if damage is done            
		            if(nDamage > 0)
		            {
		                //Apply damage effect
		                DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
						DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eACDown, oTarget));
						if (!GetIsImmune(oTarget, IMMUNITY_TYPE_PARALYSIS) && FortitudeSave(oTarget, nDC, SAVING_THROW_TYPE_TRAP, oCaster) == SAVING_THROW_CHECK_FAILED)  {
							 DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nParaDur)));
						}
		            }
				}
				//Get next target in the sequence
                oTarget = GetNextObjectInShape(SHAPE_SPHERE, TRAP_RADIUS, lTarget, TRUE, OBJECT_TYPE_CREATURE);
			}
            DestroyObject(OBJECT_SELF, 1.0);
        }
    }
}