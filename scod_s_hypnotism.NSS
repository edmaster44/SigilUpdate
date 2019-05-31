//::///////////////////////////////////////////////
//:: Hideous Laughter, Mass
//:: [scod_s_hideous_laughter_mass.nss]
//:://////////////////////////////////////////////
//:: Mass Tasha's Hideous Laughter
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
	
	object oCaster = OBJECT_SELF;

    location lTarget = GetLocation(oCaster);
    int nMetaMagic = GetMetaMagicFeat();
	
    int nDuration = d4(2);
    if (nMetaMagic == METAMAGIC_EXTEND) {
        nDuration = d4(4); //Duration is +100%
    }
	float fDur = RoundsToSeconds(nDuration);
	
	int maxCreatures = d4(2);
	int onlyOne = FALSE;
	if (maxCreatures <= 1)
		onlyOne = TRUE;
		
	int nDC = GetSpellSaveDC();
	
	//Explosion effect
    effect eVFX = EffectNWN2SpecialEffectFile("sp_enchantment_aoe");
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, lTarget);
	
	//enchantment hit vfx
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
	
	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(oCaster), TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget)) {
	
		if (maxCreatures <= 0)
			return;
			
		int nMod = 0;
		if (onlyOne) nMod = -2;
	
	    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) {
		
	        //Fire cast spell at event for the specified target
	        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HYPNOTISM));
	
			//You need a mind to be effected
	        if (spellsIsMindless(oTarget) == FALSE) {
			
				if (GetIsInCombat(oTarget)) {
					nMod = 2;
				}
			
	            if (!MyResistSpell(OBJECT_SELF, oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, nDC-nMod, SAVING_THROW_TYPE_MIND_SPELLS)) {
	                
					if ( !GetIsImmune(oTarget,IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF )) {
					
						effect eFasc = EffectFascinate();
						SetEffectSpellId(eFasc, SPELL_HYPNOTISM);
						ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFasc, oTarget, fDur);
					
						//Make sure being damaged breaks the spell
						SetLocalString(oTarget, "DamagedScript", "scod_s_creature_distracted");
					
	                    maxCreatures--;
	                }
					
	            } 
	        }
	    } 
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
}