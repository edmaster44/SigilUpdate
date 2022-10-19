#include "ps_inc_flavortext"
#include "ps_inc_experimentaleffects"
#include "ps_inc_newcrafting"
#include "ps_inc_newenchanting"

const int SPECIAL_BOOK_CHANCE = 10;
const string MANUAL_COLOR = "<C=DarkSlateBlue>";
const string QUEST_ITEM_COLOR = "<C=DarkGoldenRod>";
const string RANDOM_DROP_COLOR = "<C=SteelBlue>";
string sHolder = "ps_utility_itemvariableholder";

//***************************************************
//Utility
//***************************************************
//Grabs the CR of the creature, or the saved int CR on the placeable
int GetChallengeRatingOfTarget(object oTarget) {
	if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE) {
		if (GetLocalInt(oTarget, "QUEST_CR") > 0)
			return GetLocalInt(oTarget, "QUEST_CR");
		else
			return FloatToInt(GetChallengeRating(oTarget));
	} else {
		if (GetLocalInt(oTarget, "CR") > 0)
			return GetLocalInt(oTarget, "CR");
		else 
			return Random(10)+1;
	}
}
//Adds in debug messages for treasure generation
object CreateTreasureItemOnTarget(string sBase, object oTarget, int nStackSize=1, string sNewTag="", int bDisplayFeedback=TRUE) {
	object oObj = CreateItemOnObject(sBase, oTarget, nStackSize, sNewTag, bDisplayFeedback);
	WriteTimestampedLogEntry ("Created " + IntToString(nStackSize) + " of " + sBase + " on " + GetName(oTarget));
	return oObj;   
}

//Gets a random icon for your random item!
int GetRandomIcon(string sPartial, object oTarget = OBJECT_INVALID) {
	
	object oHolder = GetObjectByTag(sHolder);
	
	//If this list hasn't been saved yet; save it for later!
	int nMax = GetLocalInt(oHolder, sPartial+"_max");
	if (nMax <= 0) {
		int index = 0;
		int count = 0;
		int max = GetNum2DARows("nwn2_icons");
		while (index < max) {
		
			string sLabel = Get2DAString("nwn2_icons", "ICON", index);
			if (FindSubString(sLabel, sPartial) >= 0) {
				if (index >= 1955 && index <= 1961) {//golem + corpse stuff	
					count++;
				} else {
					SetLocalInt(oHolder, sPartial+"_"+IntToString(count), index);	
					count++;
				}
			}
			index++;	
			
		}
		SetLocalInt(oHolder, sPartial+"_max", count);
	} 
	
	//We have the list; go!	
	nMax = GetLocalInt(oHolder, sPartial+"_max");
	int nRandom = Random(nMax);
	int nIcon = GetLocalInt(oHolder, sPartial+"_"+IntToString(nRandom));
	return nIcon;
} 

//***************************************************
//Paper Randomness
//***************************************************
//Creates an enchantment manual on target
//Melee, Ranged, Ammo, Thrown, Armor, Glove
//Bracer, Helm, Amulet, Ring, Boots, Container, Instrument,
//Misc, Belt, Cloak
void CreateEnchantmentManualOnTarget(object oTarget) {

	string sColumn = "Melee";
	string sName = "Treatise on Weapons";
	string sKind = "melee weapons";

	int nRandom = Random(16)+1;
	switch (nRandom) {
		case 1: sColumn = "Melee"; sKind = "melee weapons"; sName = "Treatise on Weapons"; break;
		case 2: sColumn = "Ranged"; sKind = "ranged weapons"; sName = "Manual of Ranged Weapon Enchantments"; break;
		case 3: sColumn = "Ammo"; sKind = "ammunition"; sName = "Crafting Ammunition - A Brief Guide"; break;
		case 4: sColumn = "Thrown"; sKind = "throwing weapons"; sName = "Throwing Weapons & You"; break;
		case 5: sColumn = "Armor"; sKind = "armor"; sName = "Enchanting Armor - The Definitive Work"; break;
		case 6: sColumn = "Glove"; sKind = "gloves"; sName = "Manual of Enchantments - Gloves"; break;
		case 7: sColumn = "Bracer"; sKind = "bracers"; sName = "Enchanting Bracers"; break;
		case 8: sColumn = "Helm"; sKind = "headgear"; sName = "Helmets, Hoods, and Tiaras"; break;
		case 9: sColumn = "Amulet"; sKind = "amulets"; sName = "Amulets - Blessings and Enchantments"; break;
		case 10: sColumn = "Ring"; sKind = "rings"; sName = "The Magical Properties of Rings"; break;
		case 11: sColumn = "Boots"; sKind = "boots"; sName = "Treatise on Footwear"; break;
		case 12: sColumn = "Container"; sKind = "containers"; sName = "Bags of Holding, and their Lesser Incarnations"; break;
		case 13: sColumn = "Instrument"; sKind = "instruments"; sName = "Instruments - the Weapons of Bards"; break;
		case 14: sColumn = "Misc"; sKind = "usable items"; sName = "Miscellaneous Enchantments"; break;
		case 15: sColumn = "Belt"; sKind = "belts"; sName = "Enchanting Belts"; break;
		case 16: sColumn = "Cloak"; sKind = "cloaks"; sName = "Cloaks: Keeping You Warm & More!"; break;
	}
	
	sName = MANUAL_COLOR+sName+"</C>";
	
	object oBook = CreateTreasureItemOnTarget("ps_crft_basebook", oTarget);
	string sDescrip = "<i>This appears to be a manual on enchanting magical "+sKind+".</i>\n\n"+GenerateEnchantmentManualFor(oBook, sColumn);
	
	//Icon
	int nIcon = GetRandomIcon("book");
	SetItemIcon(oBook, nIcon);
	
	//Name & Description
	SetFirstName(oBook, sName);
	SetDescription(oBook, sDescrip);
}

//Creates a random junk book
void CreateRandomBookOnTarget(object oTarget) {

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
	
	object oBook = CreateTreasureItemOnTarget("ps_crft_basebook", oTarget);
	if (d100() < SPECIAL_BOOK_CHANCE) {
		sTitle = QUEST_ITEM_COLOR+sTitle+"</C>";
		sStory = QUEST_ITEM_COLOR+"For what it is, this book really isn't too bad. You could even say it was well written. Perhaps someone has a use for it.</C>\n\n"+sStory;
		SetTag(oBook, "ps_book_special");
	}
	
	SetFirstName(oBook, sTitle);
	SetDescription(oBook, sStory);
	int nIcon = GetRandomIcon("book");
	SetItemIcon(oBook, nIcon);
}

//creates a wonky scroll on the target
void CreateExperimentalScrollOnTarget(object oTarget, int nLevel = 1) {

	int nGood = Random(EXPERIMENTAL_SPELLEFFECTS_GOOD)+1;
	int nBad = Random(EXPERIMENTAL_SPELLEFFECTS_BAD)+1;
	int nType = d4();
	if (nLevel == 1) nType = 1; //everything is simple at level 1
	if (nLevel > 3) nLevel = 3;
	
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
	
	object oScroll = CreateTreasureItemOnTarget("ps_crft_basemisc", oTarget, 1, "experimentalscroll");
	SetLocalInt(oScroll, "Item_Level", nLevel);
	SetLocalInt(oScroll, "Item_Effect_Helpful", nGood);
	SetLocalInt(oScroll, "Item_Effect_Harmful", nBad);
	SetLocalInt(oScroll, "Item_Effect_Type", nType);
	
	SetFirstName(oScroll, sName);
	SetDescription(oScroll, sDescrip);
	int nIcon = GetRandomIcon("scroll");
	SetItemIcon(oScroll, nIcon);
	
	itemproperty ip = ItemPropertyCastSpell(IP_CONST_CASTSPELL_UNIQUE_POWER, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE);
	AddItemProperty(DURATION_TYPE_PERMANENT, ip, oScroll);
}

//***************************************************
//Potion Randomness
//***************************************************
//Creates a wonky potion on the target
void CreateExperimentalPotionOnTarget(object oTarget, int nLevel = 1) {

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
	
	int nIcon = GetRandomIcon("it_pot");
	object oPot = CreateTreasureItemOnTarget("ps_crft_basemisc", oTarget, 1, "experimentalpotion");
	SetLocalInt(oPot, "Item_Level", nLevel);
	SetLocalInt(oPot, "Item_Effect_Helpful", nGood);
	SetLocalInt(oPot, "Item_Effect_Harmful", nBad);
	
	SetFirstName(oPot, sName);
	SetDescription(oPot, sDescrip);
	SetItemIcon(oPot, nIcon);

	itemproperty ip = ItemPropertyCastSpell(IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY, IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE);
	AddItemProperty(DURATION_TYPE_PERMANENT, ip, oPot);
}

//***************************************************
//Wearable Items Randomness
//***************************************************
void SaveInformationAboutItems() {
	object oHolder = OBJECT_SELF;
	
	if (GetLocalInt(oHolder, "Items_Initialized") > 0)
		return;
	SetLocalInt(oHolder, "Items_Initialized", 1);
	
	int nNumA = 0;
	int nNumW = 0;
	int nNumM = 0;
	
	int nIndex = 0;
	int nMax = GetNum2DARows("scod_craft_baseitems");
	
	while (nIndex < nMax) {
		string sType = GetItemType(nIndex);
		if (sType == "W") {
			SetLocalInt(oHolder, "Item_"+sType+"_"+IntToString(nNumW), nIndex);
			nNumW++;
		} else if (sType == "A") {
			SetLocalInt(oHolder, "Item_"+sType+"_"+IntToString(nNumA), nIndex);
			nNumA++;
		} else {
			SetLocalInt(oHolder, "Item_"+sType+"_"+IntToString(nNumM), nIndex);
			nNumM++;
		}
		nIndex++;
	}
	
	SetLocalInt(oHolder, "Item_A_Max", nNumA);
	SetLocalInt(oHolder, "Item_W_Max", nNumW);
	SetLocalInt(oHolder, "Item_M_Max", nNumM);
}

int GetNumberOfBaseItemTypes(string sType = "W") {
	object oHolder = OBJECT_SELF;
	return GetLocalInt(oHolder, "Item_"+sType+"_Max");
}

struct baseitem GetRandomBaseItem(object oPC, string sType = "W") {

	object oHolder = OBJECT_SELF;
	SaveInformationAboutItems();

	int max = GetNumberOfBaseItemTypes(sType);
	int nChosen = Random(max);
	int nIndex = GetLocalInt(oHolder, "Item_"+sType+"_"+IntToString(nChosen));
	return LoadBaseItem(nIndex);
}

struct material GetRandomMaterial(string s2da) {
	int nMax = GetNum2DARows(s2da);
	int nChosen = Random(nMax);
	return LoadMaterial(nChosen, s2da);
}

int GetNumberofEnchantmentsAvailable(object oObj, int value) {
	object oHolder = OBJECT_SELF;
	int nMax = GetLocalInt(oHolder, "MaxEnchants_"+IntToString(GetBaseItemType(oObj))+"_"+IntToString(value));
	if (nMax > 0)
		return nMax;

	string sSQL = "SELECT COUNT(*) FROM recipes WHERE Points='"+IntToString(value)+"' AND Can_Generate=1 AND ";
	sSQL += GetEnchantmentItemRestriction(oObj, FALSE);
	SQLExecDirect(sSQL);
	if (SQLFetch() != SQL_ERROR) { 
		nMax = StringToInt(SQLGetData(1));
	} else {
		nMax = 0;
	}
	SetLocalInt(oHolder, "MaxEnchants_"+IntToString(GetBaseItemType(oObj))+"_"+IntToString(value), nMax);
	return nMax;
	
}

//Gets a random enchantment which can go on oObj of a given point value
struct enchantment GetRandomEnchantmentOfValue(object oObj, int value) {

	int nMax = GetNumberofEnchantmentsAvailable(oObj, value);
	int nRand = Random(nMax);

	string sSQL = "SELECT Recipe_Id FROM recipes WHERE Points='"+IntToString(value)+"' AND Can_Generate=1 AND ";
	sSQL += GetEnchantmentItemRestriction(oObj, FALSE)+" LIMIT "+IntToString(nRand)+", 1";
	SQLExecDirect(sSQL);
	
	int recipe_id = 0;
	if (SQLFetch() != SQL_ERROR) { 
		recipe_id = StringToInt(SQLGetData(1));
	}
	return LoadEnchantment(recipe_id);
}

int GetPointValueForCR(int nCR) {
	int result = (nCR/4)+1;
	if (nCR >= 30)
		return 10;
	else if (nCR >= 28)
		return 9;
	else 
		return result;
}

void GiveItemRandomEnchantments(object oItem, int nPoints) {

	int nRemaining = nPoints;
	int nCount = 0;
	while (nRemaining > 0) {
		int nValue = Random(nRemaining)+1;
		if (nValue > 5)
			nValue = 5;
		struct enchantment e = GetRandomEnchantmentOfValue(oItem, nValue);
		EnchantItem(oItem, e);
		SetLocalInt(oItem, "enchantment_"+IntToString(nCount), e.id);
		nCount++;
		nRemaining -= nValue;
	}
	SetLocalInt(oItem, "enchantment_num", nCount);
}

//Get Material for random item of tier = matTier
struct material GetRandomMaterialOfTier(string sList, int matTier) {
	struct material m1 = LoadMaterial(0, sList);
	if (sList == "SCOD_CRAFT_METAL") {
		if (matTier == 1) {
			int nRand = Random(2);
			switch (nRand) {
				case 0: m1 = LoadMaterial(23, sList); //Cold Iron
				case 1: m1 = LoadMaterial(24, sList); //Silver
			}
		} else if (matTier == 2) {
			int nRand = Random(6);
			switch (nRand) {
				case 0: m1 = LoadMaterial(1, sList); //Abyssal Bloodiron
				case 1: m1 = LoadMaterial(2, sList); //Alchemic Platinum
				case 2: m1 = LoadMaterial(7, sList); //Glassteel
				case 3: m1 = LoadMaterial(10, sList); //Mindsilver
				case 4: m1 = LoadMaterial(12, sList); //Oerthblood
				case 5: m1 = LoadMaterial(14, sList); //Riverine
			}
		} else if (matTier == 3) {
			int nRand = Random(4);
			switch (nRand) {
				case 0: m1 = LoadMaterial(5, sList); //Bloodglass
				case 1: m1 = LoadMaterial(6, sList); //Byeshk
				case 2: m1 = LoadMaterial(7, sList); //Tantulhor
				case 3: m1 = LoadMaterial(8, sList); //Metalline
			}
		} else if (matTier == 4) {
			int nRand = Random(4);
			switch (nRand) {
				case 0: m1 = LoadMaterial(4, sList); //Axiomatic Brass
				case 1: m1 = LoadMaterial(11, sList); //Morguth-Iron
				case 2: m1 = LoadMaterial(13, sList); //Pandemonic Silver
				case 3: m1 = LoadMaterial(15, sList); //Solanian Truesteel
			}
		} else if (matTier > 4) {
			int nRand = Random(2);
			switch (nRand) {
				case 0: m1 = LoadMaterial(9, sList); //Meteoric Iron
				case 1: m1 = LoadMaterial(3, sList); //Aurorum
			}
		} else if (d100() < 10) {
			int nRand = Random(6);
			switch (nRand) {
				case 0: m1 = LoadMaterial(17, sList); //Copper
				case 1: m1 = LoadMaterial(18, sList); //Electrum
				case 2: m1 = LoadMaterial(19, sList); //Gold
				case 3: m1 = LoadMaterial(20, sList); //Platinum
				case 4: m1 = LoadMaterial(21, sList); //Silver
				case 5: m1 = LoadMaterial(22, sList); //White Gold
			}
		}
	} else if (sList == "SCOD_CRAFT_LEATHER") {
		if (matTier > 2) {
			int nRand = Random(9);
			switch (nRand) {
				case 0: m1 = LoadMaterial(1, sList); //Dragon Hide Black
				case 1: m1 = LoadMaterial(2, sList); //Dragon Hide Blue
				case 2: m1 = LoadMaterial(3, sList); //Dragon Hide Red
				case 3: m1 = LoadMaterial(4, sList); //Dragon Hide White
				case 4: m1 = LoadMaterial(5, sList); //Dragon Hide Green
				case 5: m1 = LoadMaterial(6, sList); //Celestial Plumes
				case 6: m1 = LoadMaterial(7, sList); //Demonscale
				case 7: m1 = LoadMaterial(8, sList); //Devilscale
				case 8: m1 = LoadMaterial(9, sList); //Ophidian Hide
			}
		} else if (matTier > 1) {
			int nRand = Random(8);
			switch (nRand) {
				case 0: m1 = LoadMaterial(1, sList); //Dragon Hide Black
				case 1: m1 = LoadMaterial(2, sList); //Dragon Hide Blue
				case 2: m1 = LoadMaterial(3, sList); //Dragon Hide Red
				case 3: m1 = LoadMaterial(4, sList); //Dragon Hide White
				case 4: m1 = LoadMaterial(5, sList); //Dragon Hide Green
				case 5: m1 = LoadMaterial(6, sList); //Celestial Plumes
				case 6: m1 = LoadMaterial(7, sList); //Demonscale
				case 7: m1 = LoadMaterial(8, sList); //Devilscale
			}
		}
	} else if (sList == "SCOD_CRAFT_WOOD") {
		if (matTier > 2) {
			int nRand = Random(4);
			switch (nRand) {
				case 0: m1 = LoadMaterial(1, sList); //Arboreal Oak
				case 1: m1 = LoadMaterial(2, sList); //Dragon Bone
				case 2: m1 = LoadMaterial(3, sList); //Formic Amber
				case 3: m1 = LoadMaterial(4, sList); //Twelvetrees Bark
			}
		} else if (matTier > 1) {
			int nRand = Random(2);
			switch (nRand) {
				case 0: m1 = LoadMaterial(2, sList); //Dragon Bone
				case 1: m1 = LoadMaterial(3, sList); //Formic Amber
			}
		}
	}
	return m1;
}

//Runs through scod_craft_baseitems and returns the crafting index
//of the supplied BASE_ITEM_* constant (because the 2da already saves this!)
//Caches result on the module for later (speed concern)
int GetCraftingItemIndexByBaseItemType(int standardIndex) {

	object oHolder = GetObjectByTag(sHolder);
	if (GetLocalInt(oHolder, "BASE_ITEM_CACHE") > 0) {
		return GetLocalInt(oHolder, "ITEM_INDEX_"+IntToString(standardIndex));
	}

	//No info already available - time to load 2da!
	int nIndex = 0;
	int nMax = GetNum2DARows("scod_craft_baseitems");
	while (nIndex < nMax) {
	
		int baseID = GetBaseID(nIndex);
		SetLocalInt(oHolder, "ITEM_INDEX_"+IntToString(standardIndex), baseID);
		nIndex++;
	}
	
	SetLocalInt(oHolder, "BASE_ITEM_CACHE", 1);
	return GetLocalInt(oHolder, "ITEM_INDEX_"+IntToString(standardIndex));

}

object CreateRandomItemFromBaseType(object oPC, struct baseitem i, int matTier = 0) {
	
	struct material m1 = GetRandomMaterialOfTier(i.matlist_1, matTier);
	struct material m2 = LoadMaterial(0, i.matlist_2);
	struct material m3 = LoadMaterial(0, i.matlist_3);
	
	object obj = CreateCraftedItem(oPC, i, m1, m2, m3);
	SetFirstName(obj, GetCraftingItemName(i, m1, m2, m3));
	SetLocalString(obj, "material_name", m1.label);
	SetLocalString(obj, "base_name", i.label);
	return obj;
}

object CreateRandomItemOfCategory(object oPC, string sType, int matTier = 0) {

	struct baseitem i = GetRandomBaseItem(oPC, sType);
	return CreateRandomItemFromBaseType(oPC, i, matTier);
}

object CreateRandomItemOfType(object oPC, int nIndex, int matTier = 0) {

	struct baseitem i = LoadBaseItem(nIndex);
	return CreateRandomItemFromBaseType(oPC, i, matTier);
}

//Gets the appropriate enchantment name part
string GetItemNamePart(int enchantment_id, string sPart) {
	string sResult = "";
	SQLExecDirect("SELECT "+sPart+" FROM recipes_names WHERE enchantment_id='"+IntToString(enchantment_id)+"'");
	if (SQLFetch() != SQL_ERROR) { 
		sResult = SQLGetData(1);
	} else {
		sResult = "";
	}
	return sResult;
}

string GenerateGobbledegook() {
	int nRand = Random(26);
	switch (nRand) {
		case 0: return "aa";
		case 1: return "ba";
		case 2: return "cir";
		case 3: return "de";
		case 4: return "ey";
		case 5: return "fae";
		case 6: return "go";
		case 7: return "hee";
		case 8: return "ii";
		case 9: return "ju";
		case 10: return "ko";
		case 11: return "la";
		case 12: return "mn";
		case 13: return "na";
		case 14: return "o";
		case 15: return "pe";
		case 16: return "qu";
		case 17: return "rs";
		case 18: return "see";
		case 19: return "ti";
		case 20: return "uu";
		case 21: return "ve";
		case 22: return "w";
		case 23: return "xi";
		case 24: return "ya";
		case 25: return "ze";
	}
	return "";
}

//Creates a new random name for item
void GenerateRandomNameAndDescriptionForItem(object oItem) {

	string sName = "";
	struct character owner = DetailCharacter(2);
	struct character antagonist = DetailCharacter(2);
	string sBaseItem = GetLocalString(oItem, "base_name");
	
	int nRandom = d100();
	if (nRandom < 25) {
		int n;
		for (n = 0; n < GetLocalInt(oItem, "enchantment_num"); n++) {
			int nId = GetLocalInt(oItem, "enchantment_"+IntToString(n));
			if (n > 0) {
				int d = d100();
				if (d < 5)
					sName += "'";
				else if (d < 10)
					sName += "-";
				else if (d < 10)
					sName += " ";
			}
			sName += GetItemNamePart(nId, "arcane");
		}
		if (GetStringLength(sName) < 4)
			sName += GenerateGobbledegook();
		sName = CapitalizeFirstLetter(sName);
	} else if (nRandom < 40) {
		int nRand = Random(5);
		switch(nRand) {
			case 0: sName = owner.firstname+"'s "+sBaseItem; break;
			case 1: sName = owner.lastname+"'s "+sBaseItem; break;
			case 2: sName = owner.firstname+" "+owner.lastname+"'s "+sBaseItem; break;
			case 3: sName = antagonist.firstname+"'s Bane"; break;
			case 4: sName = sBaseItem+" of "+owner.nickname; break;
		}
	} else {
		if (GetLocalInt(oItem, "enchantment_0") > 0) {
			int nId = GetLocalInt(oItem, "enchantment_0");
			sName += GetItemNamePart(nId, "prefix");
		} else {
			sName += GetLocalString(oItem, "material_name");
		}
		sName += " "+sBaseItem;
		if (GetLocalInt(oItem, "enchantment_1") > 0) {
			int nId = GetLocalInt(oItem, "enchantment_1");
			sName += " "+GetItemNamePart(nId, "suffix");
		}
	}
	
	sName = RANDOM_DROP_COLOR+sName+"</C>";
	SetFirstName(oItem, sName);
	
	string sDescription = "";
	int nRand = Random(8);
	switch (nRand) {
		case 0: sDescription += "This "+sBaseItem+" was forged by "+IntroduceCharacter(owner); break;
		case 1: sDescription += "The known history of this "+sBaseItem+" begins when it fell into the hands of "+IntroduceCharacter(owner); break;
		case 2: sDescription += "This "+sBaseItem+" was created for "+IntroduceCharacter(owner); break;
		case 3: sDescription += "A "+GetLocalString(oItem, "material_name")+" "+sBaseItem+", this item was first wielded by "+IntroduceCharacter(owner); break;
		case 4: sDescription += "Used in the wars against "+antagonist.firstname+" "+antagonist.lastname+", this "+sBaseItem+" the property of "+IntroduceCharacter(owner); break;
		case 5: sDescription += "Forged of "+GetLocalString(oItem, "material_name")+", this "+sBaseItem+" was the property of "+IntroduceCharacter(owner); break;
		case 6: sDescription += "Created in "+RandomString_GeneratePlanarLocation()+" to defeat "+antagonist.firstname+" "+antagonist.nickname+", this "+sBaseItem+" was used by "+IntroduceCharacter(owner); break;
		case 7: sDescription += sName+" was forged by the great smith "+IntroduceCharacter(owner); break;
	}
	
	if (d2() == 1) {
		nRand = Random(5);
		switch (nRand) {
			case 0: sDescription += "\n\n"+owner.firstname+" used the "+sName+" to defeat the hordes of "+IntroduceCharacter(antagonist); break;
			case 1: sDescription += "\n\n"+owner.firstname+" is best known for thwarting the evil plans of "+IntroduceCharacter(antagonist); break;
			case 2: sDescription += "\n\n"+sName+" was used to subjugate a kingdom in "+RandomString_GeneratePrimeLocation()+" by "+antagonist.firstname+" "+antagonist.nickname+", before it was stolen from them by "+owner.firstname; break;
			case 3: sDescription += "\n\n"+owner.firstname+" is best known for carrying out a series of heists against "+antagonist.firstname+" "+antagonist.nickname; break;
			case 4: sDescription += "\n\n"+owner.firstname+" began "+owner.possessivePronoun+" career by slaying a "+RandomString_GenerateRace()+" in the service of "+IntroduceCharacter(antagonist); break;
		}
	}
	
	nRand = Random(4);
	switch (nRand) {
		case 0: sDescription += "\n\nThe "+sBaseItem+" vanished from history after "+owner.firstname+" suffered "+RandomString_HurdleGenerator()+"."; break;
		case 1: sDescription += "\n\n"+owner.firstname+" lost "+sName+" after "+owner.pronoun+" experienced "+RandomString_HurdleGenerator()+"."; break;
		case 2: sDescription += "\n\n"+sName+" left the hands of "+owner.lastname+" when "+owner.pronoun+" died in the year "+IntToString(Random(100) + 20) + " of Hashkar's Reign."; break;
		case 3: sDescription += "\n\n"+owner.firstname+" died at the ripe age of " + IntToString(Random(50) + 50) + " after retiring to "+RandomString_GeneratePrimeLocation()+"."; break;
	}
	
	SetDescription(oItem, sDescription);
	
}

//Creates a random item of a given category, and enchants it 
//enchantment points are based on the CR of the target
//Or the CR local int stored on the target
//Acceptable types are W, A, and M (weapon, armor, and miscellaneous)
void CreateRandomItemOfCategoryOnTarget(object oTarget, string sType) {
	int nLevel = GetChallengeRatingOfTarget(oTarget);
	int nPoints = GetPointValueForCR(nLevel);
	int nMatLevel = 0;
	if (sType != "M") {
		int nMatLevel = nPoints-2;
		if (nMatLevel <= 0)
			nMatLevel = 0;
		else
			nMatLevel = Random(nMatLevel)+1;
		nPoints -= nMatLevel;
	}
	
	object oItem = CreateRandomItemOfCategory(oTarget, sType, nMatLevel);
	GiveItemRandomEnchantments(oItem, nPoints);
	GenerateRandomNameAndDescriptionForItem(oItem);
}

//Creates a random item of a given category, and enchants it 
//enchantment points are based on the CR of the target
//Or the CR local int stored on the target
//nIndex is the index of the item in scod_craft_baseitems
//Note this is not the same as the BASE_ITEM_* constants
void CreateRandomItemOfTypeOnTarget(object oTarget, int nIndex) {
	int nLevel = GetChallengeRatingOfTarget(oTarget);
	int nPoints = GetPointValueForCR(nLevel);
	int nMatLevel = nPoints-2;
	if (nMatLevel <= 0)
		nMatLevel = 0;
	else
		nMatLevel = Random(nMatLevel)+1;
	nPoints -= nMatLevel;
	
	object oItem = CreateRandomItemOfType(oTarget, nIndex, nMatLevel);
	GiveItemRandomEnchantments(oItem, nPoints);
	GenerateRandomNameAndDescriptionForItem(oItem);
}

//***************************************************
//Trinket Randomness
//***************************************************
//Gets number of enchantments available of x point value for miscellaneous items
//for random trinket generation
int GetNumberOfTrinketEnchantmentsAvailable(int nValue) {

	object oHolder = GetModule();
	int nMax = GetLocalInt(oHolder, "MaxEnchants_"+IntToString(BASE_ITEM_MISCSMALL)+"_"+IntToString(nValue));
	if (nMax > 0)
		return nMax;
	
	string sQuery = "SELECT COUNT(*) FROM recipes WHERE Misc='1' AND Points='"+IntToString(nValue)+"' AND Can_Generate=1";
	SQLExecDirect(sQuery);
	while (SQLFetch() != SQL_ERROR) { //Fetch sql id's and store it
		nMax = StringToInt(SQLGetData(1));
	}
	SetLocalInt(oHolder, "MaxEnchants_"+IntToString(BASE_ITEM_MISCSMALL)+"_"+IntToString(nValue), nMax);	
	return nMax;
}

//Gets a random enchantment for trinkets of x points
struct enchantment GetRandomTrinketEnchantment(int nValue) {

	int nMax = GetNumberOfTrinketEnchantmentsAvailable(nValue);
	
	int nRandom = Random(nMax);
	string sQuery = "SELECT Recipe_Id FROM recipes WHERE Type='15' AND Points='"+IntToString(nValue)+"' AND Can_Generate=1 LIMIT "+IntToString(nRandom)+", 1";
	SQLExecDirect(sQuery);
	while (SQLFetch() != SQL_ERROR) { //Fetch sql id's and store it
		int n = StringToInt(SQLGetData(1));
		return LoadEnchantment(n);
	}
	return LoadEnchantment(0);
	
}

void CreateTrinketOnTarget(object oTarget, int nLevel = 1) {

	string sName = "";
	string sDescrip = "";
	string sBase = "ps_crft_basemisc";
	int nIcon = GetRandomIcon("it_qi", oTarget);
	
	int nPoints = 1;
	if (nLevel == 1)
		nPoints = d2();
	else if (nLevel == 2)
		nPoints = d2()+1;
	else if (nLevel == 3)
		nPoints = d3()+1;
	else
		nPoints = d4()+2;
		
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
	object oObject = CreateTreasureItemOnTarget(sBase, oTarget);
	
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
	
	struct enchantment e = GetRandomTrinketEnchantment(nPoints);
	
	int nRand = d100();
	if (nRand < 45) 
		sName = GetItemNamePart(e.id, "prefix")+" "+sName;
	else if (nRand < 90) 
		sName = sName+" "+GetItemNamePart(e.id, "suffix");
	else
		sName = owner.firstname+"'s "+sName;
	
	SetItemCharges(oObject, d10(2));
	EnchantItem(oObject, e);
	SetFirstName(oObject, RANDOM_DROP_COLOR+sName+"</C>");
	SetDescription(oObject, sDescrip);
	SetItemIcon(oObject, nIcon);
}