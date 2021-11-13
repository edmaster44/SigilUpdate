//::///////////////////////////////////////////////
//:: Heavenly Thunder Trap On Enter
//:: scod_s3_electricaltrap_onenter.nss
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
	//Base Dice 10
	int nDice = GetSkillAdjustedTrapDamageDice(10, oCaster, 2);
	//Base DC 20
	int nDC = GetSkillAdjustedTrapDC(18, oCaster, 5) + GetATTrapAbilityModifier(oCaster);
    int nFire = GetLocalInt(OBJECT_SELF, "scod_electricaltrap");
	int nOrgDamage;
	int nElecDamage;
	int nDivineDamage;
	int nATLevels = GetArcaneTricksterLevels(oCaster);
	    
	effect eVisTarget = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
	effect eVisTargetDiv = EffectVisualEffect(VFX_HIT_SPELL_HOLY);
	effect eVisTarget2 = EffectVisualEffect(VFX_SPELL_HIT_CALL_LIGHTNING);
	effect eVisArea = EffectVisualEffect(VFX_IMP_PULSE_HOLY);
	effect eDamShock;
	effect eShockLink;
	effect eDamDiv;
	effect eDivLink;
    //Check the faction of the entering object to make sure the entering object is not in the casters faction
    if(nFire == 0)
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
        {
            SetLocalInt(OBJECT_SELF, "scod_electricaltrap",TRUE);

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ELEMENTAL_TRAP_LIGHTNING));
			
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVisArea, GetLocation(OBJECT_SELF));
			oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oTarget))
            {
				if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster)){
					nElecDamage = d8(nDice);
					nDivineDamage = d8(nATLevels);
					nDamage = nElecDamage + nDivineDamage;
					nOrgDamage = nDamage;
		            //Change damage according to Reflex, Evasion and Improved Evasion
		            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_TRAP, GetAreaOfEffectCreator());
					if (nDamage < nOrgDamage) {
						nElecDamage = nElecDamage / 2;
						nDivineDamage = nDivineDamage / 2;
					}
		            //Set up the damage effect
		            eDamShock = EffectDamage(nElecDamage, DAMAGE_TYPE_ELECTRICAL);
					eDamDiv = EffectDamage(nDivineDamage, DAMAGE_TYPE_DIVINE);
					//Trigger visual regardless of if damage is done
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisTarget2, oTarget);
					DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisTarget, oTarget));       
		            if(nDamage > 0)
		            {
		                //Apply damage effect
						eShockLink = EffectLinkEffects(eVisTarget, eDamShock);
						eDivLink = EffectLinkEffects(eVisTargetDiv, eDamDiv);
		                DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eShockLink, oTarget));
						DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDivLink, oTarget));
		            }
				}
				//Get next target in the sequence
                oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
			}
            DestroyObject(OBJECT_SELF, 1.0);
        }
    }
}