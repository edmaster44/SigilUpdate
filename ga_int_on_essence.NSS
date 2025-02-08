#include "ff_safevar"

// Created by Agony_Aunt/Loki for SCoD
// Initially created to handle Grinnie and Shezz convo options by placing/checking vars on Essence
// to stop infinite XP and other stuff from what should be once only options.
// Can be used though for checking/storing any vars on PC Speaker Essence objects for convos though.

// Sets sVariable on Essence to sValue. The paired gc_ script only returns true/false based
// on whether value is set or not, so only really need to pass either zero or non-zero (1) as sValue
void main(string sVariable, int iValue)
{
	object oPC = GetPCSpeaker();
	object oEssence = GetItemPossessedBy(oPC,"ps_essence");
	
	if (GetIsObjectValid(oEssence))
	{
		PS_SetLocalInt(oEssence, sVariable, iValue);
	}
}