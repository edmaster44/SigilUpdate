#include "nw_i0_spells"
#include "aaa_constants"

void main()
{
object oPC = OBJECT_SELF;
int nSpell = GetSpellId();
effect eDefParry = EffectACIncrease(4);
eDefParry = SetEffectSpellId(eDefParry, nSpell);
eDefParry = SupernaturalEffect(eDefParry);
	if (GetHasSpellEffect(nSpell,oPC))
	{
		RemoveEffectsFromSpell(oPC, nSpell);
		SendMessageToPC(oPC, "Defensive Parry disabled.");
	}
		else
		
	if(GetActionMode(oPC,ACTION_MODE_COMBAT_EXPERTISE) == TRUE)
	{	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDefParry, oPC, HoursToSeconds(24)));			
		SendMessageToPC(oPC, "Defensive Parry enabled.");						
	}
		
		else if(GetActionMode(oPC,ACTION_MODE_IMPROVED_COMBAT_EXPERTISE) == TRUE)
	{	DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDefParry, oPC, HoursToSeconds(24)));			
		SendMessageToPC(oPC, "Defensive Parry enabled.");						
	}
	
}