// Created by Agony_Aunt/Loki for SCoD
// Initially created to handle Grinnie and Shezz convo options by placing/checking vars on Essence
// to stop infinite XP and other stuff from what should be once only options.
// Can be used though for checking/storing any vars on PC Speaker Essence objects for convos though.

// Returns TRUE if var exists or set to anything except zero.
// Returns FALSE if var is zero or does not exist.
int StartingConditional(string sVariable)
{
	object oPC = GetPCSpeaker();
	object oEssence = GetItemPossessedBy(oPC,"ps_essence");
	
	if (GetLocalInt(oEssence, sVariable) == 0)
	{
		return 0;
	}
	else
	{
		return 1;
	}
}