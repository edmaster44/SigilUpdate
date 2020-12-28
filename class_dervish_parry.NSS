#include "nw_i0_spells"
#include "aaa_constants"

void main()
{
object oPC = OBJECT_SELF;
int eDefParryID = -3213;
effect eDefParry = EffectACIncrease(4);
eDefParry = SetEffectSpellId(eDefParry, eDefParryID);
eDefParry = SupernaturalEffect(eDefParry);

effect eEffect = GetFirstEffect(oPC);

while(GetIsEffectValid(eEffect))
{
if(GetEffectSpellId(eEffect) == eDefParryID)
{
RemoveEffect(oPC, eEffect);
break;
}
eEffect = GetNextEffect(oPC);
}

	if 	 (GetActionMode(oPC,ACTION_MODE_IMPROVED_COMBAT_EXPERTISE) == TRUE)
	{	 ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDefParry, oPC, HoursToSeconds(24));			
		SendMessageToPC(oPC, "Defensive Parry enabled.");						
	}
		
		
	else if(GetActionMode(oPC,ACTION_MODE_COMBAT_EXPERTISE) == TRUE)
	{	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDefParry, oPC, HoursToSeconds(24));			
		SendMessageToPC(oPC, "Defensive Parry enabled.");						
	}
	}
