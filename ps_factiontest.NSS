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
		SetLocalInt(oPC, Harmonium, GetLocalInt(oPC,Harmonium)+1);
		SetLocalInt(oPC, Mercykiller, GetLocalInt(oPC, Mercykiller)+1);
		SetLocalInt(oPC, Guvner, GetLocalInt(oPC, Guvner)+1);
	}else if (bonus == "Lawful") {
		SetLocalInt(oPC, Harmonium, GetLocalInt(oPC, Harmonium)+1);
		SetLocalInt(oPC, Mercykiller, GetLocalInt(oPC, Mercykiller)+1);
		SetLocalInt(oPC, Guvner, GetLocalInt(oPC, Guvner)+1);
	} else if (bonus == "Chaotic") {
		SetLocalInt(oPC, Doomguard, GetLocalInt(oPC, Doomguard)+1);
		SetLocalInt(oPC, Xaos, GetLocalInt(oPC, Xaos)+1);
		SetLocalInt(oPC, Bleakers, GetLocalInt(oPC, Bleakers)+1);
		SetLocalInt(oPC, Sensates, GetLocalInt(oPC, Sensates)+1);
		SetLocalInt(oPC, Indeps, GetLocalInt(oPC, Indeps)+1);
		SetLocalInt(oPC, Anarchs, GetLocalInt(oPC, Anarchs)+1);
	} else if (bonus == "Neutral") {
		SetLocalInt(oPC, Godsmen, GetLocalInt(oPC, Godsmen)+1);
		SetLocalInt(oPC, Athar, GetLocalInt(oPC, Athar)+1);
		SetLocalInt(oPC, Ciphers, GetLocalInt(oPC, Ciphers)+1);
		SetLocalInt(oPC, Signers, GetLocalInt(oPC, Signers)+1);
		SetLocalInt(oPC, Fated, GetLocalInt(oPC, Fated)+1);
		SetLocalInt(oPC, Dustmen, GetLocalInt(oPC, Dustmen)+1);
	} else if (bonus == "Good") {
		SetLocalInt(oPC, Harmonium, GetLocalInt(oPC, Harmonium)+1);
		SetLocalInt(oPC, Sensates, GetLocalInt(oPC, Sensates)+1);
		SetLocalInt(oPC, Signers, GetLocalInt(oPC, Signers)+1);
		SetLocalInt(oPC, Ciphers, GetLocalInt(oPC, Ciphers)+1);
	} else if (bonus == "Evil") {
		SetLocalInt(oPC, Doomguard, GetLocalInt(oPC, Doomguard)+1);
		SetLocalInt(oPC, Mercykiller, GetLocalInt(oPC, Mercykiller)+1);
		SetLocalInt(oPC, Dustmen, GetLocalInt(oPC, Dustmen)+1);
		SetLocalInt(oPC, Bleakers, GetLocalInt(oPC, Bleakers)+1);
	} else if (bonus == "Optimistic") {
		SetLocalInt(oPC, Harmonium, GetLocalInt(oPC,Harmonium)+1);
		SetLocalInt(oPC, Mercykiller, GetLocalInt(oPC, Mercykiller)+1);
		SetLocalInt(oPC, Guvner, GetLocalInt(oPC, Guvner)+1);
		SetLocalInt(oPC, Sensates, GetLocalInt(oPC, Sensates)+1);
		SetLocalInt(oPC, Ciphers, GetLocalInt(oPC, Ciphers)+1);
		SetLocalInt(oPC, Signers, GetLocalInt(oPC, Signers)+1);
		SetLocalInt(oPC, Indeps, GetLocalInt(oPC, Signers)+1);
		SetLocalInt(oPC, Fated, GetLocalInt(oPC, Signers)+1);
	} else if (bonus == "Pessimistic") {
		SetLocalInt(oPC, Godsmen, GetLocalInt(oPC,Godsmen)+1);
		SetLocalInt(oPC, Athar, GetLocalInt(oPC, Athar)+1);
		SetLocalInt(oPC, Doomguard, GetLocalInt(oPC, Doomguard)+1);
		SetLocalInt(oPC, Dustmen, GetLocalInt(oPC, Dustmen)+1);
		SetLocalInt(oPC, Bleakers, GetLocalInt(oPC, Bleakers)+1);
		SetLocalInt(oPC, Xaos, GetLocalInt(oPC, Xaos)+1);
		SetLocalInt(oPC, Anarchs, GetLocalInt(oPC, Xaos)+1);
	} else if (bonus == "Doer") {
		SetLocalInt(oPC, Harmonium, GetLocalInt(oPC,Harmonium)+1);
		SetLocalInt(oPC, Mercykiller, GetLocalInt(oPC, Mercykiller)+1);
		SetLocalInt(oPC, Guvner, GetLocalInt(oPC, Guvner)+1);
		SetLocalInt(oPC, Doomguard, GetLocalInt(oPC, Doomguard)+1);
		SetLocalInt(oPC, Fated, GetLocalInt(oPC, Fated)+1);
		SetLocalInt(oPC, Indeps, GetLocalInt(oPC, Indeps)+1);
		SetLocalInt(oPC, Anarchs, GetLocalInt(oPC, Anarchs)+1);
	}  else if (bonus == "Thinker") {
		SetLocalInt(oPC, Sensates, GetLocalInt(oPC, Sensates)+1);
		SetLocalInt(oPC, Godsmen, GetLocalInt(oPC, Godsmen)+1);
		SetLocalInt(oPC, Ciphers, GetLocalInt(oPC, Ciphers)+1);
		SetLocalInt(oPC, Signers, GetLocalInt(oPC, Signers)+1);
		SetLocalInt(oPC, Xaos, GetLocalInt(oPC, Xaos)+1);
		SetLocalInt(oPC, Bleakers, GetLocalInt(oPC, Bleakers)+1);
		SetLocalInt(oPC, Dustmen, GetLocalInt(oPC, Dustmen)+1);	
		SetLocalInt(oPC, Athar, GetLocalInt(oPC, Athar)+1);	
	} else if (bonus == "Harmonium") {
		SetLocalInt(oPC, Harmonium, GetLocalInt(oPC, Harmonium)+1);
	} else if (bonus == "Mercykiller") {
		SetLocalInt(oPC, Mercykiller, GetLocalInt(oPC, Mercykiller)+1);
	} else if (bonus == "Guvner") {
		SetLocalInt(oPC, Guvner, GetLocalInt(oPC, Guvner)+1);
	} else if (bonus == "Fated") {
		SetLocalInt(oPC, Fated, GetLocalInt(oPC, Fated)+1);
	} else if (bonus == "Doomguard") {
		SetLocalInt(oPC, Doomguard, GetLocalInt(oPC, Doomguard)+1);
	} else if (bonus == "Xaos") {
		SetLocalInt(oPC, Xaos, GetLocalInt(oPC, Xaos)+1);
	} else if (bonus == "Dustmen") {
		SetLocalInt(oPC, Dustmen, GetLocalInt(oPC, Dustmen)+1);
	} else if (bonus == "Bleaker") {
		SetLocalInt(oPC, Bleakers, GetLocalInt(oPC, Bleakers)+1);
	} else if (bonus == "Sensate") {
		SetLocalInt(oPC, Sensates, GetLocalInt(oPC, Sensates)+1);
	} else if (bonus == "Signer") {
		SetLocalInt(oPC, Signers, GetLocalInt(oPC, Signers)+1);
	} else if (bonus == "Cipher") {
		SetLocalInt(oPC, Ciphers, GetLocalInt(oPC, Ciphers)+1);
	} else if (bonus == "Indep") {
		SetLocalInt(oPC, Indeps, GetLocalInt(oPC, Indeps)+1);
	} else if (bonus == "Anarch") {
		SetLocalInt(oPC, Anarchs, GetLocalInt(oPC, Anarchs)+1);
	} else if (bonus == "Athar") {
		SetLocalInt(oPC, Athar, GetLocalInt(oPC, Athar)+1);
	} else if (bonus == "Godsmen") {
		SetLocalInt(oPC, Godsmen, GetLocalInt(oPC, Godsmen)+1);
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