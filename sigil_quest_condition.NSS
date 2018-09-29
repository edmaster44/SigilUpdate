//This will check if sQUEST's progress ID of oPC is equal to nSTEP.
//nHIGHER: if TRUE it will also check if the progress if higher than nSTEP.
int StartingConditional(string sQUEST, int nSTEP, int nHIGHER = FALSE)
{
	object oPC = GetPCSpeaker();
	int nSTATE = GetJournalEntry(sQUEST, oPC);
	if (nSTATE == nSTEP) return TRUE;
	if ((nHIGHER == TRUE)&&(nSTATE > nSTEP)) return TRUE;
	return FALSE;
}