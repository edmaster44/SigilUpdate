#include "ff_safevar"

int StartingConditional(int iDiffCheck)
{
    object oPC = GetPCSpeaker();

	int iDiff = PS_GetLocalInt(oPC,"DIFF");

	if(iDiff==0)
	  iDiff==2;
	
	if(iDiff==iDiffCheck)
	  return iDiff;
	else
	  return 0;
}