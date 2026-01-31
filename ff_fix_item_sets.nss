// This script reapplies the correct tag and local variables to items in item sets that had
// this information corrupted by using the appearance changer
// FlattedFifth, Jan 30, 2026

void FF_FixItemSets(object oItem, string sRef){

	int bIsSetItem = FALSE;
	int iVarVal;
	
	if (FindSubString(sRef, "ps_itemset_") == -1){
		return; // bail if this is not a set item
	} else if (FindSubString(sRef, "swordsaint") > -1){
		bIsSetItem = TRUE;
		iVarVal = 1;
	} else if (FindSubString(sRef, "celglory") > -1){
		bIsSetItem = TRUE;
		iVarVal = 2;
	} else if (FindSubString(sRef, "aarcher") > -1){
		bIsSetItem = TRUE;
		iVarVal = 3;
	} else if (FindSubString(sRef, "fallshad") > -1){
		bIsSetItem = TRUE;
		iVarVal = 4;
	} else if (FindSubString(sRef, "slaadskin") > -1){
		bIsSetItem = TRUE;
		iVarVal = 5;
	} else if (FindSubString(sRef, "iggwilv") > -1){
		bIsSetItem = TRUE;
		iVarVal = 6;
	} else if (FindSubString(sRef, "brazen") > -1){
		bIsSetItem = TRUE;
		iVarVal = 7;	
	} else if (FindSubString(sRef, "fighter") > -1){
		bIsSetItem = TRUE;
		iVarVal = 8;
		SetLocalInt(oItem, "nochange", 1);
	} else return;
	
	if (bIsSetItem){
		SetTag(oItem, "ps_itemset");
		SetLocalInt(oItem, "vSetID", iVarVal);
	}
}