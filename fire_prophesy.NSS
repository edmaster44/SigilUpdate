//*********************************************************************
//Randomly generates a prophesy for the fire weird in the City of Brass
//*********************************************************************
string GenOmen() {
	string omen = "";
	switch (Random(44)+1) {
		case 1: omen += "Black"; break;
		case 2: omen += "White"; break;
		case 3: omen += "Brown"; break;
		case 4: omen += "Blue"; break;
		case 5: omen += "Orange"; break;
		case 6: omen += "Red"; break;
		case 7: omen += "Crimson"; break;
		case 8: omen += "Scarlet"; break;
		case 9: omen += "Indigo"; break;
		case 10: omen += "Turquoise"; break;
		case 11: omen += "Green"; break;
		case 12: omen += "Purple"; break;
		case 13: omen += "Yellow"; break;
		case 14: omen += "Saphron"; break;
		case 15: omen += "Diamond"; break;
		case 16: omen += "Emerald"; break;
		case 17: omen += "Ruby"; break;
		case 18: omen += "Sapphire"; break;
		case 20: omen += "Rich"; break;
		case 21: omen += "Royal"; break;
		case 22: omen += "Garnet"; break;
		case 23: omen += "Amethyst"; break;
		case 24: omen += "Aqua"; break;
		case 25: omen += "Pearly"; break;
		case 26: omen += "Topaz"; break;
		case 27: omen += "Deadly"; break;
		case 28: omen += "Dire"; break;
		case 29: omen += "Fell"; break;
		case 30: omen += "Baleful"; break;
		case 31: omen += "Holy"; break;
		case 32: omen += "Blessed"; break;
		case 33: omen += "Consecrated"; break;
		case 34: omen += "Sacred"; break;
		case 35: omen += "Firey"; break;
		case 36: omen += "Cold"; break;
		case 37: omen += "Burning"; break;
		case 38: omen += "Flaming"; break;
		case 39: omen += "Icey"; break;
		case 40: omen += "Shattered"; break;
		case 41: omen += "First"; break;
		case 42: omen += "Final"; break;
		case 43: omen += "Desolate"; break;
		case 44: omen += "Beautiful"; break;
		case 45: omen += "Shining"; break;
		default: omen += "Black"; break;
	}
	switch (Random(45)+1) {
		case 1: omen += " Sky"; break;
		case 2: omen += " Star"; break;
		case 3: omen += " Sun"; break;
		case 4: omen += " Moon"; break;
		case 5: omen += " Bonfire"; break;
		case 6: omen += " Horizon"; break;
		case 7: omen += " Battle"; break;
		case 8: omen += " Battlefield"; break;
		case 9: omen += " War"; break;
		case 10: omen += " Griffon"; break;
		case 11: omen += " Unicorn"; break;
		case 12: omen += " Hippogriph"; break;
		case 13: omen += " Pegasus"; break;
		case 14: omen += " Steed"; break;
		case 15: omen += " Rider"; break;
		case 16: omen += " Man"; break;
		case 17: omen += " Woman"; break;
		case 18: omen += " Lord"; break;
		case 20: omen += " Lady"; break;
		case 21: omen += " Bugbear"; break;
		case 22: omen += " Dragon"; break;
		case 23: omen += " Serpent"; break;
		case 24: omen += " Snake"; break;
		case 25: omen += " Spider"; break;
		case 26: omen += " Fox"; break;
		case 27: omen += " Angel"; break;
		case 28: omen += " Demon"; break;
		case 29: omen += " Devil"; break;
		case 30: omen += " Martyr"; break;
		case 31: omen += " Witness"; break;
		case 32: omen += " Herald"; break;
		case 33: omen += " Sword"; break;
		case 34: omen += " Axe"; break;
		case 35: omen += " Spear"; break;
		case 36: omen += " Shield"; break;
		case 37: omen += " Armor"; break;
		case 38: omen += " Hauberk"; break;
		case 39: omen += " Pyre"; break;
		case 40: omen += " End"; break;
		case 41: omen += " Beginning"; break;
		case 42: omen += " Road"; break;
		case 43: omen += " Plain"; break;
		case 44: omen += " Forest"; break;
		case 45: omen += " Mountain"; break;
		case 46: omen += " Desert"; break;
		default: omen += "Sky"; break;
	}
	return omen;
}

string GenTime() {
	switch (d6()) {
		case 1: return "Hour"; break;
		case 2: return "Day"; break;
		case 3: return "Week"; break;
		case 4: return "Month"; break;
		case 5: return "Year"; break;
		case 6: return "Age"; break;
		default: return "Hour"; break;
	}
	return "";
}

string GenNumber() {
	switch (d12()) {
		case 1: return "First"; break;
		case 2: return "Second"; break;
		case 3: return "Third"; break;
		case 4: return "Fourth"; break;
		case 5: return "Fifth"; break;
		case 6: return "Sixth"; break;
		case 7: return "Seventh"; break;
		case 8: return "Eighth"; break;
		case 9: return "Nineth"; break;
		case 10: return "Tenth"; break;
		case 11: return "Eleventh"; break;
		case 12: return "Twelfth"; break;
		default: return "First"; break;
	}
	return "";
}

string GenRandomAction() {
	switch (d10()) {
		case 1: return "rise"; break;
		case 2: return "fall"; break;
		case 3: return "appear"; break;
		case 4: return "wage war"; break;
		case 5: return "kill the "+GenOmen(); break;
		case 6: return "struggle with the "+GenOmen(); break;
		case 7: return "make peace with the "+GenOmen(); break;
		case 8: return "defend the "+GenOmen(); break;
		case 9: return "appear above the "+GenOmen(); break;
		case 10: return "rebel"; break;
		default: return "rise"; break;
	}
	return "";
}

string GenPersonalAction() {
	switch (d8()) {
		case 1: return "wandering through"; break;
		case 2: return "falling through"; break;
		case 3: return "running from"; break;
		case 4: return "battling with"; break;
		case 5: return "traveling alongside"; break;
		case 6: return "struggling against"; break;
		case 7: return "looking upon"; break;
		case 8: return "conversing with"; break;
		default: return "rises"; break;
	}
	return "";
}

string GenAdverb() {
	switch (d6()) {
		case 1: return "swiftly"; break;
		case 2: return "slowly"; break;
		case 3: return "quietly"; break;
		case 4: return "suddenly"; break;
		case 5: return "unexpectedly"; break;
		case 6: return ", as foretold in ages past, "; break;
		default: return "swiftly"; break;
	}
	return "";
}

string GenCalamity() {
	switch (Random(6)+1) {
		case 1: return "sword"; break;
		case 2: return "betrayer"; break;
		case 3: return "disaster"; break;
		case 4: return "calamity"; break;
		case 5: return "death"; break;
		case 6: return "plague"; break;
		case 7: return "curse"; break;
		default: return "sword"; break;
	}
	return "";
}

string GenBlessing() {
	switch (d6()) {
		case 1: return "blessing"; break;
		case 2: return "child"; break;
		case 3: return "great treasure"; break;
		case 4: return "vision"; break;
		case 5: return "divine visitor"; break;
		case 6: return "blessing"; break;
		default: return "blessing"; break;
	}
	return "";
}

string GenRequirment() {
	switch (d6()) {
		case 1: return "turn back"; break;
		case 2: return "rise up"; break;
		case 3: return "fall back"; break;
		case 4: return "change your course"; break;
		case 5: return "slay the "+GenOmen(); break;
		case 6: return "find the "+GenOmen(); break;
		default: return "turn back"; break;
	}
	return "";
}

string GenNumber2() {
	switch (d12()) {
		case 1: return "One"; break;
		case 2: return "Two"; break;
		case 3: return "Three"; break;
		case 4: return "Four"; break;
		case 5: return "Five"; break;
		case 6: return "Six"; break;
		case 7: return "Seven"; break;
		case 8: return "Eight"; break;
		case 9: return "Nine"; break;
		case 10: return "Ten"; break;
		case 11: return "Eleven"; break;
		case 12: return "Twelve"; break;
		default: return "First"; break;
	}
	return "";
}

void main () {

	object oPC = GetPCSpeaker();
	string prophesy = "";
	switch (d8()) {
		case 1: prophesy += "Before the "+GenNumber()+" "+GenTime()+" the "+GenOmen()+" will "+GenRandomAction()+" the "+GenOmen()+", and "; break;
		case 2: prophesy += "On the "+GenNumber()+" "+GenTime()+" of the "+GenNumber()+" "+GenTime()+" the "+GenOmen()+" will "+GenRandomAction()+" and "; break;
		case 3: prophesy += GenNumber2()+" times shall the "+GenOmen()+" "+GenRandomAction()+" before the "+GenOmen()+" and "; break;
		case 4: prophesy += "By the "+GenNumber()+" "+GenTime()+" will the "+GenOmen()+" "+GenAdverb()+" "+GenRandomAction()+" and then "; break;
		case 5: prophesy += "In a "+GenTime()+" of "+GenTime()+"s the "+GenOmen()+" shall "+GenRandomAction()+" and "; break;
		case 6: prophesy += "The "+GenOmen()+" "+GenRandomAction()+" in the "+GenNumber()+" "+GenTime()+" then "; break;
		case 7: prophesy += "When you find yourself between the "+GenOmen()+" and the "+GenOmen()+" then "; break;
		case 8: prophesy += "When you find yourself "+GenPersonalAction()+" the "+GenOmen()+" then look to the "+GenOmen()+" for "; break;
		default: prophesy += ""; break;
	}
	switch (d12()) {
		case 1: prophesy += "you will find what you truly seek"; break;
		case 2: prophesy += "you will at last behold the "+GenOmen(); break;
		case 3: prophesy += "a "+GenCalamity()+" will come to the house of "+GetLastName(oPC); break;
		case 4: prophesy += "a "+GenBlessing()+" will come to the house of "+GetLastName(oPC); break;
		case 5: prophesy += "the "+GenCalamity()+" will appear."; break;
		case 6: prophesy += "the "+GenBlessing()+" will act."; break;
		case 7: prophesy += "your riches will turn to rags."; break;
		case 8: prophesy += "you shall fulfill your purpose."; break;
		case 9: prophesy += "a Power will know your deeds."; break;
		case 10: prophesy += "you must "+GenRequirment()+" or forever more be chained to the road ahead."; break;
		case 11: prophesy += "you will know in your heart the one who is worthy of your deeds."; break;
		case 12: prophesy += GenNumber2()+" are the "+GenTime()+"s of "+GetFirstName(oPC)+" "+GetLastName(oPC)+"."; break;
		default: prophesy += ""; break;
	}
	SetCustomToken(2000, prophesy);
}