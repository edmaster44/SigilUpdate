//::///////////////////////////////////////////////
//:: Invocation: Leaps and Bounds
//:: NW_S0_ILeapsBnd.nss
//:://////////////////////////////////////////////
/*
    Gives a +4 Dexterity bonus and a +4 Tumble Skill
    Bonus for 24 hours.
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
	DoSelfOnlyInvocation(SPELL_I_LEAPS_AND_BOUNDS);
}



/*
void main() {

    if (!X2PreSpellCastCode()) {
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }


    //Declare major variables
	object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
	
	int nCasterLevel = GetWarlockCasterLevel(oCaster);
	int nSkillBuff = (nCasterLevel/2) + 5;
	
    float fDuration = HoursToSeconds(24);

    //Enter Metamagic conditions
    fDuration = ApplyMetamagicDurationMods(fDuration);
    int nDurType = ApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	int nDex = 4;
	if (nCasterLevel > 5) //Dexterity boost doesn't become 6 until you hit caster level 6
		nDex = 6;

    effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, nDex);
    effect eTumble = EffectSkillIncrease(SKILL_TUMBLE, nSkillBuff);
    effect eLink = EffectLinkEffects(eDex, eTumble);
	

	effect eDur = EffectVisualEffect(VFX_DUR_INVOCATION_LEAPS_BOUNDS);
	eLink = EffectLinkEffects(eDur ,eLink);
	 //Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	

    RemoveEffectsFromSpell(oTarget, GetSpellId());

    //Apply the VFX impact and effects
    ApplyEffectToObject(nDurType, eLink, oTarget, fDuration);
}
*/