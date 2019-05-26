//::///////////////////////////////////////////////
//:: Faerie Fire
//:: [scod_s_faerie_fire.nss]
//:://////////////////////////////////////////////
//:: Faerie Fire
//:://////////////////////////////////////////////
//:: Mimi Fearthegn
//:: Created: 2-17-2019
//:://////////////////////////////////////////////
#include "ps0_newspells_inc"
#include "x2_inc_spellhook"

void main() {

	//Spellhook script
    if (!X2PreSpellCastCode()) {
        return;
    }
	
	//Debug message
	object oCaster = OBJECT_SELF;
	SpeakString("casting faerie fire", TALKVOLUME_SHOUT);

    location lTarget = GetSpellTargetLocation();
    int nCasterLvl = GetCasterLevel(oCaster);
    int nMetaMagic = GetMetaMagicFeat();
	
    float fDuration = nCasterLvl*60.0f;
    if (nMetaMagic == METAMAGIC_EXTEND) {
        fDuration = fDuration *2; //Duration is +100%
    }
	
	//Explosion effect
    effect eExplosion = EffectNWN2SpecialEffectFile("sp_illusion_aoe");
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplosion, lTarget);
	
	effect eFaerie = EffectConcealmentNegated();
	effect eVis = EffectNWN2SpecialEffectFile("fx_faeriefire");
	eFaerie = EffectLinkEffects(eVis, eFaerie);
	
	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget)) {
	
		SpeakString("effecting: "+GetName(oTarget), TALKVOLUME_SHOUT);
	   	//Fire cast spell at event for the specified target
	   	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_FAERIE_FIRE));
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFaerie, oTarget, fDuration);
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
}