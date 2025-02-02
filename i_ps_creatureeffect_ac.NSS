#include "ff_safevar"

// i_ps_creatureeffect_ac
/*
Created 2012 by Dedic8ed for the Sigic: City of Doors persistant world.

When used, will apply a visual effect to the creature using it. Choose the effect by name from the NWN2 Install Directory,
subdirectory "Data", and any of the "NWN2_VFX" zipfiles.
*/

void main()
{
    object oPC  = GetItemActivator();
	object oItem = GetItemActivated();
	string sEffect = PS_GetLocalString(oItem,"Effect");
	effect eEffect = EffectNWN2SpecialEffectFile(sEffect, oPC);

 	//Your code goes here

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 300.f);
	SendMessageToPC(oPC,"Visual effect *" + sEffect + "* applied. To remove, use the Release Spells button in PC Tools.");	
}