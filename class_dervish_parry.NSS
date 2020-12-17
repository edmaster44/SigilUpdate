#include "nw_i0_spells"
#include "aaa_constants"

void main()
{
object oPC = OBJECT_SELF;
int nSpell = GetSpellId();
int nAction = GetCurrentAction(oPC);
	if (GetHasSpellEffect(nSpell,oPC))
	{
		RemoveEffectsFromSpell(oPC, nSpell);
		SendMessageToPC(oPC, "Defensive Parry disabled.");
	}
		else
	
		if (nAction == ACTION_MODE_COMBAT_EXPERTISE || nAction== ACTION_MODE_IMPROVED_COMBAT_EXPERTISE)
		{	effect eDefParry = EffectACIncrease(4);
			eDefParry = SetEffectSpellId(eDefParry, nSpell);
			eDefParry = SupernaturalEffect(eDefParry);
			DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDefParry, oPC, HoursToSeconds(24)));			
			SendMessageToPC(oPC, "Defensive Parry enabled.");						
			}
}
