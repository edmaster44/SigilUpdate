// Script for re-cutting gems. Called from i_smithhammer_ac when you use the smithing
// hammer on a gem while being in possession of an adamantine dagger to use as a
// gemcutter's chisel. Gems that already have the "recut" local int set to true will not
// call this script. -FlattedFifth, June 2, 2025


#include "ginc_crafting"
#include "x2_inc_switches"
#include "ps_inc_functions"
#include "ps_inc_newcraft_include"

const int NAT_1 = -1;
const int NAT_20 = 20;
const int SIMPLE_FAIL = FALSE;
const int SIMPLE_SUCCESS = TRUE;

void VerifyNewGem(object oPC, object oOldGem, object oRecutGem, string sName, string sDescrip);
void GenerateNewGem(object oPC, object oGem, string sNewTag, string sName, string sDescrip);
void PerformCut(object oPC, object oGem, int nQuality, int nRoll, int bImprove);
int GetGemQualityFromTag(object oPC, object oGem);
int RollForCut(object oPC, int bImprove);

void main(int bImprove){
	object oPC = GetPCSpeaker();
	object oGem = GetLocalObject(oPC, "gem_to_be_recut");
	
	//tests that exclude rough gems and non-gems are in i_smithhammer_ac, 
	// so we don't need them here
	int nQuality = GetGemQuality(oGem);
	
	if (bImprove){
		if (nQuality == 2){
			SendMessageToPC(oPC, "<c=tomato>Gem is already flawless.</c>");
			return;
		}
	} else {
		if (nQuality == 0){
			SendMessageToPC(oPC, "<c=tomato>Gem is already flawed</c>");
			return;
		}
	}

	int nRoll = RollForCut(oPC, bImprove);
	PerformCut(oPC, oGem, nQuality, nRoll, bImprove);
}

void PerformCut(object oPC, object oGem, int nQuality, int nRoll, int bImprove){

	string sMessage = "<c=tomato>";
	string sName;

	if (nRoll == NAT_1){
		sMessage += "You rolled a natural 1! You've shattered the gem.</c>";
		SendMessageToPC(oPC, sMessage);
		DestroyObject(oGem, 0.2f);
		return;
	}
	//mark the gem so that i_smithhammer_ac won't let us recut a gem more than once
	SetLocalInt(oGem, "recut", TRUE); 
	if (nRoll == SIMPLE_FAIL){
		sMessage += "You can tell that recutting this gem would destroy it.</c>";
		SendMessageToPC(oPC, sMessage);
		sName = GetFirstName(oGem);
		sName += " <c=tomato>Failed Recut</c>";
		SetFirstName(oGem, sName);
 		return;
	} 
	
	// we don't need an "else" because we've bailed before here in the failure cases
	
	string sTag = GetTag(oGem);
	int nIndex = FindSubString(sTag, "_q", 12);
	if (nIndex == -1){
		//bail if the substring _q isn't found
		SendMessageToPC(oPC, "<c=tomato>Error, unrecognized gem.</c>");
		return;
	}
	
	// set up the new tag for our recut gem, sNewTag
	string sNewTag = GetStringLeft(sTag, nIndex + 2);
	int nNewQ = nQuality - 1;
	if (bImprove) nNewQ = nQuality + 1;
	sNewTag += IntToString(nNewQ);
	int nRightChars = GetStringLength(sTag) - (nIndex + 3);
	if (nRightChars > 0)
		sNewTag += GetStringRight(sTag, nRightChars);
	
	// set up the new name for our recut gem, sName
	sName = GetFirstName(oGem);
	string sCurrentPrefix = "";
	if (nQuality == 0) sCurrentPrefix = "Flawed ";
	else if (nQuality == 2) sCurrentPrefix = "Flawless ";
	if (sCurrentPrefix != ""){
		int nTruncate = GetStringLength(sCurrentPrefix);
		if (GetStringLeft(sName, nTruncate) == sCurrentPrefix)
			sName = GetStringRight(sName, GetStringLength(sName) - nTruncate);
	}
	string sNewPrefix = "";
	if (nNewQ == 0) sNewPrefix = "Flawed ";
	else if (nNewQ == 2) sNewPrefix = "Flawless ";
	if (sNewPrefix != "") sName = sNewPrefix + sName;
	sName += " <c=tomato>Re-Cut</c>";
	
	//set new description for re-cut gem, sDescrip
	string sDescrip = GetGemstoneDescription(oGem);
	sDescrip += GetGemstoneUses(GetBaseGemTagFromString(sNewTag), nNewQ);
	
	// create the newly recut gem, 
	object oRecut = CreateItemOnObject(GetResRef(oGem), oPC, 1, sNewTag);
	//then make sure everything is kosher and clean up
	DelayCommand(0.3f, VerifyNewGem(oPC, oGem, oRecut, sName, sDescrip));
	
	//let the player know the result
	if (!GetIsObjectValid(oRecut)){
		sMessage = "<c=tomato>Error generating re-cut gem.\n";
		sMessage += "Please make sure you have an empty inventory slot.\n";
		sMessage += "If you do have an empty slot and get this message, contact support.</c>";
	} else {
		sMessage = "<c=lightgreen>";
		if (nRoll == NAT_20)
				sMessage += "You rolled a natural 20!/n";

		sMessage += "You've successfully recut the gem!</c>";
	}
	SendMessageToPC(oPC, sMessage);
}



void VerifyNewGem(object oPC, object oOldGem, object oRecutGem, string sName, string sDescrip){
	
	if (!GetIsObjectValid(oRecutGem))return;

	int nStack = GetItemStackSize(oOldGem);
	if (nStack > 1) SetItemStackSize(oOldGem, nStack -1);
	else DestroyObject(oOldGem);
	
	SetFirstName(oRecutGem, sName);
	SetDescription(oRecutGem, sDescrip);
}

// roll for the recut
// returns -1 if nat 1 roll (crit failure, destroys gem
// returns 20 if nat 20 roll, auto success
// returns true if simple success
// returns false if simple failure
int RollForCut(object oPC, int bImprove){
	int nResult = SIMPLE_FAIL;
	string sMessage;
	int nDC = 30;
	int nMod = GetSkillRank(SKILL_APPRAISE, oPC, FALSE);
	if (bImprove)
		nDC = 29 + d12(5) + d10();
	int nRoll = d20(1);
	
	if (nRoll == 1){
		sMessage = "<c=tomato>";
		nResult = NAT_1;
	} else if (nRoll == 20){
		sMessage = "<c=lightgreen>";
		nResult = NAT_20;
	} else {
		if (nRoll + nMod >= nDC){
			nResult = SIMPLE_SUCCESS; 
			sMessage = "<c=lightgreen>";
		} else sMessage = "<c=tomato>";
	}
	sMessage += "Roll: " + IntToString(nRoll) + " + " + IntToString(nMod);
	sMessage += " = " + IntToString(nRoll + nMod);
	sMessage += " vs DC: " + IntToString(nDC) + "</c>";
	SendMessageToPC(oPC, sMessage);
	return nResult;
}