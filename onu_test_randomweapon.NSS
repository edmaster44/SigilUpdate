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
		SpeakString("found :"+sType, TALKVOLUME_SHOUT);
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
	SendMessageToPC(oPC, "Number of "+sType+": "+IntToString(max));
	int nChosen = Random(max);
	SendMessageToPC(oPC, "Chose: "+IntToString(nChosen)+", checking "+"Item_"+sType+"_"+IntToString(nChosen));
	int nIndex = GetLocalInt(oHolder, "Item_"+sType+"_"+IntToString(nChosen));
	SendMessageToPC(oPC, "found index: "+IntToString(nIndex));
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
	SpeakString(sSQL, TALKVOLUME_SHOUT);
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
	SpeakString("enchantments of value "+IntToString(value)+": "+IntToString(nMax)+", chosen "+IntToString(nRand), TALKVOLUME_SHOUT);

	string sSQL = "SELECT Recipe_Id FROM recipes WHERE Points='"+IntToString(value)+"' AND ";
	sSQL += GetEnchantmentItemRestriction(oObj, FALSE)+" LIMIT "+IntToString(nRand)+", 1";
	SpeakString(sSQL, TALKVOLUME_SHOUT);
	
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
		SpeakString("adding enchantment "+IntToString(e.id), TALKVOLUME_SHOUT);
		EnchantItem(oItem, e);
		SetLocalInt(oItem, "enchantment_"+IntToString(nCount), e.id);
		nCount++;
		nRemaining -= nValue;
	}
	SetLocalInt(oItem, "enchantment_num", nCount);
}

object CreateRandomItemOfType(object oPC, string sType = "W") {
	struct baseitem i = GetRandomBaseItem(oPC, sType);
	struct material m1 = GetRandomMaterial(i.matlist_1);
	struct material m2 = GetRandomMaterial(i.matlist_2);
	struct material m3 = GetRandomMaterial(i.matlist_3);
	SendMessageToPC(oPC, "creating "+m1.label+", "+m2.label+", "+m3.label+", resref="+i.resref);
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
			sName += GetItemNamePart(nId, "suffix");
		}
	}
	
	sName = RANDOM_DROP_COLOR+sName+"</C>";
	SpeakString("name: "+sName, TALKVOLUME_SHOUT);
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
	
	SendMessageToPC(oPC, "generationg a "+IntToString(nLevel)+" weapon of "+IntToString(nPoints)+" points");
	
	object oItem;
	int nRand = Random(3);
	switch (nRand) {
		case 0: oItem = CreateRandomItemOfType(oPC, "W"); break;
		case 1: oItem = CreateRandomItemOfType(oPC, "A"); break;
		case 2: oItem = CreateRandomItemOfType(oPC, "M"); break;
	}
	GiveItemRandomEnchantments(oItem, nPoints);
	GenerateRandomNameAndDescriptionForItem(oItem);

}