void main (string sQUEST, int nSTATE, int nPARTY, int nALL, int nOVERRIDE)
{
	object oPC = GetPCSpeaker();
	AddJournalQuestEntry(sQUEST, nSTATE, oPC, nPARTY, nALL, nOVERRIDE);
}