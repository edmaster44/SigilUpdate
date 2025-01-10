/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		Feat Update Script by FlattedFifth, May 27, 2024
		
		last change May 30, 2024 by FlattedFifth: 
			Changed sneak attack feat grants to be additive, like in the OC.
			Corrected string comparison operator to check for temp dice warning.
			 
		Updated Sept 17, 2024 Changed to handle all feat updates instead of just sneak attack
		
		
		IMPORTANT NOTE ON SNEAK ATTACKS:
			Currently all sneak attack flavours except Death Attack and Bleeding Wound granted
			by classes and races are converted by this file to Rogue sneak attacks. Wererats get 
			blackguard sneak attacks when in hybrid form, I've changed the +1d6 sneak attack player
			crafted enchantment to +1d6 Shadowthief sneak attack so that it stacks with rogue, and
			there's "Neverwinter 9 Agent" sneak attack that is from a Rogue NW9 Prc that Bioware 
			never finished. I've renamed that sneak attack to "Murderous Intent" feat that the player
			gets from ninjato or stiletto in the main hand (if the char has sneak attack from a class). 
			That still leaves Arcane Trickster sneak attacks unused so if you need another sneak attack
			that will stack with all the rest, there's that one. -FlattedFifth
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
#include "aaa_constants"
#include "ff_update_feats_inc"
#include "ff_combat_mods"




void ff_update_feats(object oPC);
void fGrantSneakFeats(object oPC);
void fUpdateOtherFeats(object oPC);
void GiveCreatureWeaponFinesse(object oPC);
void AdjustAbilityScores(object oPC);



//main logic of this script
void ff_update_feats(object oPC){

	SendMessageToPC(oPC, "Re-calculating Sneak Dice");
	
	int nSneakDice = 0;
	int nDeathDice = 0;
	
	fRemoveSneakFeats(oPC);

	fGrantSneakFeats(oPC);

	SendMessageToPC(oPC, "Finished Re-calculating Sneak Dice\nUpdating Other Feats");
	
	fUpdateOtherFeats(oPC);
	
	SendMessageToPC(oPC, "Finished Updating Other Feats");

	string tempDiceWarning = "";
	tempDiceWarning = fCheckForTempSneakDice(oPC);

	if (tempDiceWarning != "")
	{
		SendMessageToPC(oPC, tempDiceWarning);
	}
	
	DelayCommand(3.0f, AdjustAbilityScores(oPC));

	if (bSaveAfterThisScript)
	{
		ExportSingleCharacter(oPC);
	}
}

void AdjustAbilityScores(object oPC){
	SendMessageToPC(oPC, "Checking for Racial Ability Score Adjustment Choices");
	object oEss = GetItemPossessedBy(oPC, "ps_essence");
	if (GetLocalInt(oEss, "startability")){
		SendMessageToPC(oPC, "You have already chosen your ability score adjustments");
		return;
	} else {
		if (GetHasFeat(FEAT_HUMAN_ABILITY_BONUS, oPC, TRUE)){
			AssignCommand(oPC, ClearAllActions(TRUE));
			AssignCommand(oPC, ActionStartConversation(oPC, "conv_Human_Abil_start", TRUE, FALSE, TRUE, TRUE));
		} else if (GetHasFeat(FEAT_HALF_ELF_ABILITY_BONUS, oPC, TRUE)){
			AssignCommand(oPC, ClearAllActions(TRUE));
			AssignCommand(oPC, ActionStartConversation(oPC, "conv_HE_Abil_start", TRUE, FALSE, TRUE, TRUE));
		}
	}
}

//Function to grant sneak dice, death dice, and ep if applicable
void fGrantSneakFeats(object oPC){

	int	nSneakDice = fCalcSneakDice(oPC);
	int nDeathDice = fCalcDeathDice(oPC);
	int i;
	
	//grant sneak attack
	if (nSneakDice > 0){
		for (i = 1; i <= nSneakDice; i++){
			FeatAdd(oPC, fFindSneakFeat(i), FALSE);
		}
	}
	// grant death attack
	if (nDeathDice > 0){
		for (i = 1; i <= nDeathDice; i++){
			FeatAdd(oPC, fFindDeathFeat(i), FALSE);
		}
	}

	// calculate additional qualifier dice for Epic Precision
	int nBonusDice = fCalcOtherSneakFeats(oPC);

	// Give swash EP at level 12 if the appropriate boolean in this script is set to TRUE
	if (bGrantToSwash12 && GetLevelByClass(CLASS_TYPE_SWASHBUCKLER, oPC) >= 12)
		nBonusDice += 5;
	

	// grant ep if sneak dice + death dice + other qualifier >= 5
	if ((nSneakDice + nDeathDice + nBonusDice) >= 5)
		FeatAdd(oPC, idFeatEpicPrecision, FALSE);
}

void GiveCreatureWeaponFinesse(object oPC){
	// if they have creature weap prof
	if (GetHasFeat(289, oPC, TRUE)){ 
		 // give weapon finesse for small, tiny, and med creat weap
		if (!GetHasFeat(3218, oPC, TRUE)) FeatAdd(oPC, 3218, FALSE);
		int nSize = GetCreatureSize(oPC);
		// if charsize >= med give weap finesse for large creat weap
		if (nSize >= 3 && !GetHasFeat(3259, oPC, TRUE)) FeatAdd(oPC, 3259, FALSE);
		// if charsize >= large give weap finesse for huge creat
		if (nSize >= 4 && !GetHasFeat(3260, oPC, TRUE)) FeatAdd(oPC, 3260, FALSE);
	}
}

void fUpdateOtherFeats(object oPC){
	// call to ps_inc_functions to grant Imbue Item to psi and to warlocks with warlock prcs.
	PS_ManageImbueItem(oPC);
	
	GiveCreatureWeaponFinesse(oPC);
	
	//Since the racial feat skill affinity craft alchemy is useless
	//replace it with skill affinity concentration -FlattedFifth, July 25, 2024
	if (GetHasFeat(1754, oPC))
	{
		FeatRemove(oPC, 1754);
		FeatAdd(oPC, 243, FALSE);
	}
	// Add situational awareness persistent feat. Please see file ff_feat_situational_awareness.nss
	// for code and an EXTREMELY IMPORTANT note on interaction with Dae's plugin. Recommend use with xp_fix
	// plugin to remove dodge ac limits at https://github.com/nwn2dev/nwnx4/wiki at the bottom of the page.
	if (GRANT_SITUATIONAL_AWARENESS && !GetHasFeat(FEAT_SITUATIONAL_AWARENESS, oPC, TRUE))
		FeatAdd(oPC, FEAT_SITUATIONAL_AWARENESS, FALSE);
	else if (!GRANT_SITUATIONAL_AWARENESS && GetHasFeat(FEAT_SITUATIONAL_AWARENESS, oPC, TRUE))
		FeatRemove(oPC, FEAT_SITUATIONAL_AWARENESS);
	
	// Add tactical weapons feat.
	if (!GetHasFeat(21922, oPC, TRUE)) FeatAdd(oPC, 21922, FALSE);
	
	// grant buckler proficiency to swash or rogue if they don't have it.
	if (GetLevelByClass(CLASS_TYPE_SWASHBUCKLER, oPC) > 0 || GetLevelByClass(CLASS_TYPE_ROGUE, oPC) > 0){
		if (!GetHasFeat(21915, oPC, TRUE)) FeatAdd(oPC, 21915, FALSE);
	}
	
	// giants can finesse falchion and medium weapons
	if (GetCreatureSize(oPC) > 3 && !GetHasFeat(FEAT_GIANT_FINESSE, oPC, TRUE))
		FeatAdd(oPC, FEAT_GIANT_FINESSE, FALSE);
		
	// grant methodical defense and considered Strike at BAB 6, or remove them
	// in the case of a de-leveled pc.
	if (GetBaseAttackBonus(oPC) >= 6){
		if (!GetHasFeat(FEAT_METHODICAL_DEFENSE, oPC, TRUE)) FeatAdd(oPC, FEAT_METHODICAL_DEFENSE, FALSE);
		if (!GetHasFeat(FEAT_CONSIDERED_STRIKE, oPC, TRUE)) FeatAdd(oPC, FEAT_CONSIDERED_STRIKE, FALSE);
	} else {
		if (GetHasFeat(FEAT_METHODICAL_DEFENSE, oPC, TRUE) || GetHasFeat(FEAT_CONSIDERED_STRIKE, oPC, TRUE)){
			FeatRemove(oPC, FEAT_METHODICAL_DEFENSE);
			FeatRemove(oPC, FEAT_CONSIDERED_STRIKE);
		}
	}
	// give staff fighting if they have twf of either kind, or are a monk, samurai
	// or kensai, or remove staff fighting if a de-leveled pc no longer qualifies.
	int bQualifiesForStaffFighting = (GetHasFeat(1734, oPC, TRUE) || GetHasFeat(41, oPC, TRUE) || 
		(GetLevelByClass(CLASS_TYPE_MONK, oPC) + GetLevelByClass(CLASS_SAMURAI, oPC) +
		GetLevelByClass(CLASS_KENSAI, oPC) > 0));
	int bHasStaffFighting = GetHasFeat(21911, oPC, TRUE);
	if (bQualifiesForStaffFighting && !bHasStaffFighting) FeatAdd(oPC, 21911, FALSE);
	else if (!bQualifiesForStaffFighting && bHasStaffFighting) FeatRemove(oPC, 21911);
	
	// update any ongoing effects for methdef, constrike, and staff
	UpdateCombatMods(oPC);
}
