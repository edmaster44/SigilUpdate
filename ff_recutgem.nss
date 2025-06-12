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

void ShowRecutResult(object oPC, object oRecut, string sMessage);
void VerifyNewGem(object oPC, object oOldGem, object oRecut, string sName, string sDescrip);
void PerformCut(object oPC, object oGem, int nQuality, int nRoll, int bImprove);
int RollForCut(object oPC, object oGem, int nQuality, int bImprove);

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

	int nRoll = RollForCut(oPC, oGem, nQuality, bImprove);
	PerformCut(oPC, oGem, nQuality, nRoll, bImprove);
}

void PerformCut(object oPC, object oGem, int nQuality, int nRoll, int bImprove){

	string sMessage = "<c=tomato>";
	string sName = GetFirstName(oGem);
	string sDescrip = GetGemstoneDescription(oGem);
	
	string sTag = GetTag(oGem);
	object oRecut;

	if (nRoll == NAT_1){
		sMessage += "You rolled a natural 1! You've shattered the gem.</c>";
		SendMessageToPC(oPC, sMessage);
		int nStack = GetItemStackSize(oGem);
		if (nStack > 1) SetItemStackSize(oGem, nStack - 1);
		else DestroyObject(oGem, 0.3f);
		return;
	}
	
	if (nRoll == SIMPLE_FAIL){
		sName += " <c=tomato>Failed Recut</c>";
		sDescrip = GetDescription(oGem);
		oRecut = CreateItemOnObject(GetResRef(oGem), oPC, 1, sTag);
		DelayCommand(0.3f, VerifyNewGem(oPC, oGem, oRecut, sName, sDescrip));
		sMessage += "You can tell that this gem cannot be recut without destroying it.</c>";
		ShowRecutResult(oPC, oRecut, sMessage);
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
		sName += " <c=grey> -small</c>";
	sName += " <c=tomato>Re-Cut</c>";
	
	//get new description for re-cut gem, sDescrip
	sDescrip += GetGemstoneUses(GetBaseGemTagFromString(sNewTag), nNewQ);
	
	// create the newly recut gem, 
	oRecut = CreateItemOnObject(GetResRef(oGem), oPC, 1, sNewTag);
	//then make sure everything is kosher and clean up
	DelayCommand(0.3f, VerifyNewGem(oPC, oGem, oRecut, sName, sDescrip));
	
	//let the player know the result

	sMessage = "<c=lightgreen>";
	if (nRoll == NAT_20)
			sMessage += "You rolled a natural 20!/n";

	sMessage += "You've successfully recut the gem!</c>";
	
	DelayCommand(0.3f, ShowRecutResult(oPC, oRecut, sMessage));
}

void ShowRecutResult(object oPC, object oRecut, string sMessage){
	if (!GetIsObjectValid(oRecut)){
		sMessage = "<c=tomato>Error generating re-cut gem.\n";
		sMessage += "Please make sure you have an empty inventory slot.\n";
		sMessage += "If you do have an empty slot and get this message, contact support.</c>";
	}
	SendMessageToPC(oPC, sMessage);
}

void VerifyNewGem(object oPC, object oOldGem, object oRecut, string sName, string sDescrip){
	
	if (!GetIsObjectValid(oRecut))return;

	int nStack = GetItemStackSize(oOldGem);
	if (nStack > 1) SetItemStackSize(oOldGem, nStack -1);
	else DestroyObject(oOldGem);
	
	//mark the gem so that i_smithhammer_ac won't let us recut a gem more than once
	SetLocalInt(oRecut, "recut", TRUE); 
	SetFirstName(oRecut, sName);
	SetDescription(oRecut, sDescrip);
}

// roll for the recut
// returns -1 if nat 1 roll (crit failure, destroys gem
// returns 20 if nat 20 roll, auto success
// returns true if simple success
// returns false if simple failure
int RollForCut(object oPC, object oGem, int nQuality, int bImprove){
	int nResult = SIMPLE_FAIL;
	string sMessage;
	int nDC = 30;
	int nMod = GetSkillRank(SKILL_APPRAISE, oPC, FALSE);
	
	// if we're improving gems, then the DC range is 35 - 99
	// as expressed by 31 + 3d20 + 1d8.
	// but it will be "weighted" towards higher numbers in the
	// range depending upon the quality and rarity of the gem.
	// For each factor, one d20 will be rolled an additional time
	// and the higher result used. These factors are:
	// going from regular quality to flawless = 1 die reroll
	// sunstone or bloodstone = 1 die reroll
	// jasmal or diamond = 2 die reroll. (but not black diamonds)
	// So if we're improving a regular jasmal to flawless then 
	// all 3 of the d20's will be rolled twice each and the higher
	// result used each time.
	if (bImprove){
		nDC += d8() + 1;
		int nFirstDie = d20();
		int nSecondDie = d20();
		int nThirdDie = d20();
		int nReRoll = 0;
		
		// find out what general category of the most used gems
		string sTag = GetStringLowerCase(GetTag(oGem));
		int bIsHealthGem = FALSE;
		if (FindSubString(sTag, "sunstone") >= 0 ||
			FindSubString(sTag, "bloodstone") >= 0)
				bIsHealthGem = TRUE;
		int bIsEnhanceGem = FALSE;
		if ((FindSubString(sTag, "diamond") >= 0 ||
			FindSubString(sTag, "jasmal") >= 0) &&
			FindSubString(sTag, "black") == -1)
				bIsEnhanceGem = TRUE;
		
		// now find out how many of the d20s will be weighted
		
		// First d20 is weighted if we're going from reg to flawless
		if (nFirstDie < 20 && nQuality > 0){
			nReRoll = d20();
			if (nReRoll > nFirstDie) nFirstDie = nReRoll;
		}
	
		// Second die is weighted if it's any of the 4 most sought after
		if (nSecondDie < 20 && (bIsHealthGem || bIsEnhanceGem)){
			nReRoll = d20();
			if (nReRoll > nSecondDie) nSecondDie = nReRoll;
		}
		// Third die is weighted if it's a diamond or jasmal
		if (nThirdDie < 20 && bIsEnhanceGem){
			nReRoll = d20();
			if (nReRoll > nThirdDie) nThirdDie = nReRoll;
				
		}
		nDC += nFirstDie + nSecondDie + nThirdDie;		
	}
	int nRoll = d20();
	
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