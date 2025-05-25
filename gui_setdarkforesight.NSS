

#include "nw_i0_spells"

void main(string status)
{
	object oPC = OBJECT_SELF;

	if (status=="On" && GetHasSpell(SPELL_I_DARK_FORESIGHT, oPC)>0) 
	{
		SetLocalInt(oPC,"DarkForesight",TRUE);
		ExecuteScript("nw_s0_idarkfors2",oPC);
	}
	else 
	{	
		SetLocalInt(oPC,"DarkForesight",FALSE);
		RemoveEffectsFromSpell(oPC, SPELL_I_DARK_FORESIGHT);
	}
}