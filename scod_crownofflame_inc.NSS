//::///////////////////////////////////////////////

// FlattedFifth - June 17, 2024. Reworked logic to have no affect on allies, changed damage 
//			to do 1d8 vs good, 2d8 vs neutral, and 3d8 vs evil with an additional 1d8 vs
//			enemy outsiders, undead, and fey
// FlattedFifth - June 26, 2024. Updated to use spellIsTarget() function in nw_io_spells. That's
// 		 	a more thorough check than just GetReactionTypeHostile().

#include "x2_inc_spellhook"
#include "NW_I0_SPELLS"
#include "aaa_constants"



void ApplyCoF(object oTarget, object oCaster, int nId, int nDuration)
{
	// Only process anything at all if the target is hostile
	if (!spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
		return;
	
	effect eImpact		= EffectVisualEffect(VFX_HIT_SPELL_FIRE);
	eImpact				= EffectLinkEffects(eImpact, EffectVisualEffect(VFX_HIT_SPELL_HOLY));
	effect eDam;
	effect eLink;
	effect eBlind 		= EffectNewBlindness();
	eBlind = SetEffectSpellId(eBlind, nId);

	int nNumDice = 1;
	int bIsBlinded = FALSE;
	int nRace = GetRacialType(oTarget);
	if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_NEUTRAL)
	{
		nNumDice += 1;
		bIsBlinded = TRUE;
	}
	else if (GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
	{
		nNumDice += 2;
		bIsBlinded = TRUE;
	}
	if (nRace == RACIAL_TYPE_OUTSIDER || nRace == RACIAL_TYPE_UNDEAD || nRace == RACIAL_TYPE_FEY)
	{
		nNumDice += 1;
	}
	
	if (bIsBlinded && GetIsImmune(oTarget, IMMUNITY_TYPE_BLINDNESS, oCaster))
		bIsBlinded = FALSE;
	
	eDam = EffectDamage(d8(nNumDice), DAMAGE_TYPE_DIVINE, DAMAGE_POWER_NORMAL, TRUE);
	eLink = EffectLinkEffects(eImpact, eDam);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);	
	if (bIsBlinded)
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, RoundsToSeconds(nDuration));	
}