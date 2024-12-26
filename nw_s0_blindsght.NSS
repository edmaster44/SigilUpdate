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
	// caster lvl for assassin feat/spells is assassin lvl + 1/2 of non-assassin lvls
	if (GetSpellFeatId() == 21895){
		nlvl = GetLevelByClass(CLASS_TYPE_ASSASSIN, OBJECT_SELF);
		nlvl += (GetTotalLevels(OBJECT_SELF, TRUE) - nlvl) / 2;
	}
	

	// ALSO, put in script in onaquire to make sure that scrolls that are useable by druids also get the 
	// useable by shaman porperty, and add the encircling scale to the list of items to get proper darkvision.
	// ALSO make new feint

    float fDuration = TurnsToSeconds(nlvl);

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    //int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	


   //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BLINDSIGHT, FALSE));
    //Apply the VFX impact and effects
	//ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	PS_RemoveEffects(oTarget, SPELL_BLINDSIGHT);
	RemoveEffect(oTarget, EffectBlindness());
	PS_RemoveEffects(oTarget, SPELL_DARKNESS, EFFECT_TYPE_MISS_CHANCE);
	PS_RemoveEffects(oTarget, SPELL_DARKNESS, EFFECT_TYPE_SKILL_DECREASE);
	PS_GrantFeatBySpellWithEffect(nFeatDarkvision, oTarget, eLink, fDuration);
}