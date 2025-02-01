//::///////////////////////////////////////////////
//:: Spike Trap On Enter
//:: scod_s3_spiketrap_onenter.nss
//:://////////////////////////////////////////////
/*
    Creates a trapped area on the ground that will deal 5d6 + 1d6 per two ranks of craft trap damage to 
	an enemy when triggered.
*/
//:://////////////////////////////////////////////
//:: Created By: SingerFromTheMist
//:: Created On: August 22, 2021
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
	int nOrgDamage;
	//Base Dice 5
	int nDice = GetSkillAdjustedTrapDamageDice(5, oCaster, 2);
	//Base DC 15
	int nDC = GetSkillAdjustedTrapDC(15, oCaster, 4);
	int nSlowDur = 5;
    int nFire = PS_GetLocalInt(OBJECT_SELF, "scod_spiketrap");
    
	effect eSlow = ExtraordinaryEffect(EffectSlow());
	effect eVis = EffectVisualEffect(VFX_IMP_SPIKE_TRAP);
	effect eVis2 = EffectVisualEffect(VFX_DUR_SPELL_SLOW);
	effect eLink = EffectLinkEffects(eSlow, eVis2);
	effect eDam;
    //Check the faction of the entering object to make sure the entering object is not in the casters faction
    if(nFire == 0)
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
        {
            PS_SetLocalInt(OBJECT_SELF, "scod_spiketrap",TRUE);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SPIKE_TRAP));
			
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
			oTarget = GetFirstObjectInShape(SHAPE_SPHERE, TRAP_RADIUS, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oTarget))
            {
				if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster)){
					nDamage = d6(nDice);
		            //Change damage according to Reflex, Evasion and Improved Evasion
					nOrgDamage = nDamage;
		            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_TRAP, GetAreaOfEffectCreator());
		            //Set up the damage effect
		            eDam = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING);
					//Trigger visual regardless of if damage is done            
		            if(nDamage > 0)
		            {
		                //Apply damage effect
		                DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
						if (GetReflexFailed(oTarget, nOrgDamage, nDamage) && !GetIsImmune(oTarget, IMMUNITY_TYPE_SLOW)) {
							 DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nSlowDur)));
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