#include "ps_inc_functions"

//Checks for illegal character abilities
int CheckELC(object oPC);

//Checks essence
int CheckEssence(object oPC);

//Check a given item for problems
int iCheckitem(object oItem);

//Inventory scan
int InventoryScan(object oPC);

//Checks race and alignment
int CheckAlignment(object oPC);

// Check for character legality (and mark character as legal if it is ok).  If
// the character is legal, an empty string is returned, otherwise a string that
// describes the problem (i.e. an error message) is returned.  As a part of the
// check the player is rested to clear all buffs.  If ForceCheck is FALSE then
// the check (and force rest) are bypassed if the check has previously passed
// on the PC.
string PS_CheckCharacterLegality(object PC, int ForceCheck);


//*********************************************************
//Helper Functions
//*********************************************************

int CheckELC(object oPC)
{
	ForceRest(oPC);
	
	int wow =0;

    if(GetImmortal(oPC))
    {
    	//SpeakString("immortal",TALKVOLUME_SHOUT);
    	wow = 1;
    }
    else if(GetMaxHitPoints(oPC) > 1500)
    {
    	//SpeakString("hp > 1000",TALKVOLUME_SHOUT);
   		wow = 1;
    }
   	else if(GetAC(oPC) > 80)
   	{
    	//SpeakString("AC > 79",TALKVOLUME_SHOUT);
    	wow = 1;
   	}
    else if(GetAbilityScore(oPC,ABILITY_STRENGTH) > 50 ||
   	GetAbilityScore(oPC,ABILITY_DEXTERITY) > 50 ||
   	GetAbilityScore(oPC,ABILITY_CONSTITUTION) > 50 ||
   	GetAbilityScore(oPC,ABILITY_WISDOM) > 50 ||
   	GetAbilityScore(oPC,ABILITY_INTELLIGENCE) > 50 ||
   	GetAbilityScore(oPC,ABILITY_CHARISMA) > 50)
   	{
   		//SpeakString("too high ab score(s)",TALKVOLUME_SHOUT);
    	wow = 1;
   	}
   	if(GetFortitudeSavingThrow(oPC) > 80 ||
   	GetWillSavingThrow(oPC) > 80 ||
   	GetReflexSavingThrow(oPC) > 80)
   	{
    	//SpeakString("too high saves",TALKVOLUME_SHOUT);
    	wow = 1;
   	}
   	string oNa = GetName(oPC);
   	if(GetStringLength(oNa) < 2)
   	{
   	 	SendMessageToPC(oPC,"Please select a character name that is longer than a single letter.");
    	//SpeakString("char name too short",TALKVOLUME_SHOUT);
    	wow = 1;
   	}

	return wow;
}

int CheckEssence(object oPC) {
	
	int iEssence = 0;
	object oItem = PS_GetEssence(oPC);
    if(GetIsObjectValid(oItem))
    {
		iEssence += 1;
    }

	if ( iEssence == 1 ) // 1 essence exactly needed otherwise bugged
	{
		return TRUE;
	}
	return FALSE;
}

int CheckExtraIllegal(object oItem)
{	
	itemproperty ipLoop		= GetFirstItemProperty(oItem);
	while (GetIsItemPropertyValid(ipLoop))
	{	if (GetItemPropertyType(ipLoop) == ITEM_PROPERTY_REGENERATION && 
			GetItemPropertyCostTableValue(ipLoop) >= 3)
		{	return 1;	}
	ipLoop = GetNextItemProperty(oItem);
	}
	return 0;
}

int iCheckitem(object oItem)
{
	int oImmun = 0;

   	if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_FREEDOM_OF_MOVEMENT))
   	{	//SpeakString("freedom " + GetTag(oItem),TALKVOLUME_SHOUT);
    	oImmun = 1;
   	}
   	else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_HASTE))
   	{  	//SpeakString("permahaste " + GetTag(oItem),TALKVOLUME_SHOUT);
    	oImmun = 1;
   	}
   	else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE))
   	{	//SpeakString("immunity damage " + GetTag(oItem),TALKVOLUME_SHOUT);
    	oImmun = 1;
   	}
   	else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS))
   	{	//SpeakString("immunity misc " + GetTag(oItem),TALKVOLUME_SHOUT);
    	oImmun = 1;
   	}
   	else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL))
   	{	//SpeakString("immunity spell " + GetTag(oItem),TALKVOLUME_SHOUT);
    	oImmun = 1;
   	}
   	else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL))
   	{	//SpeakString("immunity spells by level " + GetTag(oItem),TALKVOLUME_SHOUT);
    	oImmun = 1;
   	}
   	else if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMPROVED_EVASION))
   	{	//SpeakString("item with improved evasion " + GetTag(oItem),TALKVOLUME_SHOUT);
    	oImmun = 1;
   	}
	else if(CheckExtraIllegal(oItem) == 1)
	{	PrintString("item with regeneration over allowed: " + GetTag(oItem));
		oImmun = 1;
	}
	

	//Blocks shard items
	string sTag = GetTag(oItem);
	if (FindSubString(sTag, "nwn2_it_shard", 0) != -1)
		oImmun = 1;
	if (sTag == "ps_luca_alchemical_gun")
		oImmun = 1;
	if (sTag == "ps_luca_clawofthebezekira")
		oImmun = 1;
	if (sTag == "ps_gad_force_gauntlets")
		oImmun = 1;
	if (sTag == "ps_gad_dreadaxe")
		oImmun = 1;
	if (sTag == "ps_xbow_chokuno")
		oImmun = 1;
	if (sTag == "ps_gad_serene")
		oImmun = 1;
	if (sTag == "ps_longsword_wideblade")
		oImmun = 1;
	if (sTag == "ps_katana_momentum")
		oImmun = 1;
	if (sTag == "ps_qstaff_philosophysolidified")
		oImmun = 1;
	if (sTag == "ps_ed_bloodcleaver")
		oImmun = 1;
	if (sTag == "ps_wmace_cripplinghammer")
		oImmun = 1;
	if (sTag == "ps_luca_rukus")
		oImmun = 1;
	if (sTag == "ps_luca_sunlightseeker")
		oImmun = 1;
	if (sTag == "ps_morg_item7")
		oImmun = 1;
	if (sTag == "ps_boots_avoidance")
		oImmun = 1;
		
	return oImmun;
}



int InventoryScan(object oPC)
{
	int problem = 0;
	int finishedScan = 0;
	string sTag;
	
   	object oItem = GetFirstItemInInventory(oPC);
   	while(GetIsObjectValid(oItem))
   	{
		sTag = GetTag(oItem);
		
		if (sTag == "itemondisplay")
		{
			DestroyObject(oItem, 0.01);
			SendMessageToPC(oPC, "Naughty boy had an item stolen from a display container. Stolen item has gone bye bye!");
		}
			
 		if(iCheckitem(oItem)==1)
 		{
  			problem += 1;
 		}
		oItem = GetNextItemInInventory(oPC);
   	}
	
	finishedScan = 1;
	
   	int nSlot = 0;
   	for (nSlot=0; nSlot<NUM_INVENTORY_SLOTS; nSlot++)
   	{
	   oItem=GetItemInSlot(nSlot, oPC);
	
	   if (GetIsObjectValid(oItem))
	   {
		 if(iCheckitem(oItem)==1)
		 {
          SendMessageToPC(oPC,"Following item is illegal on server (you cannot enter while carrying it): " + GetName(oItem));
		  problem += 1;
		 }
	   }
   	}
	
	if (!finishedScan)
		return problem+1;
		
	return problem;

}

//*********************************************************
//Alignment Functions
//*********************************************************

int GetNaturalAlignmentLawChaos(object oPC) {
	int subrace = GetSubRace(oPC);
		
	//lawfuls
	if (subrace == 133 || //erinyes
		subrace == 192 || //amnizu
		subrace == 183 || //rakshasa
		subrace == 164 || //hound archon
		subrace == 171 || //duodrone
		subrace == 170 || //modron
		subrace == 129 || //trumpet archon
		subrace == 131) //paeliryon
		return ALIGNMENT_LAWFUL;
	//chaotics
	else if (subrace == 132 || //succubus
			 subrace == 180 || //bariaur
			 subrace == 155 || //mud slaad
			 subrace == 154 || //Blue Slaad
			 subrace == 152 || //Hezrou
			 subrace == 127 || //Bralani
			 subrace == 128) //Ghaele
		return ALIGNMENT_CHAOTIC;
	//neutrals
	else if (subrace == 190 || //rilmani
			 subrace == 182 || //arcanaloth
			 subrace == 191 || //lupinal
			 subrace == 148 || //night hag
			 subrace == 189) //Rilmani_Ferrumach
		return ALIGNMENT_NEUTRAL;
	//any
	else if (subrace == 203) //aasimon
		return ALIGNMENT_ALL;
	else
		return GetAlignmentLawChaos(oPC);	//If you're not an outsider, then you are your natural alignment!
}

int GetNaturalAlignmentGoodEvil(object oPC) {
	int subrace = GetSubRace(oPC);
		
	//evils
	if (subrace == 133 || //erinyes 0
		subrace == 192 || //amnizu 0
		subrace == 183 || //rakshasa 0
		subrace == 132 || //succubus 0
		subrace == 182 || //arcanaloth 0
		subrace == 152 || //Hezrou 0
		subrace == 148 || //night hag 0
		subrace == 131) //paeliryon 0
		return ALIGNMENT_EVIL;
	//goods
	else if (subrace == 180 || //bariaur 0
			 subrace == 129 || //trumpet archon 0
			 subrace == 164 || //hound archon 0
			 subrace == 203 || //aasimon 0
			 subrace == 191 || //lupinal 0
			 subrace == 127 || //Bralani 0
			 subrace == 128) //Ghaele 0
		return ALIGNMENT_GOOD;
	//neutrals
	else if (subrace == 190 || //rilmani 0
			 subrace == 171 || //duodrone 0
			 subrace == 170 || //modron 0
			 subrace == 155 || //mud slaad
			 subrace == 154 || //Blue Slaad
			 subrace == 189) //Rilmani_Ferrumach 0
		return ALIGNMENT_NEUTRAL;
	//any
	//else if (subrace == xxx) //nobody fits this yet...
	//	return ALIGNMENT_ALL;
	else
		return GetAlignmentGoodEvil(oPC);	//If you're not an outsider, then you are your natural alignment!
}

int getDifferenceInAlignment(int myAlign, int idealAlign) {
	if (myAlign == idealAlign)
		return 0;
	if (myAlign == ALIGNMENT_GOOD && idealAlign == ALIGNMENT_EVIL)
		return 2;
	else if (myAlign == ALIGNMENT_EVIL && idealAlign == ALIGNMENT_GOOD)
		return 2;
	else if (myAlign == ALIGNMENT_CHAOTIC && idealAlign == ALIGNMENT_LAWFUL)
		return 2;
	else if (myAlign == ALIGNMENT_LAWFUL && idealAlign == ALIGNMENT_CHAOTIC)
		return 2;
	else if (myAlign == ALIGNMENT_GOOD && idealAlign == ALIGNMENT_ALL)
		return 0;
	else if (myAlign == ALIGNMENT_EVIL && idealAlign == ALIGNMENT_ALL)
		return 0;
	else if (myAlign == ALIGNMENT_CHAOTIC && idealAlign == ALIGNMENT_ALL)
		return 0;
	else if (myAlign == ALIGNMENT_LAWFUL && idealAlign == ALIGNMENT_ALL)
		return 0;
	return 1;
}

int CheckAlignment(object oPC) {

	//The true neutrals among us. . .
	if (GetNaturalAlignmentLawChaos(oPC) == GetNaturalAlignmentGoodEvil(oPC))
	{
		if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_NEUTRAL ||
			GetAlignmentLawChaos(oPC) == ALIGNMENT_NEUTRAL)
			return TRUE;
		return FALSE;
	}
	
	//Everyone else
	int goodEvil = getDifferenceInAlignment(GetAlignmentGoodEvil(oPC), GetNaturalAlignmentGoodEvil(oPC));
	int lawChaos = getDifferenceInAlignment(GetAlignmentLawChaos(oPC), GetNaturalAlignmentLawChaos(oPC)); 
	if (goodEvil+lawChaos <= 1)
		return TRUE;
		
	return FALSE;
	
}

string PS_CheckCharacterLegality(object PC, int ForceCheck)
{
	// Early exit if the PC has already been confirmed to be valid this boot of
	// the server.
	if ((GetLocalInt(PC, "canEnterModule") != FALSE) && (ForceCheck == FALSE)) {
		return "";
	}
	
	object oItem = PS_GetEssence(PC);
    if(GetIsObjectValid(oItem))
    {
	 	string sLegal = GetLocalString(oItem,"LEGAL");
		if(sLegal == "TRUE")
		{
			SetLocalInt(PC, "canEnterModule", TRUE);
			return "";
		}
    }

	int hasEssence = CheckEssence(PC);
	int illegalCharacter = CheckELC(PC);
	int inventoryBugs = InventoryScan(PC);
	int wellAligned = CheckAlignment(PC);
	string errorMessage;
	
	if (hasEssence == FALSE) {
		errorMessage = "Oh no! There's something wrong with your essence. Please contact a DM.  If none are in game at the moment, you may post on the forum or send a PM to a DM/Admin.";
	}
	else if (illegalCharacter == TRUE) {
		errorMessage = "Oh no! Your stats have been found impossible. Please contact a DM. If none are in game at the moment, you may post on the forum or send a PM to a DM/Admin.";
	}
	else if (inventoryBugs > 0) {
		errorMessage = "Uh oh, there's something wrong with your inventory. You either have an illegal item, or your inventory is too big. We don't allow items that grant immunities. Please remove any offending items before entering the world.";
	}
	else if (wellAligned == FALSE && GetHitDice(PC) == 1) {
		errorMessage = "Uh oh, your character is an unacceptable alignment. For non-elemental outsider races, we require you to be within one step of the natural alignment of the race - for example a succubus can be NE, but not LE. Please remake your character with an acceptable alignment.";
	}

	if (errorMessage == "") {
		SetLocalInt(PC, "canEnterModule", TRUE);
	}
	else {
		SetLocalInt(PC, "canEnterModule", FALSE);
	}

	return errorMessage;
}