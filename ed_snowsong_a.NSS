#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x0_i0_match"
#include "aaa_constants"

void main()
{
    object oPC 		= GetAreaOfEffectCreator();	
	int nChaBonus	= GetAbilityModifier(ABILITY_CHARISMA, oPC);
	//int nCasterLvl 	= GetCasterLevel(oPC); // original
	//flattedfifth edit, would be up to 20 rounds. Could also use GetLevelByClass(117, oPC) for 10 rounds
	int nCasterLvl = GetBardicClassLevelForUses(oPC);
	object oTarget 	= GetEnteringObject();
	//flattedfifth edited effect declarations
	effect eAllies		= EffectAttackIncrease(4);
		eAllies			= EffectLinkEffects(EffectAbilityIncrease(ABILITY_CHARISMA, 4), eAllies);
		eAllies			= EffectLinkEffects(EffectACIncrease(4, AC_DODGE_BONUS), eAllies);
		eAllies			= EffectLinkEffects(EffectRegenerate(1, 6.0), eAllies);
		eAllies			= EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_COLD, 15), eAllies);
		eAllies			= EffectLinkEffects(EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_COLD), eAllies);
	effect eFoes		= EffectSpellFailure(20); 
	effect eFoesVFX		= EffectNWN2SpecialEffectFile("fx_spell_creeping_cold");
	
	// original effect declarations
	/*
	effect eAllies		= EffectLinkEffects(EffectAttackIncrease(3), EffectAbilityIncrease(ABILITY_CHARISMA, 3));
		eAllies			= EffectLinkEffects(EffectACIncrease(3, AC_DODGE_BONUS), eAllies);
		eAllies			= EffectLinkEffects(EffectRegenerate(1, 6.0), eAllies);
		eAllies			= EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_COLD, 15), eAllies);
	effect eFoes		= EffectSpellFailure(20); 
		eFoes			= EffectLinkEffects(EffectNWN2SpecialEffectFile("fx_spell_creeping_cold"), eFoes);
	*/
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
    {	SignalEvent(oTarget, EventSpellCastAt(oPC, SPELLABILITY_WC_SNOWSONG));
        if(!MyResistSpell(oPC, oTarget))
        {	if (!MySavingThrow(SAVING_THROW_WILL, oTarget, 16 + nChaBonus, SAVING_THROW_TYPE_COLD, oPC))
			{	
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFoes, oTarget, RoundsToSeconds(nCasterLvl));
				//added separate application of impact vfx as intant as per standard practice
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eFoesVFX, oTarget);
			}
		}
	}
	if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oPC))
    {	SignalEvent(oTarget, EventSpellCastAt(oPC, SPELLABILITY_WC_SNOWSONG, FALSE));
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAllies, oTarget, RoundsToSeconds(nCasterLvl));
	}
}