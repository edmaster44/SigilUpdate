//Gives you the appropriate gold reward for the debtor's pole quests

void main() {

	object oPC = GetPCSpeaker();
	string sQuestTag = "ps_quest_debtorspole";
	int nQuestStage = GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + sQuestTag);
	AddJournalQuestEntry(sQuestTag, nQuestStage+1, oPC);
	
	int nDebtor = GetLocalInt(OBJECT_SELF, "DEBTOR_INDEX");
	SetLocalInt(oPC, "DEBTOR_"+IntToString(nDebtor)+"_DONE", 1);
	int nBounty = GetLocalInt(oPC, "DEBTOR_"+IntToString(nDebtor)+"_BOUNTY");
	int nAmount = nBounty*3;
	string sOwedTo = GetLocalString(oPC, "DEBTOR_"+IntToString(nDebtor)+"_OWED_TO");
	
	if (GetLocalInt(OBJECT_SELF, "DEBTOR_FAIL") > 0) {
		SendMessageToPC(oPC, "You recovered none of the "+IntToString(nAmount)+" jink owed to "+sOwedTo+", and so collect no bounty.");
	} else if (GetLocalInt(OBJECT_SELF, "DEBTOR_EXCHANGE") > 0) {
		SendMessageToPC(oPC, "You return the "+IntToString(nAmount)+" jink owed to "+sOwedTo+", collect the bounty, and keep the magical item.");
		TakeGoldFromCreature(nAmount-nBounty, oPC, TRUE);
	} else if (GetLocalInt(OBJECT_SELF, "DEBTOR_PARTIAL") > 0) {
		int nRand = d3();
		int nReturned = nAmount;
		if (nRand == 1) {
			nReturned = nAmount/4;
			SendMessageToPC(oPC, "You recover "+IntToString(nReturned)+" of the "+IntToString(nAmount)+" jink owed to "+sOwedTo+". You are awarded part of the bounty posted, proportional to the amount recovered.");
			GiveGoldToCreature(oPC, nReturned/3);
		} else if (nRand == 2) {
			nReturned = nAmount/3;
			SendMessageToPC(oPC, "You recover "+IntToString(nReturned)+" of the "+IntToString(nAmount)+" jink owed to "+sOwedTo+". You are awarded part of the bounty posted, proportional to the amount recovered.");
			GiveGoldToCreature(oPC, nReturned/3);
		} else if (nRand == 3) {
			nReturned = nAmount/2;
			SendMessageToPC(oPC, "You recover "+IntToString(nReturned)+" of the "+IntToString(nAmount)+" jink owed to "+sOwedTo+". You are awarded part of the bounty posted, proportional to the amount recovered.");
			GiveGoldToCreature(oPC, nReturned/3);
		}
	} else {
		SendMessageToPC(oPC, "You return the "+IntToString(nAmount)+" jink owed to "+sOwedTo+", and collect the bounty.");
		GiveGoldToCreature(oPC, nBounty);
	}

}