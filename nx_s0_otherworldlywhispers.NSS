//::///////////////////////////////////////////////
//:: Otherworldly Whispers
//:: [nx_s0_otherworldlywhispers]
//:: Copyright (c) 2007 Obsidian Ent.
//:://////////////////////////////////////////////
//:: Invocation Level: Least
//:: Spell Level Equivalent: 2
//::
//:: You hear whispers in your ears, revealing secrets
//:: of the multiverse.  You gain a +6 bonus on all lore
//:: and spellcraft checks for 24 hours.
//:://////////////////////////////////////////////
//:: Mimi Fearthegn 7/26/20 - Adding scaling based on level + boost to search



#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

	
    //Declare major variables
	object oCaster = OBJECT_SELF;
	int nCasterLevel = GetWarlockCasterLevel(oCaster);
	int nSkillBuff = (nCasterLevel/2) + 5;
	
    
 	//float fDuration = 60.0*60.0*24.0;  // 24 hours
	float fDuration = HoursToSeconds(24);
	
    effect eLore = EffectSkillIncrease(SKILL_LORE, nSkillBuff);
	effect eSpellCraft = EffectSkillIncrease(SKILL_SPELLCRAFT, nSkillBuff);
	effect eSearch = EffectSkillIncrease(SKILL_SEARCH, nSkillBuff);
    effect eLink = EffectLinkEffects(eLore, eSpellCraft);
	eLink = EffectLinkEffects(eLink, eSearch);
	
	//Fire cast spell at event for the specified target
    SignalEvent(oCaster, EventSpellCastAt(oCaster, GetSpellId(), FALSE));

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
}