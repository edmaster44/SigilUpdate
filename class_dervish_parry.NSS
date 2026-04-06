#include "nw_i0_spells"
#include "aaa_constants"
#include "nwn2_inc_spells"
#include "x2_inc_spellhook"
void main()
{
object oPC = OBJECT_SELF;
int eDefParryID = SPELLABILITY_DERVISH_DEFENSIVE_PARRY;
effect eDefParry = EffectACIncrease(4);
eDefParry = SetEffectSpellId(eDefParry, eDefParryID);
eDefParry = SupernaturalEffect(eDefParry);

PS_RemoveEffects(oPC, eDefParryID);

if (GetActionMode(oPC, ACTION_MODE_COMBAT_EXPERTISE) || GetActionMode(oPC, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE)  )
			{
				if (!GetHasSpellEffect(eDefParryID,oPC))
				{
						effect eDefParry = EffectACIncrease(4);
						eDefParry = SetEffectSpellId(eDefParry, eDefParryID);
						eDefParry = SupernaturalEffect(eDefParry);
						DelayCommand(0.1f, PS_ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDefParry, oPC, HoursToSeconds(24)));			
						SendMessageToPC(oPC, "Defensive Parry enabled.");						
				}
			}
			}