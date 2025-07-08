// Script for re-cutting gems. Called from i_smithhammer_ac when you use the smithing
// hammer on a gem while being in possession of an adamantine dagger to use as a
// gemcutter's chisel. Gems that already have the "recut" local int set to true will not
// call this script. -FlattedFifth, June 2, 2025


#include "ginc_crafting"
#include "x2_inc_switches"
#include "ps_inc_functions"
#include "ps_inc_newcraft_include"


const int LOG_RECUT = TRUE; // turn logging on and off for gem recutting for debug purposes
const int CRIT_FAIL = -1;

/* FIRST VERSION
const int NAT_1 = -1;
const int NAT_20 = 20;
const int SIMPLE_FAIL = FALSE;
const int SIMPLE_SUCCESS = TRUE;
*/

void LogRecut(object oPC, string sResult);
void GenerateNewGem(object oPC, object oOldGem, string sName, string sDescrip, string sNewTag, string sMessage);
void VerifyNewGem(object oPC, object oOldGem, object oRecut, string sName, string sDescrip, string sNewTag, string sMessage, int nTries = 1);
void ShowRecutResult(object oPC, object oRecut, string sMessage);
void PerformCut(object oPC, object oGem, int nQuality, int nRoll, int bImprove);
int RollForCut(object oPC, object oGem, int bImprove);

void main(int bImprove){
	object oPC = GetPCSpeaker();
	object oGem = GetLocalObject(oPC, "gem_to_be_recut");
	
	if (LOG_RECUT){
		string sFirstLog = "gem successfully retrieved from local variable";
		if (!GetIsObjectValid(oGem))
			sFirstLog = "failed to retrieve gem from local variable";
		LogRecut(oPC, sFirstLog);
	}
	
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

	int nRoll = RollForCut(oPC, oGem, bImprove);
	PerformCut(oPC, oGem, nQuality, nRoll, bImprove);
}


void PerformCut(object oPC, object oGem, int nQuality, int nRoll, int bImprove){

	string sMessage = "<c=tomato>";
	string sName = GetFirstName(oGem);
	string sDescrip = GetGemstoneDescription(oGem);
	
	string sTag = GetTag(oGem);
	object oRecut;
	
	// in this case CRIT_FAIL is not a roll of 1, this is a failure on 
	// the d100 luck roll AND appraise roll
	if (nRoll == CRIT_FAIL){ 
		sMessage += "You've shattered the gem!</c>";
		SendMessageToPC(oPC, sMessage);
		int nStack = GetItemStackSize(oGem);
		if (nStack > 1) SetItemStackSize(oGem, nStack - 1);
		else DestroyObject(oGem, 0.3f);
		return;
	}

	if (nRoll == FALSE){
		sName += " <c=tomato>Failed Recut</c>";
		sDescrip = GetDescription(oGem);
		sMessage += "You can tell that this gem cannot be recut without destroying it.</c>";
		DelayCommand(0.3f, GenerateNewGem(oPC, oGem, sName, sDescrip, sTag, sMessage));
 		return;
	} 
	
	// we don't need an "else" because we've bailed before here in the failure cases
	
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
	if (nRightChars > 0){
		string sTagEnd = GetStringRight(sTag, nRightChars);
		// attempt to downgrade the gem size by 1 category
		// if this consistently works we may be able to do
		// away with the local int and the name "re-cut", 
		// at least on successful recuts
		if (sTagEnd == "_c2")
			sNewTag += "_c1";
		else if (sTagEnd == "_c1")
			sNewTag += "_c0";
		else
			sNewTag += sTagEnd;
	}
	
	// set up the new name for our recut gem, sName
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
	// I don't see how a recut get could still be flagged as large at 
	// this point but this is here so that, if it happens, I'll be 
	// able to know and investigate
	if (FindSubString(sNewTag, "_c2", 12) >= 0)
		sName += " <c=grey> -large</c>";
	// mark a small gem as such
	else if (FindSubString(sNewTag, "_c0", 12) >= 0)
		sName += " <c=gray> -small</c>";
	sName += " <c=tomato>Re-Cut</c>";
	
	//get new description for re-cut gem, sDescrip
	sDescrip += GetGemstoneUses(GetBaseGemTagFromString(sNewTag), nNewQ);
	
	sMessage = "<c=lightgreen>You've successfully recut the gem!</c>";
	// create the newly recut gem, 
	DelayCommand(0.3f, GenerateNewGem(oPC, oGem, sName, sDescrip, sNewTag, sMessage));
}

void GenerateNewGem(object oPC, object oOldGem, string sName, string sDescrip, string sNewTag, string sMessage){
	
	string sRes = GetResRef(oOldGem);
	object oRecut = CreateItemOnObject(sRes, oPC, 1, sNewTag);
	
	if (LOG_RECUT) LogRecut(oPC, "ResRef: " + sRes + ", Tag: " + sNewTag);
	
	DelayCommand(0.3f, VerifyNewGem(oPC, oOldGem, oRecut, sName, sDescrip, sNewTag, sMessage));
}

void VerifyNewGem(object oPC, object oOldGem, object oRecut, string sName, string sDescrip, string sNewTag, string sMessage, int nTries = 1){

	if (!GetIsObjectValid(oRecut)){
		if (nTries == 1){
			// if we failed to create a new gem using the old one's resref, then
			// we try using a resref based on the tag minus the quality and size parts
			// of the tag, which constitute the last 6 characters of the tag
			string sRes =  GetStringLeft(sNewTag, GetStringLength(sNewTag) - 6);
			oRecut = CreateItemOnObject(sRes, oPC, 1, sNewTag);
			if (LOG_RECUT) LogRecut(oPC, "Failed gem creation from original resref, tried tag res");
			DelayCommand(0.3f, VerifyNewGem(oPC, oOldGem, oRecut, sName, sDescrip, sNewTag, sMessage,  nTries + 1));
		} else {
			if (LOG_RECUT) LogRecut(oPC, "VerifyNewGem failed gem creation from original resref, tried tag res");
			//let the player know the result
			DelayCommand(0.3f, ShowRecutResult(oPC, oRecut, sMessage));
			return;
		}
	} else {
		if (LOG_RECUT) LogRecut(oPC, "success in VerifyNewGem function");
		int nStack = GetItemStackSize(oOldGem);
		if (nStack > 1) SetItemStackSize(oOldGem, nStack -1);
		else DestroyObject(oOldGem);
		
		//mark the gem so that i_smithhammer_ac won't let us recut a gem more than once
		SetLocalInt(oRecut, "recut", TRUE); 
		SetFirstName(oRecut, sName);
		SetDescription(oRecut, sDescrip);
		
		//let the player know the result
		DelayCommand(0.3f, ShowRecutResult(oPC, oRecut, sMessage));
	}
}

void ShowRecutResult(object oPC, object oRecut, string sMessage){
	if (!GetIsObjectValid(oRecut)){
		sMessage = "<c=tomato>Error generating re-cut gem. Full inventory?\n";
		sMessage += "If your inventory is not full and you get this message, contact support.</c>";
	}
	if (LOG_RECUT) LogRecut(oPC, "ShowRecutResult function with message: " + sMessage);
	
	SendMessageToPC(oPC, sMessage);
}
void LogRecut(object oPC, string sResult){
	string sPlayer = GetPCPlayerName(oPC);
	string sCharacter = GetName(oPC);
	
	string sLog = "Gem Recut Debug: Player: " + sPlayer + ", ";
	sLog += "Character: " + sCharacter + ", Result: " + sResult;
	WriteTimestampedLogEntry(sLog);
}

// roll for the recut
// appraise roll, dc = 30 if marring. 
// improve dc = 35 + 5 for sunstone/bloodstone + 10 diamond/jasmal
// if successful, there is still a fail chance because we don't want
// anyone to be able to turn 100% of their regular jasmals, etc, to flawless
// this precentile roll represents the luck of whether the gems flaws are
// in a place where they can be cut around without resulting in a too-fragile gem
// the fail rate is 50% for diamond/jasmal, 40% for sunstone/bloodstone, and 30%
// for others.
// returns true if success
// returns false if failure
// returns CRIT_FAIL if gem shatters
int RollForCut(object oPC, object oGem, int bImprove){
	int nResult = FALSE;
	int nLuck = 30;
	string sMessage;
	int nDC = 30;
	int nMod = GetSkillRank(SKILL_APPRAISE, oPC, FALSE);
	
	if (bImprove){
		nDC += 5;
		// find out what kind of gem
		string sTag = GetStringLowerCase(GetTag(oGem));
		if (FindSubString(sTag, "feldspar_yellow") >= 0 ||
			FindSubString(sTag, "blood") >= 0){
				nDC += 5;
				nLuck = 40;
		} else if (FindSubString(sTag, "diamond") >= 0 ||
			FindSubString(sTag, "jasmal") >= 0){
				nDC += 10;
				nLuck = 50;
		}
	}
	int nRoll = d20();
	int nLuckRoll = d100();
	int bLucky = (nLuckRoll >= nLuck);
	
	if (nRoll + nMod >= nDC){
		sMessage = "<c=lightgreen>";
		if (LOG_RECUT) LogRecut(oPC, "successful analysis roll vs DC " + IntToString(nDC));
		if (bLucky){
			nResult = TRUE;
		} else {
			nResult = FALSE;
		}
	} else {
		sMessage = "<c=tomato>";
		if (LOG_RECUT) LogRecut(oPC, "failed analysis roll vs DC " + IntToString(nDC));
		if (bLucky){
			nResult = FALSE;
		} else {
			nResult = CRIT_FAIL;
		}
	}
	
	sMessage += "Skill Roll: " + IntToString(nRoll) + " + " + IntToString(nMod);
	sMessage += " = " + IntToString(nRoll + nMod);
	sMessage += " vs DC: " + IntToString(nDC) + "</c>\n";
	
	if (bLucky){
		sMessage += "<c=lightgreen>";
		if (LOG_RECUT) LogRecut(oPC, "successful luck roll vs " + IntToString(nLuck));
	} else {
		sMessage += "<c=tomato>";
		if (LOG_RECUT) LogRecut(oPC, "Failed luck roll vs " + IntToString(nLuck));
	}
	sMessage += "Luck Roll: " + IntToString(nLuckRoll) + " vs " + IntToString(nLuck) +"%</c>";
	SendMessageToPC(oPC, sMessage);
	return nResult;
}

