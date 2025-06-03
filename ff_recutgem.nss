// Script for re-cutting gems. Called from i_smithhammer_ac when you use the smithing
// hammer on a gem while being in possession of an adamantine dagger to use as a
// gemcutter's chisel. Gems that already have the "recut" local int set to true will not
// call this script. -FlattedFifth, June 2, 2025


#include "ginc_crafting"
#include "x2_inc_switches"
#include "ps_inc_functions"
#include "ps_inc_newcraft_include"

int GetGemQualityFromRes(object oGem);
void RollForCut(object oPC, object oGem, int bImprove, int nQuality);

void main(int bImprove){
	object oPC = GetPCSpeaker();
	object oGem = GetLocalObject(oPC, "gem_to_be_recut");

	int nQuality = GetGemQualityFromRes(oGem);
	if (nQuality == 0){
		SendMessageToPC(oPC, "<c=red>Error: Unrecognized Gem</c>");
		return;
	} else if (bImprove){
		if (nQuality == 3){
			SendMessageToPC(oPC, "<c=red>Gem is already flawless.</c>");
			return;
		}
	} else {
		if (nQuality == 1){
			SendMessageToPC(oPC, "<c=red>Gem is already flawed</c>");
			return;
		}
	}
	RollForCut(oPC, oGem, bImprove, nQuality);
}

void RollForCut(object oPC, object oGem, int bImprove, int nQuality){
	int bSuccess;
	string sMessage;
	int nRoll = d20(1);
	if (nRoll == 1){
		bSuccess = FALSE;
		sMessage =  "<c=red>You rolled a natural 1! You've shatterd the gem.</c>";
	} else if (nRoll == 20){
		bSuccess = TRUE;
		sMessage =  "<c=green>You rolled a natural 20! You've successfully recut the gem.</c>";
	} else {
		int nDC;
		int nMod = GetSkillRank(SKILL_APPRAISE, oPC, FALSE);
		if (bImprove)
			nDC = 30 + d10(5);
		else nDC = 30;
		if (nRoll + nMod >= nDC){
			bSuccess = TRUE;
			sMessage = "<c=green>You've successfully recut the gem!</c>";
		} else {
			bSuccess = FALSE;
			sMessage = "<c=Red>You can tell that recutting this gem would destroy it.</c>";
		}
	}
	
	SendMessageToPC(oPC, sMessage);
	if (nRoll == 1){
		DestroyObject(oGem, 0.2f);
	} else {
		
		SetLocalInt(oGem, "recut", TRUE);
		string sName = GetName(oGem);
		string sTag = GetTag(oGem);
		if (bSuccess){
			string sNewQ = "_q";
			if (bImprove){
				sNewQ += IntToString(nQuality + 1);
				if (nQuality == 1){
					if (GetStringLeft(sName, 7) == "Flawed ")
						sName = GetStringRight(sName, GetStringLength(sName) - 7);
				} else sName = "Flawless " + sName;
			} else {
				sNewQ += IntToString(nQuality - 1);
				if (nQuality == 3){
					if (GetStringLeft(sName, 9) == "Flawless ")
						sName = GetStringRight(sName, GetStringLength(sName) - 9);
					else sName = "Flawed " + sName;
				}
			}
			sTag = GetStringLeft(sTag, GetStringLength(sTag) - 3) + sNewQ;
			SetTag(oGem, sTag);
			sName += " <c=grey>Re-Cut</c>";
		} else {
			sName += " <c=grey>Failed Recut</c>";
		}
		SetFirstName(oGem, sName);
	}
}


int GetGemQualityFromRes(object oGem){
	string sRes = GetResRef(oGem);
	if (FindSubString(sRes, "_q1") != -1) return 1;
	else if (FindSubString(sRes, "_q2") != -1) return 2;
	else if (FindSubString(sRes, "_q3") != -1) return 3;
	return 0;
}