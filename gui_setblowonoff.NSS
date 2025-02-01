#include "ff_safevar"

#include "nw_i0_spells"

void main(string status)
{
	object oPC = OBJECT_SELF;

	if (status=="On" && (GetHasSpell(SPELL_I_HIDEOUS_BLOW, oPC) || GetHasFeat(FEAT_WARLOCK_BLOW_ELDRTICH, oPC, TRUE)))
	{
		PS_SetLocalInt(oPC,"HideousBlow",TRUE);
		if (!GetIsInCombat()) ExecuteScript("nw_s0_ihideousb1",oPC);
		else if (PS_GetLocalInt(oPC,"AllreadyRunning")==FALSE)
			{
				ActionCastSpellAtObject(SPELL_I_HIDEOUS_BLOW, oPC);
				DelayCommand(6.0, ExecuteScript("nw_s0_ihideousb1",oPC));
			}
	}
	else 
	{
		PS_SetLocalInt(oPC,"HideousBlow",FALSE);
		RemoveEffectsFromSpell(oPC, SPELL_I_HIDEOUS_BLOW);
		PS_SetLocalInt(oPC,"AllreadyRunning",FALSE);
	}
}