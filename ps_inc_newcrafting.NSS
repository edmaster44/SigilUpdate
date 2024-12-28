#include "ps_inc_newenchanting"


//Set the crafting details field to let the player
//know what they are getting
void GenerateCraftDetails(object oPC);

//create the item which has been specified by the crafting system
//requires the indicies for the base item type
//and any applicable materials
//defaults to basic wood/leather/metal/misc
object CreateCraftedItem(object oPC, struct baseitem i, struct material m1, struct material m2, struct material m3);

//get the item cost so far
//based on base item type and material cost tiers
int GetCraftedItemCost(object oPC, struct baseitem i, struct material m1, struct material m2, struct material m3); 

//Takes the required special material items for this crafting project
void TakeRequiredCraftingItems(object oPC, struct baseitem i, struct material m1, struct material m2, struct material m3);

//Generates new item name
string GetCraftingItemName(struct baseitem i, struct material m1, struct material m2, struct material m3);

//Generated new item description
string GetCraftingNameDescription(object oPC, struct baseitem i, struct material m1, struct material m2, struct material m3);

//Get the base cost of the item by looking it up in the crafting table
int GetBaseCostOfItem(int nBaseID);

int GetHasRequiredCraftingItems(object oPC, struct baseitem i, struct material m1, struct material m2, struct material m3);


object CreateCraftedItem(object oPC, struct baseitem i, struct material m1, struct material m2, struct material m3) {
	
	string toCreate = i.resref;
	if (i.type == "A" && m1.armorSuffix != "")
		toCreate += m1.armorSuffix;
		
	object oItem = CreateItemOnObject(toCreate, oPC);
	itemproperty ipMat1 = ItemPropertySpecialMaterial(m1.ipForgedOf);
	itemproperty ipMat2 = ItemPropertySpecialMaterial(m2.ipForgedOf);
	itemproperty ipMat3 = ItemPropertySpecialMaterial(m3.ipForgedOf);
	
	// DEBUG
	if (m2.ipForgedOf == 64) SendMessageToPC(oPC, "Lever");
	if (m3.ipForgedOf == 65) SendMessageToPC(oPC, "Sight");
	
	if (GetIsItemPropertyValid(ipMat1)) {
		IPSafeAddItemProperty(oItem, ipMat1);
		//SendMessageToPC(oPC, "material 1 added");
	} if (GetIsItemPropertyValid(ipMat2)) {
		IPSafeAddItemProperty(oItem, ipMat2);
		//SendMessageToPC(oPC, "material 2 added");
	} if (m3.ipForgedOf > 0 && GetIsItemPropertyValid(ipMat3)){
		IPSafeAddItemProperty(oItem, ipMat3);
	}	
	// Apply a special itemproperty "Cage-Forged" that lets us know this is a player-made object.
	// Will result in melee and thrown weapons getting base 10 points like other player-made items
	// and allows some new, special enchantments not available to loot items.
	// Also opens up the possibility of nerfing the points on loot-drop armor without affecting
	// player-made.
	ApplyPlayerMade(oItem);
	
	int bIsMelee = (IPGetIsMeleeWeapon(oItem) || 
		(i.id == BASE_ITEM_GLOVES && CRAFTED_GLOVES_GET_MAT_POWER));
	
	itemproperty matPower;
	int nDrMat = 0;
	int bIsMetalline = (m1.label == "Metalline" && !IPGetIsThrownWeapon(OBJECT_INVALID, i.id) &&
		!IPGetIsProjectile(OBJECT_INVALID, i.id));
	
	// wood and leather melee weapons that have metalline as their 2nd mat will get the metalline 
	// property instead of the mat 1 property. Wood and leather melee weapons will pierce DR as their
	// metal component
	if (bIsMelee && i.matlist_1 != "SCOD_CRAFT_METAL"){
		if (m2.label == "Metalline"){
			matPower = GetSpecialMaterialItemProperty(i, m2);
			bIsMetalline = TRUE;
		} else matPower = GetSpecialMaterialItemProperty(i, m1);
		nDrMat = m2.drMaterial;
	} else {
		matPower = GetSpecialMaterialItemProperty(i, m1);
		nDrMat = m1.drMaterial;
	}
	
	if (GetIsItemPropertyValid(matPower)) IPSafeAddItemProperty(oItem, matPower);
	if (nDrMat > 0) SetItemBaseMaterialType(oItem, nDrMat);
	
	//Handle the metalline special script
	if (bIsMetalline) SetTag(oItem, "nw_metalline");
	
	// all duskwood, mithral, and ironwood items get weight reduction as per canon in addition to 
	// their 2da item property. Currently that's 0 points in scodenchantments anyway. Setting all to 50%
	// for simplicity
	if (m1.label == "Duskwood" || m1.label == "Ironwood" || m1.label == "Mithral"){
		matPower = ItemPropertyWeightReduction(IP_CONST_REDUCEDWEIGHT_50_PERCENT);
		IPSafeAddItemProperty(oItem, matPower);
	}
	// Combining certain materials can give a free vs race property. See
	// ps_inc_newcraft_include.nss for details
	struct synergyBonus dSynergy = GetItemMaterialSynergyBonus(oItem);
	if (GetIsItemPropertyValid(dSynergy.ip)) IPSafeAddItemProperty(oItem, dSynergy.ip);

	// check if this is a crossbow made with special materials that give it additional features
	// instead of additional points.
	if (i.id == BASE_ITEM_HEAVYCROSSBOW || i.id == BASE_ITEM_LIGHTCROSSBOW){ 
		struct xbowMechanicals dXbow = GetXbowMechanicals(oItem);
		if (GetIsItemPropertyValid(dXbow.ipAim)) IPSafeAddItemProperty(oItem, dXbow.ipAim);
		if (GetIsItemPropertyValid(dXbow.ipReload)) IPSafeAddItemProperty(oItem, dXbow.ipReload);
	}
	return oItem;
}

int GetBaseCostOfItem(int nBaseID) {
	
	int n;
	int	nMax = GetNum2DARows("scod_craft_baseitems");
	for (n = 0; n < nMax; n++) {
		string sID =  Get2DAString("scod_craft_baseitems", "ID", n);
		if (StringToInt(sID) == nBaseID) {
			string sCost = Get2DAString("scod_craft_baseitems", "BASE_COST", n);
			return StringToInt(sCost);
		}
	}
	
	return 0;
}

int GetHasRequiredCraftingItems(object oPC, struct baseitem i, struct material m1, struct material m2, struct material m3){

	string sRequired1 = m1.rResref;
	string sRequired2 = m2.rResref;
	string sRequired3 = m3.rResref;
	
	object oItem; 
	
	if (sRequired1 != "" && GetItemPossessedBy(oPC, sRequired1) == OBJECT_INVALID) 
		return FALSE;
	if (sRequired2 != "" && GetItemPossessedBy(oPC, sRequired2) == OBJECT_INVALID) 
		return FALSE;
	if (sRequired3 != "" && GetItemPossessedBy(oPC, sRequired3) == OBJECT_INVALID) 
		return FALSE;
	
	return TRUE;
}

void TakeRequiredCraftingItems(object oPC, struct baseitem i, struct material m1, struct material m2, struct material m3) {

	string sTag;
	object oItem;
	
	sTag = m1.rResref;
	//SendMessageToPC(oPC, "required item: "+sTag);
	if (sTag != "") {
		oItem = GetItemPossessedBy(oPC, sTag);
		if (GetIsObjectValid(oItem))
			TakeNumCraftingMaterials(oPC, GetTag(oItem), 1);
	}
	
	sTag = m2.rResref;
	//SendMessageToPC(oPC, "required item: "+sTag);
	if (sTag != "") {
		oItem = GetItemPossessedBy(oPC, sTag);
		if (GetIsObjectValid(oItem))
			TakeNumCraftingMaterials(oPC, GetTag(oItem), 1);
	}
	
	sTag = m3.rResref;
	//SendMessageToPC(oPC, "required item: "+sTag);
	if (sTag != "") {
		oItem = GetItemPossessedBy(oPC, sTag);
		if (GetIsObjectValid(oItem))
			TakeNumCraftingMaterials(oPC, GetTag(oItem), 1);
	}

}

string GetCraftingItemName(struct baseitem i, struct material m1, struct material m2, struct material m3) {

	string sBase = i.label;
	string sMat1 = m1.label;
	if (sMat1 != "")
		sBase = sMat1+" "+sBase;
		
	return sBase;
}

string GetCraftingNameDescription(object oPC, struct baseitem i, struct material m1, struct material m2, struct material m3) {

	string sBase = i.label;
	string sMat1 = m1.label;
	if (sMat1 != "")
		sBase = "A "+sMat1+" "+sBase;

	if (m2.label != "") {
		if (i.matlist_2 == "SCOD_CRAFT_METAL" && i.type == "A")
			sBase += ", Studded with "+m2.label;
		else if (i.matlist_2 == "SCOD_CRAFT_METAL" && i.type == "W")
			sBase += ", Shod with "+m2.label;
		else if (i.matlist_2 == "SCOD_CRAFT_METAL")
			sBase += ", Plated with "+m2.label;
		else if (i.matlist_2 == "SCOD_CRAFT_WOOD" && i.type == "W")
			sBase += ", with Shaft of "+m2.label;
		else if (i.matlist_2 == "SCOD_CRAFT_LEATHER" && i.type == "A")
			sBase += ", with Shirt of "+m2.label;
		else if (m2.label != "None")
			sBase += ", Inlayed with "+m2.label;
	}
	
	if (m3.label != "" && m3.label != "None")
		sBase += " and "+m3.label;
		
	sBase += ".\n\n";
	sBase += "Crafted by "+GetFirstName(oPC)+" "+GetLastName(oPC);
	
	return sBase;
		
}

int GetCraftedItemCost(object oPC, struct baseitem i, struct material m1, struct material m2, struct material m3) {
	if (DEBUG_IGNORE_CRAFT_COSTS) return 0;
	int nGold = i.cost;
	int nMatCost1 = m1.costTier*1000;
	int nMatCost2 = (m2.costTier*1000)/2;
	int nMatCost3 = (m3.costTier*1000)/3;
	
	//Handles cost of Cold Iron and Alchemical Silver
	//Flat x2 base cost of item
	if (m1.costTier == 0 && m1.rResref != "") {
		nGold = nGold*2;
	} else {
		nGold = nGold+nMatCost1+nMatCost2+nMatCost3;
	}
	
	return nGold;
}

void GenerateCraftDetails(object oPC) {

	int nBase = GetLocalInt(oPC, "Craft_BaseItemType");
	int nMat1 = GetLocalInt(oPC, "Craft_Mat1");
	int nMat2 = GetLocalInt(oPC, "Craft_Mat2");
	int nMat3 = GetLocalInt(oPC, "Craft_Mat3");
	
	struct baseitem i = LoadBaseItem(nBase);
	struct material m1 = LoadMaterial(nMat1, i.matlist_1);
	struct material m2 = LoadMaterial(nMat2, i.matlist_2);
	struct material m3 = LoadMaterial(nMat3, i.matlist_3);
	
	string sCaution = GetCautionString(oPC, i, m1, m2, m3);
	int nTotalPoints = 10;
	string sPointsColumn = "";
	// generating more complete info than before -FlattedFifth
	string sInfoText = ", a ";
	int bIsRanged = FALSE; // not counting thrown weapons
	if (i.type == "A"){
		sPointsColumn = "A_POINTS";
		// Get the row of armorrulestats.2da that corresponds to this armor from the columns
		// that I created for that purpose in scod_craft_baseitems.2da
		string sArmorStatColumn = "ARMORSTAT_ID";
		if (FindSubString(GetStringLowerCase(m1.label), "mithral") != -1) sArmorStatColumn = "MITH_ARMORSTAT_ID";
		string sArmorRow = Get2DAString("scod_craft_baseitems", sArmorStatColumn, nBase);
		// generate relevant info for non-cloth armor
		if (sArmorRow != "" && sArmorRow != "0")
		{
			int nRow = StringToInt(sArmorRow);
			string sBaseAC = Get2DAString("armorrulestats", "ACBONUS", nRow);
			string sDexAC = Get2DAString("armorrulestats", "MAXDEXBONUS", nRow);
			string sArmType = Get2DAString("armorrulestats", "RANK", nRow);
			string sArmorCheck = Get2DAString("armorrulestats", "ACCHECK", nRow);
			string sArcFail = Get2DAString("armorrulestats", "ARCANEFAILURE%", nRow);
			sInfoText += sBaseAC + "/" + sDexAC + " " + sArmType + " armor with ";
			sInfoText += sArmorCheck + " skill penalty & " + sArcFail + "% Spell Fail";
		}	
	} else if (i.type == "W"){
		sPointsColumn = "M_POINTS";
		if (IPGetIsProjectile(OBJECT_INVALID, i.id)){
			bIsRanged = TRUE;
			nTotalPoints = 8;
			sInfoText = "projectile";
		} else {
			if (IPGetIsLauncher(OBJECT_INVALID, i.id)){
				bIsRanged = TRUE;
				nTotalPoints = 8;
				sPointsColumn = "R_POINTS";
			}
			string sNumDice = Get2DAString("baseitems", "NumDice", i.id);
			string sDieToRoll = Get2DAString("baseitems", "DieToRoll", i.id);
			sInfoText = sNumDice + "d" + sDieToRoll + ", ";
			int nCritRange = StringToInt(Get2DAString("baseitems", "CritThreat", i.id));
			int nLowRange = 21 - nCritRange;
			if (nLowRange > 20) nLowRange = 20; // in case someone messes up the 2da
			sInfoText += IntToString(nLowRange);
			if (nLowRange < 20) sInfoText += "-20";
			string sCritMult = Get2DAString("baseitems", "CritHitMult", i.id);
			sInfoText += "/x" + sCritMult;
			string sSize = Get2DAString("baseitems", "WeaponSize", i.id);
			if (sSize == "1") sSize = "tiny";
			else if (sSize == "2") sSize = "small";
			else if (sSize == "3") sSize = "medium";
			else if (sSize == "4") sSize = "large";
			else sSize = "huge";
			sInfoText += " " + sSize;
			string sDmgType = Get2DAString("baseitems", "WeaponType", i.id);
			if (sDmgType == "1") sDmgType = "piercing";
			else if (sDmgType == "3") sDmgType = "slashing";
			else if (sDmgType == "4") sDmgType = "piercing/slashing";
			else if (sDmgType == "5") sDmgType = "bludgeoning/piercing";
			else sDmgType = "bludgeoning";
			sInfoText += " " + sDmgType + " weapon";
		}
	} else sInfoText = "";
	
	nTotalPoints -= 1;
	int nMatPoints = 0;
	if (GetIsPowerfulMaterial(m1.ipForgedOf)) nMatPoints += 1;
	if (GetIsPowerfulMaterial(m2.ipForgedOf)) nMatPoints += 1;
	if (GetIsPowerfulMaterial(m3.ipForgedOf)) nMatPoints += 1;
	
	nTotalPoints += nMatPoints;
	if (bIsRanged && nTotalPoints < 8) nTotalPoints = 8;
	else if (nTotalPoints < 10) nTotalPoints = 10;

	nTotalPoints += nMatPoints;
	if (bIsRanged && nTotalPoints < 8) nTotalPoints = 8;
	else if (nTotalPoints < 10) nTotalPoints = 10;
	
	int nUsedPoints = 0;
	int nPointsRow = nMat1;
	string sMatList = i.matlist_1;
	
	string sFeatures = "";
	itemproperty matPower;
	int nDrMat = 0;
	int bIsMelee = (IPGetIsMeleeWeapon(OBJECT_INVALID, i.id) || 
		(i.id == BASE_ITEM_GLOVES && CRAFTED_GLOVES_GET_MAT_POWER));

	if (bIsMelee && i.matlist_1 != "SCOD_CRAFT_METAL"){
		if (m2.ipForgedOf == SPECIAL_MAT_METALLINE){
			nPointsRow = nMat2;
			sMatList = i.matlist_2;
			matPower = GetSpecialMaterialItemProperty(i, m2);
		} else matPower = GetSpecialMaterialItemProperty(i, m1);
		nDrMat = m2.drMaterial;
	} else {
		matPower = GetSpecialMaterialItemProperty(i, m1);
		nDrMat = m1.drMaterial;
	}
	
	if (sPointsColumn != ""){
		nUsedPoints = StringToInt(Get2DAString(sMatList, sPointsColumn, nPointsRow));
		if (nUsedPoints < 0) nUsedPoints = 0;
		else if (nUsedPoints > 8) nUsedPoints = 8;
	}
	// TODO, fix this
	//sInfoText += " with " + IntToString(nUsedPoints) + "/" + IntToString(nTotalPoints) + " points.";
	
	if (GetIsItemPropertyValid(matPower)) {
		sFeatures += "<i>"+GetItemPropertyString(matPower)+"</i>\n";
		if (sCaution != "")
			sFeatures += "<i><color=Red>"+sCaution+"</color></i>";
	}
	
	//Manually adding DR notes since they're on the items, not itemproperties
	if (i.type == "A") {
		if (m1.label == "Demonscale") {
			sFeatures += "<i>Damage Reduction 5/Cold Iron or Good</i>";
		} else if (m1.label == "Devilscale") {
			sFeatures += "<i>Damage Reduction 5/Silver or Good</i>";
		} else if (m1.label == "Celestial Plumes") {
			sFeatures += "<i>Damage Reduction 5/Mithral or Evil</i>";
		} else if (m1.label == "Glassteel") {
			sFeatures += "<i>Damage Reduction 5/Slashing or Bludgeoning</i>";
		} else if (m1.label == "Alchemic Platinum") {
			sFeatures += "<i>Damage Reduction 5/Piercing or Slashing</i>";
		} else if (m1.label == "Riverine") {
			sFeatures += "<i>Damage Reduction 5/Piercing or Bludgeoning</i>";
		} else if (m1.label == "Oerthblood") {
			sFeatures += "<i>+3 to all Saves</i>";
		} else if (m1.label == "Pure Adamantine" || m1.label == "Flesh Golem Hide") {
			sFeatures += "<i>Damage Reduction 3/-</i>";
		} else if (m1.label == "Mithral") {
			sFeatures += "<i>Light Weight, Reduced Stealth Penalties</i>";
		} else if (m1.label == "Darksteel") {
			sFeatures += "<i>Acid Resist 5/</i>";
		}
	}
	if (nDrMat > 0 && bIsMelee)sFeatures += "Pierces DR as "+GetDRMaterialString(nDrMat)+"\n";
	
	string sText = "Base Item: " + i.label + sInfoText + "\n";
	if (nMat1 != 0) sText += "Made of "+m1.label;
	if (nMat2 != 0 && nMat3 == 0) sText += " and " + m2.label;
	if (nMat2 != 0 && nMat3 != 0) sText += ", "+m2.label;
	if (nMat3 != 0) sText += ", and "+m3.label+"\n";
	if (i.id == BASE_ITEM_HEAVYCROSSBOW || i.id == BASE_ITEM_LIGHTCROSSBOW){
		if (m2.ipForgedOf == SPECIAL_MAT_XBOW_LEVER && m3.ipForgedOf != SPECIAL_MAT_XBOW_SIGHT)
			sText += "With Bonus Feat Rapid Reload";
		else if (m2.ipForgedOf != SPECIAL_MAT_XBOW_LEVER && m3.ipForgedOf == SPECIAL_MAT_XBOW_SIGHT)
			sText += "With Bonus Feat Weapon Focus: " + i.label;
		else if (m2.ipForgedOf == SPECIAL_MAT_XBOW_LEVER && m3.ipForgedOf == SPECIAL_MAT_XBOW_SIGHT)
			sText += "With Bonus Feats Rapid Reload and Weapon Focus: " + i.label;
	}
	sText += "\n";
	
	sText += "Cost: "+IntToString(GetCraftedItemCost(oPC, i, m1, m2, m3))+" copper\n";
	
	sText += "Skill Rank requirement: ";
	if (i.type == "A" || i.type == "M") {
		sText += "Craft Armor "+IntToString(GetCraftingRankRequirement(i, m1, m2, m3));
	} else {
		sText += "Craft Weapon "+IntToString(GetCraftingRankRequirement(i, m1, m2, m3));
	}
	
	sText += "\nRequired items: ";
	
	if (nMat1 != 0 && m1.rResref != "")
		sText += m1.label;
	if (nMat1 != 0 && m2.rResref != "")
		sText += ", "+m2.label;
	if (nMat1 != 0 && m2.rResref != "")
		sText += ", "+m3.label;
		
	sText += "\n\n";
	sText += sFeatures;
		
	SetGUIObjectText(oPC, sCraftingScreen, "CRAFTING_DETAILS_TEXT", -1, sText);
}