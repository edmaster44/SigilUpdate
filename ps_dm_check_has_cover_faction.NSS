#include "ff_safevar"

// This script is used by the DM faction tool to see if conversation options should be given
// for anarchist players who have a cover faction.


int StartingConditional()
{
	object oDM = OBJECT_SELF;
	int iSecondaryFaction = PS_GetLocalInt(oDM, "TargetSecondaryFaction");
	
	if (iSecondaryFaction != 0)
		return TRUE;
	else
		return FALSE;
}