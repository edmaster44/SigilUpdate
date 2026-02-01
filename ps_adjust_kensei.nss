// Script to give Kensei feats associated with their signature weapon without having
// to check for normal qualifications (ex: fighter levels for Greater Weap Focus
// -FlattedFifth, Jan 30, 2026

//signature weapon constants for readability
const int SW_HALBERD = 	3081;
const int SW_KAMA =		3082;
const int SW_KATANA =	3083;
const int SW_NINJATO =	3084;
const int SW_ODACHI =	3085;
const int SW_SPEAR =	3086;
const int SW_STAFF =	3087;
const int SW_DAGGER =	3088;
const int SW_FLAIL =	3089;
const int SW_MACE =		3090;
const int SW_WARMACE =	3091;


void PS_KenseiLevels(object oPC){
	
	int iKenseiLevel = GetLevelByClass(66, oPC);
	
	// if kensei levels less than 3, exit because this script concerns itself with lvls 3, 6 and 7
	if (iKenseiLevel < 3)
		return;
		
	//Determine which weapon feats to grant based on signature weapon
	int iImprovedCrit;
	int iPowerCrit;
	int iGrtWeapFoc;
	
	if (GetHasFeat(SW_HALBERD, oPC, TRUE)){
		iImprovedCrit = FEAT_IMPROVED_CRITICAL_HALBERD;
		iPowerCrit = FEAT_POWER_CRITICAL_HALBERD;
		iGrtWeapFoc = FEAT_GREATER_WEAPON_FOCUS_HALBERD;
		
	} else if (GetHasFeat(SW_KAMA, oPC, TRUE)){
		iImprovedCrit = FEAT_IMPROVED_CRITICAL_KAMA;
		iPowerCrit = FEAT_POWER_CRITICAL_KAMA;
		iGrtWeapFoc = FEAT_GREATER_WEAPON_FOCUS_KAMA;
		
	} else if (GetHasFeat(SW_KATANA, oPC, TRUE)){
		iImprovedCrit = FEAT_IMPROVED_CRITICAL_KATANA;
		iPowerCrit = FEAT_POWER_CRITICAL_KATANA;
		iGrtWeapFoc = FEAT_GREATER_WEAPON_FOCUS_KATANA;
		
	} else if (GetHasFeat(SW_NINJATO, oPC, TRUE)){
		iImprovedCrit = 3251;
		iPowerCrit = 3250;
		iGrtWeapFoc = 3254;
		
	} else if (GetHasFeat(SW_ODACHI, oPC, TRUE)){
		iImprovedCrit = 3241;
		iPowerCrit = 3240;
		iGrtWeapFoc = 3244;
		
	} else if (GetHasFeat(SW_SPEAR, oPC, TRUE)){
		iImprovedCrit = 59;
		iPowerCrit = 1352;
		iGrtWeapFoc = 1126;
		
	} else if (GetHasFeat(SW_STAFF, oPC, TRUE)){
		iImprovedCrit = 58;
		iPowerCrit = 1125;
		iGrtWeapFoc = 1351;
		
	} else if (GetHasFeat(SW_DAGGER, oPC, TRUE)){
		iImprovedCrit = 52;
		iPowerCrit = 1345;
		iGrtWeapFoc = 1119;
		
	} else if (GetHasFeat(SW_FLAIL, oPC, TRUE)){
		iImprovedCrit = 76;
		iPowerCrit = 1369;
		iGrtWeapFoc = 1143;
		
	} else if (GetHasFeat(SW_MACE, oPC, TRUE)){
		iImprovedCrit = 56;
		iPowerCrit = 1349;
		iGrtWeapFoc = 1123;
		
	} else if (GetHasFeat(SW_WARMACE, oPC, TRUE)){
		iImprovedCrit = 1825;
		iPowerCrit = 1831;
		iGrtWeapFoc = 1829;
		
	} else return; // exit if no signature weapon found
	
	// Apply weapon feats
	if (iKenseiLevel >= 3 && !GetHasFeat(iImprovedCrit, oPC, TRUE))
		FeatAdd(oPC, iImprovedCrit, FALSE, TRUE);
		
	if (iKenseiLevel >= 5 && !GetHasFeat(iPowerCrit, oPC, TRUE))
		FeatAdd(oPC, iPowerCrit, FALSE, TRUE);
		
	if (iKenseiLevel >= 6 && !GetHasFeat(iGrtWeapFoc, oPC, TRUE))
		FeatAdd(oPC, iGrtWeapFoc, FALSE, TRUE);
}