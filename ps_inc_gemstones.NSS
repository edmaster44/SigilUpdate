#include "nwnx_sql"
const string sGemScreen = "SCOD_GEMCUTTING";
const string xmlGemFile = "scod_gemcutting_window.xml";
const string gemstoneBox = "plc_chest_gemstonegeneration";

const int GEMSTONE_SKILL_ID = SKILL_APPRAISE; //currently rolls appraise, could roll something else

//Checks whether this is a new gemstone
int GetIsGemstone(object oItem);

//Makes sure box is ready to go!
void InitializeGemstoneBox();

//Get the enchantments this gemstone can be used in
string GetGemstoneUses(string sTag, int nQ);

//get base tag of gemstone
string GetBaseGemTag(object oGem);

//Replaces TakeNumItems
void TakeNumCraftingMaterials(object oPC, string sTag, int nNum) {
    int nCount = 0;
	int iStack;
	int bCheckAgain = FALSE;
	object oCont;
	
    object oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem) == TRUE && nCount < nNum)
    {
        if (GetTag(oItem) == sTag)
        {
            iStack = GetItemStackSize(oItem);
			if (iStack > 1)
			{
				SetItemStackSize(oItem, iStack - 1, TRUE);
				bCheckAgain = TRUE;
			}
			else
			{
				DestroyObject(oItem);
			}
            nCount++;
        }
		// Basically, only move onto next item if it isn't currently on a stack with more than 1 item in it.
		// Therefore it will check same item again if more need taking. If the count has reached the number required then it will exit anyway.
		if (bCheckAgain == TRUE)
			bCheckAgain = FALSE;
		else
			oItem = GetNextItemInInventory(oPC);
    }

   return;
}

int GetNumberOfGemstonesOfColor(string sColor) {

	object oChest = GetObjectByTag(gemstoneBox);
	return GetLocalInt(oChest, sColor+"_Num");
}

string GetGemstoneColor(object oGem) {
	return GetLocalString(oGem, "Color");
}

string GetGemstoneMineral(object oGem) {
	return GetLocalString(oGem, "Mineral");
}

string GetGemstoneDescription(object oGem) {
	string sBaseTag = GetBaseGemTag(oGem);
	SQLExecDirect("SELECT description FROM gemstones WHERE tag='"+sBaseTag+"'");
	if (SQLFetch() != SQL_ERROR) { 
		return SQLGetData(1);
	}
	return "";
}

string GetGemstoneFullDescription(object oGem) {

	if (FindSubString(GetTag(oGem), "gemstone_rough") >= 0) {
		return "This is a rough gemstone, just waiting to be identified. The value will be clearer with identification and polishing.";
	}

	string sResult = "Mineral: "+GetGemstoneMineral(oGem)+"\n";
	sResult += "Color: "+GetGemstoneColor(oGem)+"\n\n";
	sResult += GetGemstoneDescription(oGem);
	return sResult;
	
}

//The database should tell us how many entries there are, since nwn2 doesn't understand arrays
//or counting arrays. . .
int InitializeGemstoneNumber(string sColor) {
	int nCount = 0;
	SQLExecDirect("SELECT COUNT(*) FROM gemstones WHERE color='"+sColor+"'");
	if (SQLFetch() != SQL_ERROR) { 
		nCount = StringToInt(SQLGetData(1));
	} else {
		nCount = 0;
	}
	return nCount;
}

string RollGemstoneOfColor(string sColor) {

	string sResult = "";
	object oChest = GetObjectByTag(gemstoneBox);
	int nNum = GetLocalInt(oChest, sColor+"_num");
	if (nNum <= 0) {
		nNum = InitializeGemstoneNumber(sColor);
	}
	SetLocalInt(oChest, sColor+"_num", nNum);
	int nRand = Random(nNum);
	SQLExecDirect("SELECT tag FROM gemstones WHERE color='"+sColor+"' LIMIT "+IntToString(nRand)+", 1");
	if (SQLFetch() != SQL_ERROR) { 
		sResult = SQLGetData(1);
	} else {
		sResult = "";
	}
	return sResult;
}

//Returns the tag of the identified gemstone
string RollGemstoneType(object oRough) {

	string sTag = GetTag(oRough);
	int qualityIndex = FindSubString(sTag, "_q", 12);
	sTag = GetSubString(sTag, 0, qualityIndex);
	
	if (sTag == "gemstone_rough_red") {
		return RollGemstoneOfColor("Red");
	} else if (sTag == "gemstone_rough_blue") {
		return RollGemstoneOfColor("Blue");
	} else if (sTag == "gemstone_rough_green") {
		return RollGemstoneOfColor("Green");
	} else if (sTag == "gemstone_rough_yellow") {
		return RollGemstoneOfColor("Yellow");
	} else if (sTag == "gemstone_rough_black") {
		return RollGemstoneOfColor("Black");
	} else if (sTag == "gemstone_rough_pearl") {
		return RollGemstoneOfColor("Pearl");
	} else {
		return RollGemstoneOfColor("White");
	}

}

int IsGemRough(object oGem) {
	int isRough = FindSubString(GetTag(oGem), "_rough");
	if (isRough < 0)
		return FALSE;
	return TRUE;
}

int IsGemIdentified(object oGem) {
	string sTag = GetTag(oGem);
	int nIndex = FindSubString(sTag, "gemstone_rough", 0);
	if (nIndex >= 0)
		return FALSE;
	return TRUE;
}

//Get the base tag string from tag string
//Good for creating new identical gems!
string GetBaseGemTagFromString(string sTag) {
	int qualityIndex = FindSubString(sTag, "_q", 12);
	if (FindSubString(sTag, "_rough") >= 0)
		qualityIndex = FindSubString(sTag, "_rough");
	string sResult = GetSubString(sTag, 0, qualityIndex);
	
	if (sResult == "gemstone_quartz_purple")
		return "gemstone_kuartz_purple";
	if (sResult == "gemstone_quartz_white")
		return "gemstone_kuartz_white";
	if (sResult == "gemstone_quartz_green")
		return "gemstone_kuartz_green";
		
	return sResult;
}

//Wrapper for GetBaseGemTagFromString which takes
// an object instead of string
string GetBaseGemTag(object oGem) {

	return GetBaseGemTagFromString(GetTag(oGem));
		
}

//Returns the appropriate quality string
string GetQualityString(int nQ) {
	switch (nQ) {
		case 0: return "Flawed";
		case 1: return "";
		case 2: return "Flawless";
		default: return "Flawed";
	}
	return "Flawed";
}

//Returns the appropriate size string
string GetSizeString(int nS) {
	switch (nS) {
		case 0: return "- Small";
		case 1: return "";
		case 2: return "- Large";
		default: return "";
	}
	return "";
}

//Get Carat Weight of Rough Gemstone
int GetCaratWeight(object oGem) {

 	int carobIndex = FindSubString(GetTag(oGem), "_c");
	if (carobIndex < 0)
		return 1;
	int length = GetStringLength(GetTag(oGem))-carobIndex;
	string sCarob = GetSubString(GetTag(oGem), carobIndex+2, length-2);
	return StringToInt(sCarob);
}

//Get Gem Quality of Gemstone
int GetGemQuality(object oGem) {

 	int qualityIndex = FindSubString(GetTag(oGem), "_q", 12); //start 12 slots in, because quality never comes before that
	if (qualityIndex < 0)
		return 0;
	string sQuality = GetSubString(GetTag(oGem), qualityIndex+2, 1);
	return StringToInt(sQuality);
}

string GetBaseGemName(object oGem) {
	
	int baseIndex = FindSubString(GetName(oGem), " - <C");
	int nQ = GetGemQuality(oGem);
	int nStart = 0;
	if (IsGemRough(oGem)) {
		if (TestStringAgainstPattern("**pearl**", GetTag(oGem))) {
			nStart = 13;
		} else {
			nStart = 6;
		}
	} else {
		string qString = GetQualityString(nQ);
		if (FindSubString(GetName(oGem), qString) >= 0)
			nStart = GetStringLength(qString)+1;
	}
	string sBaseName = GetSubString(GetName(oGem), nStart, baseIndex-5);
	return sBaseName;
}

void SetDetailsOfGemstone(object oGem, int nQ, int nSize, object oPC = OBJECT_INVALID) {
	string sBaseName = GetBaseGemName(oGem);
	string sBaseTag = GetBaseGemTag(oGem);
	if (IsGemRough(oGem)) {
		SetTag(oGem, sBaseTag+"_rough_q"+IntToString(nQ)+"_c"+IntToString(nSize));
		SetFirstName(oGem, "Rough "+sBaseName+" <Color=Gray>"+GetSizeString(nSize)+"</Color>");
	} else {
		SetTag(oGem, sBaseTag+"_q"+IntToString(nQ)+"_c"+IntToString(nSize));
		SetFirstName(oGem, GetQualityString(nQ)+" "+sBaseName+" <Color=Gray>"+GetSizeString(nSize)+"</Color>");
		
		string sDescrip = GetGemstoneDescription(oGem);
		string sExtra = GetGemstoneUses(sBaseTag, nQ);
		SetDescription(oGem, sDescrip+sExtra);
	}
}

void SetQualityOfGemstone(object oGem, int nQ) {
	int nSize = GetCaratWeight(oGem);
	SetDetailsOfGemstone(oGem, nQ, nSize);
}

void SetCaratOfGemstone(object oGem, int nSize) {
	int nQ = GetGemQuality(oGem);
	SetDetailsOfGemstone(oGem, nQ, nSize);
}

//Sorts gemstones so that we can spawn in new gemstones!
void InitializeGemstoneBox() {
	
	object oChest = GetObjectByTag(gemstoneBox);
	if (GetLocalInt(oChest, "Initialized") > 0)
		return;
	
	int nCount = 0;
	object oGem = GetFirstItemInInventory(oChest);
	while (GetIsObjectValid(oGem)) {
	
		//Iterate for gemstone color list
		string sColor = GetGemstoneColor(oGem);
		int nNum = GetLocalInt(oChest, sColor+"_Num");
		SetLocalString(oChest, sColor+"_"+IntToString(nNum), GetTag(oGem));
		SetLocalInt(oChest, sColor+"_Num", nNum+1);
		
		//Iterate for full gemstone list
		//AssignCommand(oChest, ActionSpeakString("setting Gemstone_"+IntToString(nCount)+" to "+GetTag(oGem), TALKVOLUME_SHOUT));
		SetLocalString(oChest, "Gemstone_"+IntToString(nCount), GetTag(oGem));
		nCount++;
		
		oGem = GetNextItemInInventory(oChest);
	}
	SetLocalInt(oChest,  "Gemstone_Num", nCount);
	SetLocalInt(oChest, "Initialized", 1);
	
}

//Randomly picks a color to sort by
string PickRandomGemColor() {
	string sColor = "White";
	
	int nRand = Random(9);
	switch(nRand) {
		case 0: sColor = "Red"; break;
		case 1: sColor = "Blue"; break;
		case 2: sColor = "Green"; break;
		case 3: sColor = "Yellow"; break;
		case 4: sColor = "Black"; break;
		case 5: sColor = "Black"; break;
		case 6: sColor = "Pearl"; break;
		case 7: sColor = "White"; break;
		case 8: sColor = "White"; break;
	}
	
	return sColor;
}

//Get the enchantments this gemstone is used in
string GetGemstoneUses(string sTag, int nQuality) {

	string sGemTag = sTag+"_q"+IntToString(nQuality+1);
	string sQuery = "SELECT Label FROM recipes WHERE gemstone = '"+sGemTag+"'";
	string sResult = "";
	
	SQLExecDirect(sQuery);
	while (SQLFetch() != SQL_ERROR) { 
		string sName = SQLGetData(1);
		if (sName != "") {
			if (sResult != "") 
				sResult += ", "+sName;
			else
				sResult += sName;
		}
	}
	
	if (sResult != "")
		return "\n\nKnown uses: "+sResult;
	else 
		return "";

}

//Gets a random gemstone from the gemstone box
object GetRandomGemstoneToSpawn(object oTarget, string sColor = "") {

	object oChest = GetObjectByTag(gemstoneBox);
	if (sColor == "")
		sColor = PickRandomGemColor();

	int nNum = GetLocalInt(oChest, sColor+"_num");
	if (nNum <= 0) {
		nNum = InitializeGemstoneNumber(sColor);
	}
	SetLocalInt(oChest, sColor+"_num", nNum);
	
	int nRand = Random(nNum);
	object oGem;
	SQLExecDirect("SELECT name, tag, resref, icon, description, vfx, duration FROM gemstones WHERE color='"+sColor+"' LIMIT "+IntToString(nRand)+", 1");
	if (SQLFetch() != SQL_ERROR) { 
		string sName = SQLGetData(1);
		string sTag = SQLGetData(2);
		string sResref = SQLGetData(3);
		int nIcon = StringToInt(SQLGetData(4));
		string sDescrip = SQLGetData(5);
		string sVFX = SQLGetData(6);
		float fDur = StringToFloat(SQLGetData(7));
		if (sTag == "gemstone_vfx_chardalyn") {
			oGem = CreateItemOnObject(sTag, oTarget, 1);
		} else {
			oGem = CreateItemOnObject(sResref, oTarget, 1);
			SetFirstName(oGem, sName);
			if (sTag == "gemstone_amber_1" || sTag == "gemstone_amber_2") {
				SetTag(oGem, "ps_summoner");
			} else {
				SetTag(oGem, sTag);
			}
			SetItemIcon(oGem, nIcon);
			SetDescription(oGem, sDescrip);
			SetLocalString(oGem, "VFX", sVFX);
			SetLocalFloat(oGem, "Duration", fDur);
		}
	}
	return oGem;

}

//Create a gemstone of the specified tag, quality, and size
object CreateGemstoneOfType(string sTag, int nQuality = 0, int nSize = 0, object oTarget = OBJECT_INVALID) {

	object oGem;
	string sQuery = "SELECT name, tag, resref, icon, description, vfx, duration FROM gemstones WHERE tag='"+sTag+"'";
	
	SQLExecDirect(sQuery);
	if (SQLFetch() != SQL_ERROR) { 
		string sName = SQLGetData(1);
		string sTag = SQLGetData(2);
		string sResref = SQLGetData(3);
		int nIcon = StringToInt(SQLGetData(4));
		string sDescrip = SQLGetData(5);
		string sVFX = SQLGetData(6);
		float fDur = StringToFloat(SQLGetData(7));
		if (sTag == "gemstone_vfx_chardalyn") {
			oGem = CreateItemOnObject(sTag, oTarget, 1);
		} else {
			oGem = CreateItemOnObject(sResref, oTarget, 1);
			SetFirstName(oGem, sName);
			if (sTag == "gemstone_amber_1" || sTag == "gemstone_amber_2") {
				SetTag(oGem, "ps_summoner");
			} else {
				SetTag(oGem, sTag);
			}
			SetItemIcon(oGem, nIcon);
			SetDescription(oGem, sDescrip);
			SetLocalString(oGem, "VFX", sVFX);
			SetLocalFloat(oGem, "Duration", fDur);
		}
	}
	
	if (GetIsGemstone(oGem)) {
		SetDetailsOfGemstone(oGem, nQuality, nSize, oTarget);
	}
	
	return oGem;
}

void CreateRandomGemstoneOnSpawnOrChest(object oTarget, int nLootLevel) {

	object oGem = GetRandomGemstoneToSpawn(oTarget);
	
	if (GetIsGemstone(oGem)) {
		int nSize = 0;
		int nQuality = Random(3);
		SetDetailsOfGemstone(oGem, nQuality, nSize, oTarget);
	}
}

int GetHasRoughGemstone(object oPC) {
	object oItem = GetFirstItemInInventory(oPC);
	while (GetIsObjectValid(oItem)) {
	
		if (GetBaseItemType(oItem) != BASE_ITEM_GEM)
			continue;
		string sTag = GetTag(oItem);
		//SendMessageToPC(oPC, "checking: "+sTag);
		if (FindSubString(sTag, "gemstone_rough") >= 0) { //is a rough gemstone
			//SendMessageToPC(oPC, sTag+" is a rough gemstone.");
			return TRUE;
		} else {
			//SendMessageToPC(oPC, sTag+" is not a rough gemstone.");
		}
	
		oItem = GetNextItemInInventory(oPC);
	}
	
	return FALSE;
}

int GetIsGemstone(object oItem) {
	if (GetBaseItemType(oItem) != BASE_ITEM_GEM)
		return FALSE;
	string sTag = GetTag(oItem);
	if (FindSubString(sTag, "gemstone") >= 0) //is a new gemstone
		return TRUE;
	return FALSE;
}

//GUI Regenerate Gem Listbox
void RegenerateGemList(object oPC) {
	object oGem = GetFirstItemInInventory(oPC);
	int nCount = 0;
	ClearListBox(oPC, sGemScreen, "SCOD_GEM_INVENTORY");
	while (GetIsObjectValid(oGem)) {
	
		if (GetBaseItemType(oGem) == BASE_ITEM_GEM) {
			if (GetTag(oGem) != "gemstone_gravel" && GetIsGemstone(oGem) && IsGemRough(oGem)) { 
				int iconIndex = GetItemIcon(oGem);
				string sIcon = Get2DAString("nwn2_icons", "ICON", iconIndex);
				SetLocalObject(oPC, "gemrow_"+IntToString(nCount), oGem);
				AddListBoxRow(oPC, sGemScreen, "SCOD_GEM_INVENTORY", "GEMROW_"+IntToString(nCount), "GemEntryName="+GetName(oGem)+";", "GemEntryIcon="+sIcon+".tga;", "5=" + IntToString(nCount), "");
				nCount++;
			}
		}
		oGem = GetNextItemInInventory(oPC);
	}
	if (nCount <= 0) {
		SetGUIObjectHidden(oPC, sGemScreen, "IDENTIFY_GEM", TRUE);
		SetGUIObjectHidden(oPC, sGemScreen, "CUT_GEM", TRUE);
	}
}

//GUI Updates Gem Selected Screen
void UpdateSelectedGem(object oPC) {
	object oGem = GetLocalObject(oPC, "selected_gem");
	if (GetTag(oGem) == "gemstone_gravel") {
		SetGUITexture(oPC, sGemScreen, "MAINGEM_ICON", "");
		SetGUIObjectText(oPC, sGemScreen, "MAINGEM_NAME", -1, "");
		SetGUIObjectText(oPC, sGemScreen, "MAINGEM_DESCRIPTION", -1, "The gem has been destroyed. You can do nothing further with it.");
		SetGUIObjectHidden(oPC, sGemScreen, "IDENTIFY_GEM", TRUE);
		SetGUIObjectHidden(oPC, sGemScreen, "CUT_GEM", TRUE);
		return;
	} else if (GetBaseItemType(oGem) == BASE_ITEM_MISCSMALL) { //for gems with special effects
		int iconIndex = GetItemIcon(oGem);
		string sIcon = Get2DAString("nwn2_icons", "ICON", iconIndex);
		SetGUITexture(oPC, sGemScreen, "MAINGEM_ICON", sIcon+".tga");
		SetGUIObjectText(oPC, sGemScreen, "MAINGEM_NAME", -1, GetName(oGem));
		SetGUIObjectText(oPC, sGemScreen, "MAINGEM_DESCRIPTION", -1, "You can do nothing further to this gem.\n\n"+GetGemstoneFullDescription(oGem));
		SetGUIObjectHidden(oPC, sGemScreen, "IDENTIFY_GEM", TRUE);
		SetGUIObjectHidden(oPC, sGemScreen, "CUT_GEM", TRUE);
		return;
	}
	
	if (IsGemIdentified(oGem)) {
		SetGUIObjectHidden(oPC, sGemScreen, "IDENTIFY_GEM", TRUE);
		if (IsGemRough(oGem))
			SetGUIObjectHidden(oPC, sGemScreen, "CUT_GEM", FALSE);
		else
			SetGUIObjectHidden(oPC, sGemScreen, "CUT_GEM", TRUE);
	} else {
		SetGUIObjectHidden(oPC, sGemScreen, "IDENTIFY_GEM", FALSE);
		SetGUIObjectHidden(oPC, sGemScreen, "CUT_GEM", TRUE);
	}
	int iconIndex = GetItemIcon(oGem);
	string sIcon = Get2DAString("nwn2_icons", "ICON", iconIndex);
	SetGUITexture(oPC, sGemScreen, "MAINGEM_ICON", sIcon+".tga");
	SetGUIObjectText(oPC, sGemScreen, "MAINGEM_NAME", -1, GetName(oGem));
	SetGUIObjectText(oPC, sGemScreen, "MAINGEM_DESCRIPTION", -1, GetGemstoneFullDescription(oGem));
	
}