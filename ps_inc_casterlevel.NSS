//Gets caster progression for the given classID from the 2das
//can safely be passed CLASS_TYPE_INVALID
int GetCasterLevelFromClass(object oPC, int classID) {

	if (classID == CLASS_TYPE_INVALID)
		return 0;
	
	int nCasterLevel = 0; 
	int nCount;
	int isCaster = StringToInt(Get2DAString("classes", "SpellCaster", classID));
	if (isCaster) { //is base class spellcaster
		nCasterLevel += GetLevelByClass(classID, oPC);
	} else {
		string bonusTable = Get2DAString("classes", "BonusSpellcasterLevelTable", classID);
		if (bonusTable != "" && bonusTable != "****") {
			int nLevel = GetLevelByClass(classID, oPC);
			for (nCount = 0; nCount <= nLevel; nCount++) {
				int nBonus = StringToInt(Get2DAString(bonusTable, "GrantsBonusSpellcasterLevel", nCount));
				nCasterLevel += nBonus;
			}
		}
	}
	return nCasterLevel;
}

//returns feat-based caster level boni - for practiced spellcaster
int GetFeatGrantedCasterLevel(object oPC) {
	
	int nCasterLevel = 0;
	if (GetLevelByClass(CLASS_TYPE_BARD, oPC) > 0 &&
	GetHasFeat(FEAT_PRACTICED_SPELLCASTER_BARD, oPC)) {
		nCasterLevel += 4;
	} else if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0 &&
	GetHasFeat(FEAT_PRACTICED_SPELLCASTER_CLERIC, oPC)) {
		nCasterLevel += 4;
	} else if (GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0 &&
	GetHasFeat(FEAT_PRACTICED_SPELLCASTER_DRUID, oPC)) {
		nCasterLevel += 4;
	} else if (GetLevelByClass(CLASS_TYPE_PALADIN, oPC) > 0 &&
	GetHasFeat(FEAT_PRACTICED_SPELLCASTER_PALADIN, oPC)) {
		nCasterLevel += 4;
	} else if (GetLevelByClass(CLASS_TYPE_RANGER, oPC) > 0 &&
	GetHasFeat(FEAT_PRACTICED_SPELLCASTER_RANGER, oPC)) {
		nCasterLevel += 4;
	} else if (GetLevelByClass(CLASS_TYPE_SORCERER, oPC) > 0 &&
	GetHasFeat(FEAT_PRACTICED_SPELLCASTER_SORCERER, oPC)) {
		nCasterLevel += 4;
	} else if (GetLevelByClass(CLASS_TYPE_WIZARD, oPC) > 0 &&
	GetHasFeat(FEAT_PRACTICED_SPELLCASTER_WIZARD, oPC)) {
		nCasterLevel += 4;
	}
	return nCasterLevel;
}

//Pulled out of the manifestation struct for using more generically
int GetPsionicCasterLevel(object oPC) {
	int nPsionLevel = GetLevelByClass(90, oPC);
	int nIllithidMentalistLevel = GetLevelByClass(100,oPC);
	int nGemDragonLevel = GetLevelByClass(128, oPC);
	int nCerebremancerLevel = GetLevelByClass(152, oPC);
	int nPsyKnightLevel = GetLevelByClass(109, oPC);
	int nPsyWarriorLevel = GetLevelByClass(110, oPC);
	int nWarmindLevel = GetLevelByClass(111, oPC);
	
	return nPsionLevel + nIllithidMentalistLevel + nGemDragonLevel + nCerebremancerLevel + 
		nPsyKnightLevel + nPsyWarriorLevel + nWarmindLevel;

	/*
	We don't need to make 2 function calls for each class, and there were some missing.
	- FlattedFifth, June 3, 2024
	int nManifesterLevel = GetLevelByClass(90, oPC);
	if(GetLevelByClass(100, oPC) > 0)
    {
        nManifesterLevel = nManifesterLevel + GetLevelByClass(100, oPC);
    }
	if(GetLevelByClass(152, oPC) > 0)
	{
        nManifesterLevel = nManifesterLevel + GetLevelByClass(152, oPC);
    }
	if(GetLevelByClass(128, oPC) > 0)
	{
        nManifesterLevel = nManifesterLevel + GetLevelByClass(128, oPC);
    }
	return nManifesterLevel;
	*/
}

//Gets the PC's caster level, via 2da and feats
//Does not require you to cast a spell first
//A bit slower than GetCasterLevel - only use for non-spells
int GetRealCasterLevel(object oPC) {

	int nCasterLevel = 0;
	int nPsionicLevel = GetPsionicCasterLevel(oPC);
	
	int class1 = GetClassByPosition(1, oPC);
	nCasterLevel = GetCasterLevelFromClass(oPC, class1);
	
	int class2 = GetClassByPosition(2, oPC);
	nCasterLevel += GetCasterLevelFromClass(oPC, class2);
	
	int class3 = GetClassByPosition(3, oPC);
	nCasterLevel += GetCasterLevelFromClass(oPC, class3);
	
	int class4 = GetClassByPosition(4, oPC);
	nCasterLevel += GetCasterLevelFromClass(oPC, class4);
	
	//Account for Practiced Spellcaster
	nCasterLevel += GetFeatGrantedCasterLevel(oPC);
	
	if (nPsionicLevel > nCasterLevel)
		return nPsionicLevel;
	else
		return nCasterLevel;
}