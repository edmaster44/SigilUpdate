

#include "ff_feat_tactical_weapon_inc"


//called from ps_inc_equipment. 
void FF_TacticalWeapons(object oPC, object oRHAND, object oSkin){

	int nTacRange = GetTacSuiteByWeaponCategory(oPC, oRHAND);
	string sMessage = "Tactical ";
	string sManeuver = "";
	int nFeat = NULL;
	switch (nTacRange){
		case TAC_SUITE_BOW:{
			sManeuver = "Disabling Strike";
			break;
		}
		case TAC_SUITE_CE:{
			sMessage += "Combat Expertise";
			sManeuver = "Disabling Strike";
			nFeat = FEAT_COMBAT_EXPERTISE;
			break;
		}
		case TAC_SUITE_CLEAVE:{
			sMessage += "Cleave";
			sManeuver = "Hewing";
			nFeat = FEAT_CLEAVE;
			break;
		}
		case TAC_SUITE_PA:{
			sMessage += "Power Attack";
			sManeuver = "Roundhouse";
			nFeat = FEAT_POWER_ATTACK;
			break;
		}
		case TAC_SUITE_DISARM:{
			sMessage += "Disarm";
			sManeuver = "Entagling";
			nFeat = FEAT_DISARM;
			break;
		}
		case TAC_SUITE_KD:{
			sMessage += "Knockdown";
			sManeuver = "Leg-Sweep";
			nFeat = FEAT_KNOCKDOWN;
			break;
		}
		default:{
			nTacRange = TAC_SUITE_NONE;
			sMessage = "Bonuses and Maneuvers Disabled";
			break;
		}
	}
	if (nTacRange != TAC_SUITE_NONE){
		// ranged weapons dont get a bonus feat in this way
		if (nTacRange != TAC_SUITE_BOW){
			sMessage += " Bonus Feat Granted\n";
			ApplyTacticalBonusFeat(oSkin, nFeat);
		} else  sMessage = ""; 
		sMessage += sManeuver + " Maneuver Enabled"; // but ranged gets a Maneuver	
	}
	// make sure we don't double-message, doesn't have to persist across resets
	if (GetLocalString(oPC, "tac_message") != sMessage){
		SendMessageToPC(oPC, sMessage);
		SetLocalString(oPC, "tac_message", sMessage);
	}

}