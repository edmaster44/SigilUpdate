

//**************************************
//ga_set_customvariables
//Sets tokens with variables which might be needed in conversation
//for instance: name of random npc
//uses Custom Tokens 6000+
//6001 = Name of a random male character (character #1)
//6002 = Nickname of a random male character (character #1)
//6003 = A Random Prime Location (Kingdom/village name)
//6004 = name of a character of the speakers gender (character #2)
//6005 = nickname of a character of the speakers gender (character #2)
//6006 = a location in sigil (also sets string, for later)
//6007 = if you're doing the debtor quest. . the debtor's name
//6008 = if you're doing the debtor quest. . the amount owed
//6009 = if you're doing the debtor quest. . who they owe the amount to
//**************************************

#include "ps_inc_flavortext"

string pickRandomSigilLocation() {

	int rand = Random(7)+1;
	switch(rand) {
		case 1: SetLocalString(OBJECT_SELF, "Destination", "Temple of the Abyss"); return "Temple of the Abyss";
		case 2: SetLocalString(OBJECT_SELF, "Destination", "Hall of Records"); return "Hall of Records";
		case 3: SetLocalString(OBJECT_SELF, "Destination", "Civic Festhall"); return "Civic Festhall";
		case 4: SetLocalString(OBJECT_SELF, "Destination", "Shattered Temple"); return "Shattered Temple";
		case 5: SetLocalString(OBJECT_SELF, "Destination", "Mortuary"); return "Mortuary";
		case 6: SetLocalString(OBJECT_SELF, "Destination", "Armory"); return "Armory";
		case 7: SetLocalString(OBJECT_SELF, "Destination", "Laboratory"); return "Laboratory, in the Lower Ward";
		default: SetLocalString(OBJECT_SELF, "Destination", "Laboratory"); return "Laboratory";
	}
	
	return "Gatehouse";

}

string pickPointofInterest() {

	int rand = Random(9)+1;
	switch(rand) {
		case 1: return "restaurant";
		case 2: return "bar";
		case 3: return "gallery";
		case 4: return "dive";
		case 5: return "eatery";
		case 6: return "tavern";
		case 7: return "inn";
		case 8: return "distillery";
		case 9: return "winery";
		default: return "restaurant";
	}
	
	return "restaurant";
}


void main () {

	object oPC = GetPCSpeaker();

	struct character randomCharMale = DetailCharacter(GENDER_MALE);
	struct character randomCharSpeaker = DetailCharacter(GetGender(OBJECT_SELF));
	SetCustomToken(6001, randomCharMale.firstname+" "+randomCharMale.lastname);
	SetCustomToken(6002, randomCharMale.nickname);
	SetCustomToken(6003, RandomString_GeneratePrimeLocationObscure());
	SetCustomToken(6004, randomCharSpeaker.firstname+" "+randomCharSpeaker.lastname);
	SetCustomToken(6005, randomCharSpeaker.nickname);
	SetCustomToken(6006, pickRandomSigilLocation());
	SetCustomToken(6007, pickPointofInterest());
	
	if (GetLocalString(OBJECT_SELF, "Slogan_1") != "")
		SetCustomToken(6010, GetLocalString(OBJECT_SELF, "Slogan_1"));
	if (GetLocalString(OBJECT_SELF, "Slogan_2") != "")
		SetCustomToken(6011, GetLocalString(OBJECT_SELF, "Slogan_2"));
	if (GetLocalString(OBJECT_SELF, "Slogan_3") != "")
		SetCustomToken(6012, GetLocalString(OBJECT_SELF, "Slogan_3"));
	if (GetLocalString(OBJECT_SELF, "Explanation") != "")
		SetCustomToken(6013, GetLocalString(OBJECT_SELF, "Explanation"));
	
	//mark everyone in the set as having been spoken to
	if (GetLocalString(OBJECT_SELF, "Berk_Type") == "Rioter") {
		int n;
		int nBerkNum = GetLocalInt(OBJECT_SELF, "NUM_RIOTERS");
		for (n = 1; n <= nBerkNum; n++) {
			object oBerk = GetLocalObject(OBJECT_SELF, "FELLOW_RIOTER_"+IntToString(n)); 
			SetLocalInt(oBerk, "talkto", 1);
		}
	}
	
	string sDebtorQuest = "ps_quest_debtorspole";
	int nHasDebtorQuest = GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + sDebtorQuest);
	if (nHasDebtorQuest > 0) {
		int nDebtor = GetLocalInt(OBJECT_SELF, "DEBTOR_INDEX");
		SetCustomToken(6007, GetLocalString(oPC, "DEBTOR_"+IntToString(nDebtor)+"_NAME"));
		SetCustomToken(6008, IntToString(GetLocalInt(oPC, "DEBTOR_"+IntToString(nDebtor)+"_BOUNTY")*3));
		SetCustomToken(6009, GetLocalString(oPC, "DEBTOR_"+IntToString(nDebtor)+"_OWED_TO"));
	}
	
}