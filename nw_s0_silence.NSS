//::///////////////////////////////////////////////
//:: Silence
//:: NW_S0_Silence.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target is surrounded by a zone of silence
    that allows them to move without sound.  Spell
    casters caught in this area will be unable to cast
    spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
// JLR - OEI 08/23/05 -- Metamagic changes
// ChazM 1/18/07 - EvenFlw modifications


#include "nwn2_inc_spells"
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

// this has the silence constant EVENFLW_SILENCE, and is the only reason we include it.
// Affects NW_S0_Silence & NW_S0_SilenceA
#include "nw_i0_generic"

void ApplySilenceAoE(object oCaster, object oTarget, int bHarm){
	if (bHarm){
		if (MyResistSpell(oCaster, oTarget) || 
			MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC()))
				return;
	}
	effect eAOE = EffectAreaOfEffect(AOE_MOB_SILENCE);
	effect eHit = EffectVisualEffect(VFX_DUR_SPELL_SILENCE );
    float fDuration = RoundsToSeconds(PS_GetCasterLevel(oCaster));
	 //Make sure duration does no equal 0
    if (fDuration < 1.0) fDuration = 1.0;
    //Check Extend metamagic feat.
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	if (!GetIsObjectValid(oTarget)){
		location lTarget = GetSpellTargetLocation();
		ApplyEffectAtLocation( nDurType, eAOE, lTarget, fDuration);
		return;
	}
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SILENCE, bHarm));
	ApplyEffectToObject(nDurType, eAOE, oTarget, fDuration);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
	SetLocalInt(oTarget, EVENFLW_SILENCE, TRUE);
}


void main(){

    if (!X2PreSpellCastCode()) return;

    //Declare major variables including Area of Effect Object
	object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
	
	if (GetIsObjectValid(oTarget)){
		if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE){
			if (GetFactionEqual(oTarget, oCaster)){
				ApplySilenceAoE(oCaster, oTarget, FALSE);
			} else {
				ApplySilenceAoE(oCaster, oTarget, TRUE);
	        }
		} else { // non-creature objects dont get a save
			ApplySilenceAoE(oCaster, oTarget, FALSE);
		}	
	} else { // for when the spell is cast at a location
	   ApplySilenceAoE(oCaster, OBJECT_INVALID, FALSE);
	}
}