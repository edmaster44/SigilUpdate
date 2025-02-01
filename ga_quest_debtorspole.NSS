#include "ff_safevar"

//Conversation script for the Debtors Pole
//Sets up the variables and pretty text
//3-12-20, Mimi Fearthegn
#include "ps_inc_flavortext"

string GetLastSeenAreaTag() {

	int nRand = Random(4)+1;
	switch(nRand) {
		case 1: return "ps_area_s_cw_clerksward";
		case 2: return "ps_area_s_hw_hiveward";
		case 3: return "ps_area_s_lo_lowerward";
		case 4: return "ps_area_s_lw_ladyswardnew";
	}
	
	return "ps_area_s_cw_clerksward";

}

string GetLastSeenWardFromTag(string sTag) {

	if (sTag == "ps_area_s_cw_clerksward")
		return "the Clerk's Ward";
	else if (sTag == "ps_area_s_hw_hiveward")
		return "the Hive Ward"; 
	else if (sTag == "ps_area_s_lo_lowerward")
		return "the Lower Ward"; 
	else if (sTag == "ps_area_s_lw_ladyswardnew")
		return "The Lady's Ward"; 
		
	return "the Clerk's Ward";

}

string GetMoneyOwedTo() {

	int nRand = Random(12)+1;
	switch(nRand) {
		case 1: return "Alexander Fish";
		case 2: return "Nellie";
		case 3: return "Tarion";
		case 4: return "Whisper";
		case 5: return "Dion";
		case 6: return "Minerva";
		case 7: return "Layla";
		case 8: return "Zharak";
		case 9: return "the Ravenwing Armory";
		case 10: return "Marroweater";
		case 11: return "Bria Tomay";
		case 12: return "Herman Bouldertank";
	}
	
	return "Nellie";
}

int GetGoldReward(object oPC) {

	int nHD = GetHitDice(oPC)-d6();
	if (nHD < 3)
		nHD = 3;
		
	return d100(nHD);

}

string PrintPrettyWantedPost(object oPC, int nDebtor) {

	string sName = PS_GetLocalString(oPC, "DEBTOR_"+IntToString(nDebtor)+"_NAME");
	string sBounty = IntToString(PS_GetLocalInt(oPC, "DEBTOR_"+IntToString(nDebtor)+"_BOUNTY"));
	string sAmount = IntToString(PS_GetLocalInt(oPC, "DEBTOR_"+IntToString(nDebtor)+"_BOUNTY")*3);
	string sOwedTo = PS_GetLocalString(oPC, "DEBTOR_"+IntToString(nDebtor)+"_OWED_TO");
	string sLastSeen = GetLastSeenWardFromTag(PS_GetLocalString(oPC, "DEBTOR_"+IntToString(nDebtor)+"_LOCATION"));
	
	string sResult = ""; 
	int nRand = Random(5)+1;
	switch(nRand) {
		case 1: sResult = "Offering a reward of "+sBounty+" jink to the cutter who finds "+sName+" and makes 'em return what's owed to me. - "+sOwedTo; break;
		case 2: sResult = "Let it be known to the merchants of the Great Bazaar that "+sName+" has defaulted on debts of "+sAmount+" jink to "+sOwedTo+". "+sBounty+" jink to the blood who collects."; break;
		case 3: sResult = "The scoundrel "+sName+" owes me "+sAmount+" jink. "+sBounty+" jink to the cutter who gets me my money. - "+sOwedTo; break; 
		case 4: sResult = "Wanted: "+sName+", or "+sAmount+" jink, owed to me for services rendered. - "+sOwedTo; break; 
		case 5: sResult = "A pox on "+sName+" for cheating me out of "+sAmount+" jink. "+sBounty+" jink to the blood who gets me my money. - "+sOwedTo; break; 
	}
	
	sResult += "\n<i>The chant has it that "+sName+" was last seen in "+sLastSeen+"</i>\n\n";
	return sResult;
	
}

void main() {

	object oPC = GetPCSpeaker();
	string sQuestTag = "ps_quest_debtorspole";
	int nQuestStage = PS_GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + sQuestTag);
	
	string sPrintOut = "";
	
	if (nQuestStage <= 0) {
	
		struct character char1 = DetailCharacter(Random(2));
		PS_SetLocalInt(oPC, "DEBTOR_1_GENDER", char1.gender);
		PS_SetLocalString(oPC, "DEBTOR_1_NAME", char1.firstname+" "+char1.lastname);
		int nBounty = GetGoldReward(oPC);
		PS_SetLocalInt(oPC, "DEBTOR_1_BOUNTY", nBounty);
		PS_SetLocalString(oPC, "DEBTOR_1_OWED_TO", GetMoneyOwedTo());
		
		string lastSeenTag1 = GetLastSeenAreaTag();
		PS_SetLocalString(oPC, "DEBTOR_1_LOCATION", lastSeenTag1);
		
		struct character char2 = DetailCharacter(Random(2));
		PS_SetLocalInt(oPC, "DEBTOR_2_GENDER", char2.gender);
		PS_SetLocalString(oPC, "DEBTOR_2_NAME", char2.firstname+" "+char2.lastname);
		nBounty = GetGoldReward(oPC);
		PS_SetLocalInt(oPC, "DEBTOR_2_BOUNTY", nBounty);
		PS_SetLocalString(oPC, "DEBTOR_2_OWED_TO", GetMoneyOwedTo());
		
		string lastSeenTag2 = GetLastSeenAreaTag();
		PS_SetLocalString(oPC, "DEBTOR_2_LOCATION", lastSeenTag2);
		
		struct character char3 = DetailCharacter(Random(2));
		PS_SetLocalInt(oPC, "DEBTOR_3_GENDER", char3.gender);
		PS_SetLocalString(oPC, "DEBTOR_3_NAME", char3.firstname+" "+char3.lastname);
		nBounty = GetGoldReward(oPC);
		PS_SetLocalInt(oPC, "DEBTOR_3_BOUNTY", nBounty);
		PS_SetLocalString(oPC, "DEBTOR_3_OWED_TO", GetMoneyOwedTo());
		
		string lastSeenTag3 = GetLastSeenAreaTag();
		PS_SetLocalString(oPC, "DEBTOR_3_LOCATION", lastSeenTag3);
		
		AddJournalQuestEntry(sQuestTag, 1, oPC);
	
	} 
	
	sPrintOut += PrintPrettyWantedPost(oPC, 1);
	sPrintOut += PrintPrettyWantedPost(oPC, 2);
	sPrintOut += PrintPrettyWantedPost(oPC, 3);
	
	SetCustomToken(6001, sPrintOut);

}