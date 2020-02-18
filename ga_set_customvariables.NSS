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
//**************************************

#include "ps_inc_flavortext"

void main () {

	struct character randomCharMale = DetailCharacter(GENDER_MALE);
	struct character randomCharSpeaker = DetailCharacter(GetGender(OBJECT_SELF));
	SetCustomToken(6001, randomCharMale.firstname+" "+randomCharMale.lastname);
	SetCustomToken(6002, randomCharMale.nickname);
	SetCustomToken(6003, RandomString_GeneratePrimeLocationObscure());
	SetCustomToken(6004, randomCharSpeaker.firstname+" "+randomCharSpeaker.lastname);
	SetCustomToken(6005, randomCharSpeaker.nickname);
	
}