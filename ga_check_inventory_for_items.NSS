// ga_check_inventory_for_items
// Mimi Fearthegn
// 7/7/19
// Checks OBJECT_SELF's inventory for the given list of items
// or a give gold value worth of items
// CheckType = 1: list of items
// CheckType = 2: gold value of items
// CheckType = 3: based on substring in item tag
// CheckType = 4: based on base item type

#include "nw_i0_plot"

int CheckIfItemInList(object oItemToCompare, object oSelf);

void ExecuteSuccessActions(object oSelf);

void ExecuteFailureActions(object oSelf);

void main() {

    object oPC = GetLastClosedBy();
	object oChest = OBJECT_SELF;
	
	int nType = GetLocalInt(oChest, "CheckType");
	int nMinValue = GetLocalInt(oChest, "MinimumValue");
	string successString = GetLocalString(oChest, "SuccessMessage");
	string failString = GetLocalString(oChest, "FailMessage");
	
	string sVFX = GetLocalString(oChest, "SuccessVFX");
	
	if (nType == 1) {
	
		int nSuccess = FALSE;
		object oItem = GetFirstItemInInventory(oChest);
		while (GetIsObjectValid(oItem)) {
			
			if (CheckIfItemInList(oItem, oChest)) {
				nSuccess = TRUE;
				DestroyObject(oItem);
				break;
			}
		
			oItem = GetNextItemInInventory(oChest);
		}
		
		if (nSuccess) {
			SendMessageToPC(oPC, successString);
			ExecuteSuccessActions(oChest);
			if (sVFX != "") {
				effect eVFX = EffectNWN2SpecialEffectFile(sVFX, oChest);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oChest);
			}
		} else {
			SendMessageToPC(oPC, failString);
			ExecuteFailureActions(oChest);
		}
		
	} else if (nType == 2) {
	
		int nValue = 0;
		object oItem = GetFirstItemInInventory(oChest);
		while (GetIsObjectValid(oItem)) {
			nValue += GetGoldPieceValue(oItem);
			oItem = GetNextItemInInventory(oChest);
		}
		
		if (nValue >= nMinValue) {
			object oItem = GetFirstItemInInventory(oChest);
			while (GetIsObjectValid(oItem)) {
				DestroyObject(oItem);
				oItem = GetNextItemInInventory(oChest);
			}
			SendMessageToPC(oPC, successString);
			ExecuteSuccessActions(oChest);
		} else {
			SendMessageToPC(oPC, failString);
			ExecuteFailureActions(oChest);
		}
	
	} else if (nType == 3) {
		
		string sSub = GetLocalString(oChest, "SubstringToFind");
		int nFound = FALSE;
		object oItem = GetFirstItemInInventory(oChest);
		while (GetIsObjectValid(oItem)) {
			
			if (FindSubString(GetTag(oItem), sSub) >= 0) {
				nFound = TRUE;
				DestroyObject(oItem);
				break;
			}
		
			oItem = GetNextItemInInventory(oChest);
		}
		
		if (nFound) {
			SendMessageToPC(oPC, successString);
			ExecuteSuccessActions(oChest);
		} else {
			SendMessageToPC(oPC, failString);
			ExecuteFailureActions(oChest);
		}
		
	} else if (nType == 4) {
		
		int nType = GetLocalInt(oChest, "BaseItemType");
		int nFound = FALSE;
		object oItem = GetFirstItemInInventory(oChest);
		while (GetIsObjectValid(oItem)) {
			
			if (GetBaseItemType(oItem) == nType) {
				nFound = TRUE;
				DestroyObject(oItem);
				break;
			}
		
			oItem = GetNextItemInInventory(oChest);
		}
		
		if (nFound) {
			SendMessageToPC(oPC, successString);
			ExecuteSuccessActions(oChest);
		} else {
			SendMessageToPC(oPC, failString);
			ExecuteFailureActions(oChest);
		}
		
	}
	
}

int CheckIfItemInList(object oItemToCompare, object oSelf) {

	int nMax = GetLocalInt(oSelf, "NumberOfItems");
	string sTag = GetTag(oItemToCompare);
	
	int n;
	for (n = 1; n <= nMax; n++) {
		string sReq = GetLocalString(oSelf, "Item_"+IntToString(n));
		if (sTag == sReq)
			return TRUE;
	}
	
	return FALSE;
	
}

void ExecuteSuccessActions(object oSelf) {
	
	float fDelay = 0.1f;
	int nActionMax = GetLocalInt(oSelf, "NumberOfActions_Success");
	int n;
	for (n = 1; n <= nActionMax; n++) {
		string sScript = GetLocalString(oSelf, "SuccessAction_"+IntToString(n));
		if (sScript == "")
			return;
		SpeakString("Executing success action "+sScript, TALKVOLUME_SHOUT);
		DelayCommand(fDelay, ExecuteScript(sScript, oSelf));
		fDelay += 0.1f;
	}
}

void ExecuteFailureActions(object oSelf) {
	
	float fDelay = 0.1f;
	int nActionMax = GetLocalInt(oSelf, "NumberOfActions_Failure");
	int n;
	for (n = 1; n <= nActionMax; n++) {
		string sScript = GetLocalString(oSelf, "FailureAction_"+IntToString(n));
		if (sScript == "")
			return;
		SpeakString("Executing failure action "+sScript, TALKVOLUME_SHOUT);
		DelayCommand(fDelay, ExecuteScript(sScript, oSelf));
		fDelay += 0.1f;
	}
}