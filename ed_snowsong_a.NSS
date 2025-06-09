#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x0_i0_match"
#include "aaa_constants"

void main()
{
    object oPC 		= GetAreaOfEffectCreator();	
	int nChaBonus	= GetAbilityModifier(ABILITY_CHARISMA, oPC);
	int nCasterLvl 	= GetCasterLevel(oPC);
	object oTarget 	= GetEnteringObject();
	effect eAllies		= EffectLinkEffects(EffectAttackIncrease(3), EffectAbilityIncrease(ABILITY_CHARISMA, 3));
		eAllies			= EffectLinkEffects(EffectACIncrease(3, AC_DODGE_BONUS), eAllies);
		eAllies			= EffectLinkEffects(EffectRegenerate(1, 6.0), eAllies);
		eAllies			= EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_COLD, 15), eAllies);
	effect eFoes		= EffectSpellFailure(20); 
		eFoes			= EffectLinkEffects(EffectNWN2SpecialEffectFile("fx_spell_creeping_cold"), eFoes);
	
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC))
    {	SignalEvent(oTarget, EventSpellCastAt(oPC, SPELLABILITY_WC_SNOWSONG));
        if(!MyResistSpell(oPC, oTarget))
        {	if (!MySavingThrow(SAVING_THROW_WILL, oTarget, 16 + nChaBonus, SAVING_THROW_TYPE_COLD, oPC))
			{	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFoes, oTarget, RoundsToSeconds(nCasterLvl));
			}
		}
	}
	if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oPC))
    {	SignalEvent(oTarget, EventSpellCastAt(oPC, SPELLABILITY_WC_SNOWSONG, FALSE));
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAllies, oTarget, RoundsToSeconds(nCasterLvl));
	}
}