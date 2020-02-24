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

void main () {

	struct character randomCharMale = DetailCharacter(GENDER_MALE);
	struct character randomCharSpeaker = DetailCharacter(GetGender(OBJECT_SELF));
	SetCustomToken(6001, randomCharMale.firstname+" "+randomCharMale.lastname);
	SetCustomToken(6002, randomCharMale.nickname);
	SetCustomToken(6003, RandomString_GeneratePrimeLocationObscure());
	SetCustomToken(6004, randomCharSpeaker.firstname+" "+randomCharSpeaker.lastname);
	SetCustomToken(6005, randomCharSpeaker.nickname);
	SetCustomToken(6006, pickRandomSigilLocation());
	
}