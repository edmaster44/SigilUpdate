//::///////////////////////////////////////////////
//:: Blindsight
//:: NW_S0_Blindsght.nss
//:://////////////////////////////////////////////
/*
    Allows the mage to see invisible creatures &
    see in darkness as well as being immune to blindness.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 12, 2005
//:://////////////////////////////////////////////


// JLR - OEI 08/23/05 -- Permanency & Metamagic changes

#include "nwn2_inc_spells"
#include "ps_inc_functions"
#include "x2_inc_spellhook" 

void main()
{

    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	//Declare major variables
	int nFeatDarkvision = 228;
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect( VFX_DUR_SPELL_BLINDSIGHT );	// NWN2 VFX
    effect eSightInvis = EffectSeeInvisible();
    effect eSightDark = EffectUltravision();
    effect eLink = EffectLinkEffects(eVis, eSightInvis);
    eLink = EffectLinkEffects(eLink, eSightDark);
    eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
	eLink = SetEffectSpellId(eLink, SPELL_BLINDSIGHT);
	
	int nlvl = PS_GetCasterLevel(OBJECT_SELF);
	
	if (GetSpellFeatId() == 21895){
		nlvl = GetLevelByClass(CLASS_TYPE_ASSASSIN, OBJECT_SELF);
	}
	

    float fDuration = TurnsToSeconds(nlvl);

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    //int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	


   //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BLINDSIGHT, FALSE));
    //Apply the VFX impact and effects
	//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	PS_RemoveEffects(oTarget, SPELL_BLINDSIGHT);
	RemoveEffect(oTarget, EffectNewBlindness());
	PS_RemoveEffects(oTarget, SPELL_DARKNESS, EFFECT_TYPE_MISS_CHANCE);
	PS_RemoveEffects(oTarget, SPELL_DARKNESS, EFFECT_TYPE_SKILL_DECREASE);
	PS_GrantFeatBySpellWithEffect(nFeatDarkvision, oTarget, eLink, fDuration);
}