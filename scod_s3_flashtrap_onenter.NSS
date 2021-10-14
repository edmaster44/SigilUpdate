//::///////////////////////////////////////////////
//:: Flash Trap - On Enter
//:: scod_s3_flashtrap_onenter.nss
//:://////////////////////////////////////////////
/*
    Creates a trapped area on the ground that produces a bright explosion upon being triggered.
	Enemies in the area of effect must succeed in a fortitude save or be blinded for five rounds.
	The save and duration are increased by 1 per four ranks of craft trap.
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
	
	int nCraftTrap = GetSkillRank(SKILL_CRAFT_TRAP, oCaster,FALSE);
	//Base DC 19
	int nDC = GetSkillAdjustedTrapDC(19, nCraftTrap, 4);
	//Base duration 5
	int nBlindDur = GetSkillAdjustedTrapDC(5, nCraftTrap, 4);
    int nFire = GetLocalInt(OBJECT_SELF, "scod_flashtrap");
    
	effect eBlind = ExtraordinaryEffect(EffectBlindness());
	effect eDetVis = EffectVisualEffect(VFX_HIT_AOE_HOLY);
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_BLIND_DEAF);
	effect eLink = EffectLinkEffects(eBlind, eVis);
    //Check the faction of the entering object to make sure the entering object is not in the casters faction
    if(nFire == 0)
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
        {
            SetLocalInt(OBJECT_SELF, "scod_flashtrap",TRUE);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_FLASH_TRAP));
			
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eDetVis, lTarget);
			oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 2.8f, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oTarget))
            {
				if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster) && !GetIsImmune(oTarget, IMMUNITY_TYPE_BLINDNESS)){
					if (FortitudeSave(oTarget, nDC, SAVING_THROW_TYPE_TRAP, oCaster) == SAVING_THROW_CHECK_FAILED)  {
						 DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nBlindDur)));
					}
				}
				//Get next target in the sequence
                oTarget = GetNextObjectInShape(SHAPE_SPHERE, 2.5f, lTarget, TRUE, OBJECT_TYPE_CREATURE);
			}
            DestroyObject(OBJECT_SELF, 1.0);
        }
    }
}