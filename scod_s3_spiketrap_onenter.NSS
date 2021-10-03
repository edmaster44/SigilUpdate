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

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

    //Declare major variables
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
	int nCraftTrap = GetSkillRank(SKILL_CRAFT_TRAP, oCaster,FALSE);
    location lTarget = GetLocation(OBJECT_SELF);
	int nDice;
    int nDamage;
	int nBaseDC = 15;
	int nDC;
    int nFire = GetLocalInt(OBJECT_SELF, "scod_spiketrap");
    effect eVis = EffectVisualEffect(VFX_IMP_SPIKE_TRAP);
    //Check the faction of the entering object to make sure the entering object is not in the casters faction
    if(nFire == 0)
    {
        //if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
        {
			effect eDam;
            SetLocalInt(OBJECT_SELF, "scod_spiketrap",TRUE);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, 1708));
			
			//Damage is 5d6 + 1d6 per 2 modified ranks of craft trap
			//This will result in a total of 25d6-30d6 for someone who goes all in. (default deadly spike trap is 25d6)
            nDice = 5 + nCraftTrap / 2;
			nDamage = d6(nDice);
			// DC is 15 + 1/4 Craft Trap
			nDC = nBaseDC + nCraftTrap / 4;
            //Change damage according to Reflex, Evasion and Improved Evasion
            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_TRAP, GetAreaOfEffectCreator());
            //Set up the damage effect
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING);
			//Trigger visual regardless of if damage is done            
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
            if(nDamage > 0)
            {
                //Apply damage effect
                DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            }
            DestroyObject(OBJECT_SELF, 1.0);
        }
    }
}