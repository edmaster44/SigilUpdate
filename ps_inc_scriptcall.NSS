#include "ps_inc_functions"
#include "aaa_constants"
#include "ps_inc_advscript"

void PS_WP_DeathDealer(object oKiller);

// If the killer of a creature is a Weapon Master with the "Death Dealer" feat, apply the
// half-round 2d4 damage bonus. To be called by nw_c2_default7
void PS_WP_DeathDealer(object oKiller)
{
	effect eBoost	= EffectDamageIncrease(DAMAGE_BONUS_2d4, DAMAGE_TYPE_NEGATIVE);
	effect eVis		= EffectNWN2SpecialEffectFile("evil_hand_effect", oKiller);
	effect eLink	= EffectLinkEffects(eBoost, eVis);

	if(GetHasFeat(99999, oKiller))
	{	
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oKiller, 0.3f)	;
	}
}