#include "nw_i0_spells"

void main(string status)
{
	object oPC = OBJECT_SELF;

	if (status=="On" && GetHasSpell(SPELL_I_HIDEOUS_BLOW, oPC))
	{
		SetLocalInt(oPC,"HideousBlow",TRUE);
		if (!GetIsInCombat()) ExecuteScript("nw_s0_ihideousb1",oPC);
		else if (GetLocalInt(oPC,"AllreadyRunning")==FALSE)
			{
				ActionCastSpellAtObject(SPELL_I_HIDEOUS_BLOW, oPC);
				DelayCommand(6.0, ExecuteScript("nw_s0_ihideousb1",oPC));
			}
	}
	else 
	{
		SetLocalInt(oPC,"HideousBlow",FALSE);
		RemoveEffectsFromSpell(oPC, SPELL_I_HIDEOUS_BLOW);
		SetLocalInt(oPC,"AllreadyRunning",FALSE);
	}
}