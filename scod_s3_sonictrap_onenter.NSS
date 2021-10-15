//::///////////////////////////////////////////////
//:: Sonic Trap - On Enter
//:: scod_s3_sonictrap_onenter.nss
//:://////////////////////////////////////////////
/*
    Creates a trapped area on the ground that produces a sonic burst. Deals 10d8 sonic damage and stuns
	targets that fail a DC 25 will save. Damage and DC increased by craft trap (+1d8 damage and +1 DC 
	per 4 Craft Trap rank)
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
	int nDice = GetSkillAdjustedTrapDamageDice(10, oCaster, 4);
	//Base DC 21
	int nDC = GetSkillAdjustedTrapDC(21, oCaster, 4);
	int nStunDur = 5;
    int nFire = GetLocalInt(OBJECT_SELF, "scod_sonictrap");
    
	effect eStun = ExtraordinaryEffect(EffectStunned());
	effect eVis = EffectVisualEffect(VFX_HIT_AOE_SONIC);
	effect eVis2 = EffectVisualEffect(VFX_DUR_STUN);
	effect eLink = EffectLinkEffects(eStun, eVis2);
	effect eDam;
    //Check the faction of the entering object to make sure the entering object is not in the casters faction
    if(nFire == 0)
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
        {
            SetLocalInt(OBJECT_SELF, "scod_sonictrap",TRUE);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SONIC_TRAP));
			
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
			oTarget = GetFirstObjectInShape(SHAPE_SPHERE, TRAP_RADIUS, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oTarget))
            {
				if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster)){
					nDamage = d8(nDice);
		            //Set up the damage effect
		            eDam = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
					//Trigger visual regardless of if damage is done            
		            if(nDamage > 0)
		            {
		                //Apply damage effect
		                DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
						if (WillSave(oTarget, nDC, SAVING_THROW_TYPE_TRAP, oCaster) == SAVING_THROW_CHECK_FAILED && !GetIsImmune(oTarget, IMMUNITY_TYPE_STUN))  {
							 DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nStunDur)));
						}
		            }
				}
				//Get next target in the sequence
                oTarget = GetNextObjectInShape(SHAPE_SPHERE, 2.5f, lTarget, TRUE, OBJECT_TYPE_CREATURE);
			}
            DestroyObject(OBJECT_SELF, 1.0);
        }
    }
}