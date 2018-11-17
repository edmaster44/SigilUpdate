#include "x2_inc_compon"
#include "x0_i0_spawncond"
#include "ps_inc_scriptcall"
#include "ps_inc_gemstones"

string sCategoryTag = GetLocalString(object OBJECT_SELF, string sQuestName);
int nEntryID = GetLocalInteger(object OBJECT_SELF, int iQuestState);

void main(string sCategoryTag, int nEntryID, int bAllPartyMembers, int bAllPlayers, int bAllowOverrideHigher);
{
	object oPC = (GetLastKiller();
	AddJournalQuestEntry(sCategoryTag,nEntryID,oPC, 1, 0, 0);
}	