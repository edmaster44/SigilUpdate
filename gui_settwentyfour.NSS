#include "ff_safevar"

#include "nw_i0_spells"

const int SPELL_I_OTHERWORLDLY_WHISPERS = 1059;

void main(string status)
{
	object oPC = OBJECT_SELF;

	if (status=="On" && (
		GetHasSpell(SPELL_I_DARK_ONES_OWN_LUCK, oPC)>0 ||
		GetHasSpell(SPELL_I_BEGUILING_INFLUENCE, oPC)>0 ||
		GetHasSpell(SPELL_I_ENTROPIC_WARDING, oPC)>0 ||
		GetHasSpell(SPELL_I_LEAPS_AND_BOUNDS, oPC)>0 ||
		GetHasSpell(SPELL_I_SEE_THE_UNSEEN, oPC)>0 ||
		GetHasSpell(SPELL_I_OTHERWORLDLY_WHISPERS, oPC)>0
		)) 
	{
		PS_SetLocalInt(oPC,"TwentyFour",TRUE);
		if (!GetIsInCombat()) ExecuteScript("nw_s0_itwentyfour",oPC);
	}
	else 
	{
		PS_SetLocalInt(oPC,"TwentyFour",FALSE);
		RemoveEffectsFromSpell(oPC, SPELL_I_BEGUILING_INFLUENCE);
		RemoveEffectsFromSpell(oPC, SPELL_I_DARK_ONES_OWN_LUCK);
		RemoveEffectsFromSpell(oPC, SPELL_I_ENTROPIC_WARDING);
		RemoveEffectsFromSpell(oPC, SPELL_I_LEAPS_AND_BOUNDS);
		RemoveEffectsFromSpell(oPC, SPELL_I_OTHERWORLDLY_WHISPERS);
		RemoveEffectsFromSpell(oPC, SPELL_I_SEE_THE_UNSEEN);
	}
}