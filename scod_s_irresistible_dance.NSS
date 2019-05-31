//::///////////////////////////////////////////////
//:: Otto's Irresistible Dance
//:: [scod_s_irresistible_dance.nss]
//:://////////////////////////////////////////////
//:: Target is forced to dance for 1d4+1 rounds
//:://////////////////////////////////////////////
//:: Mimi Fearthegn
//:: Created: 2-10-2019
//:://////////////////////////////////////////////
#include "ps0_newspells_inc"
#include "ps_inc_equipment"
#include "x2_inc_spellhook"

void main() {

	//Spellhook script
    if (!X2PreSpellCastCode()) {
        return;
    }

	//debug code to make sure we got here
	object oCaster = OBJECT_SELF;
	
    //Declare major variables
    object oTarget = GetSpellTargetObject();

	//Extend Metamagic
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = d4()+1;
    //check meta magic for extend
    if (nMetaMagic == METAMAGIC_EXTEND) {
        nDuration = d4(2)+2;
    }
	
	//-4 AC
    effect eDanceEffects = EffectACDecrease(4);
	
	//No AC from shield
	int nShieldAC = GetACProvidedByShield(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget));
	if (nShieldAC > 0) {
		effect eShieldRemove = EffectACDecrease(nShieldAC, AC_SHIELD_ENCHANTMENT_BONUS);
		eDanceEffects = EffectLinkEffects(eShieldRemove, eDanceEffects);
	}
	
	//-10 to Reflex
	effect eReflexDecrease = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, 10);
	eDanceEffects = EffectLinkEffects(eReflexDecrease, eDanceEffects);
	
	//VFX
    effect eVisual = EffectNWN2SpecialEffectFile("fx_irresistible_dance");
    effect eFinal = EffectLinkEffects(eDanceEffects, eVisual);
	eFinal = EffectLinkEffects(eDanceEffects, EffectCutsceneParalyze());
	eFinal = SetEffectSpellId(eFinal, SPELL_IRRESISTIBLE_DANCE);
	
    
    //Make sure the target is an enemy
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) {
	
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_IRRESISTIBLE_DANCE));
               
		//Make SR check
        if (!MyResistSpell(OBJECT_SELF, oTarget)) {
			//Apply the effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFinal, oTarget, RoundsToSeconds(nDuration));		
			//Apply the animations
			PS_Spell_IrresistibleDance(oTarget);
		}
    }
}