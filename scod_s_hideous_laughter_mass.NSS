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
	
	//Debug message
	object oCaster = GetLastSpellCaster();

    location lTarget = GetSpellTargetLocation();
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
	
    int nDuration = nCasterLvl;
    if (nMetaMagic == METAMAGIC_EXTEND) {
        nDuration = nDuration *2; //Duration is +100%
    }
	
	//Explosion effect
    effect eExplosion = EffectNWN2SpecialEffectFile("fx_kos_explosion");
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplosion, lTarget);
	
	//laughter vfx
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
	
	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget)) {
	
	    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) {
		
	        //Fire cast spell at event for the specified target
	        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MASS_HIDEOUS_LAUGHTER));
	
			//You need a mind to be effected
	        if (spellsIsMindless(oTarget) == FALSE) {
			
	            if (!MyResistSpell(OBJECT_SELF, oTarget) && !MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
	            {
	                if ( !GetIsImmune(oTarget,IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF ))
	                {
	                    effect eDur = EffectVisualEffect( VFX_DUR_SPELL_TASHA_LAUGHTER );
	                    float fDur = RoundsToSeconds(nDuration);
	                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
						
	                    AssignCommand(oTarget, ClearAllActions());
	                    //AssignCommand(oTarget, PlayVoiceChat(VOICE_CHAT_LAUGH));
						if (GetGender(oTarget) == GENDER_FEMALE)
							PlaySound("as_pl_laughingf1");
						else
							PlaySound("as_pl_laughingm1");
	                    AssignCommand(oTarget, ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING));
	                    effect eLaugh = EffectKnockdown();
	                    eLaugh = EffectLinkEffects(eLaugh, eDur);
	                    DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLaugh, oTarget, fDur));
	                }
	            }
	        }
	    }
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
}