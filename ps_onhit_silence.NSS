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
#include "nw_i0_generic"
#include "ps_inc_onhit" 

void main()
{

    //Declare major variables
    location lTarget = GetLocation(OBJECT_SELF);
	object oCaster = GetOnHitAbilityCaster(OBJECT_SELF);
    int nCasterLevel = GetCasterLevel(oCaster);
	int nDC = GetOnHitAbilityDC(OBJECT_SELF);
	int nID = GetOnHitAbilityID(OBJECT_SELF);
    effect eAOE = EffectAreaOfEffect(AOE_MOB_SILENCE, "ps_onhit_silencea", "ps_onhit_silencec", "ps_onhit_silenceb");
	effect eHit = EffectVisualEffect( VFX_DUR_SPELL_SILENCE );
    float fDuration = RoundsToSeconds(GetCasterLevel(oCaster));
    object oTarget = OBJECT_SELF;
	
    //Make sure duration does no equal 0
    if (fDuration < 1.0)
    {
        fDuration = 1.0;
    }
    int nDurType = DURATION_TYPE_TEMPORARY;

	ApplyEffectAtLocation( nDurType, eAOE, lTarget, fDuration );
}