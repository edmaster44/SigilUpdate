#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x0_i0_match"
#include "aaa_constants"
#include "nwn2_inc_spells"



void main()
{
    object oPC 		= GetAreaOfEffectCreator();	
	object oTarget 	= GetEnteringObject();
	
	int nChaBonus	= GetAbilityModifier(ABILITY_CHARISMA, oPC);
	
	//int nCasterLvl 	= GetCasterLevel(oPC); // original, was an error, there is no caster lvl so dur was 0
	//flattedfifth edit, would be up to 20 rounds. Could also use GetLevelByClass(117, oPC) for 10 rounds
	int nDuration = GetBardicClassLevelForUses(oPC);
	int nDamage = nDuration; // the damge will also be based on # bard song uses
	
	if (GetHasFeat(FEAT_LINGERING_SONG, oPC)) nDuration += 5; // duration increased by lingering song
	if (GetHasFeat(FEAT_EXTRA_MUSIC, oPC)) nDamage += 4; // damage increased by extra music
	float fDamage = IntToFloat(nDamage) / 2.0f;
	
	//flattedfifth edited effect declarations
	effect eAllies		= EffectAttackIncrease(4);
		eAllies			= EffectLinkEffects(EffectAbilityIncrease(ABILITY_CHARISMA, 4), eAllies);
		eAllies			= EffectLinkEffects(EffectACIncrease(4, AC_DODGE_BONUS), eAllies);
		eAllies			= EffectLinkEffects(EffectRegenerate(1, 6.0), eAllies);
		eAllies			= EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_COLD, 15), eAllies);
		eAllies			= EffectLinkEffects(EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_COLD), eAllies);
	effect eFoes		= EffectSpellFailure(20); 
	effect eFoesDoTM 	= EffectDamageOverTime(PS_RoundToInt(fDamage, "down"), 6.0f, DAMAGE_TYPE_MAGICAL, TRUE);
	effect eFoesDoTC 	= EffectDamageOverTime(PS_RoundToInt(fDamage, "up"), 6.0f, DAMAGE_TYPE_COLD);
	effect eFoesDoT		= EffectLinkEffects(eFoesDoTC, eFoesDoTM);
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
	if (GetIsObjectValidSongTarget(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oPC) && oTarget != oPC)
		{	
			SignalEvent(oTarget, EventSpellCastAt(oPC, SPELLABILITY_WC_SNOWSONG));
			DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFoesDoT, oTarget, RoundsToSeconds(nDuration)));
				
			if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDuration + nChaBonus, SAVING_THROW_TYPE_COLD, oPC))
			{	
				DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFoes, oTarget, RoundsToSeconds(nDuration)));
				//added separate application of impact vfx as intant as per standard practice
				DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eFoesVFX, oTarget));
			}
			
		}
		else if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oPC) || oTarget == oPC)
		{	
			SignalEvent(oTarget, EventSpellCastAt(oPC, SPELLABILITY_WC_SNOWSONG, FALSE));
			DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAllies, oTarget, RoundsToSeconds(nDuration)));
		}
	}
}