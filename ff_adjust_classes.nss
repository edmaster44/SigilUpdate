#include "ps_inc_functions"
#include "ff_track_classes"

void LaunchGuiChoices(object oPC, string sParam);
void AdjustHalfUndead(object oPC, int nLastLevel);
void AdjustVampMaleficus(object oPC, int nLastLevel);
void AdjustHalfOutsider(object oPC, int nLastLevel);
void AdjustAbilityScore(object oPC, int nAbility, int nAmount);
void AdjustDragonPrC(object oPC, int nLvl);
void PS_HD_SetAlignmentsByHeritage(object oPC, object oEss);

//this feat fetches the most recent class leveled up and what it was leveled up to by checking local integers
//tracked on the character's essence, one integer for each of the four class positions. This is for functions, 
//such as ability score adjustments and launching the custom feat selection UI, that we need to happen on specific 
//levels of specific classes and then never repeated. We could make sure of non repetition by storing a bunch of local 
//integers for each separate feature, but that woud entail dozens of local integers instead of 4. This is cleaner.
void FF_AdjustClasses(object oPC){
	//this will be removed once we transition to gui for mentalist power selection because this will
	//be moved to 2da
	if (GetLevelByClass(110, oPC) >= 1 && !GetHasFeat(21470, oPC) && !GetHasFeat(21471, oPC))
		LaunchGuiChoices(oPC, "PSYWAR_START");

	object oEss = PS_GetEssence(oPC);
	int nLastClass = GetLastClassLeveledUp(oPC);
	if (nLastClass == -1 || nLastClass == -2){
		string sMessage = "Error in function FF_AdjustClasses in script ff_adjust_classes.";
		if (nLastClass == -1) sMessage += "\nEssence not found";
		else if (nLastClass == -2) sMessage += "\nLast leveled up class not found";
		sMessage += "\nPlease screenshot this entire message and send to an admin on our Discord.";
		SendMessageToPC(oPC, sMessage);
		return;
	}
	
	int nLastClassLevel = GetLevelByClass(nLastClass, oPC);
	if (nLastClass == 129 || nLastClass == 130) // new dragon prc
		AdjustDragonPrC(oPC, nLastClassLevel);
	else if (nLastClass == CLASS_TYPE_HALFOUTSIDER_PRC){
		AdjustHalfOutsider(oPC, nLastClassLevel);
	} else if (nLastClass == CLASS_TYPE_HALF_UNDEAD){
		AdjustHalfUndead(oPC, nLastClassLevel);
	} else if (nLastClass == CLASS_TYPE_VAMPIRE_MAL_PRC){
		AdjustVampMaleficus(oPC, nLastClassLevel);
	} else if (nLastClass == CLASS_TYPE_NATUREWARRIOR){
		if (nLastClassLevel == 1 || nLastClassLevel == 3 || nLastClassLevel == 5)
			LaunchGuiChoices(oPC, "NATURE_WARRIOR_START");
	} else if (nLastClass == CLASS_TYPE_LYCAN_PRC && nLastClassLevel == 1){
		LaunchGuiChoices(oPC, "LYCAN_START");
		SetLocalString(oEss, "Template", "Lycan");
		SetLocalInt(oEss, "Lycan_Affliction", 1); 
	} else if (nLastClass == 49){ // half dragon
		if (nLastClassLevel == 1){
			PS_HD_SetAlignmentsByHeritage(oPC, oEss);
			SetLocalString(oEss, "Template", "HalfDragon");
		} else if (nLastClassLevel == 6){
			LaunchGuiChoices(oPC, "HALF_DRAGON_START");
			PS_TintFixer(oPC); 
		}
	} else if (nLastClass == 42 && nLastClassLevel == 1){ //celestial envoy
		LaunchGuiChoices(oPC, "CELESTIAL_ENVOY_START");
	} else if (nLastClass == 108 && nLastClassLevel == 6){ // gray sladd crafting
		LaunchGuiChoices(oPC, "GRAY_SLAAD_START");
	}
	ExportSingleCharacter(oPC);
}

void LaunchGuiChoices(object oPC, string sParam){
	AddScriptParameterString(sParam);
	AddScriptParameterString("");
	ExecuteScriptEnhanced("gui_extra_choices", oPC);
}

void AdjustAbilityScore(object oPC, int nAbility, int nAmount){
	int nScore = GetAbilityScore(oPC, nAbility, TRUE);
	nScore += nAmount;
	SetBaseAbilityScore(oPC, nAbility, nScore);
}

//helper function for AdjustHalfOutsider()
void SetHoHeritage(object oPC, object oEss, string sOutsider){
	if (sOutsider == "HalfFiend") FeatAdd(oPC, 2537, FALSE); 
	else FeatAdd(oPC, 2538, FALSE);
	SetLocalString(oEss, "Planar", sOutsider);
}

void AdjustHalfOutsider(object oPC, int nLastLevel){  //half outsider template
	object oEss = GetItemPossessedBy(oPC,"ps_essence");
	if (nLastLevel == 6){ 
		//APOTHEOSIS
		if (GetOriginalRace(oPC) != RACIAL_TYPE_OUTSIDER ||
			GetOriginalSubrace(oPC) != RACIAL_SUBTYPE_OUTSIDER){
				SetLocalString(oEss, "Template", "HalfOutsider");
				SetLocalString(oEss, "RaceChange", "Outsider");
				SetLocalInt(oEss, "TemplateFix", 0);
				PS_SetRacialType(oPC, RACIAL_TYPE_OUTSIDER);
				PS_SetSubRacialType(oPC, RACIAL_SUBTYPE_OUTSIDER);
		}	
		// add +2 ability according to spell progression feat
		int nAbility = ABILITY_CHARISMA;
		if (GetHasFeat(3028, oPC) || GetHasFeat(3032, oPC) || GetHasFeat(3031, oPC) ||
			GetHasFeat(2989, oPC) || GetHasFeat(3037, oPC)) 
				nAbility = ABILITY_WISDOM;
		else if (GetHasFeat(3026, oPC) || GetHasFeat(2988, oPC)) 
			nAbility = ABILITY_INTELLIGENCE;
		else if (GetHasFeat(2987, oPC))
			nAbility = ABILITY_CONSTITUTION;
		AdjustAbilityScore(oPC, nAbility, 2);
		
	} else if (nLastLevel == 3){
		if (GetHasFeat(3034, oPC)){ //path of strength
			FeatAdd(oPC, 28, FALSE); // power attack
		} else if (GetHasFeat(3038, oPC) || GetHasFeat(3039, oPC) || 
			GetHasFeat(3040, oPC)){// mental ability paths
				FeatAdd(oPC, 7, FALSE);  // combat casting
		}
		// add toughness feat for those who did not progress spells
		if (GetHasFeat(2987, oPC))
			FeatAdd(oPC, 40, FALSE);
	// if lvl 1 and has not had heritage assigned
 	} else if (nLastLevel == 1 && !GetHasFeat(2537, oPC) && !GetHasFeat(2538, oPC)){
		if (GetHasFeat(81, oPC) && GetHasFeat(86, oPC)){ // if has both backgrounds
			int nSub = GetSubRace(oPC);
			// if user set path ahead of time with chat command available 
			// to characters with both history feats
			string sPreset = GetLocalString(oEss, "HOpathPreset");
			if (sPreset != ""){
				if (sPreset == "fiend") SetHoHeritage(oPC, oEss, "HalfFiend");
				else if (sPreset == "celestial") SetHoHeritage(oPC, oEss, "HalfCelestial");
				DeleteLocalString(oEss, "HOpathPreset");
			} else if (nSub == RACIAL_SUBTYPE_TIEFLING){
				if (GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL) SetHoHeritage(oPC, oEss, "HalfCelestial");
				else SetHoHeritage(oPC, oEss, "HalfFiend");
			} else if (nSub == RACIAL_SUBTYPE_AASIMAR){
				if (GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD) SetHoHeritage(oPC, oEss, "HalfFiend");
				else SetHoHeritage(oPC, oEss, "HalfCelestial");
			} else SetHoHeritage(oPC, oEss, "HalfFiend");// default in case there's any I missed
		} else if (GetHasFeat(81, oPC)){//fiendish
			SetHoHeritage(oPC, oEss, "HalfFiend");
		} else if (GetHasFeat(86, oPC) && !GetHasFeat(2538)){ // celestial
			SetHoHeritage(oPC, oEss, "HalfCelestial");
		}
	}
	// gui launch
	if (nLastLevel == 6 || nLastLevel == 2){
		string sArg = (nLastLevel == 6) ? "HO_APOTHEOSIS_START" : "HO_PATH_START";
		LaunchGuiChoices(oPC, sArg);
	}
}

void AdjustHalfUndead(object oPC, int nLastLevel){
	if (nLastLevel == 1){
		LaunchGuiChoices(oPC, "HALF_UNDEAD_START");
	}
	if (GetHasFeat(3049, oPC)){ //half vampire
		if (nLastLevel == 2){
			int nDex = GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE);
			int nStr = GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE);
			int nBuff = (nDex > nStr) ? ABILITY_DEXTERITY : ABILITY_STRENGTH;
			AdjustAbilityScore(oPC, nBuff, 2);
		} else if (nLastLevel == 3 || nLastLevel == 5){
			AdjustAbilityScore(oPC, ABILITY_STRENGTH, 1);
			AdjustAbilityScore(oPC, ABILITY_DEXTERITY, 1);
			AdjustAbilityScore(oPC, ABILITY_CHARISMA, 1);
		}
	} else if (GetHasFeat(3051, oPC)){ //fetch
		if (nLastLevel == 2){
			AdjustAbilityScore(oPC, ABILITY_CHARISMA, 2);
		} else if (nLastLevel == 3 || nLastLevel == 5){
			AdjustAbilityScore(oPC, ABILITY_CONSTITUTION, 1);
			AdjustAbilityScore(oPC, ABILITY_DEXTERITY, 1);
			AdjustAbilityScore(oPC, ABILITY_CHARISMA, 1);
		}
	} else if (GetHasFeat(3050, oPC)){ //ghul
		if (nLastLevel == 2){
			AdjustAbilityScore(oPC, ABILITY_DEXTERITY, 2);
		} else if (nLastLevel == 3 || nLastLevel == 5){
			AdjustAbilityScore(oPC, ABILITY_CONSTITUTION, 1);
			AdjustAbilityScore(oPC, ABILITY_DEXTERITY, 1);
			AdjustAbilityScore(oPC, ABILITY_STRENGTH, 1);
		}
	} else if (GetHasFeat(3052, oPC)){ //ghedan
		if (nLastLevel == 2){
			AdjustAbilityScore(oPC, ABILITY_STRENGTH, 2);
			AdjustAbilityScore(oPC, ABILITY_CONSTITUTION, 2);
			AdjustAbilityScore(oPC, ABILITY_CHARISMA, -2);
		} else if (nLastLevel == 3 || nLastLevel == 5){
			AdjustAbilityScore(oPC, ABILITY_CONSTITUTION, 1);
			AdjustAbilityScore(oPC, ABILITY_STRENGTH, 1);
		}
	} 
}


void AdjustVampMaleficus(object oPC, int nLastLevel){
	if (nLastLevel < 3) return;
	int nAbility = ABILITY_WISDOM;
	if (GetHasFeat(2572, oPC) || GetHasFeat(2575, oPC) || GetHasFeat(2579, oPC) || 
		GetHasFeat(2580, oPC) || GetHasFeat(2883, oPC)) // charisma casters
			nAbility = ABILITY_CHARISMA;
	else if (GetHasFeat(2577, oPC) || GetHasFeat(2881, oPC)) // wizard and psion		
			nAbility = ABILITY_INTELLIGENCE;
	
	if (nLastLevel == 3 || nLastLevel == 5 || nLastLevel == 7)
		AdjustAbilityScore(oPC, nAbility, 2);
	if (nLastLevel == 6){
		AddScriptParameterString("VAMP_MAL_START");
		AddScriptParameterString("");
		ExecuteScriptEnhanced("gui_extra_choices", oPC);
	}
}

void AdjustDragonPrC(object oPC, int nLvl){

	int nPsyLvl = GetLevelByClass(130, oPC); // new psy dragon prc
	
	// psy/psi path feats have to be granted automatically based on which
	// class they have more lvls of, because I can't make the 2da not give
	// psy/psi power feats on a particular lvl
	if (nPsyLvl == 1){ 
		if (!GetHasFeat(3679, oPC) && !GetHasFeat(3680, oPC)){
			if (GetLevelByClass(CLASS_TYPE_PSION, oPC) > 
				GetLevelByClass(CLASS_PSYCHIC_WARRIOR, oPC))
					FeatAdd(oPC, 3679, FALSE); //psion path
			else FeatAdd(oPC, 3680, FALSE); //psywar path
		}
	} //end psy/psi path grant block
	
	// add path specific ability scores and feats
	if (nLvl == 2){
		int nAbility = -1;
		if (GetHasFeat(3670, oPC)){ // melee path
			FeatAdd(oPC, 28, FALSE); //power attack
			nAbility = ABILITY_DEXTERITY;
		} else if (GetHasFeat(3671, oPC)){ // rogue path	
			FeatAdd(oPC, 1857, FALSE); // trapfinding
			nAbility = ABILITY_DEXTERITY;
		} else if (GetHasFeat(3672, oPC)){	// ranger path
			FeatAdd(oPC, 2178, FALSE); // scent
			nAbility = ABILITY_DEXTERITY;
		} else if (GetHasFeat(3677, oPC)){ // bard path
			FeatAdd(oPC, 423, FALSE); // extra music
			nAbility = ABILITY_CHARISMA;
		} else if (GetHasFeat(3676, oPC)){ // knight path
			FeatAdd(oPC, 28, FALSE); //power attack
			nAbility = ABILITY_CHARISMA;
		} else if (GetHasFeat(3685, oPC)){ //barb path
			FeatAdd(oPC, 1341, FALSE); //extra rage
			nAbility = ABILITY_CONSTITUTION;
		} else if (GetHasFeat(3686, oPC)){ //monk path
			FeatAdd(oPC, 410, FALSE); // xtra stunning fist
			nAbility = ABILITY_WISDOM;
		} else { // caster classes get combat casting
			FeatAdd(oPC, 7, FALSE); // combat casting
			if (GetHasFeat(3673, oPC) || GetHasFeat(3674, oPC) || GetHasFeat(3675, oPC))//sorc, warlock, fs
				nAbility = ABILITY_CHARISMA;
			else if (GetHasFeat(3678, oPC) || GetHasFeat(3679, oPC)) // wiz, psion
				nAbility = ABILITY_INTELLIGENCE;
			else nAbility = ABILITY_WISDOM; //psywar 3680, cleric 3681, shaman 3682, druid 3683
		}
		if (nAbility != -1) AdjustAbilityScore(oPC, nAbility, 2);
	}
	// rogue path gets skill focus hide and ms at lvl 6
	if (nLvl >= 6 && GetHasFeat(3671, oPC)){
		FeatAdd(oPC, 178, FALSE); // skill focus hide
		FeatAdd(oPC, 181, FALSE);  // skill focus  ms
	}
}


void PS_HD_SetAlignmentsByHeritage(object oPC, object oEss){
	int nHeritage;
	if (GetHasFeat(2496, oPC)) nHeritage = 2496;
	else if (GetHasFeat(2497, oPC)) nHeritage = 2497;
	else if (GetHasFeat(2498, oPC)) nHeritage = 2498;
	else if (GetHasFeat(2499, oPC)) nHeritage = 2499; 
	else if (GetHasFeat(2500, oPC)) nHeritage = 2500;
	else if (GetHasFeat(2501, oPC)) nHeritage = 2501;
	else if (GetHasFeat(2502, oPC)) nHeritage = 2502;
	else if (GetHasFeat(2503, oPC)) nHeritage = 2503;
	else if (GetHasFeat(2504, oPC)) nHeritage = 2504;
	else if (GetHasFeat(2505, oPC)) nHeritage = 2505;
	else if (GetHasFeat(2506, oPC)) nHeritage = 2506;
	else if (GetHasFeat(2507, oPC)) nHeritage = 2507;
	else if (GetHasFeat(2508, oPC)) nHeritage = 2508;
	else if (GetHasFeat(2509, oPC)) nHeritage = 2509;
	else if (GetHasFeat(2510, oPC)) nHeritage = 2510;
	else if (GetHasFeat(2511, oPC)) nHeritage = 2511;
	else if (GetHasFeat(2512, oPC)) nHeritage = 2512;
	else return; //Just in case there's no heritage, we avoid setting the local variable on object.
	SetLocalInt(oEss, "Draconic_Heritage", nHeritage);
	
	int iGood_D;
	int iLaw_D;
	switch (nHeritage){
		case 2496: case 2497: case 2500: case 2512: iLaw_D = 0; iGood_D = 0; break;
		case 2498: case 2499: iLaw_D = 100; iGood_D = 0; break;
		case 2501: case 2502: iLaw_D = 0; iGood_D = 100; break;
		case 2503: case 2504: case 2505: iLaw_D = 100; iGood_D = 100; break;
		case 2506: iLaw_D = 50; iGood_D = 50; break;
		case 2507: case 2510: iLaw_D = 0; iGood_D = 50; break;
		case 2508: case 2509: iLaw_D = 100; iGood_D = 50; break;
		case 2511: iLaw_D = 50; iGood_D = 0; break;
		default: return; //Heritage set to wrong feat or we have no heritage
	}
	int iGood  = GetGoodEvilValue(oPC);
	int iLaw  = GetLawChaosValue(oPC);

	if (GetLocalInt(oEss, "HD_Align") == 0){	
		SetLocalInt(oEss, "OldGoodEvil", iGood);
		SetLocalInt(oEss, "OldLawChaos", iLaw);
		SetLocalInt(oEss, "HD_Align", 1);	
	}

	// Good-Evil axis check
	int nDiff_Good = iGood_D - iGood;
	if (nDiff_Good > 70) AdjustAlignment(oPC, ALIGNMENT_GOOD, 35);
	else if (nDiff_Good < -70) AdjustAlignment(oPC, ALIGNMENT_EVIL, 35);

	// Law-Chaos axis check
	int nDiff_Law = iLaw_D - iLaw;
	if (nDiff_Law > 70) AdjustAlignment(oPC, ALIGNMENT_LAWFUL, 35);
	else if (nDiff_Law < -70) AdjustAlignment(oPC, ALIGNMENT_CHAOTIC, 35);
}