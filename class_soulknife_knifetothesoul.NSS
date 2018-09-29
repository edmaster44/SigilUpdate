// Spell script for the Knife to the Soul feat for Soulknifes
// Cycles through the various attributes
// Actual effect is applied in i_mindblade_hc
// By Electrohydra
// Last Edited : 21/08/15

#include "class_soulknife_global"

void main()
{
	object oPC = OBJECT_SELF;

	int kttsStatus = GetLocalInt(oPC, VAR_KNIFE_TO_THE_SOUL);
	
	switch (kttsStatus)
	{
		case 1 : 
			SendMessageToPC(oPC, "Knife to the Soul : INT");
			SetLocalInt(oPC, VAR_KNIFE_TO_THE_SOUL, KTTS_INT);
			break;
		case 2 :
			SendMessageToPC(oPC, "Knife to the Soul : WIS");
			SetLocalInt(oPC, VAR_KNIFE_TO_THE_SOUL, KTTS_WIS);
			break;
		case 3 :
			SendMessageToPC(oPC, "Knife to the Soul : CHA");
			SetLocalInt(oPC, VAR_KNIFE_TO_THE_SOUL, KTTS_CHA);
			break;
		case 4 :
			SendMessageToPC(oPC, "Knife to the Soul : OFF");
			SetLocalInt(oPC, VAR_KNIFE_TO_THE_SOUL, KTTS_OFF);
			break;
		default : // First use
			SendMessageToPC(oPC, "Knife to the Soul : INT");
			SetLocalInt(oPC, VAR_KNIFE_TO_THE_SOUL, KTTS_INT);
	}
}