// Script for the Wing Clip feat for Mind Blades
// Actual weapon effect is applied in i_mindblade_hc
// By Electrohydra
// Last Edited : 24/04/16

#include "class_soulknife_global"

void main()
{
	SetLocalInt(OBJECT_SELF, VAR_WINGCLIP, TRUE);
	DelayCommand(6.0f, SetLocalInt(OBJECT_SELF, VAR_WINGCLIP, FALSE));
	
	object oTarget = GetPlayerCurrentTarget(OBJECT_SELF);
	if (GetIsObjectValid(oTarget) && GetIsReactionTypeHostile(oTarget))
	{
		ActionAttack(oTarget);
	}
}