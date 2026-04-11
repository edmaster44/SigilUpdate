//::///////////////////////////////////////////////
//:: Invocation: Beguiling Influence
//:: NW_S0_IBeguInfl.nss
//:://////////////////////////////////////////////
/*
    Gives a +6 bonus to Bluff, Diplomacy & Intimidate
    for 24 hours.
*/
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: June 19, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: JLR - OEI 08/24/05 -- Metamagic changes
//:: Mimi Fearthegn 7/26/20 - Adding scaling based on level

#include "ps_inc_invocations"

void main(){
	DoSelfOnlyInvocation(SPELL_I_BEGUILING_INFLUENCE);
}




/* original
void main()
{
    if (!X2PreSpellCastCode()) return;

    //Declare major variables
	object oCaster = OBJECT_SELF;
	int nCasterLevel = GetWarlockCasterLevel(oCaster);
	
    float fDuration = HoursToSeconds(24);

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	int nSkillBuff = (nCasterLevel/2) + 5;

    effect eBluff = EffectSkillIncrease(SKILL_BLUFF, 6);
    effect eDiplomacy = EffectSkillIncrease(SKILL_DIPLOMACY, 6);
    effect eIntimidate = EffectSkillIncrease(SKILL_INTIMIDATE, 6);
    effect eLink = EffectLinkEffects(eBluff, eDiplomacy);
    eLink = EffectLinkEffects(eIntimidate, eLink);
	
	if (!GetLocalInt(oCaster, "WarlockBuddy")){
		effect eDur = EffectVisualEffect(VFX_DUR_INVOCATION_BEGUILE_INFLUENCE);
		eLink = EffectLinkEffects(eDur, eLink);
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	}
	
	RemoveEffectsFromSpell(oTarget, GetSpellId());
    //Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}
*/