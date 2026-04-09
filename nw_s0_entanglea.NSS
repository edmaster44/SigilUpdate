//::///////////////////////////////////////////////
//:: Entangle B: On Exit
//:: NW_S0_EntangleB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Removes the entangle effect after the AOE dies.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 25, 2002
//:://////////////////////////////////////////////


#include "x2_inc_spellhook"

void main(){


    //Declare major variables
    object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();
	struct dSpellData data = GetSpellDataForAoE("Entangle", oCaster);
	effect eHold = EffectEntangle();
    effect eEntangle = EffectVisualEffect(VFX_DUR_ENTANGLE);
    effect eLink = EffectLinkEffects(eHold, eEntangle);
	int nDC;
	
	if (GetTag(OBJECT_SELF) == "AOE_ENTANGLE_RACIAL"){
		nDC = 10 + GetSpellLevel(SPELL_ENTANGLE) + GetAbilityModifier(ABILITY_CHARISMA, oCaster);
	} else nDC = data.nDC;
	
	if(GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE){
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)){
	
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENTANGLE));

			if(!GetHasSpellEffect(SPELL_ENTANGLE, oTarget)){
				if(!MyResistSpell(oCaster, oTarget)){
					if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC)){
					   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2));
					}
				}
			}
		}
	}
}

