#include "nwnx_sql"
#include "ps_inc_newcrafting"
#include "ps_inc_newenchanting"
#include "ps_inc_flavortext"
const string RANDOM_DROP_COLOR = "<C=SteelBlue>";

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

	string sSQL = "SELECT COUNT(*) FROM recipes WHERE Points='"+IntToString(value)+"' AND ";
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

	string sSQL = "SELECT Recipe_Id FROM recipes WHERE Points='"+IntToString(value)+"' AND ";
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

object CreateRandomItemOfType(object oPC, string sType = "W", int matTier = 0) {
	
	struct baseitem i = GetRandomBaseItem(oPC, sType);
	struct material m1 = LoadMaterial(0, i.matlist_1);
	struct material m2 = LoadMaterial(0, i.matlist_2);
	struct material m3 = LoadMaterial(0, i.matlist_3);
	
	if (i.matlist_1 == "SCOD_CRAFT_METAL") {
		if (matTier == 1) {
			int nRand = Random(2);
			switch (nRand) {
				case 0: m1 = LoadMaterial(23, i.matlist_1); //Cold Iron
				case 1: m1 = LoadMaterial(24, i.matlist_1); //Silver
			}
		} else if (matTier == 2) {
			int nRand = Random(6);
			switch (nRand) {
				case 0: m1 = LoadMaterial(1, i.matlist_1); //Abyssal Bloodiron
				case 1: m1 = LoadMaterial(2, i.matlist_1); //Alchemic Platinum
				case 2: m1 = LoadMaterial(7, i.matlist_1); //Glassteel
				case 3: m1 = LoadMaterial(10, i.matlist_1); //Mindsilver
				case 4: m1 = LoadMaterial(12, i.matlist_1); //Oerthblood
				case 5: m1 = LoadMaterial(14, i.matlist_1); //Riverine
			}
		} else if (matTier == 3) {
			int nRand = Random(4);
			switch (nRand) {
				case 0: m1 = LoadMaterial(5, i.matlist_1); //Bloodglass
				case 1: m1 = LoadMaterial(6, i.matlist_1); //Byeshk
				case 2: m1 = LoadMaterial(7, i.matlist_1); //Tantulhor
				case 3: m1 = LoadMaterial(8, i.matlist_1); //Metalline
			}
		} else if (matTier == 4) {
			int nRand = Random(4);
			switch (nRand) {
				case 0: m1 = LoadMaterial(4, i.matlist_1); //Axiomatic Brass
				case 1: m1 = LoadMaterial(11, i.matlist_1); //Morguth-Iron
				case 2: m1 = LoadMaterial(13, i.matlist_1); //Pandemonic Silver
				case 3: m1 = LoadMaterial(15, i.matlist_1); //Solanian Truesteel
			}
		} else if (matTier > 4) {
			int nRand = Random(2);
			switch (nRand) {
				case 0: m1 = LoadMaterial(9, i.matlist_1); //Meteoric Iron
				case 1: m1 = LoadMaterial(3, i.matlist_1); //Aurorum
			}
		} else if (d100() < 10) {
			int nRand = Random(6);
			switch (nRand) {
				case 0: m1 = LoadMaterial(17, i.matlist_1); //Copper
				case 1: m1 = LoadMaterial(18, i.matlist_1); //Electrum
				case 2: m1 = LoadMaterial(19, i.matlist_1); //Gold
				case 3: m1 = LoadMaterial(20, i.matlist_1); //Platinum
				case 4: m1 = LoadMaterial(21, i.matlist_1); //Silver
				case 5: m1 = LoadMaterial(22, i.matlist_1); //White Gold
			}
		}
	} else if (i.matlist_1 == "SCOD_CRAFT_LEATHER") {
		if (matTier > 2) {
			int nRand = Random(9);
			switch (nRand) {
				case 0: m1 = LoadMaterial(1, i.matlist_1); //Dragon Hide Black
				case 1: m1 = LoadMaterial(2, i.matlist_1); //Dragon Hide Blue
				case 2: m1 = LoadMaterial(3, i.matlist_1); //Dragon Hide Red
				case 3: m1 = LoadMaterial(4, i.matlist_1); //Dragon Hide White
				case 4: m1 = LoadMaterial(5, i.matlist_1); //Dragon Hide Green
				case 5: m1 = LoadMaterial(6, i.matlist_1); //Celestial Plumes
				case 6: m1 = LoadMaterial(7, i.matlist_1); //Demonscale
				case 7: m1 = LoadMaterial(8, i.matlist_1); //Devilscale
				case 8: m1 = LoadMaterial(9, i.matlist_1); //Ophidian Hide
			}
		} else if (matTier > 1) {
			int nRand = Random(8);
			switch (nRand) {
				case 0: m1 = LoadMaterial(1, i.matlist_1); //Dragon Hide Black
				case 1: m1 = LoadMaterial(2, i.matlist_1); //Dragon Hide Blue
				case 2: m1 = LoadMaterial(3, i.matlist_1); //Dragon Hide Red
				case 3: m1 = LoadMaterial(4, i.matlist_1); //Dragon Hide White
				case 4: m1 = LoadMaterial(5, i.matlist_1); //Dragon Hide Green
				case 5: m1 = LoadMaterial(6, i.matlist_1); //Celestial Plumes
				case 6: m1 = LoadMaterial(7, i.matlist_1); //Demonscale
				case 7: m1 = LoadMaterial(8, i.matlist_1); //Devilscale
			}
		}
	} else if (i.matlist_1 == "SCOD_CRAFT_WOOD") {
		if (matTier > 2) {
			int nRand = Random(4);
			switch (nRand) {
				case 0: m1 = LoadMaterial(1, i.matlist_1); //Arboreal Oak
				case 1: m1 = LoadMaterial(2, i.matlist_1); //Dragon Bone
				case 2: m1 = LoadMaterial(3, i.matlist_1); //Formic Amber
				case 3: m1 = LoadMaterial(4, i.matlist_1); //Twelvetrees Bark
			}
		} else if (matTier > 1) {
			int nRand = Random(2);
			switch (nRand) {
				case 0: m1 = LoadMaterial(2, i.matlist_1); //Dragon Bone
				case 1: m1 = LoadMaterial(3, i.matlist_1); //Formic Amber
			}
		}
	}
	
	object obj = CreateCraftedItem(oPC, i, m1, m2, m3);
	SetFirstName(obj, GetCraftingItemName(i, m1, m2, m3));
	SetLocalString(obj, "material_name", m1.label);
	SetLocalString(obj, "base_name", i.label);
	return obj;
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

void main () {

	object oPC = GetLastUsedBy();
	int nLevel = Random(30)+1;
	int nPoints = GetPointValueForCR(nLevel);
	int nMatLevel = nPoints-2;
	if (nMatLevel <= 0)
		nMatLevel = 0;
	else
		nMatLevel = Random(nMatLevel)+1;
	
	SendMessageToPC(oPC, "generationg a level "+IntToString(nLevel)+" item of "+IntToString(nPoints)+" points");
	
	object oItem;
	int nRand = Random(5);
	switch (nRand) {
		case 0: oItem = CreateRandomItemOfType(oPC, "W", nMatLevel); break;
		case 1: oItem = CreateRandomItemOfType(oPC, "W", 0); break;
		case 2: oItem = CreateRandomItemOfType(oPC, "A", nMatLevel); break;
		case 3: oItem = CreateRandomItemOfType(oPC, "A", 0); break;
		case 4: oItem = CreateRandomItemOfType(oPC, "M", 0); break;
	}
	GiveItemRandomEnchantments(oItem, nPoints);
	GenerateRandomNameAndDescriptionForItem(oItem);
	SetFirstName(oItem, GetName(oItem)+" (Level "+IntToString(nLevel)+")");
}