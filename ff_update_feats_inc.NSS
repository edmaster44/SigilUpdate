
// constants to control optional epic precision qualifications
const int bGrantToSwash12 = TRUE;
const int bCountBleedingWound = TRUE;
const int bCountWererat = TRUE;

//control whether blackguard loses sneak attack if they become non-evil
const int bOnlyEvilBlackguardSneakAttacks = TRUE;

// control whether to include checks for legacy blackguard class from before the
// conversion to knight, in case of legacy characters
const int bIncludeLegacyBlackguard = FALSE;

// boolean to control whether or not we save character after adjusting sneak dice
const int bSaveAfterThisScript = FALSE;

// integer to control the maximum allowed sneak dice. Cannot be more than 20
const int nMaxAllowedSneakDice = 20;

// class ids
const int idClassThug= 67;
const int idClassShiftingInfiltrator = 212;
const int idClassSlayerOfDomiel = 41;
// only included in case of legacy blackguard characters, this class
// has been replaced by knight, which internally is paladin class id
const int idClassBlackguard = 31;
const int idClassCuprilach = 116;
	
//sneak attack feat ids
const int idFeatSneakAttack1 = 221;
const int idFeatSneakAttack2 = 345;
const int idFeatSneakAttack3 = 346;
const int idFeatSneakAttack4 = 347;
const int idFeatSneakAttack5 = 348;
const int idFeatSneakAttack6 = 349;
const int idFeatSneakAttack7 = 350;
const int idFeatSneakAttack8 = 351;
const int idFeatSneakAttack9 = 352;
const int idFeatSneakAttack10 = 353;
const int idFeatSneakAttack11 = 1032;
const int idFeatSneakAttack12 = 1033;
const int idFeatSneakAttack13 = 1034;
const int idFeatSneakAttack14 = 1035;
const int idFeatSneakAttack15 = 1036;
const int idFeatSneakAttack16 = 1037;
const int idFeatSneakAttack17 = 1038;
const int idFeatSneakAttack18 = 1039;
const int idFeatSneakAttack19 = 1040;
const int idFeatSneakAttack20 = 1041;

// death attack feat ids.
const int idFeatDeathAttack1 = 455;
const int idFeatDeathAttack2 = 456;
const int idFeatDeathAttack3 = 457;
const int idFeatDeathAttack4 = 458;
const int idFeatDeathAttack5 = 459;

// arcane trickster sneak attack feat ids
const int idFeatArcaneTricksterSA1 = 1502;
const int idFeatArcaneTricksterSA2 = 1503;
const int idFeatArcaneTricksterSA3 = 1504;
const int idFeatArcaneTricksterSA4 = 1505;
const int idFeatArcaneTricksterSA5 = 1506;

// blackguard sneak attack feat ids
const int idFeatBlackguardSA1 = 460;
const int idFeatBlackguardSA2 = 461;
const int idFeatBlackguardSA3 = 462;

// guild thief sneak attack feat ids
const int idFeatGuildThiefSA1 = 1562;
const int idFeatGuildThiefSA2 = 1563;
const int idFeatGuildThiefSA3 = 1564;

// other releveant feat ids
const int idFeatCripplingStrike = 222;
const int idFeatEpicPrecision = 2128;
const int idFeatFranticReactions = 1806;
const int idFeatPathOfGuile = 3033;
const int idFeatPsyWarLurk = 21470;
const int idFeatWererat = 2593;
const int idFeatBlackguardPath = 3019;

int fFindSneakFeat(int dice);
int fFindDeathFeat(int dice);
int fFindBgFeat(int dice);
int fFindArcFeat(int dice);
int fFindGuildFeat(int dice);
void fRemoveSneakFeats(object oPC);
int fCalcSneakDice(object oPC);
int fCalcDeathDice(object oPC);
int fCalcOtherSneakFeats(object oPC);
string fCheckForTempSneakDice(object oPC);



// function to calculate sneak dice
int fCalcSneakDice(object oPC)
{
	int nSneakDice = 0;

	// lets do knight first, and make it so that they can lose their sneak dice
	// if they become non-evil, IF the appropriate boolean in this script is set to TRUE
	if (GetHasFeat(idFeatBlackguardPath, oPC)){
		if (bOnlyEvilBlackguardSneakAttacks){
			if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
				nSneakDice += (GetLevelByClass(CLASS_TYPE_PALADIN, oPC) -1) / 3;
		} else {
			nSneakDice += (GetLevelByClass(CLASS_TYPE_PALADIN, oPC) -1) / 3;
		}
	}

	// next legacy blackguards from before they were replaced with knight,
	// just in case of an old returning character, but really they should remake.
	// This is also controlled by a boolean
	if (bIncludeLegacyBlackguard)
		nSneakDice += (GetLevelByClass(idClassBlackguard, oPC) -1) / 3;

	// next half outsider
	if (GetHasFeat(idFeatPathOfGuile, oPC))
		nSneakDice += (GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC, oPC) + 1) /2;

	// psychic warrior
	if (GetHasFeat(idFeatPsyWarLurk, oPC))
		nSneakDice += GetLevelByClass(CLASS_PSYCHIC_WARRIOR, oPC) / 3;

	// rogue
	nSneakDice += (GetLevelByClass(CLASS_TYPE_ROGUE, oPC) + 1) / 2;

	// what I presume to be legacy arcane trickster
	nSneakDice += GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER, oPC) / 2;

	// what I presume to be current arcane trickster
	nSneakDice += GetLevelByClass(CLASS_TYPE_ARCANETRICKSTER_W, oPC) / 2;

	// guild thief
	nSneakDice += (GetLevelByClass(CLASS_TYPE_SHADOWTHIEFOFAMN, oPC) + 1) / 2;

	// thug
	nSneakDice += (GetLevelByClass(idClassThug, oPC) +1 ) / 2 ;

	// vampire via lupus
	nSneakDice += GetLevelByClass(CLASS_TYPE_VAMPIRE_LUP_PRC, oPC) / 2;

	// shadowdancer
	nSneakDice += GetLevelByClass(CLASS_TYPE_SHADOWDANCER,oPC) / 3;

	// marquis cambion
	nSneakDice += GetLevelByClass(CLASS_TYPE_MARQUIS_CAMBION, oPC) / 2;

	// shifting infiltrator
	nSneakDice += (GetLevelByClass(idClassShiftingInfiltrator, oPC) + 1) / 2;
	
	// Cuprilach racial PrC
	nSneakDice += GetLevelByClass(idClassCuprilach, oPC) / 2;

	// warden frantic reactions
	if (GetHasFeat(idFeatFranticReactions)) nSneakDice += 2;
	
	if (nSneakDice > nMaxAllowedSneakDice)nSneakDice = nMaxAllowedSneakDice;

	return nSneakDice;
}

// function to calculate the number of death attack dice
int fCalcDeathDice(object oPC)
{
	int nDeathDice = 0;

	nDeathDice += (GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC) + 1) /2;
	nDeathDice += (GetLevelByClass(idClassSlayerOfDomiel, oPC) + 1) /2;
	if (nDeathDice > 5) nDeathDice = 5;
	return nDeathDice;
}

// calculate additional factors that count as having sneak dice
int fCalcOtherSneakFeats(object oPC){
	int nBonusDice = 0;
	
	// +1 for each bleeding wound if the appropriate boolean in this script is set to true.
	if (bCountBleedingWound)
		nBonusDice += (GetLevelByClass(CLASS_TYPE_INVISIBLE_BLADE, oPC) + 1) / 2;
	
	// +2 for wererat but ONLY if they have their hybrid form and the appropriate boolean
	// in this script is set to TRUE
	if (bCountWererat && GetHasFeat(idFeatWererat, oPC) && GetLevelByClass(CLASS_TYPE_LYCAN_PRC, oPC) >= 4)
		nBonusDice += 2;
	
	return nBonusDice;
}

// function that checks for a character having conditions that might 
// generate temporary sneak attack dice that this script would remove if
// that condition is active while levelling up. For now there's only wererat
// hybrid form, but there may be others in the future.
string fCheckForTempSneakDice(object oPC)
{
	string nMessage = "";

	if (GetHasFeat(idFeatWererat, oPC) && GetLevelByClass(CLASS_TYPE_LYCAN_PRC, oPC) >= 4)
	{
		nMessage =  "WARNING: If you leveled up while Wererat Hybrid Form " + 
			"was active, you have lost your bonus sneak dice until you re-activate "
			+ "that ability.";
	}
	return nMessage;
}


// function that returns the sneak attack feat according to number of sneak dice
int fFindSneakFeat(int dice)
{
	int nFeatID = 0;
	switch (dice)
	{
	case 1: nFeatID = idFeatSneakAttack1;
		break;
	case 2: nFeatID = idFeatSneakAttack2;
		break;
	case 3: nFeatID = idFeatSneakAttack3;
		break;
	case 4: nFeatID = idFeatSneakAttack4;
		break;
	case 5: nFeatID = idFeatSneakAttack5;
		break;
	case 6: nFeatID = idFeatSneakAttack6;
		break;
	case 7: nFeatID = idFeatSneakAttack7;
		break;
	case 8: nFeatID = idFeatSneakAttack8;
		break;
	case 9: nFeatID = idFeatSneakAttack9;
		break;
	case 10: nFeatID = idFeatSneakAttack10;
		break;
	case 11: nFeatID = idFeatSneakAttack11;
		break;
	case 12: nFeatID = idFeatSneakAttack12;
		break;
	case 13:  nFeatID = idFeatSneakAttack13;
		break;
	case 14: nFeatID = idFeatSneakAttack14;
		break;
	case 15: nFeatID = idFeatSneakAttack15;
		break;
	case 16:  nFeatID = idFeatSneakAttack16;
		break;
	case 17:  nFeatID = idFeatSneakAttack17;
		break;
	case 18: nFeatID = idFeatSneakAttack18;
		break;
	case 19: nFeatID = idFeatSneakAttack19;
		break;
	default: nFeatID = idFeatSneakAttack20;
		break;
	}
	return nFeatID;
}

// function that returns the appropriate death attack feat based on number of dice
int fFindDeathFeat(int dice)
{
	int nFeatID = 0;
	switch (dice)
	{
	case 1:  nFeatID = idFeatDeathAttack1; 
		break;
	case 2:  nFeatID = idFeatDeathAttack2;
		break;
	case 3:  nFeatID = idFeatDeathAttack3;
		break;
	case 4:  nFeatID = idFeatDeathAttack4;
		break;
	default:  nFeatID = idFeatDeathAttack5;
		break;
	}
	return nFeatID;
}

// function that returns the blackguard sneak attack feat ids
int fFindBgFeat(int dice)
{
	int nFeatID = 0;
	switch (dice)
	{
	case 1: nFeatID = idFeatBlackguardSA1;
		break;
	case 2: nFeatID = idFeatBlackguardSA2;
		break;
	default: nFeatID = idFeatBlackguardSA3;
		break;
	}
	return nFeatID;
}

// function that returns the arcane trickster sneak attack feat ids
int fFindArcFeat(int dice)
{
	int nFeatID = 0;
	switch (dice)
	{
	case 1: nFeatID = idFeatArcaneTricksterSA1;
		break;
	case 2: nFeatID = idFeatArcaneTricksterSA2;
		break;
	case 3: nFeatID = idFeatArcaneTricksterSA3;
		break;
	case 4: nFeatID = idFeatArcaneTricksterSA4;
		break;
	default: nFeatID = idFeatArcaneTricksterSA5;
		break;
	}
	return nFeatID;
}

// function that returns the guild thief sneak attack feat ids
int fFindGuildFeat(int dice)
{
	int nFeatID = 0;
	switch (dice)
	{
	case 1: nFeatID = idFeatGuildThiefSA1;
		break;
	case 2: nFeatID = idFeatGuildThiefSA2;
		break;
	default: nFeatID = idFeatGuildThiefSA3;
		break;
	}
	return nFeatID;
}

//Remove all sneak attack feats of all flavours. Also remove epic precision UNLESS
//the character qualified for it by choosing Crippling Strike first (possible without 5d6
// sneak through Lupus vampire).
void fRemoveSneakFeats(object oPC)
{
	// remove basic sneak attack feats
	int i;
	int nFeatID = idFeatSneakAttack1;
	for (i = 1; i <= 20; i++)
	{
		nFeatID = fFindSneakFeat(i);
		FeatRemove(oPC, nFeatID);
	}

	// remove death attack feats
	for (i = 1; i <= 5; i++)
	{
		nFeatID = fFindDeathFeat(i);
		FeatRemove(oPC, nFeatID);
	}
		
	// remove blackguard sneak attack feats
	for (i = 1; i <= 3; i++)
	{
		nFeatID = fFindBgFeat(i);
		FeatRemove(oPC, nFeatID);
	}
			
	// remove arcane trickster sneak attack feats
	for (i = 1; i <= 5; i++)
	{
		nFeatID = fFindArcFeat(i);
		FeatRemove(oPC, nFeatID);
	}
		
	// remove guild thief sneak attack feats
	for (i = 1; i <= 3; i++)
	{
		nFeatID = fFindGuildFeat(i);
		FeatRemove(oPC, nFeatID);
	}	
		
	// remove epic precision but only if the character didn't qualify for it normally
	if (!GetHasFeat(idFeatCripplingStrike, oPC))
	{
		FeatRemove(oPC, idFeatEpicPrecision);
	}
}
// End remove feats



