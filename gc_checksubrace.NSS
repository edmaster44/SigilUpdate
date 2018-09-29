int StartingConditional(int iSubRace)
{
    object oPC = GetPCSpeaker();

	int iCheck = GetSubRace(oPC);

	if(iCheck == iSubRace)
	  return TRUE;
	else
	  return FALSE;
}