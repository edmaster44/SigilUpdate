void main (string sQUEST, int nSTATE, int nPARTY = FALSE, int nALL = FALSE, int nOVERRIDE = FALSE)
{
	object oPC = GetPCSpeaker();
	AddJournalQuestEntry(sQUEST, nSTATE, oPC, nPARTY, nALL, nOVERRIDE);
}