//******************************************************************//
//ps_inc_flavortext
//A script devoted to flavor text, and silly story generation
//for descriptions on loot / in quests / etc.
//******************************************************************//

//Returns a random name by gender
string RandomString_GenerateFirstName(int gender);

//Returns a random last name and/or title
string RandomString_GenerateLastName();

//Returns a random distinguishing trait
string RandomString_GenerateTrait();

//Returns a random backstory / random fact
string RandomString_GenerateBackstory();

//Returns a random place in the planes
string RandomString_GeneratePlanarLocation();

//The hurdles / problems one might face while trying to get something done
string RandomString_HurdleGenerator();

//Returns a random nickname / last name
string RandomString_GenerateNickname();

//Returns a random title
string RandomString_GenerateTitle(int gender);

//generate a random race
string RandomString_GenerateRace();

//generate a non-planar location; like a prime
string RandomString_GeneratePrimeLocation();

//for generating lists of things (such as for shopping)
string RandomString_GenerateItem(int nType);

//for generating a magic item
string RandomString_GenerateArtifact();

//Get eye color
string RandomString_GenerateEyes();

//Get hair color
string RandomString_GenerateHair();

//Get an entertaining crime!
string RandomString_GenerateCrime();

//******************************************************************//
//Structs
//******************************************************************//
//A character; wanted by the law? the hero of a quest? the villain?!
struct character {
	string firstname;
	string lastname;
	string nickname;
	int gender;
	string race;
	string eyes;
	string hair;
	string feature1;
	string feature2;
	string backstory;
	string title;
	string pronoun;
	string possessivePronoun;
	string crime;
};

struct character DetailCharacter(int gender) {

	if (gender == 2)
		gender = d2(); //random male/female

	struct character newChar;
	newChar.firstname = RandomString_GenerateFirstName(gender);
	newChar.lastname = RandomString_GenerateLastName();
	newChar.nickname = RandomString_GenerateNickname();
	newChar.gender = gender;
	newChar.race = RandomString_GenerateRace();
	newChar.eyes = RandomString_GenerateEyes();
	newChar.hair = RandomString_GenerateHair();
	newChar.feature1 = (d2()==2)?newChar.eyes:newChar.hair;
	newChar.feature2 = RandomString_GenerateTrait();
	newChar.backstory = RandomString_GenerateBackstory();
	newChar.title = RandomString_GenerateTitle(newChar.gender);
	newChar.pronoun = (gender==GENDER_MALE)?"he":"she";
	newChar.possessivePronoun = (gender==GENDER_MALE)?"his":"her";
	newChar.crime = RandomString_GenerateCrime();
	
	return newChar;
}

//Write a typical introduction for this character
string IntroduceCharacter(struct character Char) {
	string sResult = "";
	
	//just in case we need obnoxiously long lineage lines
	string lineage = "the "+(Char.gender==GENDER_MALE?"daughter":"son")+" of "+RandomString_GenerateFirstName(GENDER_MALE)+" "+Char.lastname;
	int nMax = Random(4)+1;
	while (nMax > 0) {
		lineage += ", the son of "+RandomString_GenerateFirstName(2);
		switch(Random(4)) {
			case 0: lineage += ""; break;
			case 1: lineage += " "+RandomString_GenerateNickname(); break;
			case 2: lineage += " "+RandomString_GenerateLastName(); break;
			case 3: lineage += " who was "+RandomString_GenerateBackstory(); break;
		}
		nMax--;
	}
	
	int total = 13;
	switch (Random(total)) {
		case 0: sResult += Char.firstname; break;
		case 1: sResult += Char.firstname+" "+Char.lastname; break;
		case 2: sResult += Char.firstname+" of "+Char.lastname; break;
		case 3: sResult += Char.firstname+" of the house of "+Char.lastname; break;
		case 4: sResult += Char.title+" "+Char.firstname+" of "+Char.lastname; break;
		case 5: sResult += Char.title+" "+Char.firstname+" "+Char.nickname; break;
		case 6: sResult += Char.firstname+", also known as "+Char.lastname; break;
		case 7: sResult += Char.firstname+", frequently called "+Char.nickname; break;
		case 8: sResult += Char.firstname+", sometimes called "+Char.nickname; break;
		case 9: sResult += Char.firstname+", who was called by his friends "+Char.nickname; break;
		case 10: sResult += Char.firstname+", occasionally referred to as "+Char.nickname; break;
		case 11: sResult += Char.firstname+", sometimes called "+Char.nickname; break;
		case 12: sResult += Char.firstname+", who was called by "+Char.possessivePronoun+" enemies "+Char.nickname; break;
	}
	sResult += ". ";
	total = 10;
	switch (Random(total)) {
		case 0: sResult += ""; break;
		case 1: sResult += Char.firstname+" was a "+Char.race+", and "+Char.backstory+"."; break;
		case 2: sResult += Char.firstname+" was a "+Char.race+", with "+Char.feature1+"."; break;
		case 3: sResult += Char.firstname+" was a "+Char.race+", and had "+Char.feature1+" and "+Char.feature2+"."; break;
		case 4: sResult += Char.firstname+" had "+Char.feature1+", and was "+Char.backstory+"."; break;
		case 5: sResult += Char.firstname+" had "+Char.feature1+", and "+Char.feature2+"."; break;
		case 6: sResult += Char.firstname+" had travelled long in "+RandomString_GeneratePlanarLocation()+", and was but newly returned."; break;
		case 7: sResult += Char.firstname+" had been on marvelous adventures in "+RandomString_GeneratePlanarLocation()+", and was but newly returned."; break;
		case 8: sResult += Char.firstname+" was "+Char.backstory+"."; break;
		case 9: sResult += Char.firstname+" was "+lineage+"."; break;
	}
	
	return sResult;
}
//******************************************************************//
//Create a random magical gobbledegook phrase
string RandomString_GenerateMagicalPhrase() {

	int nNum;
	string sPhrase = "";
	int nMax = Random(4)+2;
	for (nNum = 0; nNum < nMax; nNum++) {

		int total = 27;
		switch(Random(total)) {
			case 0: sPhrase += "Miser "; break;
			case 1: sPhrase += "Marcalus "; break;
			case 2: sPhrase += "Invenio "; break;
			case 3: sPhrase += "Umbris "; break;
			case 4: sPhrase += "Nolo "; break;
			case 5: sPhrase += "Tamen "; break;
			case 6: sPhrase += "Locum "; break;
			case 7: sPhrase += "Festum "; break;
			case 8: sPhrase += "Omnes "; break;
			case 9: sPhrase += "Sordidus "; break;
			case 10: sPhrase += "Magis "; break;
			case 11: sPhrase += "Velis "; break;
			case 12: sPhrase += "Illum "; break;
			case 13: sPhrase += "Convictus "; break;
			case 14: sPhrase += "Dicere "; break;
			case 15: sPhrase += "Manum "; break;
			case 16: sPhrase += "Turpissima "; break;
			case 17: sPhrase += "Iactura "; break;
			case 18: sPhrase += "Et "; break;
			case 19: sPhrase += "Gratus "; break;
			case 20: sPhrase += "Enim "; break;
			case 21: sPhrase += "Aliud "; break;
			case 22: sPhrase += "Vindica "; break;
			case 23: sPhrase += "Sic "; break;
			case 24: sPhrase += "Diem "; break;
			case 25: sPhrase += "Inpensae "; break;
			case 26: sPhrase += "Pretium "; break;
		}
		
	}
	return sPhrase;
}

//Generates a mundane item
//for generating lists of things (such as for shopping)
const int GENERIC_ITEM_FOOD = 0;
const int GENERIC_ITEM_DOMESTIC = 1;
const int GENERIC_ITEM_ALCHEMY = 2;
const int GENERIC_ITEM_MAGIC = 3;
string RandomString_GenerateItem(int nType) {

	if (nType == GENERIC_ITEM_FOOD) {
		string sFood = "";
		
		int total = 23;
		switch(Random(total)) {
			case 0: sFood += "Warriors' "; break;
			case 1: sFood += "Arcadian "; break;
			case 2: sFood += "Abyssal "; break;
			case 3: sFood += "Elysian "; break;
			case 4: sFood += "Arborean "; break;
			case 5: sFood += "Larva "; break;
			case 6: sFood += "Bebelith "; break;
			case 7: sFood += "Bytopian "; break;
			case 8: sFood += "Cranium Rat "; break;
			case 9: sFood += "Death "; break;
			case 10: sFood += "Divine "; break;
			case 11: sFood += "Glorium "; break;
			case 12: sFood += "Krigalan "; break;
			case 13: sFood += "Goat "; break;
			case 14: sFood += "Poached "; break;
			case 15: sFood += "Baked "; break;
			case 16: sFood += "Roasted "; break;
			default: break;
		}
		
		total = 24;
		switch(Random(total)) {
			case 0: sFood += "Bread"; break;
			case 1: sFood += "Wine"; break;
			case 2: sFood += "Beer"; break;
			case 3: sFood += "Milk"; break;
			case 4: sFood += "Eggs"; break;
			case 5: sFood += "Butter"; break;
			case 6: sFood += "Berries"; break;
			case 7: sFood += "Apple"; break;
			case 8: sFood += "Pear"; break;
			case 9: sFood += "Peach"; break;
			case 10: sFood += "Pear"; break;
			case 11: sFood += "Steak"; break;
			case 12: sFood += "Sausage"; break;
			case 13: sFood += "Tenderloin"; break;
			case 14: sFood += "Bacon"; break;
			case 15: sFood += "Lager"; break;
			case 16: sFood += "Rolls"; break;
			case 17: sFood += "Cookies"; break;
			case 18: sFood += "Biscuits"; break;
			case 19: sFood += "Filet"; break;
			case 20: sFood += "Soup"; break;
			case 21: sFood += "Souffle"; break;
			case 22: sFood += "Cheese"; break;
			case 23: sFood += "Sauce"; break;
		}
		return sFood;
	} else if (nType == GENERIC_ITEM_DOMESTIC) {
		int total = 15;
		switch(Random(total)) {
			case 0: return IntToString(d6(2))+" Inches of String"; break;
			case 1: return IntToString(d6(2))+" Spools of Thread"; break;
			case 2: return "Pot"; break;
			case 3: return "Pan"; break;
			case 4: return IntToString(d6(2))+" Spoons"; break;
			case 5: return IntToString(d6(2))+" Forks"; break;
			case 6: return "Knife"; break;
			case 7: return "Tongs"; break;
			case 8: return "Ladel"; break;
			case 9: return "Kettle"; break;
			case 10: return IntToString(d6(2))+" Cups"; break;
			case 11: return IntToString(d6(2))+" Plates"; break;
			case 12: return IntToString(d6(2))+" Knives"; break;
			case 13: return "Firewood"; break;
			case 14: return IntToString(d3(2))+" Needles"; break;
		}
	} else if (nType == GENERIC_ITEM_ALCHEMY) {
		int total = 68;
		switch(Random(total)) {
			case 0: return "Aaron's Rod Powder"; break;
			case 1: return "Aelfengrape"; break;
			case 2: return "Amaranth Infusion"; break;
			case 3: return "Crushed Birthwort"; break;
			case 4: return "Fermented Bitterroot"; break;
			case 5: return "Bitterroot Tincture"; break;
			case 6: return "Sprigs of Blackthorn"; break;
			case 7: return "Borage Leaves"; break;
			case 8: return "Caranator Root"; break;
			case 9: return "Cave Star Flowers"; break;
			case 10: return "Cloth of Gold Six-Leaf"; break;
			case 11: return "Darkroot Gum"; break;
			case 12: return "Djinn Blossoms"; break;
			case 13: return "Dragon's Blood Resin"; break;
			case 14: return "Elven Willow Sap"; break;
			case 15: return "Elysium Sprig"; break;
			case 16: return "Garlic Bulb"; break;
			case 17: return "Goldencup Moss"; break;
			case 18: return "Hemlock Tincture"; break;
			case 19: return "Hum Nettles"; break;
			case 20: return "Lakeleaf Tincture"; break;
			case 21: return "Lish Nuts"; break;
			case 22: return "Mandrake Root"; break;
			case 23: return "Nahre Lotus Petals"; break;
			case 24: return "Old Man's Friend Infusion"; break;
			case 25: return "Pomegranate Seeds"; break;
			case 26: return "Prickly Tea"; break;
			case 27: return "Salamander Orchid Flowers"; break;
			case 28: return "Spriggan Acorns"; break;
			case 29: return "St. John's Wort Tincture"; break;
			case 30: return "Distilled Fireclover"; break;
			case 31: return "Wolfsbane"; break;
			case 32: return "Wolfweed Serum"; break;
			case 33: return "Woundwort Leaves"; break;
			case 34: return "Dragon's Blood"; break;
			case 35: return "Dragon's Sinew"; break;
			case 36: return "Captured Archon's Light"; break;
			case 37: return "Bat Tooth"; break;
			case 38: return "Claw of Bear"; break;
			case 39: return "Beetle Gland"; break;
			case 40: return "Leg of a Blade Spider"; break;
			case 41: return "Bladeling Spike"; break;
			case 42: return "Bugbear's Tusk"; break;
			case 43: return "Deva's Feather"; break;
			case 44: return "Blood of a Devil"; break;
			case 45: return "Blood of a Demon"; break;
			case 46: return "Tusk of a Boar"; break;
			case 47: return "Wolf's Tooth"; break;
			case 48: return "Eye of a Larva"; break;
			case 49: return "Farastu Slime"; break;
			case 50: return "Fire Beetle Belly"; break;
			case 51: return "Scale from a Fire Mephit"; break;
			case 52: return "Gargoyle's Horn"; break;
			case 53: return "Powdered Gear of Mechanus"; break;
			case 54: return "Ghast Claw"; break;
			case 55: return "Whisper of a Ghost"; break;
			case 56: return "Ghoul Claws"; break;
			case 57: return "Scale from an Ice Mephit"; break;
			case 58: return "Skull of an Ogre"; break;
			case 59: return "Mandible from a Phase Spider"; break;
			case 60: return "Skeleton Rib"; break;
			case 61: return "Reaver's Bones"; break;
			case 62: return "Slaad Eggs"; break;
			case 63: return "Blood of a Troll"; break;
			case 64: return "Stag Beetle's Horn"; break;
			case 65: return "Vampire's Tooth"; break;
			case 66: return "Shadow of a Wraith"; break;
			case 67: return "Wyvern Scale"; break;
		}
	} else if (nType == GENERIC_ITEM_MAGIC) {
		return RandomString_GenerateArtifact();
	}
	return "";
}

//for generating lists of magical items
string RandomString_GenerateArtifact() {

	string sName = "";
	int total = 23;
	switch(Random(total)) {
		case 0: sName += "Blade"; break;
		case 1: sName += "Stone"; break;
		case 2: sName += "Diamond"; break;
		case 3: sName += "Crystal"; break;
		case 4: sName += "Staff"; break;
		case 5: sName += "Sword"; break;
		case 6: sName += "Edge"; break;
		case 7: sName += "Spear"; break;
		case 8: sName += "Cube"; break;
		case 9: sName += "Mace"; break;
		case 10: sName += "Shovel"; break;
		case 11: sName += "Morningstar"; break;
		case 12: sName += "Flail"; break;
		case 13: sName += "Shield"; break;
		case 14: sName += "Armor"; break;
		case 15: sName += "Chain"; break;
		case 16: sName += "Whip"; break;
		case 17: sName += "Knife"; break;
		case 18: sName += "Dagger"; break;
		case 19: sName += "Rod"; break;
		case 20: sName += "Wand"; break;
		case 21: sName += "Elixer"; break;
		case 22: sName += "Potion"; break;
	}
	
	if (d3() == 1) {
		total = 27;
		switch(Random(total)) {
			case 0: sName += "of Destiny"; break;
			case 1: sName += "of Burning"; break;
			case 2: sName += "of Death"; break;
			case 3: sName += "of Wrath"; break;
			case 4: sName += "of Freezing"; break;
			case 5: sName += "of Healing"; break;
			case 6: sName += "of Acid"; break;
			case 7: sName += "of Corrosion"; break;
			case 8: sName += "of Stabbing"; break;
			case 9: sName += "of Mortality"; break;
			case 10: sName += "of Lightning"; break;
			case 11: sName += "of Divinity"; break;
			case 13: sName += "of Clarity"; break;
			case 14: sName += "of Screaming"; break;
			case 15: sName += "of Shocking"; break;
			case 16: sName += "of Darkness"; break;
			case 17: sName += "of Light"; break;
			case 18: sName += "of Strength"; break;
			case 19: sName += "of Agility"; break;
			case 20: sName += "of Protection"; break;
			case 21: sName += "of Health"; break;
			case 22: sName += "of Wisdom"; break;
			case 23: sName += "of Wit"; break;
			case 24: sName += "of Beauty"; break;
			case 25: sName += "of Charisma"; break;
			case 26: sName += "of Missiles"; break;
		}
	} else {
		total = 29;
		switch(Random(total)) {
			case 0: sName = "Destiny "+sName; break;
			case 1: sName = "Blazing "+sName; break;
			case 2: sName = "Burning "+sName; break;
			case 3: sName = "Freezing "+sName; break;
			case 4: sName = "Ice "+sName; break;
			case 5: sName = "Acid "+sName; break;
			case 6: sName = "Corrosive "+sName; break;
			case 7: sName = "Shocking "+sName; break;
			case 8: sName = "Electric "+sName; break;
			case 9: sName = "Screaming "+sName; break;
			case 10: sName = "Thunderous "+sName; break;
			case 11: sName = "Strong "+sName; break;
			case 12: sName = "Dextrous "+sName; break;
			case 13: sName = "Healthy "+sName; break;
			case 14: sName = "Witty "+sName; break;
			case 15: sName = "Wise "+sName; break;
			case 16: sName = "Protective "+sName; break;
			case 17: sName = "Flaming "+sName; break;
			case 18: sName = "Icey "+sName; break;
			case 19: sName = "White "+sName; break;
			case 20: sName = "Black "+sName; break;
			case 21: sName = "Yellow "+sName; break;
			case 22: sName = "Blue "+sName; break;
			case 23: sName = "Purple "+sName; break;
			case 24: sName = "Spiked "+sName; break;
			case 25: sName = "Orange "+sName; break;
			case 26: sName = "Red "+sName; break;
			case 27: sName = "Blinding "+sName; break;
			case 28: sName = "Deafening "+sName; break;
		}
	}
	
	return sName;
}

//get a title
string RandomString_GenerateTitle(int gender) {
	
	int total = 10;
	switch (Random(total)) {
		case 0: return gender==GENDER_MALE?"King":"Queen"; break;
		case 1: return gender==GENDER_MALE?"Baron":"Baroness"; break;
		case 2: return gender==GENDER_MALE?"Lord":"Lady"; break;
		case 3: return gender==GENDER_MALE?"Prince":"Princess"; break;
		case 4: return gender==GENDER_MALE?"Mother Priestess":"Father Priest"; break;
		case 5: return gender==GENDER_MALE?"Duke":"Duchess"; break;
		case 6: return gender==GENDER_MALE?"Emperor":"Empress"; break;
		case 7: return "Factor";
		case 8: return "Factotum";
		case 9: return "Namer";
	}
	
	return "";
}

//Returns a random name by gender
string RandomString_GenerateFirstName(int gender) {

	int total = 100;
	if (gender == GENDER_FEMALE) {
		switch (Random(total)) {
			case 0: return "Keanna";
			case 1: return "Yaffe";
			case 2: return "Vanna";
			case 3: return "Snezhana";
			case 4: return "Alwilda";
			case 5: return "Elyse";
			case 6: return "Nehir";
			case 7: return "Karen";
			case 8: return "Efthymia";
			case 9: return "Britta";
			case 10: return "Gauri";
			case 11: return "Klementyna";
			case 12: return "Parisa";
			case 13: return "Finnuala";
			case 14: return "Magdalene";
			case 15: return "Atarah";
			case 16: return "Til";
			case 17: return "Celestina";
			case 18: return "Desislava";
			case 19: return "Tlalli";
			case 20: return "Steffi";
			case 21: return "Pilirani";
			case 22: return "Laima";
			case 23: return "Amala";
			case 24: return "Onyekachukwu";
			case 25: return "Eireann";
			case 26: return "Maeva";
			case 27: return "Yana";
			case 28: return "Hadas";
			case 29: return "Uzoma";
			case 30: return "Magdalini";
			case 31: return "Taryn";
			case 32: return "Milana";
			case 33: return "Paulinha";
			case 34: return "Ditte";
			case 35: return "Azize";
			case 36: return "Zorica";
			case 37: return "Ines";
			case 38: return "Jannicke";
			case 39: return "Ainsley";
			case 40: return "Lucrece";
			case 41: return "Gunilla";
			case 42: return "Michelle";
			case 43: return "Jacinta";
			case 44: return "Metztli";
			case 45: return "Zaharina";
			case 46: return "Porcia";
			case 47: return "Sollemnia";
			case 48: return "Adjoa";
			case 49: return "Zdenka";
			case 50: return "Ythery";
			case 51: return "Tiar";
			case 52: return "Atnal";
			case 53: return "Per'ash";
			case 54: return "Phoumess";
			case 55: return "Sul'alea";
			case 56: return "Quenys";
			case 57: return "Liris";
			case 58: return "Letys";
			case 59: return "Ald'ran'een";
			case 60: return "Tonbanirdra";
			case 61: return "Yersulosunda";
			case 62: return "Asootu";
			case 63: return "Silycila";
			case 64: return "Jilere";
			case 65: return "Hilari";
			case 66: return "Hezora";
			case 67: return "Alire";
			case 68: return "Umorunda";
			case 69: return "Rudipada";
			case 70: return "Honeyface";
			case 71: return "Danitia";
			case 72: return "Omoutia";
			case 73: return "U'rayale";
			case 74: return "Lor'tina";
			case 75: return "Que'urn'yw";
			case 76: return "Urn-raness";
			case 77: return "Emia-ver";
			case 78: return "Ing-che";
			case 79: return "Lyeav-lye";
			case 80: return "Kei";
			case 81: return "Iwawa";
			case 82: return "Ifuku";
			case 83: return "Kitake";
			case 84: return "Furukei";
			case 85: return "Padyt";
			case 86: return "Soess";
			case 87: return "Elmtia";
			case 88: return "Uskvia";
			case 89: return "Jizam";
			case 90: return "Atha";
			case 91: return "Shy'say";
			case 92: return "Ristaness";
			case 93: return "Ooma";
			case 94: return "Ess'eno";
			case 95: return "Che'dyne";
			case 96: return "Polina";
			case 97: return "Cafeda";
			case 98: return "Ine'awe";
			case 99: return "Ceresul";	
		}
	} else {
		int total = 50;
		switch (Random(total)) {
			case 0: return "Misho";
			case 1: return "Jeronimo";
			case 3: return "Fotis";
			case 4: return "Amand";
			case 5: return "Germogen";
			case 6: return "Aldo";
			case 7: return "Arkaitz";
			case 8: return "David";
			case 9: return "Rajender";
			case 10: return "Swithun";
			case 11: return "Aed";
			case 12: return "Faust";
			case 13: return "Isidor";
			case 14: return "Mahesh";
			case 15: return "Jon";
			case 16: return "Sergio";
			case 17: return "Ivan";
			case 18: return "Gabriel";
			case 19: return "Rafael";
			case 20: return "Michael";
			case 21: return "Tymon";
			case 22: return "Kavan";
			case 23: return "Ryou";
			case 24: return "Orion";
			case 25: return "Heracles";
			case 26: return "Thangelos";
			case 27: return "Vincent";
			case 28: return "Nachum";
			case 29: return "Valdemaras";
			case 30: return "Alex";
			case 31: return "Uzochi";
			case 32: return "Saam";
			case 33: return "Kartik";
			case 34: return "Ethan";
			case 35: return "Micha";
			case 36: return "Dinesh";
			case 37: return "Jehoram";
			case 38: return "Steinn";
			case 39: return "Thamir";
			case 40: return "Timaeus";
			case 41: return "Viggo";
			case 42: return "Anil";
			case 43: return "Karsci";
			case 44: return "Jordon";
			case 45: return "Goraidh";
			case 46: return "Dorian";
			case 47: return "Fishke";
			case 48: return "Raj";
			case 49: return "Marc";
			case 50: return "Urlik";
			case 51: return "Osdenray";
			case 52: return "Belngar";
			case 53: return "Roth'cer";
			case 54: return "Lleinaild";
			case 55: return "Drethat";
			case 56: return "Samunt";
			case 57: return "Angdim";
			case 58: return "Iseto";
			case 59: return "Tew";
			case 60: return "Lermor";
			case 61: return "Undrod";
			case 62: return "Mormos";
			case 63: return "Samashaw";
			case 64: return "Banranos";
			case 65: return "Clading";
			case 66: return "Faqueer";
			case 67: return "Crerothad";
			case 68: return "Danwartherserray";
			case 69: return "Shyoughenth";
			case 70: return "Pitny";
			case 71: return "Drorr";
			case 72: return "Vec";
			case 73: return "Jyhem";
			case 74: return "Sadut";
			case 75: return "Zydymiso";
			case 76: return "Ine'war";
			case 77: return "Dar'ilde";
			case 78: return "Aw'gha'uw";
			case 79: return "Tur'rak";
			case 80: return "Honale-gar";
			case 81: return "Tin-oldat";
			case 82: return "Sul-kim";
			case 83: return "Chuinat-che";
			case 84: return "Nysith-den";
			case 85: return "Motozaki";
			case 86: return "Osuzu";
			case 87: return "Yamagawa";
			case 88: return "Oo";
			case 89: return "Senchi";
			case 90: return "Dutios";
			case 91: return "Lycios";
			case 92: return "Doofartle";
			case 93: return "Faron";
			case 94: return "Radauth";
			case 95: return "B'orm";
			case 96: return "T'hol";
			case 97: return "Ealunmol";
			case 98: return "Quariel";
			case 99: return "Ayal";
			
		}
	}
	
	return "Bob";
}

//Returns a random last name
string RandomString_GenerateLastName() {

	int total = 41;
	switch (Random(total)) {
		case 0: return "Naaji";
		case 1: return "Watson";
		case 2: return "Ventura";
		case 3: return "Atkinson";
		case 4: return "Mas";
		case 5: return "Olander";
		case 6: return "Verhoeven";
		case 7: return "Stablum";
		case 8: return "Honeysett";
		case 9: return "Stavros";
		case 10: return "Bitter";
		case 11: return "Kimball";
		case 12: return "Ratti";
		case 13: return "Szek";
		case 14: return "Abbasi";
		case 15: return "Spannagel";
		case 16: return "Maier";
		case 17: return "Gerst";
		case 18: return "Simek";
		case 19: return "Lion";
		case 20: return "Dahl";
		case 21: return "Fermi";
		case 22: return "Hayley";
		case 23: return "Castell";
		case 24: return "Skathi";
		case 25: return "Ruiz";
		case 26: return "Jonkers";
		case 27: return "Ingersleben";
		case 28: return "Bul";
		case 29: return "Abel";
		case 30: return "Kriz";
		case 31: return "Conti";
		case 32: return "Gadhavi";
		case 33: return "Pretorius";
		case 34: return "Beumer";
		case 35: return "Suljo";
		case 36: return "Roach";
		case 37: return "Taggart";
		case 38: return "Shine";
		case 39: return "Dunajski";
		case 40: return "Zelenko";
	}
	
	return "Zelenko";
}


//Returns a random nickname / last name
string RandomString_GenerateNickname() {
	int total = 110;
	switch (Random(total)) {
		case 0: return "the Maggot";
		case 1: return "the First";
		case 2: return "the Last";
		case 3: return "the Unready";
		case 4: return "the Second";
		case 5: return "the Third";
		case 6: return "the False";
		case 7: return "the True";
		case 8: return "the Candlestickmaker";
		case 9: return "the Sweet";
		case 10: return "the Bitter";
		case 11: return "the Breathless";
		case 12: return "the Player";
		case 13: return "Minstrel";
		case 14: return "the Fiend";
		case 15: return "the Deserter";
		case 16: return "the Tame";
		case 17: return "the Untamed";
		case 18: return "the Songbird";
		case 19: return "the Roach";
		case 20: return "the Rat";
		case 21: return "the Tailor";
		case 22: return "the Butcher";
		case 23: return "the Mercenary";
		case 24: return "the Cobbler";
		case 25: return "the Tanner";
		case 26: return "the Vintner";
		case 27: return "the Brutal";
		case 28: return "the Second";
		case 29: return "the Third";
		case 30: return "the Seventh";
		case 31: return "the Fast";
		case 32: return "the Slow";
		case 33: return "the Dumb";
		case 34: return "the Deaf";
		case 35: return "the Blind";
		case 36: return "the Accursed";
		case 37: return "the Cursed";
		case 38: return "Shine";
		case 39: return "the Favored";
		case 40: return "the Known";
		case 41: return "the Milner";
		case 42: return "the Mason";
		case 43: return "the Caring";
		case 44: return "the Uncaring";
		case 45: return "XII";
		case 46: return "the Grave";
		case 47: return "the Cursed";
		case 48: return "the Stonier";
		case 49: return "the Cheeseman";
		case 50: return "Bonny";
		case 51: return "the Magnificent";
		case 52: return "the Brave";
		case 53: return "the Unwilling";
		case 54: return "the Mighty";
		case 55: return "the Merciless";
		case 56: return "the Cowardly";
		case 57: return "the Dragonslayer";
		case 58: return "the Unbeliever";
		case 59: return "the Cruel";
		case 60: return "the Willing";
		case 61: return "the Foul";
		case 62: return "Six-fingered";
		case 63: return "Kinslayer";
		case 64: return "the Mystic";
		case 65: return "the Destroyer";
		case 66: return "the Fiendslayer";
		case 67: return "the Godslayer";
		case 68: return "the Celibate";
		case 69: return "the Polite";
		case 70: return "the Heroic";
		case 71: return "the Glutton";
		case 72: return "the Worrier";
		case 73: return "the Bold";
		case 74: return "the Bald";
		case 75: return "the Clueless";
		case 76: return "the Necromancer";
		case 77: return "the Swift";
		case 78: return "Swift";
		case 79: return "the Flamboyant";
		case 80: return "the Wise";
		case 81: return "the Monk";
		case 82: return "the Grey";
		case 83: return "the Red";
		case 84: return "the Blue";
		case 85: return "the White";
		case 86: return "the Green";
		case 87: return "the Yellow";
		case 88: return "the Black";
		case 89: return "the Cold-hearted";
		case 90: return "Coldheart";
		case 91: return "the Prankster";
		case 92: return "the Unclean";
		case 93: return "the Rotten";
		case 94: return "the Virtuous";
		case 95: return "the Noble";
		case 96: return "the Effete";
		case 97: return "the Insane";
		case 98: return "the Unknown";
		case 99: return "the Strange";
		case 100: return "Stranger";
		case 101: return "the Unquestionable";
		case 102: return "the Questioned";
		case 103: return "the Terrible";
		case 104: return "the Orthodox";
		case 105: return "the Lost";
		case 106: return "Quickwit";
		case 107: return "the child of "+RandomString_GenerateFirstName(GENDER_MALE)+" "+RandomString_GenerateNickname();
		case 108: return "the descendent of "+RandomString_GenerateFirstName(GENDER_MALE)+" "+RandomString_GenerateNickname();
		case 109: return "the parent of "+RandomString_GenerateFirstName(GENDER_MALE)+" "+RandomString_GenerateNickname();
	}
	
	return "the Unready";
}

//generate a random race
string RandomString_GenerateRace() {
	int total = 35;
	switch (Random(total)) {
		case 0: return "Human";
		case 1: return "Elf";
		case 2: return "Dwarf";
		case 3: return "Gnome";
		case 4: return "Halfling";
		case 5: return "Orc";
		case 6: return "Half Orc";
		case 7: return "Half Elf";
		case 8: return "Water Genasi";
		case 9: return "Fire Genasi";
		case 10: return "Earth Genasi";
		case 11: return "Air Genasi";
		case 12: return "Tanar'ri";
		case 13: return "Baatezu";
		case 14: return "Archon";
		case 15: return "Eladrin";
		case 16: return "Tiefling";
		case 17: return "Aasimar";
		case 18: return "Nymph";
		case 19: return "Fey";
		case 20: return "Giant";
		case 21: return "Goblin";
		case 22: return "Kobald";
		case 23: return "Gnoll";
		case 24: return "Deva";
		case 25: return "Slaad";
		case 26: return "Dragon";
		case 27: return "Human";
		case 28: return "Elf";
		case 29: return "Dwarf";
		case 30: return "Gnome";
		case 31: return "Halfling";
		case 32: return "Orc";
		case 33: return "Half Orc";
		case 34: return "Half Elf";
	}
	
	return "Human";
}

//Get eye color
string RandomString_GenerateEyes() {
	int total = 29;
	switch (Random(total)) {
		case 0: return "deep blue eyes";
		case 1: return "piercing blue eyes";
		case 2: return "ice blue eyes";
		case 3: return "uncanny green eyes";
		case 4: return "beautiful green eyes";
		case 5: return "sea green eyes";
		case 6: return "emerald green eyes";
		case 7: return "bewitching green eyes";
		case 8: return "hazel eyes";
		case 9: return "eyes both brown and blue";
		case 10: return "soft brown eyes";
		case 11: return "deep brown eyes";
		case 12: return "ox-brown eyes";
		case 13: return "glowing red eyes";
		case 14: return "bloodshot eyes";
		case 15: return "blood red eyes";
		case 16: return "pale eyes";
		case 17: return "grey eyes";
		case 18: return "steely grey eyes";
		case 19: return "steely blue eyes";
		case 20: return "black eyes";
		case 21: return "deep black eyes";
		case 22: return "lavender eyes";
		case 23: return "golden eyes";
		case 24: return "yellow cat-like eyes";
		case 25: return "yellow eyes";
		case 26: return "blue eyes";
		case 27: return "green eyes";
		case 28: return "cat-like eyes";
	}
	
	return "deep blue eyes";
}

//Get hair color
string RandomString_GenerateHair() {
	int total = 32;
	switch (Random(total)) {
		case 0: return "blood red hair";
		case 1: return "red hair";
		case 2: return "curly red hair";
		case 3: return "orange-red hair";
		case 4: return "firey red hair";
		case 5: return "brown hair";
		case 6: return "straight brown hair";
		case 7: return "fine brown hair";
		case 8: return "curly brown hair";
		case 9: return "light brown hair";
		case 10: return "dark brown hair";
		case 11: return "chocolate brown hair";
		case 12: return "black hair";
		case 13: return "jet black hair";
		case 14: return "straight black hair";
		case 15: return "thick black hair";
		case 16: return "curly black hair";
		case 17: return "short black hair";
		case 18: return "salt and pepper hair";
		case 19: return "a shock of white hair";
		case 20: return "graying hair";
		case 21: return "blonde hair";
		case 22: return "straw-colored hair";
		case 23: return "dirty blonde hair";
		case 24: return "dark blonde hair";
		case 25: return "straight blonde hair";
		case 26: return "long blonde hair";
		case 27: return "strawberry blonde hair";
		case 28: return "platinum blonde hair";
		case 29: return "short hair";
		case 30: return "curly hair";
		case 31: return "long straight hair";
	}
	
	return "long straight hair";
}

//Returns a random distinguishing trait or feature
//Bob, a human with or who had x
string RandomString_GenerateTrait() {
	int total = 29;
	switch (Random(total)) {
		case 0: return "long spiralled horns";
		case 1: return "curved goat horns";
		case 2: return "cloven hooves";
		case 3: return "a scar on one cheek";
		case 4: return "a limp in one leg";
		case 5: return "unusually tall stature";
		case 6: return "very short stature";
		case 7: return "a slight build";
		case 8: return "a medium build";
		case 9: return "a few too many pounds around the middle";
		case 10: return "a scarred face";
		case 11: return "a terrible smell";
		case 12: return "a narrow face";
		case 13: return "a wide face";
		case 14: return "only one arm";
		case 15: return "only one leg";
		case 16: return "a noteworthy accent";
		case 17: return "an unusual accent";
		case 18: return "a hiver accent";
		case 19: return "a heavy build";
		case 20: return "a lithe build";
		case 21: return "one bad eye";
		case 22: return "a way with words";
		case 23: return "a cutting wit";
		case 24: return "a fast-paced gate";
		case 25: return "an uneven gate";
		case 26: return "a round face";
		case 27: return "perfectly symmetrical features";
		case 28: return "a large nose";
	}
	
	return "blood red hair";
}

string RandomString_GeneratePrimeLocation() {

	int total = 24;
	switch (Random(total)) {
		case 0: return "Athas";
		case 1: return "the backwater prime known as Toril";
		case 2: return "some unknown prime";
		case 3: return "the wondrous prime of Oerth";
		case 4: return "the demi-plane of dread";
		case 5: return "the Mists";
		case 6: return "the little known world of Mystara";
		case 7: return "the prime of Ebberon";
		case 8: return "the irrelevant prime of Krynn";
		case 9: return "Blackmoor";
		case 10: return "the strange prime known as Aebrynis";
		case 11: return "the thousand blessed lands of Zakhara on Toril (may a hundred songbirds praise its name for eternity!)";
		case 12: return "Kara-tur, a honourable land on the plane known as Toril";
		case 13: return "a place best not mentioned";
		case 14: return "a distant corner of the multiverse";
		case 15: return "Toril";
		case 16: return "Fearun";
		case 17: return "Oerth";
		case 18: return "Mystara";
		case 19: return "Ebberon";
		case 20: return "Krynn";
		case 21: return "Aebrynis";
		case 22: return "Zakhara";
		case 23: return "Kara-tur";
	}
	return "Athas";
}

//Returns a random backstory / random fact
//. . and who was
string RandomString_GenerateBackstory() {
	int total = 41;
	switch (Random(total)) {
		case 0: return "nobody important";
		case 1: return "a hero";
		case 2: return "a victim of fate";
		case 3: return "initially of a backwater village";
		case 4: return "a person of ill repute";
		case 5: return "an outspoken politician";
		case 6: return "a lazy servant";
		case 7: return "the champion of a nation";
		case 8: return "an escaped slave";
		case 9: return "a successful businessman";
		case 10: return "involved in questionable dealings";
		case 11: return "a slayer of "+RandomString_GenerateRace()+"s";
		case 12: return "a veteran of the blood war";
		case 13: return "the savior of "+RandomString_GeneratePlanarLocation();
		case 14: return "a failed businessman";
		case 15: return "a shady customer";
		case 16: return "an industrious person";
		case 17: return "a friend to "+RandomString_GenerateRace()+"s";
		case 18: return "an enemy of "+RandomString_GenerateRace()+"s";
		case 19: return "an exceptionally lucky person";
		case 20: return "a soldier of the Harmonium";
		case 21: return "a scholar of the Fraternity of Order";
		case 22: return "a bounty hunter of the Mercykillers";
		case 23: return "a Sensate";
		case 24: return "a hedonist";
		case 25: return "a member of the Sign of One";
		case 26: return "a taxation officer of the Fated";
		case 27: return "one of the Heartless";
		case 28: return "a Cipher";
		case 29: return "a member of the Transcendent Order";
		case 30: return "a servant of the gods";
		case 31: return "a denier of the gods";
		case 32: return "a member of the Athar";
		case 33: return "a free person of the Indeps";
		case 34: return "a prominent member of the Free League";
		case 35: return "a Doomguard";
		case 36: return "a warrior of the Doomguard";
		case 37: return "a member of the Bleak Cabal";
		case 38: return "an anarchist";
		case 39: return "a Xaositect";
		case 40: return "from "+RandomString_GeneratePrimeLocation();
	}
	
	return "nobody important";
}

//The hurdles / problems one might face while trying to get something done
//after x suffered or overcame or survived. . . 
string RandomString_HurdleGenerator() {

	int total = 13;
	switch (Random(total)) {
		case 0: return "a blow to the head";
		case 1: return "an encounter with a banana peel";
		case 2: return "a run in with bandits";
		case 3: return "a sudden bout of indigestion";
		case 4: return "getting lost in "+RandomString_GeneratePlanarLocation();
		case 5: return "a sudden run in with XAOSItECts";
		case 6: return "bumping into a Dabus";
		case 7: return "various long and trying legal proceedings";
		case 8: return "falling through a random portal which led to "+RandomString_GeneratePlanarLocation();
		case 9: return "an almost fatal wound";
		case 10: return "a test of courage";
		case 11: return "a horrible illness";
		case 12: return "a mysterious curse";
	}
	
	return "a sudden blow to the head";
}

//Returns a random place in the planes
string RandomString_GeneratePlanarLocation() {

	int total = 139;
	switch (Random(total)) {
		case 0: return "Sigil";
		case 1: return "Ysgard";
		case 2: return "Muspelheim";
		case 3: return "Nidevellir";
		case 4: return "the Everchanging Chaos of Limbo";
		case 5: return "Limbo";
		case 6: return "the Spawning Stone";
		case 7: return "Shra'kt'lor";
		case 8: return "Zerth'Ad'lun";
		case 9: return "the Windswept Depths of Pandemonium";
		case 10: return "Pandemonium";
		case 11: return "the Madhouse";
		case 12: return "Pandesmos";
		case 13: return "Cocytus";
		case 14: return "Phlegethon";
		case 15: return "Windglum";
		case 16: return "the Abyss";
		case 17: return "the Infinite Layers of the Abyss";
		case 18: return "Broken Reach";
		case 19: return "Azzagrat";
		case 20: return "Thanatos";
		case 21: return "Abysm";
		case 22: return "the Fortress of Indifference";
		case 23: return "Carceri";
		case 24: return "the Tarterian Depths of Carceri";
		case 25: return "Bastion of Last Hope";
		case 26: return "Orthrys";
		case 27: return "Cathrys";
		case 28: return "Minethys";
		case 29: return "Colothys";
		case 30: return "Porphatys";
		case 31: return "Agathys";
		case 32: return "Hades";
		case 33: return "the Gray Waste of Hades";
		case 34: return "the Gray Wastes";
		case 35: return "Oinos";
		case 36: return "Niflheim";
		case 37: return "Pluton";
		case 38: return "Gehenna";
		case 39: return "the Bleak Eternity of Gehenna";
		case 40: return "Khalas";
		case 41: return "Chamada";
		case 42: return "Nimicri";
		case 43: return "Mungoth";
		case 44: return "Krangath";
		case 45: return "Baator";
		case 46: return "the Nine Hells of Baator";
		case 47: return "Avernus";
		case 48: return "Dis";
		case 49: return "Minauros";
		case 50: return "Phlegethos";
		case 51: return "Malbolge";
		case 52: return "Maladomini";
		case 53: return "Cania";
		case 54: return "Nessus";
		case 55: return "Acheron";
		case 56: return "the Infernal Battlefield of Acheron";
		case 57: return "Clangor";
		case 58: return "Nishrek";
		case 59: return "Avalas";
		case 60: return "Thuldanin";
		case 61: return "Tintibulus";
		case 62: return "Ocanthus";
		case 63: return "Mechanus";
		case 64: return "the Clockwork Nirvana of Mechanus";
		case 65: return "Delon-Estin Oti";
		case 66: return "a Hive Cog in Mechanus";
		case 67: return "Neumannus";
		case 68: return "Regulus";
		case 69: return "Fortress of Disciplined Enlightenment";
		case 70: return "Arcadia";
		case 71: return "the Peaceable Kingdoms of Arcadia";
		case 72: return "Abellio";
		case 73: return "Buxenos";
		case 74: return "Mandible";
		case 75: return "Celestia";
		case 76: return "the Seven Mounting Heavens of Celestia";
		case 77: return "Lunia";
		case 78: return "Mercuria";
		case 79: return "Venya";
		case 80: return "Mertion";
		case 81: return "Jovar";
		case 82: return "Bytopia";
		case 83: return "the Twin Paradises of Bytopia";
		case 84: return "Shurrock";
		case 85: return "Dothion";
		case 86: return "Elysium";
		case 87: return "the Blessed Fields of Elysium";
		case 88: return "Amoria";
		case 89: return "Eronia";
		case 90: return "Thalasia";
		case 91: return "Belierin";
		case 92: return "the Beastlands";
		case 93: return "the Wilderness of the Beastlands";
		case 94: return "Krigala";
		case 95: return "Brux";
		case 96: return "Karasuthra";
		case 97: return "Arborea";
		case 98: return "the Olympian Glades of Arborea";
		case 99: return "Arvandor";
		case 100: return "Aquallor";
		case 101: return "Mithardir";
		case 102: return "the Outlands";
		case 103: return "the Concordant Domain of the Outlands";
		case 104: return "Glorium";
		case 105: return "Xaos";
		case 106: return "Bedlam";
		case 107: return "Plague-Mort";
		case 108: return "Curst";
		case 109: return "Hopeless";
		case 110: return "Torch";
		case 111: return "Ribcage";
		case 112: return "Rigus";
		case 113: return "Automata";
		case 114: return "Fortitude";
		case 115: return "Excelsior";
		case 116: return "Tradegate";
		case 117: return "Ecstasy";
		case 118: return "Faunel";
		case 119: return "Sylvania";
		case 120: return "Sigil";
		case 121: return "the City of Doors";
		case 122: return "the Cage";
		case 123: return "the Elemental Plane of Fire";
		case 124: return "the Elemental Plane of Earth";
		case 125: return "the Elemental Plane of Water";
		case 126: return "the Elemental Plane of Air";
		case 127: return "the Para-Elemental Plane of Smoke";
		case 128: return "the Para-Elemental Plane of Magma";
		case 129: return "the Para-Elemental Plane of Ice";
		case 130: return "the Para-Elemental Plane of Ooze";
		case 131: return "the Quasi-Elemental Plane of Lightning";
		case 132: return "the Quasi-Elemental Plane of Radiance";
		case 133: return "the Quasi-Elemental Plane of Mineral";
		case 134: return "the Quasi-Elemental Plane of Steam";
		case 135: return "the Quasi-Elemental Plane of Vacuum";
		case 136: return "the Quasi-Elemental Plane of Ash";
		case 137: return "the Quasi-Elemental Plane of Dust";
		case 138: return "the Quasi-Elemental Plane of Salt";
	}	
	return "Sigil";
}

//Generate an entertaining crime, for someone to be guilty of!
string RandomString_GenerateCrime() {

	string sCrime = "";
	int nTotal = 41;
	switch (Random(nTotal)) {
		case 0: sCrime += "Crime Spree"; break;
		case 1: sCrime += "Disobeying Banishment Orders"; break;
		case 2: sCrime += "Murder"; break;
		case 3: sCrime += "Rape"; break;
		case 4: sCrime += "Treason"; break;
		case 5: sCrime += "Kidnapping"; break;
		case 6: sCrime += "Assault"; break;
		case 7: sCrime += "Association with Criminals"; break;
		case 8: sCrime += "Domination of another Sentient Being"; break;
		case 9: sCrime += "Irresponsible Use of Magic"; break;
		case 10: sCrime += "Manslaughter"; break;
		case 11: sCrime += "Misleading the Authorities"; break;
		case 12: sCrime += "Resisting Arrest"; break;
		case 13: sCrime += "Stalking"; break;
		case 14: sCrime += "Spying for the Enemy"; break;
		case 15: sCrime += "Taking Bribes"; break;
		case 16: sCrime += "Bribery"; break;
		case 17: sCrime += "Theft"; break;
		case 18: sCrime += "Grand Larceny"; break;
		case 19: sCrime += "Trespassing"; break;
		case 20: sCrime += "Dangerous Behavior"; break;
		case 21: sCrime += "Disrupting the Peace"; break;
		case 22: sCrime += "Failure to Comply with a Lawful Order"; break;
		case 23: sCrime += "Lewd Acts in Public"; break;
		case 24: sCrime += "Unauthorized Use of Magic"; break;
		case 25: sCrime += "Unauthorized Use of Force"; break;
		case 26: sCrime += "Grand Arson"; break;
		case 27: sCrime += "Public Intoxication"; break;
		case 28: sCrime += "Blackmail"; break;
		case 29: sCrime += "Forgery"; break;
		case 30: sCrime += "Failure to Control a Dangerous Magical Beast"; break;
		case 31: sCrime += "Impersonation of a member of the Harmonium"; break;
		case 32: sCrime += "Revolutionary Leanings"; break;
		case 33: sCrime += "Fraud"; break;
		case 34: sCrime += "Fencing Stolen Goods"; break;
		case 35: sCrime += "Defiling of a Temple"; break;
		case 36: sCrime += "Preaching without a Permit"; break;
		case 37: sCrime += "Selling without a Permit"; break;
		case 38: sCrime += "Tax Evasion"; break;
		case 39: sCrime += "Robbery"; break;
		case 40: sCrime += "Burglary"; break;
	}
	
	if (d10() <= 3) {
		sCrime += ", "+RandomString_GenerateCrime();
	}
	
	return sCrime;
}

//***************************************************************************
//Generates a romance story with a starting string and 5 characters
string GenerateRomanceStory(string sStart, struct character protagonist, struct character loveInterest, struct character newPerson, struct character newPerson2, struct character newPerson3) {
	string sStory = sStart;
	
	//Enter the protagonist
	sStory += IntroduceCharacter(protagonist);
	
	//Beginning circumstances. . .
	switch (Random(9)) {
		case 0: sStory += "\n\nWhile sitting under a tree, "; break;
		case 1: sStory += "\n\nOne day, "; break;
		case 2: sStory += "\n\nDuring "+protagonist.possessivePronoun+" travels, "; break;
		case 3: sStory += "\n\nDuring "+protagonist.possessivePronoun+" work, "; break;
		case 4: sStory += "\n\nAfter a grevious defeat in "+RandomString_GeneratePlanarLocation()+", "; break;
		case 5: sStory += "\n\nAfter a glorious victory "+RandomString_GeneratePlanarLocation()+", "; break;
		case 6: sStory += "\n\nWhen "+protagonist.pronoun+" came of age, "; break;
		case 7: sStory += "\n\nIn the year "+IntToString(Random(100) + 20) + " of Hashkar's Reign, "; break;
		case 8: sStory += "\n\While recoving from a terrible illness, "; break;
	}
	
	//Introduction of love interest
	sStory += protagonist.firstname+" met ";
	sStory += IntroduceCharacter(loveInterest);
	switch (Random(6)) {
		case 0: sStory += " "; break;
		case 1: sStory += " It was love at first sight."; break;
		case 2: sStory += " It was not long before they pledged their undying love."; break;
		case 3: sStory += " At first, she had an incredible dislike of him. However, after he suffered "+RandomString_HurdleGenerator()+", "+loveInterest.firstname+" saw his true worth."; break;
		case 4: sStory += " At first, "+loveInterest.firstname+" did not think he was very special. But when "+protagonist.firstname+" survived "+RandomString_HurdleGenerator()+", "+loveInterest.firstname+" saw his true worth."; break;
		case 5: sStory += " Their love soon blossomed, and they became engaged."; break;
	} 
	
	//Developments
	switch (Random(8)) {
		case 0: sStory += "\n\nUnfortunately, "+loveInterest.firstname+"'s parents did not approve because "+protagonist.pronoun+" was a "+protagonist.race+". Heartbroken, "; break;
		case 1: sStory += "\n\nUnfortunately, "+protagonist.firstname+"'s parents forbade the match because "+loveInterest.pronoun+" was a "+loveInterest.race+". Deeply hurt, "; break;
		case 2: sStory += "\n\nUnfortunately, "+loveInterest.firstname+"'s family did not approve because "+protagonist.pronoun+" was "+protagonist.backstory+". Because of this, "; break;
		case 3: sStory += "\n\nUnfortunately, "+loveInterest.firstname+"'s parents forbade the match because "+loveInterest.pronoun+" was a "+loveInterest.title+". As a result, "; break;
		case 4: sStory += "\n\nBut before they could be married, "; break;
		case 5: sStory += "\n\nBut the day before the wedding, "; break;
		case 6: sStory += "\n\nThe wedding was beautitful, but the following day, "; break;
		case 7: sStory += "\n\nThe happy couple was married, and they soon concieved a child. But "; break;
	}
	
	//The lovers are separated
	int nRand = Random(6);
	int newGender = GENDER_MALE;
	struct character leftBehind = loveInterest;
	struct character left = protagonist;
	switch (nRand) {
		case 0: sStory += loveInterest.firstname+" disappeared through a portal to "+RandomString_GeneratePlanarLocation()+"."; break;
		case 1: sStory += protagonist.firstname+" disappeared through a portal to "+RandomString_GeneratePlanarLocation()+"."; break;
		case 2: sStory += protagonist.firstname+" was exiled to "+RandomString_GeneratePlanarLocation()+", on charges of treason.";  break;
		case 3: sStory += loveInterest.firstname+" fell dealthly ill, and died, "+loveInterest.possessivePronoun+" soul passing on to "+RandomString_GeneratePlanarLocation()+".";  break;
		case 4: sStory += protagonist.firstname+" was soon called off to war."; break;
		case 5: sStory += protagonist.firstname+" was called away to "+RandomString_GeneratePlanarLocation()+" on business."; break;
	}
	
	if (nRand == 0 || nRand == 3) { //if the love interest left instead of the protagonist; for some reason we can't put this in the case statement
		leftBehind = protagonist;
		left = loveInterest;
		newGender = GENDER_FEMALE;
	}
	
	//Trials and Tribulations and Reunions
	switch (Random(12)) {
		case 0: sStory += "\n\n. . . unfortunately, the rest of the volume is filled with indecipherable scribbling. The end of the story is a mystery."; break;
		case 1: sStory += "\n\nThe story ends with "+leftBehind.firstname+" grieving the loss of "+left.firstname+". The afterword promises that the story will be continued in a future volume."; break;
		case 2: sStory += "\n\nSeparated from "+leftBehind.possessivePronoun+" lover, "+leftBehind.firstname+" went mad with grief. "+leftBehind.firstname+"'s family had "+leftBehind.firstname+" committed to the gatehouse. "; 
				sStory += " When by miraculous circumstances "+left.firstname+" returned home, "+left.pronoun+" was furious, and took vengeance on "+leftBehind.firstname+"'s family for their cruelty.";
				sStory += " Then, also quite mad with guilt and grief, "+left.firstname+" joined "+leftBehind.firstname+" in the madhouse. \n\n The story ends with the lovers together again, even if it is in insanity."; break;
		case 3: sStory += "\n\nAt first, "+leftBehind.firstname+" was heartbroken to be abandoned. However, in time, "+leftBehind.pronoun+" met "+IntroduceCharacter(newPerson);
				sStory += " They quickly fell in love, and "+newPerson.firstname+" heals the hole in "+leftBehind.firstname+"'s heart. The fate of "+left.firstname+" is unknown."; break;
		case 4: sStory += "\n\nThe loss of "+left.firstname+" nearly drove "+leftBehind.firstname+" mad with grief. However, "+left.pronoun+" used the power of "+left.possessivePronoun+" mind and imagination to reunite with "+left.possessivePronoun+" lover - even if only in spirit.";
				sStory += "\n\nThe story slowly devolves into a detailed treatise on the power of the mind. Apparently the author was a Signer."; break;
		case 5: sStory += "\n\nDetermined to be reunited with "+left.possessivePronoun+" lover, "+leftBehind.firstname+" left home on an epic journey to find "+left.firstname+".";
				sStory += "\n\nThe story at this point splits into two narratives. One part follows the planar adventures of "+leftBehind.firstname+", who first travels to "+RandomString_GeneratePlanarLocation()+", then "+RandomString_GeneratePlanarLocation()+", and even to "+RandomString_GeneratePlanarLocation()+".";
				sStory += " Meanwhile, "+left.firstname+" ends up in "+RandomString_GeneratePlanarLocation()+". The lovers are only united at the end of their lives; they die in each other's arms."; break;
		case 6: sStory += "\n\nUnable to bear being separated from "+leftBehind.possessivePronoun+" lover, "+leftBehind.firstname+" throws "+leftBehind.possessivePronoun+"self off a cliff. The next day, ";
				sStory += left.firstname+" returns miraculously. Horrified, "+left.firstname+" drives a knife through "+left.pronoun+" heart, to be reunited with "+leftBehind.firstname+" - even if only in death"; break;
		case 7: sStory += "\n\nThe story jumps in time. "+left.firstname+" is unable to return home, and settles down to make a new life for "+left.possessivePronoun+"self. Part of that new life is a series of new characters, such as "+IntroduceCharacter(newPerson);
				sStory += " "+newPerson.firstname+" introduces "+left.firstname+" to "+newPerson.possessivePronoun+" friend, "+IntroduceCharacter(newPerson2)+". "+left.firstname+" ends up in a love triangle between "+newPerson2.firstname+" and a third party "+newPerson3.firstname+". ";
				sStory += " However, "+left.firstname+" ultimately realizes that they really love "+newPerson.firstname+", because "+newPerson.pronoun+" reminds "+left.pronoun+" of "+leftBehind.firstname+". They get married and live happily ever after."; break;
		case 8: sStory += "\n\nSaddened at the departure of "+left.firstname+", "+leftBehind.firstname+" found comfort in religion. After "+left.firstname+" had been gone a year, "+leftBehind.firstname+" joined a monastery. ";
				sStory += "The day after "+leftBehind.firstname+" swore "+left.possessivePronoun+" lifelong vows to "+left.possessivePronoun+" deity, "+left.firstname+" miraculously returned. While "+leftBehind.firstname+" was gladdened by ";
				sStory += left.firstname+"'s return, "+leftBehind.pronoun+" refused to abandon "+left.possessivePronoun+" vows. With nothing else to live for, "+left.firstname+" joins the neighboring monastery. The couple lives out the rest of their lives ";
				sStory += "in service to their gods."; break;
		case 9: sStory += "\n\nSaddened at the departure of "+left.firstname+", "+leftBehind.firstname+" found comfort in religion. After "+left.firstname+" had been gone a year, "+leftBehind.firstname+" joined a monastery. ";
				sStory += "The day after "+leftBehind.firstname+" swore "+left.possessivePronoun+" lifelong vows to "+left.possessivePronoun+" deity, "+left.firstname+" miraculously returned. While "+leftBehind.firstname+" was gladdened by ";
				sStory += left.firstname+"'s return, "+leftBehind.pronoun+" refused to abandon "+left.possessivePronoun+" vows. With nothing else to live for, "+left.firstname+" became very bitter. He joined the Blood War, and distinguished "+left.possessivePronoun+"self in ";
				sStory += "unending bloody combat, until "+left.pronoun+" eventually fell, and "+left.possessivePronoun+" soul was devoured by the forces of the lower planes."; break;
		case 10: sStory += "\n\nThe separation is long and trying, but eventually "+left.firstname+" returned to "+leftBehind.firstname+"'s side. They live happily ever after."; break;	
		case 11: sStory += "\n\nAfter many trials and tribulations "+left.firstname+" returned home. Upon "+left.firstname+"'s return "+left.pronoun+" is horrified to discover that ";
				sStory += leftBehind.firstname+" was not true; "+leftBehind.pronoun+" was having an affair with "+IntroduceCharacter(newPerson)+" Enraged, "+left.firstname+" ambushed "+leftBehind.firstname+" and her new lover, "+newPerson.firstname+", slaying them both."; 
				sStory += "\n\nThe story ends with "+left.firstname+" committing suicide, having nothing left to live for."; break;	
	}
	return sStory;
}

//Generates a title for a Romance Novel
string GenerateRomanceTitle(struct character char1, struct character char2) {
	
	int total = 9;
	switch (Random(total)) {
		case 0: return "The "+char1.title+" of "+char1.lastname; break;
		case 1: return "The Love of "+char1.firstname+" and "+char2.firstname; break;
		case 2: return char1.firstname+" "+char1.lastname; break;
		case 3: return char1.firstname+" and "+char2.lastname; break;
		case 4: return char1.firstname+" "+char1.nickname; break;
		case 5: return "The "+(char1.gender==GENDER_MALE?"Lad":"Maid")+" of "+char1.lastname; break;
		case 6: return "The "+(char2.gender==GENDER_MALE?"Lad":"Maid")+" of "+char2.lastname; break;
		case 7: return "The Tale of "+char1.firstname+" and "+char2.firstname; break;
		case 8: return "The Tale of "+char1.firstname+" "+char1.nickname; break;
	}
	return "True Love";
}

//Generates the tale of a legendary hero, with a string and five characters
string GenerateLegend(string sStart, struct character protagonist, struct character supporting, struct character villain, struct character champion, struct character helper) {

	string sStory = sStart;
	
	//Enter the protagonist
	sStory += IntroduceCharacter(protagonist);

	switch (Random(6)) {
		case 0: sStory += "\n\nOnce upon a time, "; break;
		case 1: sStory += "\n\nIn the year "+IntToString(Random(100) + 20) + " of Hashkar's Reign, "; break;
		case 2: sStory += "\n\nIn the far distant past, in "+RandomString_GeneratePrimeLocation()+", "; break;
		case 3: sStory += "\n\nIn the year "+IntToString(Random(1000) + Random(100)) + " by some prime's reckoning, "; break;
		case 4: sStory += "\n\nLong ago, "; break;
		case 5: sStory += "\n\nNot so long ago, in the land of "+RandomString_GeneratePrimeLocation()+", "; break;
	}
	
	sStory += protagonist.firstname+", the hero with "+protagonist.feature2+", ";
	
	switch(Random(6)) {
	 	case 0: sStory += "did battle with "+villain.nickname+", "+villain.firstname+". "; break;
	 	case 1: sStory += "stole an artifact of power from "+villain.firstname+" "+villain.nickname+" a "+villain.title+" of "+RandomString_GeneratePrimeLocation()+". "; break;
	 	case 2: sStory += "defeated the armies of "+villain.title+" "+villain.firstname+" of "+villain.nickname+" in pitched battle. "; break;
	 	case 3: sStory += "became known to "+villain.firstname+" of the house of "+villain.nickname+". Not by name, or chance meeting, but by prophecy. The soothsayer of "+villain.firstname+" "+villain.nickname+"'s household foretold that a "; 
				sStory += protagonist.race+" with "+protagonist.feature1+" and "+protagonist.feature2+" would bring an end to "+villain.nickname+"'s evil ways."; break;
	 	case 4: sStory += "stole the heart of "+villain.firstname+" "+villain.nickname+"'s betrothed, the beautiful "+IntroduceCharacter(supporting); break;
		case 5: sStory += "joined forces with "+supporting.nickname+" "+supporting.firstname+", and thwarted the will of "+villain.title+" "+villain.firstname+" of "+villain.nickname+". "; break;
	}
	
	string sRelationship = "lover";
	if (supporting.gender == protagonist.gender)
		sRelationship = "comrade";
		
	switch (Random(3)) {
			case 0: sStory += "\n\nFeeling threatened by the might of "+protagonist.firstname+" "+protagonist.nickname+" and "+protagonist.possessivePronoun+" "+sRelationship+" "+supporting.firstname+", ";
					sStory += villain.firstname+" "+villain.nickname+" took counsel against them."; break;
			case 1: sStory += "\n\nAngered at the audacity of "+protagonist.firstname+" "+protagonist.nickname+" and "+protagonist.possessivePronoun+" "+sRelationship+" "+supporting.firstname+" "+supporting.nickname+", ";
					sStory += villain.firstname+" "+villain.nickname+" devised a deadly scheme."; break;
			case 2: sStory += "\n\n"+villain.firstname+" "+villain.nickname+" consulted "+villain.possessivePronoun+" soothsayers as to the best course of action to take to protect "+villain.possessivePronoun+" lands and title against ";
					sStory += protagonist.firstname+" "+protagonist.nickname+"."; break;
	}
	
	string threat = "spell";
	switch (Random(5)) {
		case 0: sStory += " "+villain.firstname+" laid a curse upon "+protagonist.firstname+" "+protagonist.nickname+". "; threat = "the curse"; break;
		case 1: sStory += " "+villain.firstname+" laid a curse upon "+supporting.firstname+" "+supporting.nickname+". "; threat = "the curse on "+supporting.firstname; break;
		case 2: sStory += " "+villain.firstname+" cast a mighty spell to lay waste the land of "+protagonist.firstname+" "+protagonist.nickname+". "; threat = "the spell on the land"; break;
		case 3: sStory += " "+villain.firstname+" "+villain.nickname+" marshalled "+villain.possessivePronoun+" armies, and marched against "+protagonist.firstname+" "+protagonist.nickname+". "; threat = villain.firstname+"' army"; break;
		case 4: sStory += " "+villain.firstname+" "+villain.nickname+" summoned the mighty "+champion.race+", "+champion.firstname+" "+champion.nickname+" to fight "+protagonist.firstname+" "+protagonist.nickname+" in single combat. "; threat = villain.firstname+"'s champion, "+champion.firstname+" "+champion.nickname; break;
	}	
	
	switch(Random(4)) {
		case 0: sStory += "\n\n"+protagonist.firstname+" "+protagonist.nickname+" would have been able to defeat "+threat+" handily, were it not for "+RandomString_HurdleGenerator()+"."; break;
		case 1: sStory += "\n\nUnfortunately, "+RandomString_HurdleGenerator()+" forced "+protagonist.firstname+" "+protagonist.nickname+" to fall before "+threat+"."; break;
		case 2: sStory += "\n\nThe might of "+threat+" was too much for "+protagonist.firstname+" and "+supporting.firstname+" to face alone."; break;
		case 3: sStory += "\n\nAt the same time, "+supporting.firstname+" suffered "+RandomString_HurdleGenerator()+", which kept "+protagonist.firstname+" from simply destroying "+threat+"."; break;
	}
	
	sStory += " And so, ";
	
	if (d2() == 1) { //solution is item
		string sItem = RandomString_GenerateArtifact();
		switch(Random(3)) {
			case 0: sStory += protagonist.firstname+" "+protagonist.nickname+" embarked on a quest to find "+sItem+"."; break;
			case 1: sStory += protagonist.firstname+" "+protagonist.nickname+" went in search of the "+sItem+"."; break;
			case 2: sStory += protagonist.firstname+" and "+supporting.firstname+" traveled to "+RandomString_GeneratePlanarLocation()+" to find the "+sItem+"."; break;
		}
		
		sStory += " Along the way, "+protagonist.pronoun+" suffered many trials and tribulations, including "+RandomString_HurdleGenerator()+".";
		sStory += " But "+protagonist.firstname+" was able to recover the "+sItem+" at long last, and used it to defeat "+threat+".";
	} else { //solution is person
		switch(Random(3)) {
			case 0: sStory += protagonist.firstname+" went in search of "+helper.firstname+" "+helper.nickname+", a "+(helper.gender==GENDER_MALE?"warlock":"witch")+" of great power."; break;
			case 1: sStory += protagonist.firstname+" sought the aid of "+helper.firstname+" "+helper.nickname+", for it was rumored that only "+helper.pronoun+" knew the secret to defeating "+threat+"."; break;
			case 2: sStory += protagonist.firstname+" and "+supporting.firstname+" traveled to "+RandomString_GeneratePlanarLocation()+" to find "+helper.firstname+" "+helper.nickname+", a warrior of renown."; break;
		}
		
		if (d2() == 1) {
			sStory += " Before "+helper.pronoun+" would aid "+protagonist.pronoun+", "+helper.firstname+" "+helper.nickname+" challenged "+protagonist.firstname+" to face "+RandomString_HurdleGenerator()+".";
			sStory += " "+protagonist.firstname+" rose to the challenge, and secured "+helper.firstname+"'s help.";
		} else {
			sStory += " "+helper.firstname+" agreed to help "+protagonist.firstname+", because of an old grudge against "+villain.firstname+".";
		}
		
		sStory += "With the aid of "+helper.firstname+", "+protagonist.firstname+" was able to defeat "+threat+".";
	}
	
	switch(Random(2)) {
		case 0: sStory += "\n\n"+protagonist.firstname+" and "+supporting.firstname+" then moved directly against "+villain.firstname+" "+villain.nickname+". With "+
			threat+" thwarted, "+villain.firstname+" "+villain.nickname+" was unable to defend against the power of "+protagonist.firstname+" "+protagonist.nickname+". "+
			protagonist.firstname+" was victorious, and went down in legend as a great hero."; break;
		case 1: sStory += "\n\nWith "+threat+" thwarted, "+protagonist.firstname+" and "+supporting.firstname+" raised an army, and marched against "+villain.firstname+" "+villain.nickname+"."+
				" The fighting was fierce, but "+protagonist.firstname+" "+protagonist.nickname+" emerged victorious. "+villain.firstname+" "+villain.nickname+" was executed, and the land knew peace.";
	}
		
	return sStory;
}

//Generates the title of a Legendary Tale
string GenerateLegendTitle(struct character char1, struct character char2) {
	
	int total = 8;
	switch (Random(total)) {
		case 0: return "The "+char1.title+" of "+char1.lastname; break;
		case 1: return "The "+char2.title+" of "+char2.lastname; break;
		case 2: return char1.firstname+" "+char1.nickname; break;
		case 3: return char2.firstname+" "+char2.nickname; break;
		case 4: return "The Legend of "+char1.firstname+" "+char1.nickname; break;
		case 5: return "The Tale of "+char1.firstname+" "+char1.nickname; break;
		case 6: return "The Reign of "+char2.firstname+" "+char2.nickname; break;
		case 7: return "The Hero with "+char1.feature1; break;
	}
	return "A Heroic Tale";
}

//A generic grocery list in Sigil. Which means its probably not generic at all.
string GenerateGroceryList() {
	string sList = "";
	
	int total = 4;
	switch(Random(total)) {
		case 0: sList += "A hastily scribbled shopping list, in a sloppy hand. \n\n"; break;
		case 1: sList += "A plain grocery list, in a neat hand. The paper looks like a page torn out of a book. \n\n"; break;
		case 2: sList += "A list, scribbled on the back of what appears to be an invoice. \n\n"; break;
		case 3: sList += "On one side, you can make out half of a letter. Apparently it was not a very important document, because on the other side is someone's shopping list. \n\n"; break;
	}
	
	struct character shopkeeper = DetailCharacter(2);
	string sComment = "";
	total = 10;
	switch (Random(total)) {
		case 0: sComment += " (Don't buy from "+shopkeeper.firstname+")"; break;
		case 1: sComment += " - "+shopkeeper.firstname+" charges too much"; break;
		case 2: sComment += " - Best prices at "+shopkeeper.firstname+"'s"; break;
		case 3: sComment += " (Not the green ones)"; break;
		case 4: sComment += " (Make sure they're ripe)"; break;
		case 5: sComment += " - Check for rust"; break;
		default: break;
	}
	
	sList += RandomString_GenerateItem(GENERIC_ITEM_FOOD)+"\n";
	sList += RandomString_GenerateItem(GENERIC_ITEM_FOOD)+"\n";
	if (d10() < 8)
		sList += RandomString_GenerateItem(GENERIC_ITEM_FOOD)+"\n";
	if (d10() < 5)
		sList += RandomString_GenerateItem(GENERIC_ITEM_FOOD)+"\n";
	if (d10() < 3)
		sList += RandomString_GenerateItem(GENERIC_ITEM_FOOD)+sComment+"\n";
	else if (d10() < 2)
		sList += RandomString_GenerateItem(GENERIC_ITEM_DOMESTIC)+sComment+"\n";
	else if (d10() < 2)
		sList += RandomString_GenerateItem(GENERIC_ITEM_ALCHEMY)+sComment+"\n";
	if (d10() < 2)
		sList += RandomString_GenerateItem(GENERIC_ITEM_DOMESTIC)+"\n";
	if (d10() < 3)
		sList += RandomString_GenerateItem(GENERIC_ITEM_FOOD)+"\n";
	if (d10() < 2)
		sList += RandomString_GenerateItem(GENERIC_ITEM_ALCHEMY)+"\n";
	if (d10() < 2)
		sList += RandomString_GenerateItem(GENERIC_ITEM_ALCHEMY)+"\n";
	if (d10() < 1)
		sList += RandomString_GenerateItem(GENERIC_ITEM_MAGIC)+"\n";
		
	return sList;
}

//Creates a strange alchemical recipes
string GenerateRecipeText() {

	string sText = "";
	
	int total = 5;
	switch(Random(total)) {
		case 0: sText += "A scribbled alchemical recipe on a dirty piece of paper. \n\n"; break;
		case 1: sText += "Over the top of the following recipe, the words 'DOES NOT WORK' are written in large letters. Someone was disappointed. \n\n"; break;
		case 2: sText += "The word 'SUCCESS!' appears scribbled again and again along the margins of this recipe. \n\n"; break;
		case 3: sText += "The torn page from a mad wizard's alchemical book. \n\n"; break;
		case 4: sText += "Despite the careful penmanship and detailed explanations in the following recipe, you find no mention about what it is supposed to do. \n\n"; break;
	}
	
	sText += "<i>";
	string ingred1 = RandomString_GenerateItem(GENERIC_ITEM_ALCHEMY);
	string ingred2 = RandomString_GenerateItem(GENERIC_ITEM_ALCHEMY);
	string ingred3 = RandomString_GenerateItem(GENERIC_ITEM_ALCHEMY);
	string ingred4 = RandomString_GenerateItem(GENERIC_ITEM_ALCHEMY);
	string ingred5 = RandomString_GenerateItem(GENERIC_ITEM_ALCHEMY);
	string ingred6 = RandomString_GenerateItem(GENERIC_ITEM_FOOD);
	
	total = 6;
	switch(Random(total)) {
		case 0: sText += "Take "+ingred1+" and make a find powder from it. Then take distilled vinegar, and disolve the powder within it. Let stand in a glass over a small fire until the vinegar changes color."; break;
		case 1: sText += "Take "+IntToString(d3())+" parts of "+ingred1+" and "+IntToString(d3())+" parts oil, and combine in a glass vessel. Allow to stand in the sun for "+IntToString(d3())+" days; watching to ensure that the mixture does not mold. Once infused, strain out the "+ingred1+", and store in a dark cool place."; break;
		case 2: sText += "Heat "+IntToString(d3())+" parts oil, mixed with "+IntToString(d3())+" parts "+ingred1+" over a small fire. Keep at a steady low temperature to allow the "+ingred1+" to infuse in the oil.";
		case 3: sText += "Combine "+ingred1+" with "+ingred2+", and grind into a fine powder."; break;
		case 4: sText += "Mix "+ingred1+" and "+ingred2+". Allow to rest for "+IntToString(d3())+" hours, then pour into a glass vessel. Add vinegar until the mixture is just covered. Allow to sit in a cool dark place for "+IntToString(d3())+" days."; break;
		case 5: sText += "Sift "+IntToString(d3())+" parts "+ingred1+" and then add "+IntToString(d3())+" parts "+ingred2+". Set aside."; break;
	}
	
	total = 6;
	switch(Random(total)) {
		case 0: sText += "\n\nBring the mixture to room temperature. Then add "+IntToString(d3())+" parts "+ingred3+". In another vessel, grind "+IntToString(d3())+" parts "+ingred4+" to a fine powder."; break;
		case 1: sText += "\n\nSet the mixture aside. In another vessel, combine 1 part "+ingred3+" and "+IntToString(d3())+" parts "+ingred4+"."; break;
		case 2: sText += "\n\nIn another vessel, combine "+ingred3+", "+ingred4+", and "+ingred6+". Place over an open fire, and bring to a boil. Boil for one hour, and then allow to cool."; break;
		case 3: sText += "\n\nCombine "+ingred3+" with "+ingred4+", and grind into a fine powder. Disolve in the finest distilled vinegar."; break;
		case 4: sText += "\n\nMix "+ingred3+" and "+ingred4+". Allow to rest for "+IntToString(d3())+" hours, then pour into a new vessel."; break;
		case 5: sText += "\n\nSift "+IntToString(d3())+" parts "+ingred3+" and then add "+IntToString(d3())+" parts "+ingred4+". Set aside."; break;
	}
	
	total = 4;
	switch(Random(total)) {
		case 0: sText += "\n\nCombine the "+ingred1+" mixture with the "+ingred4+" solution; bring to a boil, and keep at a slow boil for "+IntToString(d3())+" hours."; break;
		case 1: sText += "\n\nTake the combination of "+ingred1+" and "+ingred4+", and distill "+IntToString(d6(6))+" times over, to purify the mixture."; break;
		case 2: sText += "\n\nMix the "+ingred1+" solution with "+IntToString(d3())+" parts of the "+ingred4+" mixture."; break;
		case 3: sText += "\n\nTake the noble mixture of "+ingred1+" and "+ingred4+" and put it into a glass amphora with a long neck.  Close the mouth securely with wax, and bury in horse dung. Allow to purify for "+IntToString(d3())+" weeks, then remove."; break;
	}
	
	total = 6;
	switch(Random(total)) {
		case 0: sText += " Allow the mixture to rest before use."; break;
		case 1: sText += " Distill the mixture "+IntToString(d6(6))+" times before use."; break;
		case 2: sText += " Add yeast, and set the mixture aside for "+IntToString(d3())+" weeks while it ferments."; break;
		case 3: sText += " Add the mixture to melted wax. Allow to infuse, and then use when completely cool."; break;
		default: break;
	}

	sText += "</i>";
	return sText;
}

//Generate a Wanted Poster
string GenerateWantedPoster() {

	struct character wanted = DetailCharacter(2);
	string sText = "WANTED";
	
	int total = 4;
	int nReward = d100(10)*100;
	switch(Random(total)) {
		case 0: sText += "\nDead or Alive"; break;
		case 1: sText += "\nAlive"; break;
		case 2: sText += "\nFor "+wanted.crime; break;
		case 3: sText += "\n"+IntToString(nReward)+" Jink Reward"; break;
		default: break;
	}
	sText += "\n\n"+wanted.firstname+" "+wanted.lastname+", also known as "+wanted.nickname;
	sText += "\n\n<i>There follows a sketch of a "+(wanted.gender==GENDER_MALE?"male":"female")+" "+wanted.race+" with "+wanted.feature1+" and "+wanted.feature2+".</i>";
	sText += "\n\nGuilty of "+wanted.crime+"\n"+IntToString(nReward)+" Jink Reward";
	return sText;
}

//Generates a random love letter
string GenerateLoveLetterText() {

	string sText = "";
	struct character writer = DetailCharacter(2);
	int nGender = GENDER_MALE;
	if (writer.gender == GENDER_MALE)
		nGender = GENDER_FEMALE;
	struct character recipient = DetailCharacter(nGender);
	
	int total = 6;
	switch(Random(total)) {
		case 0: sText += "My Dear "+recipient.firstname+","; break;
		case 1: sText += "Dear "+recipient.firstname+","; break;
		case 2: sText += "My Love,"; break;
		case 3: sText += "My Sweetheart,"; break;
		case 4: sText += "My "+recipient.title+","; break;
		case 5: sText += "Dearest,"; break;
		default: break;
	}
	
	int nParagraphs = Random(2)+1;
	int nCurrent = 0;
	while (nCurrent < nParagraphs) {
		total = 23;
		switch(Random(total)) {
			case 0: sText += "\n\nMy sweet love, I want you to know that I love you dearly and I always will. Your "+recipient.eyes+" fascinate me."; break;
			case 1: sText += "\n\nWhat "+(writer.gender==GENDER_MALE?"man":"woman")+" in "+writer.possessivePronoun+" right mind could resist those "+recipient.eyes+" of yours? They look like glass marbles shimmering in the sunlight."; break;
			case 2: sText += "\n\nYour "+recipient.hair+" is something to be admired by all. I love the way it shines in the sun"; break;
			case 3: sText += "\n\nMy love for you is sweeter than sugar, and there is no other love for me."; break;
			case 4: sText += "\n\nI can't remember if I've already told you this but I really do love your "+recipient.eyes+". Sometimes I wish I could do nothing but stare at your eyes all day."; break;
			case 5: sText += "\n\nDarling, I really wanted to let you know how special you are to me. Every time I see you, I get butterflies in my stomach."; break;
			case 6: sText += "\n\nWhat person in their sane mind could resist those beautiful "+recipient.eyes+" of yours which look like shiny little pebbles which you find on the beach. Is that where you found them?"; break;
			case 7: sText += "\n\nHow are things going for you, my darling?"; break;
			case 8: sText += "\n\nMy dearest love, I just wanted to let you know that you always brighten up a dull day in my life. Just seeing you is enough to make me feel warm inside."; break;
			case 9: sText += "\n\nMy dearest darling love. I really want you to know that I love you with all my heart."; break;
			case 10: sText += "\n\nWhat manner of creature can resist those "+recipient.eyes+" of yours which shimmer like bright stars in the night sky."; break;
			case 11: sText += "\n\nI love your "+recipient.eyes+", your "+recipient.hair+". . even the fact that you have "+recipient.feature2+"."; break;
			case 12: sText += "\n\nI am so in love with you. I think about you constantly."; break;
			case 13: sText += "\n\nI miss you dearly, and would traverse the planes to be with you again. I would even journey to the ends of "+RandomString_GeneratePlanarLocation()+", for but a single kiss."; break;
			case 14: sText += "\n\nI hope and pray that I inspire you the way that you inspire me. I am fascinated by your "+recipient.feature1+" and how you have "+recipient.feature2+"."; break;
			case 15: sText += "\n\nI realize that you are "+recipient.backstory+", but that just makes me love you more."; break;
			case 16: sText += "\n\nI know that your parents disapprove of me because I am "+writer.backstory+", but I hope that does not affect your opinion of me, my love."; break;
			case 17: sText += "\n\nI am so sorry that you had to suffer "+RandomString_HurdleGenerator()+". Your endurance is inspirational."; break;
			case 18: sText += "\n\nI need to confess something to you. Ever since I met you, I can only think of your "+recipient.feature1+". You fill my heart with unexpected joy and my head with amazing dreams of us together. My love can only grow more and more each day."; break;
			case 19: sText += "\n\nWhen I’m alone in the quiet, it always feels like I can hear your voice, whispering sweet nothings to me, just like the blessed music of a harp."; break;
			case 20: sText += "\n\nI must be the luckiest person in all the planes to have you in my life. You are my sunny day in winter. I’d give up everything in the world to know that you will be right there beside me for the rest of our lives."; break;
			case 21: sText += "\n\nI miss you so much. I hope to soon be done with my business in "+RandomString_GeneratePlanarLocation()+" so that I can return to your arms."; break;
			case 22: sText += "\n\nOthers may call you "+recipient.nickname+", but to me, you are the most loveable creature in the planes."; break;
			default: break;
		}
	}
	
	total = 4;
	switch(Random(total)) {
		case 0: sText += "\n\nAll my Love,\n"+writer.firstname; break;
		case 1: sText += "\n\nLove,\n"+writer.firstname; break;
		case 2: sText += "\n\nYour Greatest Admirer,\n"+writer.firstname; break;
		case 3: sText += "\n\nYour Beloved "+writer.firstname; break;
		default: break;
	}
	
	return sText;

}

string CapitalizeFirstLetter(string s) {
	string c = GetStringLeft(s, 1);
	string rest = GetStringRight(s, GetStringLength(s)-1);
	if (c == "a") 		return "A"+rest;
	else if (c == "b") 	return "B"+rest;
	else if (c == "c")	return "C"+rest;
	else if (c == "d") 	return "D"+rest;
	else if (c == "e") 	return "E"+rest;
	else if (c == "f") 	return "F"+rest;
	else if (c == "g") 	return "G"+rest;
	else if (c == "h") 	return "H"+rest;
	else if (c == "i") 	return "I"+rest;
	else if (c == "j") 	return "J"+rest;
	else if (c == "k") 	return "K"+rest;
	else if (c == "l") 	return "L"+rest;
	else if (c == "m") 	return "M"+rest;
	else if (c == "n") 	return "N"+rest;
	else if (c == "o") 	return "O"+rest;
	else if (c == "p") 	return "P"+rest;
	else if (c == "q") 	return "Q"+rest;
	else if (c == "r") 	return "R"+rest;
	else if (c == "s") 	return "S"+rest;
	else if (c == "t") 	return "T"+rest;
	else if (c == "u") 	return "U"+rest;
	else if (c == "v") 	return "V"+rest;
	else if (c == "w") 	return "W"+rest;
	else if (c == "x") 	return "X"+rest;
	else if (c == "y") 	return "Y"+rest;
	else if (c == "z") 	return "Z"+rest;
	return s;
}