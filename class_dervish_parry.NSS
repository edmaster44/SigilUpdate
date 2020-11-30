#include "nwn2_inc_spells"
#include "aaa_constants"
#include "ps_inc_equipment"
#include "x2_inc_spellhook"
#include "aaa_constants"
#include "X0_I0_SPELLS"
#include "nw_i0_spells"

void main()
{
object oPC = OBJECT_SELF;
int nSpell = SPELLABILITY_DERVISH_DEFENSIVE_PARRY;
int nAction = GetCurrentAction(oPC);
	if (GetHasSpellEffect(nSpell,oPC))
				{
					RemoveEffectsFromSpell(oPC, nSpell);
					SendMessageToPC(oPC, "Defensive Parry disabled.");
					}
		if (GetHasFeat(FEAT_DERVISH_DEFENSIVE_PARRY,oPC))
			{
			if (nAction == ACTION_MODE_COMBAT_EXPERTISE || nAction== ACTION_MODE_IMPROVED_COMBAT_EXPERTISE)
			{
				
						effect eDefParry = EffectACIncrease(4);
						eDefParry = SetEffectSpellId(eDefParry, nSpell);
						eDefParry = SupernaturalEffect(eDefParry);
						DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDefParry, oPC, HoursToSeconds(24)));			
						SendMessageToPC(oPC, "Defensive Parry enabled.");						
				}
}
}