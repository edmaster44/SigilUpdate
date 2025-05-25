

string IntToFaction(string nFact) {

	if (nFact == "faction_1") 
		return "Harmonium";
	else if (nFact == "faction_2") 
		return "Red Death";
	else if (nFact == "faction_3") 
		return "Fraternity of Order";
	else if (nFact == "faction_4") 
		return "Fated";
	else if (nFact == "faction_5") 
		return "Doomguard";
	else if (nFact == "faction_6") 
		return "Xaositects";
	else if (nFact == "faction_7") 
		return "Dustmen";
	else if (nFact == "faction_8") 
		return "Bleak Cabal";
	else if (nFact == "faction_9") 
		return "Society of Sensation";
	else if (nFact == "faction_10") 
		return "Sign of One";
	else if (nFact == "faction_11") 
		return "Transcendent League";
	else if (nFact == "faction_12") 
		return "Free League";
	else if (nFact == "faction_13") 
		return "Revolutionary League";
	else if (nFact == "faction_14") 
		return "Athar";
	else if (nFact == "faction_15") 
		return "Believers of the Source";
	return "";
}

void main (int clear) {

	object oPC = GetPCSpeaker();
	if (clear == 1) {
		int count = 0; 
		for (count = 1; count <= 15; count++) {
			string sFaction = "faction_"+IntToString(count);
			DeleteLocalInt(oPC, sFaction);
			
		}
		return;
	} else {
	
		int count = 0; 
		int largestValue = 0;
		string winningFaction = "";
		for (count = 1; count <= 15; count++) {
			string sFaction = "faction_"+IntToString(count);
			int nValue = GetLocalInt(oPC, sFaction);
			if (nValue >= largestValue) {
				largestValue = nValue;
				winningFaction = IntToFaction(sFaction);
			}
			
		}
		
		SetCustomToken(5002, "You would be a good fit for the "+winningFaction);
	
	}

}