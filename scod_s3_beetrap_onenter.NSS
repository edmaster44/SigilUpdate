//::///////////////////////////////////////////////
//:: Bee Trap - On Enter
//:: scod_s3_beetrap_onenter.nss
//:://////////////////////////////////////////////
/*
    Creates a trapped area on the ground that will deal 1d6 + 1d6 per four ranks of craft trap damage per round
	to effected enemies. They must also make a will save or become confused. Lasts 5 rounds by default.
*/
//:://////////////////////////////////////////////
//:: Created By: SingerFromTheMist
//:: Created On: October 9, 2021
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

#include "scod_inc_trapfeats"

// Applies the trap damage over time.
// - oTarget
// - nDice: The number of damage dice to roll
// - nDuration: The number of remaining rounds in the DOT
void ApplyTrapDOT(object oTarget, int nDice, object oCaster);

// Constructs, Undead, Elementals, and Ooze aren't really gonna care about bees
int GetBeeVulnerable(object oTarget);

void main()
{
	
    //Declare major variables
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
	
	location lTarget = GetLocation(OBJECT_SELF);

    int nDamage;
	int nOrgDamage;
	//Base Dice 1
	int nDice = GetSkillAdjustedTrapDamageDice(1, oCaster, 4);
	//Base DC 17
	int nDC = GetSkillAdjustedTrapDC(17, oCaster, 4);
	int nDuration = 5;
    int nFire = GetLocalInt(OBJECT_SELF, "scod_beetrap");
    
	effect eVis = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_NATURE);
	effect eVis2 = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_SPELL_CREEPING_DOOM));
	effect eVis3 = EffectVisualEffect(VFX_DUR_SPELL_CONFUSION);
	effect eLink = ExtraordinaryEffect(EffectLinkEffects(EffectConfused(), eVis3));
    //Check the faction of the entering object to make sure the entering object is not in the casters faction
    if(nFire == 0)
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
        {
            SetLocalInt(OBJECT_SELF, "scod_beetrap",TRUE);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BEE_TRAP));
			
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
			oTarget = GetFirstObjectInShape(SHAPE_SPHERE, TRAP_RADIUS, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oTarget))
            {
				if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster) && GetBeeVulnerable(oTarget)){
					ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis2, oTarget, RoundsToSeconds(nDuration));
					ApplyTrapDOT(oTarget, nDice, oCaster);
					if (WillSave(oTarget, nDC, SAVING_THROW_TYPE_TRAP, oCaster) == SAVING_THROW_CHECK_FAILED) {
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));	
					}
				}
				//Get next target in the sequence
                oTarget = GetNextObjectInShape(SHAPE_SPHERE, TRAP_RADIUS, lTarget, TRUE, OBJECT_TYPE_CREATURE);
			}
        }
    }
}

void ApplyTrapDOT(object oTarget, int nDice, object oCaster) {
	if (GetIsDead(oTarget) == FALSE) {
		int nDamage = d6(nDice);
		effect eDamage = EffectDamage(nDamage, IP_CONST_DAMAGETYPE_PIERCING);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
		DelayCommand(6.0f,ApplyTrapDOT(oTarget, nDice, oCaster)); 
	}
}

int GetBeeVulnerable(object oTarget) {
	int nRacial = GetRacialType(oTarget);
	return !(nRacial == RACIAL_TYPE_CONSTRUCT || nRacial == RACIAL_TYPE_ELEMENTAL || nRacial == RACIAL_TYPE_UNDEAD || nRacial == RACIAL_TYPE_OOZE);
}