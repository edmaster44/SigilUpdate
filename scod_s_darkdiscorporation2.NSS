//:://///////////////////////////////////////////////
//:: Warlock Dark Invocation: Dark Discorporation
//:: scod_s_darkdiscorporation.nss
//:: This script is for Warlock buddy
//::////////////////////////////////////////////////
//:: Added 5/26/21 - Mimi Fearthegn

#include "x2_inc_spellhook"
#include "nwn2_inc_metmag"
#include "ps_inc_functions"
#include "nwn2_inc_spells"
#include "ginc_debug"
#include "nw_i0_spells"

const float fDiscorpDuration = 6.0f;

void DoDiscorporation(object oPC) {

	if (GetHasSpellEffect(843)) { 
		SendMessageToPC(oPC, "You may not discorporate while Word of Changing is active.");
		return;
	}

	if (GetHasSpellEffect(1657)) { 
		SendMessageToPC(oPC, "You may not discorporate while Fiend Form is active.");
		return;
	}

    //Declare major variables
    object oCaster = oPC;
    int nCasterLvl = GetWarlockCasterLevel(oCaster);
    effect eVis = EffectNWN2SpecialEffectFile("fx_kos_teleport");
    effect ePoly;
    int nPoly;
    int nMetaMagic = GetMetaMagicFeat();
	
	effect eBuff = EffectMovementSpeedIncrease(99); //x2 speed
	eBuff = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK), eBuff); //being discorporated means undead like immunities
	eBuff = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT), eBuff); //being discorporated means undead like immunities
	eBuff = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN), eBuff); //being discorporated means undead like immunities
	eBuff = EffectLinkEffects(EffectConcealment(50), eBuff); //50% concealment
	eBuff = EffectLinkEffects(EffectNWN2SpecialEffectFile("fx_dark_discorporation"), eBuff);
	
	SetEffectSpellId(eBuff, SPELL_I_DARK_DISCORPORATION);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oCaster, fDiscorpDuration);
	
	
	effect eAOE = EffectAreaOfEffect(97);
	SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_I_DARK_DISCORPORATION, FALSE));
	DelayCommand(0.0f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oCaster, fDiscorpDuration));

}

void DiscorporationRefresh(object oPC)
{
	if (GetLocalInt(oPC,"DarkDiscorporation")==FALSE) return;
	
	DoDiscorporation(oPC);
	DelayCommand(fDiscorpDuration+0.1f, DiscorporationRefresh(oPC));
}

void main() {
	object oPC = OBJECT_SELF;
	
    if (!X2PreSpellCastCode())
    {
	    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
		
	DiscorporationRefresh(oPC);
}
	
	