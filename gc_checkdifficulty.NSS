

int StartingConditional(int iDiffCheck)
{
    object oPC = GetPCSpeaker();

	int iDiff = GetLocalInt(oPC,"DIFF");

	if(iDiff==0)
	  iDiff==2;
	
	if(iDiff==iDiffCheck)
	  return iDiff;
	else
	  return 0;
}