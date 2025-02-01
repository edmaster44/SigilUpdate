#include "ff_safevar"

#include "nw_i0_spells"

void main(string status)
{
	object oPC = OBJECT_SELF;

	if (status=="On" && GetHasSpell(SPELL_I_DARK_DISCORPORATION, oPC)>0) 
	{
		PS_SetLocalInt(oPC,"DarkDiscorporation",TRUE);
		ExecuteScript("scod_s_darkdiscorporation2",oPC);
	}
	else 
	{	
		PS_SetLocalInt(oPC,"DarkDiscorporation",FALSE);
		RemoveEffectsFromSpell(oPC, SPELL_I_DARK_DISCORPORATION);
	}
}