#include "ff_safevar"

#include "nw_i0_spells"

void main(string status)
{
	object oPC = OBJECT_SELF;

	if (status=="On" && GetHasSpell(SPELL_I_FLEE_THE_SCENE, oPC)>0) 
	{
		PS_SetLocalInt(oPC,"FleeTheScene",TRUE);
		ExecuteScript("nw_s0_ifleescen2",oPC);
	}
	else 
	{
		PS_SetLocalInt(oPC,"FleeTheScene",FALSE);
		RemoveEffectsFromSpell(oPC, SPELL_I_FLEE_THE_SCENE);
	}
}