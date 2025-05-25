

#include "nw_i0_spells"

void main(string status)
{
	object oPC = OBJECT_SELF;

	if (status=="On" && (GetHasSpell(SPELL_I_RETRIBUTIVE_INVISIBILITY, oPC)>0 || GetHasSpell(SPELL_I_WALK_UNSEEN, oPC)>0)) 
	{
		SetLocalInt(oPC,"Invisibility",TRUE);
		ExecuteScript("nw_s0_iwalkunsn2",oPC);
	}
	else 
	{
		SetLocalInt(oPC,"Invisibility",FALSE);
		RemoveEffectsFromSpell(oPC, SPELL_I_WALK_UNSEEN);
		RemoveEffectsFromSpell(oPC, SPELL_I_RETRIBUTIVE_INVISIBILITY);
	}
}