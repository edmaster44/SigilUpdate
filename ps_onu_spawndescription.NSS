#include "ps_inc_flavortext"
#include "ps_inc_experimentaleffects"
#include "ps_inc_newenchanting"

int GetRandomIcon(object oPC, string sPartial) {
	
	object oHolder = GetModule();
	
	//If this list hasn't been saved yet; save it for later!
	int nMax = GetLocalInt(oHolder, sPartial+"_max");
	if (nMax <= 0) {
		int index = 0;
		int count = 0;
		int max = GetNum2DARows("nwn2_icons");
		while (index < max) {
		
			string sLabel = Get2DAString("nwn2_icons", "ICON", index);
			if (FindSubString(sLabel, sPartial) >= 0) {
				if (index >= 1955 && index <= 1961) //golem + corpse stuff
					continue;
				SendMessageToPC(oPC, "found "+sLabel);
				SetLocalInt(oHolder, sPartial+"_"+IntToString(count), index);	
				count++;
			}
			index++;	
			
		}
		SetLocalInt(oHolder, sPartial+"_max", count);
	} 
	
	//We have the list; go!	
	nMax = GetLocalInt(oHolder, sPartial+"_max");
	int nRandom = Random(nMax);
	int nIcon = GetLocalInt(oHolder, sPartial+"_"+IntToString(nRandom));
	//SendMessageToPC(oPC, "Chosen "+IntToString(nRandom)+" out of "+IntToString(nMax)+" = "+IntToString(nIcon));
	return nIcon;
} 

void CreateBookOnTarget(object oPC) {

	SendMessageToPC(oPC, "creating a story. . ");
	struct character char1 = DetailCharacter(2); //usually protagonist
	int nGender = (char1.gender==GENDER_MALE?GENDER_MALE:GENDER_FEMALE); //gender of character 2 (usually love interest) is the opposite of character 1
	struct character char2 = DetailCharacter(nGender);
	struct character char3 = DetailCharacter(char1.gender); //gender of character 3 (usually a villain) is the same as character 1
	struct character char4 = DetailCharacter(2); //character 4 could be anyone; supporting, extra villain, etc.
	struct character char5 = DetailCharacter(2); //character 5 could be anyone; supporting, extra villain, etc.
	
	string sTitle = "";
	string sStory = "";
	
	int nRandom = d2();
	if (nRandom == 1) {
		string sStart = "This book tells the tale of "; //first line of the story
		sTitle = GenerateRomanceTitle(char1, char2);
		sStory = GenerateRomanceStory(sStart, char1, char2, char3, char4, char5);
	} else {
		sTitle = GenerateLegendTitle(char1, char3); //title based on hero and villain
		sStory = GenerateLegend("", char1, char2, char3, char4, char5);
	}
	SendMessageToPC(oPC, sTitle);
	SendMessageToPC(oPC, sStory);
	
	object oBook = CreateItemOnObject("ps_crft_basebook", oPC);
	SetFirstName(oBook, sTitle);
	SetDescription(oBook, sStory);
	SendMessageToPC(oPC, "getting icon");
	int nIcon = GetRandomIcon(oPC, "book");
	SetItemIcon(oBook, nIcon);
}

void CreatePaperJunkOnTarget(object oPC) {

	string sTitle = "";
	string sContent = "";
	int nIcon = 0;

	int nRandom = d100();
	if (nRandom <= 15) {
		SendMessageToPC(oPC, "Generating grocery list");
		sTitle = "Grocery List";
		sContent = GenerateGroceryList();
		nIcon = GetRandomIcon(oPC, "it_qi_smugglerdocs");
	} else if (nRandom <= 30) {
		SendMessageToPC(oPC, "Generating alchemical recipe");
		sTitle = "Alchemical Recipe";
		sContent = GenerateRecipeText();
		nIcon = GetRandomIcon(oPC, "it_qi_smugglerdocs");
	} else if (nRandom <= 45) {
		SendMessageToPC(oPC, "Generating old wanted poster");
		sTitle = "Old Wanted Poster";
		sContent = GenerateWantedPoster();
		nIcon = GetRandomIcon(oPC, "it_blankscroll");
	} else if (nRandom <= 60) {
		SendMessageToPC(oPC, "Generating love letter");
		sTitle = "Love Letter";
		sContent = GenerateLoveLetterText();
		nIcon = GetRandomIcon(oPC, "it_qi_issanidoc");
	} else {
		SendMessageToPC(oPC, "Generating book");
		CreateBookOnTarget(oPC);
		return;
	}
	
	SendMessageToPC(oPC, "creating the object");
	object oPaper = CreateItemOnObject("ps_crft_basemisc", oPC);
	SetFirstName(oPaper, sTitle);
	SetDescription(oPaper, sContent);
	SetItemIcon(oPaper, nIcon);
}

void CreateExperimentalPotionOnTarget(object oPC, int nLevel = 1) {

	int nGood = Random(EXPERIMENTAL_EFFECTS_GOOD)+1; 
	int nBad = Random(EXPERIMENTAL_EFFECTS_BAD)+1; 
	
	// Level word + base name
	string sName = "Potion of ";
	switch (nLevel) {
		case 1: sName = "Weak "+sName; break;
		case 2: break;
		case 3: sName = "Strong "+sName; break;
	}
	
	sName += GetExperimentalEffectName(nGood, nBad);
	
	//Generic description
	string sDescrip = "<i>A vial filled with a strange liquid. What harm could it do?</i>\n\n";
	sDescrip += "Experimental alchemical mixtures are those concoctions which never quite caught on in the wider adventuring community due to either an overly specific or overly dangerous effect.";
	sDescrip += " But if one is willing to brave the ill effect, experimental potions can also have very potent beneficial effects.\n\n";
	sDescrip += "The label indicates that this is a "+sName+" and should last about "+IntToString(nLevel*30)+" minutes.";
	
	int nIcon = GetRandomIcon(oPC, "it_pot");
	object oPot = CreateItemOnObject("ps_crft_basepotion", oPC, 1, "experimentalpotion");
	SetLocalInt(oPot, "Item_Level", nLevel);
	SetLocalInt(oPot, "Item_Effect_Helpful", nGood);
	SetLocalInt(oPot, "Item_Effect_Harmful", nBad);
	
	SetFirstName(oPot, sName);
	SetDescription(oPot, sDescrip);
	SetItemIcon(oPot, nIcon);

}

void CreateExperimentalScrollOnTarget(object oPC, int nLevel = 1) {

	int nGood = Random(EXPERIMENTAL_SPELLEFFECTS_GOOD)+1;
	int nBad = Random(EXPERIMENTAL_SPELLEFFECTS_BAD)+1;
	int nType = d4();
	if (nLevel == 1) nType = 1; //everything is simple at level 1
	
	// Level word + base name
	string sName = "Scroll of ";
	switch (nLevel) {
		case 1: sName = "Lesser "+sName; break;
		case 2: break;
		case 3: sName = "Greater "+sName; break;
	}
	
	//Putting the type into the name
	if (nType == 2) sName += "Explosive ";
	else if (nType == 3) sName += "Linked ";
	else if (nType == 4) sName += "Sinister Linked ";
	
	sName += GetExperimentalEffectName(nGood, nBad);
	
	//Generic description
	string sDescrip = "<i>"+RandomString_GenerateMagicalPhrase()+"</i>\n\n";
	sDescrip += "This scroll contains an unusual spell. Upon analysis, it is clear why this spell is not more widely known - there are some downsides to its use. ";
	switch (nType) {
		case 1: sDescrip += "The spell is single-target, and inflicts both beneficial and harmful effects on the target."; break;
		case 2: sDescrip += "The spell is area of effect, and inflicts both beneficial and harmful effects on the targets."; break;
		case 3: sDescrip += "The spell links the target to the caster, bestowing a blessing on the target, and a curse on the caster. The caster also shares in any damage the target takes for the duration of the spell."; break;
		case 4: sDescrip += "The spell links the target to the caster, bestowing a blessing on the caster, and a curse on the target. The target also shares in any damage the caster takes for the duration of the spell."; break;
	}
	
	object oScroll = CreateItemOnObject("ps_crft_basescroll", oPC, 1, "experimentalscroll");
	SetLocalInt(oScroll, "Item_Level", nLevel);
	SetLocalInt(oScroll, "Item_Effect_Helpful", nGood);
	SetLocalInt(oScroll, "Item_Effect_Harmful", nBad);
	SetLocalInt(oScroll, "Item_Effect_Type", nType);
	
	SetFirstName(oScroll, sName);
	SetDescription(oScroll, sDescrip);

}

//Gets a random cast spell enchantment for trickets
//Should probably let it be filtered by point value someday
struct enchantment GetRandomSpellEnchantment(object oPC) {

	struct enchantment e;
	int nMax = 0;
	
	string sQuery = "SELECT COUNT(*) FROM recipes WHERE Type='15'";
	SendMessageToPC(oPC, sQuery);
	SQLExecDirect(sQuery);
	while (SQLFetch() != SQL_ERROR) { //Fetch sql id's and store it
		nMax = StringToInt(SQLGetData(1));
	}
	SendMessageToPC(oPC, "Maximum: "+IntToString(nMax));
	
	int nRandom = Random(nMax);
	sQuery = "SELECT Recipe_Id FROM recipes WHERE Type='15' LIMIT 1 OFFSET "+IntToString(nRandom);
	while (SQLFetch() != SQL_ERROR) { //Fetch sql id's and store it
		int n = StringToInt(SQLGetData(1));
		SendMessageToPC(oPC, "Selected: "+IntToString(n));
		e = LoadEnchantment(n);
		return e;
	}
	return e;
	
}

void CreateTrinketOnTarget(object oPC) {

	string sName = "";
	string sDescrip = "";
	string sBase = "ps_crft_basemisc";
	int nIcon = GetRandomIcon(oPC, "it_qi");
	
	//Create Name base from the icon in question
	switch (nIcon) {
		case 174: sName = "Feather"; break;
		case 175: sName = "Jerky"; break;
		case 176: sName = "Fur"; break;
		case 177: sName = "Feather"; break;
		case 178: sName = "Feather"; break;
		case 179: sName = "Goblet"; break;
		case 180: sName = "Stone"; break;
		case 181: sName = "Heart"; break;
		case 182: sName = "Powder"; break;
		case 183: sName = "Book"; break;
		case 184: sName = "Elixer"; break;
		case 185: sName = "Visage"; break;
		case 186: sName = "Elixer"; break;
		case 187: sName = "Wheel"; break;
		case 188: sName = "Scroll"; break;
		case 189: sName = "Badge"; break;
		case 190: sName = "Tome"; break;
		case 191: sName = "Tome"; break;
		case 192: sName = "Scroll"; break;
		case 193: sName = "Coin"; break;
		case 194: sName = "Sphere"; break;
		case 195: sName = "Rock"; break;
		case 196: sName = "Trinket"; break;
		case 197: sName = "Globe"; break;
		case 198: sName = "Moneypouch"; break;
		case 199: sName = "Fist"; break;
		case 1199: sName = "Elixer"; break;
		case 1200: sName = "Pouch"; break;
		case 1201: sName = "Bandolier"; break;
		case 1202: sName = "Bag"; break;
		case 1203: sName = "Box"; break;
		case 1204: sName = "Book"; break;
		case 1205: sName = "Bottle"; break;
		case 1206: sName = "Key"; break;
		case 1207: sName = "Veil"; break;
		case 1208: sName = "Barrel"; break;
		case 1209: sName = "Hammer"; break;
		case 1210: sName = "Tome"; break;
		case 1211: sName = "Bone"; break;
		case 1212: sName = "Elixer"; break;
		case 1213: sName = "Scroll"; break;
		case 1214: sName = "Banner"; break;
		case 1215: sName = "Mummified Head"; break;
		case 1216: sName = "Lute"; sBase = "ps_music_lute"; break;
		case 1217: sName = "Lute"; sBase = "ps_music_lute"; break;
		case 1218: sName = "Blade"; break;
		case 1219: sName = "Rod"; break;
		case 1220: sName = "Disc"; break;
		case 1221: sName = "Writings"; break;
		case 1222: sName = "Painting"; break;
		case 1223: sName = "Medallion"; break;
		case 1224: sName = "Book"; break;
		case 1225: sName = "Flask"; break;
		case 1226: sName = "Rod"; break;
		case 1227: sName = "Rune"; break;
		case 1228: sName = "Pendant"; break;
		case 1229: sName = "Painting"; break;
		case 1230: sName = "Shard"; break;
		case 1231: sName = "Shard"; break;
		case 1232: sName = "Shard"; break;
		case 1233: sName = "Shard"; break;
		case 1234: sName = "Shard"; break;
		case 1235: sName = "Shard"; break;
		case 1236: sName = "Shard"; break;
		case 1237: sName = "Shard"; break;
		case 1238: sName = "Shard"; break;
		case 1239: sName = "Shard"; break;
		case 1240: sName = "Shard"; break;
		case 1241: sName = "Shard"; break;
		case 1242: sName = "Skull"; break;
		case 1243: sName = "Mirror"; break;
		case 1244: sName = "Journal"; break;
		case 1245: sName = "Blade"; break;
		case 1246: sName = "Box"; break;
		case 1247: sName = "Tome"; break;
		case 1248: sName = "Stick"; break;
		case 1249: sName = "Holy Symbol"; break;
		case 1250: sName = "Vial"; break;
		case 1268: sName = "Sword"; break;
		case 1269: sName = "Knife"; break;
		case 1270: sName = "Box"; break;
		case 1271: sName = "Token"; break;
		case 1272: sName = "Rolling Pin"; sBase = "ps_misc_seasonalitem9"; break;
		case 1273: sName = "Rod"; break;
		case 1274: sName = "Tabard"; break;
		case 1275: sName = "Pouch"; break;
		case 1276: sName = "Signet"; break;
		case 1277: sName = "Crystal"; break;
		case 1278: sName = "Leaf"; break;
		case 1279: sName = "Disc"; break;
		case 1280: sName = "Scroll"; break;
		case 1628: sName = "Rock"; break;
		case 1952: sName = "Cinder"; break;
		case 1953: sName = "Skull"; break;
		case 1954: sName = "Chalk"; break;
		case 1962: sName = "Powder"; break;
		case 1963: sName = "Rod"; break;
		case 1964: sName = "Mask"; break;
		case 1965: sName = "Mask"; break;
		case 1966: sName = "Mask"; break;
		case 1967: sName = "Trinket"; break;
		case 1968: sName = "Orb"; break;
		case 1969: sName = "Orb"; break;
		case 1970: sName = "Orb"; break;
		case 1971: sName = "Orb"; break;
		case 1972: sName = "Orb"; break;
		case 1973: sName = "Orb"; break;
		case 1974: sName = "Orb"; break;
		case 1975: sName = "Orb"; break;
		case 1976: sName = "Orb"; break;
		case 1977: sName = "Orb"; break;
		case 1978: sName = "Orb"; break;
		case 1979: sName = "Elixer"; break;
		case 1980: sName = "Sword"; break;
		case 1981: sName = "Stone"; break;
		case 1982: sName = "Husk"; break;
		case 2057: sName = "Nugget"; break;
		case 2058: sName = "Tusk"; break;
		case 2081: sName = "Stone"; break;
		case 2086: sName = "Signet"; break;
		case 2087: sName = "Signet"; break;
		case 2088: sName = "Signet"; break;
		case 2089: sName = "Tools"; break;
		case 2090: sName = "Blood"; break;
		case 2091: sName = "Elixer"; break;
		case 2092: sName = "Spike"; break;
		case 2093: sName = "Bird"; break;
		case 2094: sName = "Scrimshaw"; break;
		case 2095: sName = "Distillate"; break;
		case 2096: sName = "Widget"; break;
		case 2097: sName = "Silk"; break;
		case 2098: sName = "Figurine"; break;
		case 2099: sName = "Log"; break;
		case 2100: sName = "Snake"; break;
		case 2101: sName = "Tusk"; break;
		case 2105: sName = "Spike"; break;
		case 2109: sName = "Fragment"; break;
		default: sName = "Trinket"; break;
	}
	
	struct character owner = DetailCharacter(d2());
	int nTotal = 4;
	switch (Random(nTotal)) {
		case 0: sDescrip = "This "+sName+" once belonged to "+owner.firstname+". ";
		case 1: sDescrip = "This "+sName+" was created by "+owner.firstname+" "+owner.lastname+". ";
		case 2: sDescrip = "The known history of this "+sName+" begins when it fell into the hands of "+owner.firstname+". ";
		case 3: sDescrip = "Crafted by the renowned "+owner.firstname+" "+owner.lastname+", this "+sName+" glimmers with magical power. ";
	}
	
	sDescrip += IntroduceCharacter(owner);
	sDescrip += "\n\n";
	
	struct character villain = DetailCharacter(d2());
	nTotal = 3;
	switch (Random(nTotal)) {
		case 0: sDescrip += " This "+sName+" saved "+owner.firstname+" from both "+RandomString_HurdleGenerator()+" and "+RandomString_HurdleGenerator()+".";
		case 1: sDescrip += " "+owner.firstname+" used this "+sName+" to escape "+RandomString_HurdleGenerator()+" on several occasions.";
		case 2: sDescrip += " The "+sName+" was first used in the great battle between "+owner.firstname+" "+owner.nickname+" and "+villain.firstname+" "+villain.nickname+". "+IntroduceCharacter(villain)+" It secured "+owner.firstname+" the victory.";
	}
	
	nTotal = 4;
	switch (Random(nTotal)) {
		case 0: sDescrip += " "+owner.firstname+" eventually misplaced the "+sName+", and it vanished from history. . . until now. ";
		case 1: sDescrip += " The "+sName+" was then stolen by "+villain.firstname+" "+villain.nickname+", and fell into obscurity. ";
		case 2: sDescrip += " After that, the "+sName+" was lost. ";
		case 3: sDescrip += " Where the "+sName+" went from there is unknown. . . until it ended up in your hands. ";
	}
	
	if (sName == "Sword" || sName == "Blade" || sName == "Knife") {
		sDescrip += "\n\nAlthough it looks impressive, this "+sName+" is purely ceremonial. The power lies in the ownership; do not try to use this in combat.";
	}
	
	if (sName == "Elixer" || sName == "Vial" || sName == "Bottle") {
		sDescrip += "\n\nThe liquid inside of this vial never seems to run out, no matter how often it is poured out.";
	}
	
	struct enchantment e = GetRandomSpellEnchantment(oPC);
	int nMainSpell = e.subtype;
	switch (nMainSpell) {
		case 169: sName = "Blessed "+sName; break;
		case 170: sName = sName+" of Curing"; break;
		case 171: sName = "Entangling "+sName; break;
		case 172: sName = "Magic "+sName; break;
		case 173: sName = sName+" of Protection"; break;
		case 174: sName = sName+" of Affliction"; break;
		case 175: sName = sName+" of Curing"; break;
		case 176: sName = sName+" of Darkness"; break;
		case 177: sName = sName+" of Lore"; break;
		case 178: sName = sName+" of Invisibility"; break;
		case 179: sName = sName+" of Knocking"; break;
		case 180: sName = sName+" of Acid"; break;
		case 181: sName = "Ghostly "+sName; break;
		case 182: sName = sName+" of Sight"; break;
		case 210: sName = sName+" of Animation"; break;
		case 211: sName = "Arcing "+sName; break;
		case 212: sName = sName+" of Assessment"; break;
		case 213: sName = sName+" of Vitality"; break;
		case 214: sName = "Dehydrating "+sName; break;
		case 215: sName = "Waking "+sName; break;
		case 216: sName = "Iron "+sName; break;
		case 217: sName = "Accursed "+sName; break;
		case 218: sName = sName+" of Bark"; break;
		case 219: sName = sName+" of Battle"; break;
		case 220: sName = sName+" of Ensurance"; break;
		case 221: sName = sName+" of Cursing"; break;
		case 222: sName = "Bladed "+sName; break;
		case 223: sName = sName+" of Blades"; break;
		case 224: sName = "Flaming "+sName; break;
		case 225: sName = sName+" of Blessing"; break;
		case 226: sName = sName+" of Blindness"; break;
		case 227: sName = sName+" of Blood"; break;
		case 228: sName = sName+" of Horror"; break;
		case 230: sName = "Quaking "+sName; break;
		case 231: sName = sName+" of Strength"; break;
		case 232: sName = "Burning "+sName; break;
		case 233: sName = "Cacophonic "+sName; break;
		case 234: sName = sName+" of Lightning"; break;
		case 235: sName = sName+" of Camouflage"; break;
		case 236: sName = "Graceful "+sName; break;
		case 237: sName = "Fearful "+sName; break;
		case 238: sName = "Shocking "+sName; break;
		case 239: sName = "Charming "+sName; break;
		case 240: sName = sName+" of Death"; break;
		case 241: sName = sName+" of Farsight"; break;
		case 242: sName = sName+" of Bewilderment"; break;
		case 243: sName = "Noxious "+sName; break;
		case 244: sName = "Colorful "+sName; break;
		case 245: sName = "Burning "+sName; break;
		case 246: sName = sName+" of Cold"; break;
		case 247: sName = sName+" of Confusion"; break;
		case 248: sName = sName+" of Disease"; break;
	}
	
	if (d100() < 20) {
		sName = owner.firstname+"'s "+sName;
	}
	
	object oObject = CreateItemOnObject(sBase, oPC);
	SetItemCharges(oObject, d10(2));
	EnchantItem(oObject, e);
	SetFirstName(oObject, sName);
	SetDescription(oObject, sDescrip);
	SetItemIcon(oObject, nIcon);
}

void main() {

	object oPC = GetLastUsedBy();
	SendMessageToPC(oPC, "Generating paper");
	//CreatePaperJunkOnTarget(oPC);
	CreateExperimentalPotionOnTarget(oPC, d3());
	CreateExperimentalScrollOnTarget(oPC, d3());
	CreateTrinketOnTarget(oPC);
}