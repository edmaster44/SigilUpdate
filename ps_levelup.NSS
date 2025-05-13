/* v1.01
12/8/2020 added Psyhic Knight Check
Removed Alignment change for Thug for exploit reason 
May 30, 2024 FlattedFifth
	removed redundant ps_adjust_sneakattack and AddEPForDeathDice()
	Added ff_update_feats as final function in level up operations.
July 3, 2024 FlattedFifth
	Added imbue item to psi at psi caster level 6. Removed dragon disciple function
 */ 
#include "ps_inc_functions"
#include "ps_class_inc"
#include "aaa_constants"
#include "gui_add_psywarfeat"
#include "gui_add_halfundeadfeat"
#include "ps_inc_wingtail"
//	this include removed because of redundancy, this
//  methodology now performed by ff_update_feats, which used to be ff_sneak_fix
//	#include "ps_adjust_sneakattack"
#include "ps_givespellfeat"
#include "ps_adjust_barbarian"
#include "ff_update_feats"
#include "ps_adjust_monk"
#include "ps_adjust_knight"
#include "ps_inc_bgspellfix"
#include "class_mageslayer_utils"


// "level up" of creature weapons.
// initial thought was to this based off creature weapon as defined in racialsubtypes.2da
// however, we have option of removing creature weapons, so we don't want this to happen if people
// have chosen to do that, specifically because of monks.
// all CW templates in a series should have the same tag,
// only resref should have extra numbers which are the HD at which the character should get it.
void UpgradeCreatureWeapons(object oPC)
{
	object oCW_OLD;
	object oCW_NEW;
	string sHD = IntToString(GetHitDice(oPC));
	int nSLOT = INVENTORY_SLOT_CWEAPON_L;
	while (nSLOT <= INVENTORY_SLOT_CWEAPON_B)
	{
		oCW_OLD = GetItemInSlot(nSLOT, oPC);
		if (oCW_OLD != OBJECT_INVALID)
		{
			oCW_NEW = CreateItemOnObject(GetTag(oCW_OLD) + sHD, oPC);
			if (oCW_NEW != OBJECT_INVALID)
			{
				AssignCommand(oPC, ActionEquipItem(oCW_NEW, nSLOT));
				DestroyObject(oCW_OLD);
			}
		}
		nSLOT = nSLOT + 1;
	}
}

//Progression for Psionic classes.
void DoPsiProgression(object oPC)
{
	int nPsion = GetLevelByClass(90, oPC);
	if (nPsion < 1) return;
	int nIlMentalist = GetLevelByClass(100, oPC) - 1;
	int nCerebremancer = GetLevelByClass(152, oPC);
	int nPknight	   = GetLevelByClass(109, oPC) - 1;
	int nTheruge 	   = GetLevelByClass(115,oPC);
	int nGemDragon = GetLevelByClass(128, oPC) / 2 + 1;
	int nLEVEL = nPsion + nIlMentalist + nCerebremancer + nGemDragon + nPknight + nTheruge;
	
	if (nLEVEL > 16)
	{
		int nTOTAL = 0;
		int nCOUNT = 21331;
		while (nCOUNT < 21338)
		{
			if (nCOUNT != 21334) //This was excluded or was it an oversight?
			{
				if (GetHasFeat(nCOUNT, oPC, TRUE) == TRUE) nTOTAL = nTOTAL + 1;
			}
			nCOUNT = nCOUNT + 1;
		}
		if (nTOTAL == 4) FeatRemove(oPC, 21402);
	}
	else
	{
		int nADD;
		int nREMOVE;
		int nTHRESHOLD = 2;
		while (nTHRESHOLD <= 16)
		{
			if (nLEVEL < nTHRESHOLD) break;
			switch (nTHRESHOLD)
			{
				case 2: nADD = 21395; nREMOVE = 21409; break;
				case 4: nADD = 21396; nREMOVE = 21395; break;
				case 6: nADD = 21397; nREMOVE = 21396; break;
				case 8: nADD = 21398; nREMOVE = 21397; break;
				case 10: nADD = 21399; nREMOVE = 21398; break;
				case 12: nADD = 21400; nREMOVE = 21399; break;
				case 14: nADD = 21401; nREMOVE = 21400; break;
				case 16: nADD = 21402; nREMOVE = 21401; break;
				default: nADD = 0; nREMOVE = 0;
			}
			if (nREMOVE > 0)
			{
				if (GetHasFeat(nREMOVE, oPC, TRUE) == TRUE)
				{
					FeatAdd(oPC, nADD, FALSE, TRUE);
					FeatRemove(oPC, nREMOVE);
				}
			}
			nTHRESHOLD = nTHRESHOLD + 2;
		}
	}
}


//Bardic music stacks
void CheckBardicSongs(object oPC)
{
	int nSONG;
	int nMUSIC;
					
	if (GetLevelByClass(CLASS_TYPE_MONADIC_DEVA_PRC, oPC) > 0) //Monadic Deva racial class
	{
		nSONG = TRUE;
		nMUSIC = TRUE;		
	}	
	else if (GetLevelByClass(CLASS_TYPE_FIRRE_PRC, oPC) > 0) //Firre Eladrin racial class
	{
		nSONG = TRUE;
		nMUSIC = TRUE;		
	}
	else if (GetLevelByClass(CLASS_TYPE_VAMPIRE_MAL_PRC, oPC) > 0) //Vampire Maleficus template class
	{
		nSONG = TRUE;
		nMUSIC = TRUE;		
	}
	else if ((GetLevelByClass(CLASS_TYPE_BARD, oPC) > 0) && GetHasFeat(FEAT_ARTIST, oPC)) //Artist Feat
	{
		nSONG = TRUE;		
	}	
	
	if (nSONG == TRUE) StackBardicUses(oPC);
	if (nMUSIC == TRUE) StackBardMusicUses(oPC);
}

// Grants specific feats to evil clerics.
void GiveEvilClericFeats (object oPC)
{
	if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) < 1) return;
	if (GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL) return;	
	if (GetHasFeat(2457, oPC, TRUE) == FALSE) FeatAdd(oPC, 2457, FALSE, TRUE, TRUE);
	if (GetHasFeat(2458, oPC, TRUE) == FALSE) FeatAdd(oPC, 2458, FALSE, TRUE, TRUE);
}

// redundant
//If Dragon + Class 5 add Multiattack
//Change Self Feats for level 6+ of Dragon and Dragon Psion.
/*
void GiveDragonFeats(object oPC)
{	
	int nDRAGON = (GetLevelByClass(127, oPC));
	if (GetHasFeat(4000, oPC, TRUE))  
	{	
		if (GetHasFeat(1784, oPC, TRUE) == FALSE) FeatAdd(oPC, 1784, FALSE, TRUE, TRUE);
	}
	if (GetHasFeat(2797, oPC, TRUE) == TRUE) return;
	int nSUB = GetSubRace(oPC);
	if (nDRAGON >= 6)
	{
		if (nSUB == 222 || nSUB == 239) FeatAdd(oPC, 2797, FALSE, TRUE, TRUE); //Bronze and Topaz Dragon PrC
	}
	else if (GetLevelByClass(128, oPC) >= 6)
	{
		if (nSUB == 239) FeatAdd(oPC, 2797, FALSE, TRUE, TRUE); //Topaz Dragon Psion PrC
	}
}
*/

void GiveWarlockBlastShapes(object oPC) {

	int iTotal = GetWarlockCasterLevelBase(oPC);
	
	//Adding blast shapes
	if (iTotal >= 2) {	
		FeatAdd(oPC, FEAT_WARLOCK_SPEAR_ELDRTICH, FALSE);
	} if (iTotal >= 4) {	
		FeatAdd(oPC, FEAT_WARLOCK_BLOW_ELDRTICH, FALSE);
	} if (iTotal >= 6) {	
		FeatAdd(oPC, FEAT_WARLOCK_SHIELD_ELDRTICH, FALSE);
	} if (iTotal >= 8) {	
		FeatAdd(oPC, FEAT_WARLOCK_CHAIN_ELDRITCH, FALSE);
	} if (iTotal >= 12) {	
		FeatAdd(oPC, FEAT_WARLOCK_BURST_ELDRITCH, FALSE);
	} if (iTotal >= 16) {	
		FeatAdd(oPC, FEAT_WARLOCK_DOOM_ELDRITCH, FALSE);
	}
	
	GiveEssenceBlastShapes(oPC);
}

void main()
{
	object oPC = GetPCLevellingUp();
	object oItem = PS_GetEssence(oPC);
	
	//DeleteLocalString(oPC, "ECL"); //Clang's fix on 3-31-16

	//Remove XP from xp-saving players
	//Disabled on Jeg Training Sigil Edition Preparation Room.
	string sAREA = GetTag(GetArea(oPC));
	int bCullXP = TRUE;
	if (sAREA == "ps_area_dmlair" || sAREA == "jeg_preparation_room")
		bCullXP = FALSE;
	if (ALLOW_INSTANT_REBUILD && (sAREA == "OOC_Area_Tailor" || 
		sAREA =="spawnroom")) bCullXP = FALSE;
	if (bCullXP) PS_TrimXP(oPC);
	
	if (!ALLOW_ECL_LEVEL_30) PS_EnforceMaxLevel(oPC);
	
	//Save new ECL to essence
	PS_CalculateECL(oPC);
	
	//Bardic Music Stacks.
	CheckBardicSongs(oPC);

	// Template classes - apply fix to racial ability bonuses
	// Add new templates to this list when created
	string sTemplate	= GetLocalString(oItem, "Template");
	int iStop			= GetLocalInt(oItem, "TemplateFix");
	int iOldSub			= GetLocalInt(oItem, "OldSubrace");
	if (PS_NeedsTemplateClassAbilityFix(oPC))
	{	
		if (iStop != 1)	SetLocalInt(oItem, "TemplateFix", 0);
		SendMessageToPC(oPC, "Your character has levels in a template class.");
		if (iStop == 0)
		{	
			SendMessageToPC(oPC, "Your original subrace is " + IntToString(iOldSub) + " : " + Get2DAString("racialsubtypes", "Label", iOldSub));
			SendMessageToPC(oPC, "Applying Template Class Ability Fix");
			PS_ApplyTemplateClassAbilityFix(oPC, oItem);
		}
	}
	
	if (GetLocalInt(oItem, "TempChange") != 1)
	{	
		PS_WingTailSetup(oPC);
		PS_ApplyPCTail(oPC);
		PS_ApplyPCWings(oPC);
	}	
	// various class and race related checks
	CountSpells(oPC,1);
	GetWarlockCasterLevel(oPC);
	GiveWarlockBlastShapes(oPC);
	CheckDiashoWeapons(oPC, oItem);
	// We don't hve dragon disciple any more
	//CheckDragonBreath(oPC, oItem);
	PS_BarbarianLevels(oPC);
	GetClericWithoutFeat(oPC);
	GetDruidWithoutFeat(oPC);
	GetBardWithoutFeat(oPC);
	GetSorcererWithoutFeat(oPC);
	GetRangerWithOutFeats(oPC);
	GetWizardWithoutFeat(oPC);
	GetPaladinWithoutFeat(oPC);
	GetSpiritShamanWithoutFeat(oPC);
	GetFavoredSoulWithoutFeat(oPC);
	PS_MonkLevels(oPC);
	PsyWarProgression(oPC);
	HalfUndeadFeat(oPC);
	UpgradeCreatureWeapons(oPC);
 	GiveEvilClericFeats(oPC);
	DoPsiProgression(oPC);
	DoPsyFeatProgression(oPC);
	// redundant, ff_update_feats does this
//	AddEPForDeathDice(oPC);
	DoPsyProgression(oPC);
//	GiveDragonFeats(oPC); redundant now
	KnightLevels(oPC);
	// redundant, ff_update_feats does all of this
//	PS_AdjustSneakAttack(oPC);
	PS_KnightLevels(oPC);
	MageSlayerLevels(oPC);
	// moved to ff_update_feats
	//PS_ManageImbueItem(oPC);
	// ff_update_feats should always come last after all 
	// other leveling up operations. It matters less with the on login script.
	// Sept 12, 2024, ff_update_feats also handling some other feat grants that need to
	// happen at both login and level up. Should prob change name -FlattedFifth. 
	ff_update_feats(oPC); // used to be ff_sneak_fix, now single source of all general feat updates
}


/* We don't have red dragon disciple any more

// check for RDD levels and change immunity to fire to appropriate type.
// we still check for 10 levels of RDD just in case same feat was granted to another class or race or something
void CheckDragonBreath(object oPC, object oItem)
{	
	int nDRAGON = GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, oPC);
	if (nDRAGON < 1) return;
	if (oItem == OBJECT_INVALID)
	{
		SendMessageToPC(oPC, "You appear to be missing your essence. Contact a member of staff");
		return;
	}
	int nTYPE = GetLocalInt(oItem, "DRAGONTYPE");
	if (nTYPE < 1)
	{
		ActionStartConversation(oPC, "ps_srr_conv_dbreath", TRUE, FALSE, TRUE, TRUE);
		return;
	}
	if (nDRAGON < 10) return;
	if (GetHasFeat(964, oPC, TRUE) == FALSE) return;
	int nIMMUNITY;
	switch (nTYPE)
	{
		case 2: 	//Silver
		case 10:	//White
			nIMMUNITY = 2261;
			break;
		case 3:		//Copper
		case 7:		//Black
		case 9:		//Green
			nIMMUNITY = 2282;
			break;
		case 1:		//Gold
		case 4:		//Brass
		case 6:		//Red
			nIMMUNITY = 2260;
			break;
		case 5:		//Bronze
		case 8:		//Blue
			nIMMUNITY = 2283;
			break;
		default:
			SendMessageToPC(oPC, "Cannot set Immunity type as Dragon heritage not selected. Use your breath ability to fix or if that fails, contact a member of staff");
			return;
	}
	
	FeatAdd(oPC, nIMMUNITY, FALSE, TRUE, TRUE);
	FeatRemove(oPC, 964);
	
}
*/

// This function removed because of redundancy, this method now performed
// by ff_update_feats
// void AddEPForDeathDice(object oPC)
// {
//	if (GetHasFeat(459,oPC))
//		{FeatAdd(oPC, 2128, FALSE, FALSE, TRUE);}
// }
