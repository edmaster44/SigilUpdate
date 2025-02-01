#include "ff_safevar"

//
/*
   Activate item - Love Potion
   It searches for the nearest PC or NPC
   And then gives you silly messages about how amazing they are :)
   
*/
#include "aaa_constants"

void DoLovePotion(object oPC);

object GetNearestVictim(object oPC);

void FallInLoveWith(object oPC, object oTarget);

int GetHighestAbility(object oTarget) {

	int highestAbility = 0;
	int highestValue = 0;
	
	int n;
	for (n = 0; n < 6; n++) {
		int nScore = GetAbilityScore(oTarget, n);
		if (nScore > highestValue) {
			highestAbility = n;
			highestValue = nScore;
		}
	}
	
	return highestAbility;

}

void main() {

    object oPC = GetItemActivator();
	
	//reset counter
	PS_DeleteLocalInt(oPC, "LOVE_POTION");
	
	DoLovePotion(oPC);
	
}


object GetNearestVictim(object oPC) {

	object oNPCVictim = OBJECT_INVALID;
	
	int n;
	for (n = 1; n < 10; n++) {
	
		object oVictim = GetNearestObject(OBJECT_TYPE_CREATURE, oPC, n);
		if (!GetIsObjectValid(oVictim))
			break;
			
		if (GetIsPC(oVictim) && oVictim != oPC) //always favor PC victims
			return oVictim;
		else if (!GetIsObjectValid(oNPCVictim) && !GetIsReactionTypeHostile(oVictim, oPC)) //We haven't found a valid npc victim yet
			oNPCVictim = oVictim;
	
	}
	
	return oNPCVictim;

}

void DoLovePotion(object oPC) {

	object oVictim = GetNearestVictim(oPC);
	SendMessageToPC(oPC, "Checking for victims.");
	
	if (GetIsObjectValid(oVictim)) {
		FallInLoveWith(oPC, oVictim);
	} else {
		
		//We'll keep checking for people in the vicinity
		//At least 10 times
		int nTimesChecked = PS_GetLocalInt(oPC, "LOVE_POTION");
		if (nTimesChecked < 10) {
			PS_SetLocalInt(oPC, "LOVE_POTION", nTimesChecked++);
			
			DelayCommand(120.0f, DoLovePotion(oPC));
		}
		
	}

}

void FallInLoveWith(object oPC, object oTarget) {

	SendMessageToPC(oPC, "<i>You feel a sudden attraction to "+GetName(oTarget)+"</i>");
		
	//*******************************************************
	//Outsider types
	//*******************************************************
	//Celestials
	if (GetSubRace(oTarget) == RACIAL_SUBTYPE_AASIMON || GetSubRace(oTarget) == RACIAL_SUBTYPE_ARCHON || GetSubRace(oTarget) == RACIAL_SUBTYPE_ELADRIN) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>You instantly feel safe around her. She's a good person. An admirable person.</i>");
		else
			SendMessageToPC(oPC, "<i>You instantly feel safe around him. He's a good person. An admirable person.</i>");
		return;
	}
		
	//Fiends
	if (GetSubRace(oTarget) == RACIAL_SUBTYPE_BAATEZU || GetSubRace(oTarget) == RACIAL_SUBTYPE_TANARRI) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>She's dangerous, but that's just part of the attraction. You are filled with desire for her.</i>");
		else
			SendMessageToPC(oPC, "<i>He's dangerous, but that's just part of the attraction. You are filled with desire for him.</i>");
		return;
	}
		
	//Slaad
	if (GetSubRace(oTarget) == RACIAL_SUBTYPE_SLAAD) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>The embodiment of chaos. . she beckons you to let go of yourself.</i>");
		else
			SendMessageToPC(oPC, "<i>The embodiment of chaos. . he beckons you to let go of yourself.</i>");
		return;
	}
		
	//Rakshasa, and other furries
	if (GetSubRace(oTarget) == RACIAL_SUBTYPE_RAKSHASA || GetSubRace(oTarget) == RACIAL_SUBTYPE_LUPINAL || GetSubRace(oTarget) == RACIAL_SUBTYPE_ARCANALOTH) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>Her soft glossy fur, her proud bearing, her knowing eyes. . .</i>");
		else
			SendMessageToPC(oPC, "<i>His soft glossy fur, his proud bearing, his knowing eyes. . .</i>");
		return;
	}
	
	//*******************************************************
	//Abberant types
	//*******************************************************
	//Beholder
	if (GetSubRace(oTarget) == RACIAL_SUBTYPE_BEHOLDER) {
		SendMessageToPC(oPC, "<i>Its many eyes look deep into your soul. Its eyestalks sway gently as it levitates - the epitome of grace. Its body is an imperfect sphere that you long to caress.</i>");
		return;
	}
	//Drider, female
	if (GetSubRace(oTarget) == RACIAL_SUBTYPE_DRIDER_FEMALE) {
		SendMessageToPC(oPC, "<i>Her ebony skin is perfect, her body is perfectly formed. You long for her many legs to embrace you.</i>");
		return;
	}
	//Drider, male
	if (GetSubRace(oTarget) == RACIAL_SUBTYPE_DRIDER_MALE) {
		SendMessageToPC(oPC, "<i>His ebony skin is perfect, his body is perfectly formed. You long for his many legs to embrace you.</i>");
		return;
	}
	//Umber Hulk
	if (GetSubRace(oTarget) == RACIAL_SUBTYPE_UMBER_HULK) {
		SendMessageToPC(oPC, "<i>You stare into its many fascinated eyes, and loose yourself. You long to run your hands over its chitinous skin.</i>");
		return;
	}
	//Umber Hulk
	if (GetSubRace(oTarget) == RACIAL_SUBTYPE_UMBER_HULK) {
		SendMessageToPC(oPC, "<i>You stare into its many fascinated eyes, and loose yourself. You long to run your hands over its chitinous skin.</i>");
		return;
	}
	//Elan
	if (GetSubRace(oTarget) == RACIAL_SUBTYPE_ELAN || GetSubRace(oTarget) == RACIAL_SUBTYPE_XEPH) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>There is something so otherworldly about her. Her eyes fascinate you.</i>");
		else
			SendMessageToPC(oPC, "<i>There is something so otherworldly about him. His eyes fascinate you.</i>");
		return;
	}
	//Catch all aberation - think mind flayer
	if (GetRacialType(oTarget) == RACIAL_TYPE_ABERRATION) {
		SendMessageToPC(oPC, "<i>Its skin looks so smooth and shiny, its tentatacles sway hypnotically. . .</i>");
		return;
	}
	
	//*******************************************************
	//Construct types
	//*******************************************************
	if (GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT) {
		SendMessageToPC(oPC, "<i>It looks so strong. So tall. It could defend you against anything. . and you're sure it would. You long to be held in its arms.</i>");
		return;
	}
	
	//*******************************************************
	//Dragon types
	//*******************************************************
	if (GetRacialType(oTarget) == RACIAL_TYPE_DRAGON) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>She's so wise, so knowing. You feel as though she holds the secrets of the multiverse. . .</i>");
		else
			SendMessageToPC(oPC, "<i>He's so wise, so knowing. You feel as though he holds the secrets of the multiverse. . .</i>");
		return;
	}
	
	//*******************************************************
	//Dwarf types
	//*******************************************************
	if (GetRacialType(oTarget) == RACIAL_TYPE_DWARF) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>Her broad shoulders, her ample bossom, her motherly features. . .</i>");
		else
			SendMessageToPC(oPC, "<i>His broad shoulders, his strong arms, his manly beard. . .</i>");
		return;
	}
	
	//*******************************************************
	//Elemental types
	//*******************************************************
	if (GetSubRace(oTarget) == RACIAL_SUBTYPE_DAO || GetSubRace(oTarget) == RACIAL_SUBTYPE_EARTH_GENASI) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>Her wisdom, her sparkling gemlike eyes, her ample curves. . .</i>");
		else
			SendMessageToPC(oPC, "<i>His wisdom, his sparkling gemlike eyes, his strength. . . You are certain he could move mountains with a thought.</i>");
		return;
	}
	if (GetSubRace(oTarget) == RACIAL_SUBTYPE_MARID || GetSubRace(oTarget) == RACIAL_SUBTYPE_WATER_GENASI) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>Her wisdom, her soft skin, her eyes as deep as the ocean. You are mesmerized by her graceful movements.</i>");
		else
			SendMessageToPC(oPC, "<i>His wisdom, his eyes as deep as the ocean. You are mesmerized by his graceful powerful movements.</i>");
		return;
	}
	if (GetSubRace(oTarget) == RACIAL_SUBTYPE_DJINN || GetSubRace(oTarget) == RACIAL_SUBTYPE_JANN || GetSubRace(oTarget) == RACIAL_SUBTYPE_AIR_GENASI) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>She is as light as air; she seems to glide rather than walk on the ground. She is as bright as a sunny day, and as terrible as a great storm.</i>");
		else
			SendMessageToPC(oPC, "<i>He is as light as air; he seems to glide rather than walk on the ground. He is as bright as a sunny day, and as terrible as a great storm.</i>");
		return;
	}
	if (GetSubRace(oTarget) == RACIAL_SUBTYPE_EFREET || GetSubRace(oTarget) == RACIAL_SUBTYPE_FIRE_GENASI) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>Her eyes are like flickering embers, her joy like a leaping flame, and her wrath like a volcano. You are fascinated by her.</i>");
		else
			SendMessageToPC(oPC, "<i>His eyes are like flickering embers, his joy like a leaping flame, and his wrath like a volcano. You are fascinated by him.</i>");
		return;
	}
	if (GetSubRace(oTarget) == RACIAL_SUBTYPE_KHAYAL) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>Her eyes are pools of shadow, you feel like you could loose yourself within them.</i>");
		else
			SendMessageToPC(oPC, "<i>His eyes are pools of shadow, you feel like you could loose yourself within them.</i>");
		return;
	}
	if (GetSubRace(oTarget) == RACIAL_SUBTYPE_FIRE_MEPHIT || GetSubRace(oTarget) == RACIAL_SUBTYPE_ICE_MEPHIT || GetSubRace(oTarget) == RACIAL_SUBTYPE_EARTH_MEPHIT) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>She dances through the air, held aloft by tiny wings. Playful. Whimsical.</i>");
		else
			SendMessageToPC(oPC, "<i>He dances through the air, held aloft by tiny wings. Playful. Whimsical.</i>");
		return;
	}
	if (GetRacialType(oTarget) == RACIAL_TYPE_ELEMENTAL) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>Her wisdom is the knowledge of ages, her form made of the building blocks of the multiverse.</i>");
		else
			SendMessageToPC(oPC, "<i>His wisdom is the knowledge of ages, his form made of the building blocks of the multiverse.</i>");
		return;
	}
	
	//*******************************************************
	//Fey types
	//*******************************************************
	if (GetRacialType(oTarget) == RACIAL_TYPE_FEY) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>Her very presence is intoxicating. You want to dance, to sing, to follow her wherever she leads. . .</i>");
		else
			SendMessageToPC(oPC, "<i>His very presence is intoxicating. You want to dance, to sing, to follow him wherever he leads. . .</i>");
		return;
	}
	
	//*******************************************************
	//Giant types
	//*******************************************************
	if (GetSubRace(oTarget) == RACIAL_SUBTYPE_FIRE_GIANT_NEW || GetSubRace(oTarget) == RACIAL_SUBTYPE_FIRE_GIANT) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>Her form is perfect, on a large scale. Powerful, but graceful.</i>");
		else
			SendMessageToPC(oPC, "<i>His broad shoulders, his well muscled arms. . he's perfection. . . and so big.</i>");
		return;
	}
	
	if (GetSubRace(oTarget) == RACIAL_SUBTYPE_FROST_GIANT || GetSubRace(oTarget) == RACIAL_SUBTYPE_FROST_GIANT_NEW) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>Her form is perfect, on a large scale. Powerful, but graceful.</i>");
		else
			SendMessageToPC(oPC, "<i>His broad shoulders, his well muscled arms. . he's perfection. . . and so big.</i>");
		return;
	}
	
	if (GetRacialType(oTarget) == RACIAL_TYPE_GIANT) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>She is a pillar of strength, statuesqe, towering into the sky, perfectly formed.</i>");
		else
			SendMessageToPC(oPC, "<i>He is a pillar of strength, statuesqe, towering into the sky, perfectly formed. . . and so big.</i>");
		return;
	}
	
	//*******************************************************
	//Humanoid Types
	//*******************************************************
	//Kenku
	if (GetSubRace(oTarget) == RACIAL_SUBTYPE_KENKU) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>Her glossy well-kept feathers, her sparkling eyes, her shiny beak. . .</i>");
		else
			SendMessageToPC(oPC, "<i>His glossy well-kept feathers, his sparkling eyes, his shiny beak. . .</i>");
		return;
	}
	
	//Catch all
	if (GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_GOBLINOID || GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_MONSTROUS || GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_ORC || GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_OTHER) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>You used to think her homely, but now you realize that she has a rugged beauty.</i>");
		else
			SendMessageToPC(oPC, "<i>You used to think him homely, but now you realize that he has a rugged handsomness.</i>");
		return;
	}
	
	//*******************************************************
	//Animal Types
	//*******************************************************
	if (GetRacialType(oTarget) == RACIAL_TYPE_ANIMAL || GetRacialType(oTarget) == RACIAL_TYPE_BEAST || GetRacialType(oTarget) == RACIAL_TYPE_MAGICAL_BEAST) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>Her fur is sleek and shiny, her eyes belie hidden intelligence.</i>");
		else
			SendMessageToPC(oPC, "<i>His fur is sleek and shiny, his eyes belie hidden intelligence.</i>");
		return;
	}
	
	//*******************************************************
	//Plant Types
	//*******************************************************
	if (GetRacialType(oTarget) == RACIAL_TYPE_PLANT) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>Her very existence is rooted, you recognize her sensible nature. You are intoxicated with her presence.</i>");
		else
			SendMessageToPC(oPC, "<i>His very existence is rooted, you recognize his sensible nature. You are intoxicated with his presence.</i>");
		return;
	}
	
	//*******************************************************
	//Reptilian Types
	//*******************************************************
	if (GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_REPTILIAN) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>Her scales are smooth and glistening. Her eyes see right through you.</i>");
		else
			SendMessageToPC(oPC, "<i>His scales are smooth and glistening. His eyes see right through you.</i>");
		return;
	}
	
	//*******************************************************
	//Undead Types
	//*******************************************************
	if (GetRacialType(oTarget) == RACIAL_SUBTYPE_UNDEAD) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>Her beauty is ephemeral. As fleeting as this life, as eternal as death. . .</i>");
		else
			SendMessageToPC(oPC, "<i>His beauty is ephemeral. As fleeting as this life, as eternal as death. . .</i>");
		return;
	}
	
	//*******************************************************
	//Ability switches
	//*******************************************************
	int nAbility = GetHighestAbility(oTarget);
	if (nAbility == ABILITY_STRENGTH) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>Her body is well toned, perfectly formed. Her curves are in all the right places.</i>");
		else
			SendMessageToPC(oPC, "<i>His body is well toned, perfectly formed. His shoulders are broad, his arms well muscled. You know you could rely upon him, and you long to feel the strength of his embrace.</i>");
		return;
	}
	if (nAbility == ABILITY_DEXTERITY) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>Her movements are graceful, her body is lithe. You are mesmerized by her poise and agility, and long to see her dance.</i>");
		else
			SendMessageToPC(oPC, "<i>His movements are graceful, his body taunt and lithe. He holds himself with poise. You are mesmerized by his agility and capabilities.</i>");
		return;
	}
	
	if (nAbility == ABILITY_CONSTITUTION) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>Her curvaceous body is easy on the eyes. Her ruddy cheeks glow with health.</i>");
		else
			SendMessageToPC(oPC, "<i>His body is toned, and well formed, easy on the eyes. His ruddy cheeks glow with health. And his stamina. . .</i>");
		return;
	}
	
	if (nAbility == ABILITY_INTELLIGENCE) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>She has a quick mind, and a keen wit. You cannot help but laugh at her jokes.</i>");
		else
			SendMessageToPC(oPC, "<i>He has a quick mind, and a keen wit. You cannot help but laugh at his jokes.</i>");
		return;
	}
	
	if (nAbility == ABILITY_WISDOM) {
		if (GetGender(oTarget) == GENDER_FEMALE)
			SendMessageToPC(oPC, "<i>Her eyes look deep into your soul, and you feel you could tell her anything. She is understanding, and empathetic.</i>");
		else
			SendMessageToPC(oPC, "<i>His eyes look deep into your soul, and you feel that you could tell him anything. He is understanding, and empathetic.</i>");
		return;
	}
	
	//Fallback is Charisma
	if (GetGender(oTarget) == GENDER_FEMALE)
		SendMessageToPC(oPC, "<i>You feel drawn to her. . . the way she holds herself, the confidence with which she speaks. You would follow her to the ends of the multiverse. If only she would notice you. . .</i>");
	else
		SendMessageToPC(oPC, "<i>You feel drawn to him. . . the confidences of his bearing, his commanding tone of voice. You would follow him to the ends of the multiverse. If only he would notice you. . . </i>");


}