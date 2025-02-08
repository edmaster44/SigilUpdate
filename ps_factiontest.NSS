#include "ff_safevar"

string Harmonium = "faction_1"; //lawful
string Mercykiller = "faction_2"; //lawful
string Guvner = "faction_3"; //lawful
string Fated = "faction_4"; //neutral
string Doomguard = "faction_5"; //chaotic
string Xaos = "faction_6"; //chaotic
string Dustmen = "faction_7"; //chaotic
string Bleakers = "faction_8"; //chaotic
string Sensates = "faction_9"; //chaotic
string Signers = "faction_10"; //neutral
string Ciphers = "faction_11"; //neutral
string Indeps = "faction_12"; //chaotic
string Anarchs = "faction_13"; //chaotic
string Athar = "faction_14"; //neutral
string Godsmen = "faction_15"; //neutral

void CalculateBonuses(object oPC, string bonus) {

	if (bonus == "")
		return;

	if (bonus == "Triad") {
		PS_SetLocalInt(oPC, Harmonium, PS_GetLocalInt(oPC,Harmonium)+1);
		PS_SetLocalInt(oPC, Mercykiller, PS_GetLocalInt(oPC, Mercykiller)+1);
		PS_SetLocalInt(oPC, Guvner, PS_GetLocalInt(oPC, Guvner)+1);
	}else if (bonus == "Lawful") {
		PS_SetLocalInt(oPC, Harmonium, PS_GetLocalInt(oPC, Harmonium)+1);
		PS_SetLocalInt(oPC, Mercykiller, PS_GetLocalInt(oPC, Mercykiller)+1);
		PS_SetLocalInt(oPC, Guvner, PS_GetLocalInt(oPC, Guvner)+1);
	} else if (bonus == "Chaotic") {
		PS_SetLocalInt(oPC, Doomguard, PS_GetLocalInt(oPC, Doomguard)+1);
		PS_SetLocalInt(oPC, Xaos, PS_GetLocalInt(oPC, Xaos)+1);
		PS_SetLocalInt(oPC, Bleakers, PS_GetLocalInt(oPC, Bleakers)+1);
		PS_SetLocalInt(oPC, Sensates, PS_GetLocalInt(oPC, Sensates)+1);
		PS_SetLocalInt(oPC, Indeps, PS_GetLocalInt(oPC, Indeps)+1);
		PS_SetLocalInt(oPC, Anarchs, PS_GetLocalInt(oPC, Anarchs)+1);
	} else if (bonus == "Neutral") {
		PS_SetLocalInt(oPC, Godsmen, PS_GetLocalInt(oPC, Godsmen)+1);
		PS_SetLocalInt(oPC, Athar, PS_GetLocalInt(oPC, Athar)+1);
		PS_SetLocalInt(oPC, Ciphers, PS_GetLocalInt(oPC, Ciphers)+1);
		PS_SetLocalInt(oPC, Signers, PS_GetLocalInt(oPC, Signers)+1);
		PS_SetLocalInt(oPC, Fated, PS_GetLocalInt(oPC, Fated)+1);
		PS_SetLocalInt(oPC, Dustmen, PS_GetLocalInt(oPC, Dustmen)+1);
	} else if (bonus == "Good") {
		PS_SetLocalInt(oPC, Harmonium, PS_GetLocalInt(oPC, Harmonium)+1);
		PS_SetLocalInt(oPC, Sensates, PS_GetLocalInt(oPC, Sensates)+1);
		PS_SetLocalInt(oPC, Signers, PS_GetLocalInt(oPC, Signers)+1);
		PS_SetLocalInt(oPC, Ciphers, PS_GetLocalInt(oPC, Ciphers)+1);
	} else if (bonus == "Evil") {
		PS_SetLocalInt(oPC, Doomguard, PS_GetLocalInt(oPC, Doomguard)+1);
		PS_SetLocalInt(oPC, Mercykiller, PS_GetLocalInt(oPC, Mercykiller)+1);
		PS_SetLocalInt(oPC, Dustmen, PS_GetLocalInt(oPC, Dustmen)+1);
		PS_SetLocalInt(oPC, Bleakers, PS_GetLocalInt(oPC, Bleakers)+1);
	} else if (bonus == "Optimistic") {
		PS_SetLocalInt(oPC, Harmonium, PS_GetLocalInt(oPC,Harmonium)+1);
		PS_SetLocalInt(oPC, Mercykiller, PS_GetLocalInt(oPC, Mercykiller)+1);
		PS_SetLocalInt(oPC, Guvner, PS_GetLocalInt(oPC, Guvner)+1);
		PS_SetLocalInt(oPC, Sensates, PS_GetLocalInt(oPC, Sensates)+1);
		PS_SetLocalInt(oPC, Ciphers, PS_GetLocalInt(oPC, Ciphers)+1);
		PS_SetLocalInt(oPC, Signers, PS_GetLocalInt(oPC, Signers)+1);
		PS_SetLocalInt(oPC, Indeps, PS_GetLocalInt(oPC, Signers)+1);
		PS_SetLocalInt(oPC, Fated, PS_GetLocalInt(oPC, Signers)+1);
	} else if (bonus == "Pessimistic") {
		PS_SetLocalInt(oPC, Godsmen, PS_GetLocalInt(oPC,Godsmen)+1);
		PS_SetLocalInt(oPC, Athar, PS_GetLocalInt(oPC, Athar)+1);
		PS_SetLocalInt(oPC, Doomguard, PS_GetLocalInt(oPC, Doomguard)+1);
		PS_SetLocalInt(oPC, Dustmen, PS_GetLocalInt(oPC, Dustmen)+1);
		PS_SetLocalInt(oPC, Bleakers, PS_GetLocalInt(oPC, Bleakers)+1);
		PS_SetLocalInt(oPC, Xaos, PS_GetLocalInt(oPC, Xaos)+1);
		PS_SetLocalInt(oPC, Anarchs, PS_GetLocalInt(oPC, Xaos)+1);
	} else if (bonus == "Doer") {
		PS_SetLocalInt(oPC, Harmonium, PS_GetLocalInt(oPC,Harmonium)+1);
		PS_SetLocalInt(oPC, Mercykiller, PS_GetLocalInt(oPC, Mercykiller)+1);
		PS_SetLocalInt(oPC, Guvner, PS_GetLocalInt(oPC, Guvner)+1);
		PS_SetLocalInt(oPC, Doomguard, PS_GetLocalInt(oPC, Doomguard)+1);
		PS_SetLocalInt(oPC, Fated, PS_GetLocalInt(oPC, Fated)+1);
		PS_SetLocalInt(oPC, Indeps, PS_GetLocalInt(oPC, Indeps)+1);
		PS_SetLocalInt(oPC, Anarchs, PS_GetLocalInt(oPC, Anarchs)+1);
	}  else if (bonus == "Thinker") {
		PS_SetLocalInt(oPC, Sensates, PS_GetLocalInt(oPC, Sensates)+1);
		PS_SetLocalInt(oPC, Godsmen, PS_GetLocalInt(oPC, Godsmen)+1);
		PS_SetLocalInt(oPC, Ciphers, PS_GetLocalInt(oPC, Ciphers)+1);
		PS_SetLocalInt(oPC, Signers, PS_GetLocalInt(oPC, Signers)+1);
		PS_SetLocalInt(oPC, Xaos, PS_GetLocalInt(oPC, Xaos)+1);
		PS_SetLocalInt(oPC, Bleakers, PS_GetLocalInt(oPC, Bleakers)+1);
		PS_SetLocalInt(oPC, Dustmen, PS_GetLocalInt(oPC, Dustmen)+1);	
		PS_SetLocalInt(oPC, Athar, PS_GetLocalInt(oPC, Athar)+1);	
	} else if (bonus == "Harmonium") {
		PS_SetLocalInt(oPC, Harmonium, PS_GetLocalInt(oPC, Harmonium)+1);
	} else if (bonus == "Mercykiller") {
		PS_SetLocalInt(oPC, Mercykiller, PS_GetLocalInt(oPC, Mercykiller)+1);
	} else if (bonus == "Guvner") {
		PS_SetLocalInt(oPC, Guvner, PS_GetLocalInt(oPC, Guvner)+1);
	} else if (bonus == "Fated") {
		PS_SetLocalInt(oPC, Fated, PS_GetLocalInt(oPC, Fated)+1);
	} else if (bonus == "Doomguard") {
		PS_SetLocalInt(oPC, Doomguard, PS_GetLocalInt(oPC, Doomguard)+1);
	} else if (bonus == "Xaos") {
		PS_SetLocalInt(oPC, Xaos, PS_GetLocalInt(oPC, Xaos)+1);
	} else if (bonus == "Dustmen") {
		PS_SetLocalInt(oPC, Dustmen, PS_GetLocalInt(oPC, Dustmen)+1);
	} else if (bonus == "Bleaker") {
		PS_SetLocalInt(oPC, Bleakers, PS_GetLocalInt(oPC, Bleakers)+1);
	} else if (bonus == "Sensate") {
		PS_SetLocalInt(oPC, Sensates, PS_GetLocalInt(oPC, Sensates)+1);
	} else if (bonus == "Signer") {
		PS_SetLocalInt(oPC, Signers, PS_GetLocalInt(oPC, Signers)+1);
	} else if (bonus == "Cipher") {
		PS_SetLocalInt(oPC, Ciphers, PS_GetLocalInt(oPC, Ciphers)+1);
	} else if (bonus == "Indep") {
		PS_SetLocalInt(oPC, Indeps, PS_GetLocalInt(oPC, Indeps)+1);
	} else if (bonus == "Anarch") {
		PS_SetLocalInt(oPC, Anarchs, PS_GetLocalInt(oPC, Anarchs)+1);
	} else if (bonus == "Athar") {
		PS_SetLocalInt(oPC, Athar, PS_GetLocalInt(oPC, Athar)+1);
	} else if (bonus == "Godsmen") {
		PS_SetLocalInt(oPC, Godsmen, PS_GetLocalInt(oPC, Godsmen)+1);
	} else {
		SendMessageToPC(oPC, "No term found for: "+bonus);
	}

}

void main (string bonus1, string bonus2, string bonus3, string bonus4) {

	object oPC = GetPCSpeaker();
	CalculateBonuses(oPC, bonus1);
	CalculateBonuses(oPC, bonus2);
	CalculateBonuses(oPC, bonus3);
	CalculateBonuses(oPC, bonus4);

}