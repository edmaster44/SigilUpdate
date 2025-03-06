//v. 1.01
// FlattedFifth, June 30, 2024; Replaced old call to "ff_mod_game_items" with new, improved
//					"ff_update_legacy_items" and call it just before StackingEquipmentBugFix is
//					called from main. Also moved boots to last item of StackingEquipmentBugFix
//					and increased the delay from 0.1 second to o.5 seconds in the hopes of
//					removing double dodge ac bug.


#include "dmfi_inc_initial"
#include "nwnx_sql"
#include "nwnx_srvadmin"
#include "ps_inc_functions"
#include "nwnx_character"
#include "ps_class_inc"
#include "ps_inc_advscript"
#include "ps_inc_polymorph"
#include "ps_convertbio"
#include "ps_inc_time"
#include "ps_inc_wingtail"
#include "ps_inc_bgspellfix"
#include "ginc_time"
#include "ps_heightadjust_includes"
#include "ff_update_legacy_items"
#include "ff_update_feats"
#include "class_mageslayer_utils"
#include "ps_adjust_knight"
#include "inc_tattoo"
#include "ff_combat_mods"
#include "_aaa_first_login"

const int nDailyXP = 300;
const int nDailyXPlevel = 100;

//remove all bonus feats added to the creature skin by spells or Tactical Weapon feat 
// or ps_inc_equipment in case any got stuck by a poorly timed player or server crash or 
// some other ill-fated event. Note that currently none of the tattoos use a bonus feat on
// a skin like they used to. There are also 3 feats that are added directly to the pc in
// ps_inc_equipment instead of the skin because they are feats that cannot be gained
// through any normal means; therefore the safety of the skin isn't needed. But remove
// those also in case any got stuck.
void RemoveTempFeatsAndFX(object oPC, object oSkin){
	itemproperty ip = GetFirstItemProperty(oSkin);
	while (GetIsItemPropertyValid(ip)){
		if (GetItemPropertyType(ip) == ITEM_PROPERTY_BONUS_FEAT)
				RemoveItemProperty(oSkin, ip);
		ip = GetNextItemProperty(oSkin);
	}
	if (GetHasFeat(FEAT_MURDEROUS_INTENT, oPC, TRUE))
		FeatRemove(oPC, FEAT_MURDEROUS_INTENT);
	if (GetHasFeat(FEAT_KENJUTSU, oPC, TRUE))
		FeatRemove(oPC, FEAT_KENJUTSU);
	if (GetHasFeat(FEAT_BOJUTSU, oPC, TRUE))
		FeatRemove(oPC, FEAT_BOJUTSU);
	UpdateCombatMods(oPC, 0);
	
}

// the creature skin in the invisible inventory slot carmor is necessary
// for spells that grant darkvision, and also for adding temp bonus feats
// in ff_feat_tactical_weapon that won't interfere with existing feats or
// existing bonus feats on other items.
// Make sure the player has it on login.
void GiveCreatureSkin(object oPC){
	object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
	
	if (oSkin == OBJECT_INVALID){
		int i = 0;
		object oItem = GetFirstItemInInventory(oPC);
		while (GetIsObjectValid(oItem))
		{
			i++;
			// num of items a pc could have if inv full of full bags, including the bags
			if (i > 27072) break;
			// creature skin base item id is 73
			if (GetBaseItemType(oItem) == 73){
				oSkin = oItem;
				break;
			}
			oItem = GetNextItemInInventory(oPC);
		}
		if (oSkin == OBJECT_INVALID)
			oSkin = CreateItemOnObject("x2_it_emptyskin", oPC, 1, "", FALSE);
		
		DelayCommand(2.0f, AssignCommand(oPC, ActionEquipItem(oSkin, INVENTORY_SLOT_CARMOUR)));
	} else 
		DelayCommand(0.5f, RemoveTempFeatsAndFX(oPC, oSkin));
}

// ps_levelup is not called on character creation, and it's not called at the 
// start of the level up process but at the END. So if there's any feats we
// need a character to have before they reach level 2 rather than after it, 
// we need to add that code here.
void GiveStartingFeats(object oPC)
{
	// calls the psywar progression function from ps_inc_functions with 
	// an argument that tells it to grant the first feat only.
	DoPsyProgression(oPC, TRUE);
}
void GiveStartingGold( object oPC, int nAmount )
{
	int nGold = GetGold(oPC);
	TakeGoldFromCreature(nGold, oPC, TRUE);
	GiveGoldToCreature(oPC, nAmount);
}

void RemoveAllItems(object oPC)
{
	int nSLOT;
	object oINVALID = OBJECT_INVALID;
	object oITEM;
	while (nSLOT < 18)
	{
		oITEM = GetItemInSlot(nSLOT, oPC);
		DestroyObject(oITEM);
		nSLOT = nSLOT + 1;
	}
	oITEM = GetFirstItemInInventory(oPC);
	while(oITEM != oINVALID)
	{	
		DestroyObject(oITEM);
		oITEM = GetNextItemInInventory();
	}
}
 
int CheckIfNameExploiting(object oPC)
{
	string name = SQLEncodeSpecialChars(GetName(oPC));
	string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	
	SQLExecDirect("SELECT '"+name+"' REGEXP '[<!>]' OR '"+name+"' NOT REGEXP '[A-Z,0-9]',"+
	" '"+act+"' REGEXP '[<!>]' OR '"+act+"' NOT REGEXP '[A-Z,0-9]';");
	SQLFetch();
	
	if(SQLGetData(1) == "1" || SQLGetData(2) == "1")
	{
		BootPC(oPC);
		//ReportBadLogins(oPC, "Attempted name exploit.");
		return FALSE;
	}
	return TRUE;
}

//Should only be called after checking that the character doesn't exist
//returns the character id, or FALSE on failure
int AddCharacterToDatabase(object oPC) {

	string sAccount = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	string sName = SQLEncodeSpecialChars(GetName(oPC));
	
	SQLExecDirect("INSERT INTO characterdata (account,name,dm_pool,rp_pool) VALUES ('"+sAccount+"','"+sName+"',0,0)");
	
	string sQuery = "SELECT id FROM characterdata WHERE account='"+sAccount+"' AND name='"+sName+"'";
	SQLExecDirect(sQuery);
	
	if (SQLFetch() != SQL_ERROR) {	
		int nID = StringToInt(SQLGetData(1));
		return nID;
	}
	
	return FALSE;
}

int prepChar(object oPC)
{
	//should be moved to first time entry after every char is fixed
	object oItem = PS_GetEssence(oPC);
	object oINVALID = OBJECT_INVALID;

	int nID = PS_GetLocalInt(oItem,"ID");
	string sAccount = "";
	string sName = "";
	int sECL = PS_GetEssenceECL(oPC); //Edit by Clangeddin, this will take care of setting the proper ECL at login.
	string sKey = GetPCPublicCDKey(oPC);
	string sIP = GetPCIPAddress(oPC);
		
	if(oItem != oINVALID) {		
		
		if (nID == 0) {	
		
			sAccount = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
			sName = SQLEncodeSpecialChars(GetName(oPC));
			
			SQLExecDirect("SELECT id FROM characterdata WHERE account='"+sAccount+"' AND name='"+sName+"'");
			if (SQLFetch() != SQL_ERROR) {	
				nID = StringToInt(SQLGetData(1));
			}
			else {
				nID = AddCharacterToDatabase(oPC);
			}
			
		} else { //Make sure it's not some asshat bypassing bioware servers 	
		
			SQLExecDirect("SELECT ifnull(publickey,''),ifnull(ip,'') FROM characterdata WHERE id=" + IntToString(nID));
			if (SQLFetch() != SQL_ERROR)
			{
				if(SQLGetData(1) != "" && SQLGetData(2) != "" && SQLGetData(1) != sKey && SQLGetData(2) != sIP)
				{	
					sAccount = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
					sName = SQLEncodeSpecialChars(GetName(oPC));				
					SQLExecDirect("INSERT INTO logging (account,name,event,type) VALUES ('" + sAccount + "','" + sName + "','key "+sKey+" ip "+sIP+" attempted to access account',667)");
					BootPlayer(sAccount);
					return TRUE;
				}
			}
			
		}
		
	}
		
	PS_SetLocalInt(oItem,"ID",nID);
	PS_SetLocalInt(oPC,"ID",nID);
			
	string sDay = PS_GetLocalString(oItem, "XPDay");
	//DebugMessageToPC(oPC, "id:" + IntToString(nID));
	//DebugMessageToPC(oPC, "last day xp given:" + sDay);

	SQLExecDirect("SELECT id,dm_pool,rp_pool,Day(Now()) FROM characterdata WHERE id=" + IntToString(nID));
	if (SQLFetch() != SQL_ERROR)  {	
	
		int dm_pool = StringToInt(SQLGetData(2));
		int rp_pool = StringToInt(SQLGetData(3));
		int availableXP = dm_pool+rp_pool;
		//DebugMessageToPC(oPC, "dm pool xp: "+IntToString(dm_pool));
		//DebugMessageToPC(oPC, "rp pool xp: "+IntToString(rp_pool));
		//DebugMessageToPC(oPC, "combined xp: "+IntToString(availableXP));
		int xpGiven = FALSE;
						
		if ( sDay != SQLGetData(4) && availableXP > 0 ) {
			
			PS_SetLocalString(oItem,"XPDay",SQLGetData(4));
			//DebugMessageToPC(oPC,"xpday:" + PS_GetLocalString(oItem,"XPDay"));
				
			int nModifiedXP = FloatToInt((nDailyXP + nDailyXPlevel * GetHitDice(oPC)) * PS_GetXPModifier(sECL));
			if (dm_pool > nModifiedXP)
			{	
				//SendMessageToPC(oPC, "Pulling from DM Pool");
				xpGiven = PS_GiveXPReward(oPC, nModifiedXP);
				
				dm_pool -= nModifiedXP;
			}
			else if (availableXP > nModifiedXP)
			{	
				//SendMessageToPC(oPC, "Pulling from both pools");
				int givenXP = nModifiedXP;
				xpGiven = PS_GiveXPReward(oPC, givenXP);
					
				givenXP -= dm_pool;
				dm_pool = 0;
				rp_pool -= givenXP;	
			}
			else 
			{	
				//SendMessageToPC(oPC, "Exhausting pools");
				nModifiedXP = availableXP;
				xpGiven = PS_GiveXPReward(oPC, availableXP);
				
				dm_pool = 0;
				rp_pool = 0;
				
				if (xpGiven) {
					DelayCommand(11.0, SendMessageToPC(oPC,"Your pool is now empty."));	
				}
			}
				
			if (xpGiven) {	
				DelayCommand(10.0, SendMessageToPC(oPC,"Your character has been awarded " + IntToString(nModifiedXP) + " XP for previous roleplay (or from removing xp with Styx)"));
				SQLExecDirect("UPDATE characterdata SET dm_pool=" + IntToString(dm_pool) + ", rp_pool=" + IntToString(rp_pool) + " WHERE id=" + IntToString(nID));
			}
		}
		
	}
	else
	{	
		//existing char not in database (precrash)
		nID = AddCharacterToDatabase(oPC);
		DelayCommand(10.0, SendMessageToPC(oPC,"Character restored to database."));
	}
		
	// give daisho weapons if taken samurai level 1.
	CheckDiashoWeapons(oPC, oItem);
	
	// Save current ECL to essence
	PS_CalculateECL(oPC);
		
	//Run check to see if character's original appearance is saved. If not, save it.
	if (PS_GetLocalInt(oItem, "AppInitialized") != 1)
	{	
		PS_SaveOriginalAppearance(oPC);
		PS_SetLocalInt(oItem, "AppInitialized", 1);
	}

	//Run check to see if any temp appearance changes are applied, and if so revert to Original.
	if (PS_GetLocalInt(oItem, "TempChange") != 0)
	{	
		PS_RestoreOriginalAppearance(oPC);
		PS_SetLocalInt(oItem, "TempChange", 0);
	}

	int iSUB = GetSubRace(oPC);
			
	//sECL = Get2DAString("racialsubtypes", "LA", iSUB);
	//PS_SetLocalString(oItem,"ECL", sECL);	
	//PS_SetLocalString(oPC,"ECL", sECL);
	// and while we are here, give creature weapons/hides and wings as required.
	
	string s2DA = "racialsubtypes";
	int nCACHE = GetNum2DARows(s2DA); //For caching purposes. Makes the script faster.
	string sCharFix = Get2DAString(s2DA, "TINTFIX", iSUB);
	string sITEM;
	object oTemp;
	int nCOUNT;
	int nEQUIP;
	int nSLOT;
	while (nCOUNT <	5)
	{
		switch (nCOUNT)
		{
			case 0: sITEM = Get2DAString(s2DA, "ITEMGRANTED", iSUB); nEQUIP = FALSE; break;
			case 1: sITEM = Get2DAString(s2DA, "CW1", iSUB); nEQUIP = TRUE; nSLOT = INVENTORY_SLOT_CWEAPON_L; break;
			case 2: sITEM = Get2DAString(s2DA, "CW2", iSUB); nEQUIP = TRUE; nSLOT = INVENTORY_SLOT_CWEAPON_R; break;
			case 3: sITEM = Get2DAString(s2DA, "CW3", iSUB); nEQUIP = TRUE; nSLOT = INVENTORY_SLOT_CWEAPON_B; break;
			case 4: sITEM = Get2DAString(s2DA, "CH", iSUB); nEQUIP = TRUE; nSLOT = INVENTORY_SLOT_CARMOUR; break;
		}
		if (sITEM != "")
		{
			oTemp = GetItemPossessedBy(oPC, sITEM);
			if (oTemp == oINVALID)
			{
				oTemp = CreateItemOnObject(sITEM, oPC, 1, "", TRUE);
				SetIdentified(oTemp, TRUE);
				if (nEQUIP == TRUE) DelayCommand(2.0, AssignCommand(oPC, ActionEquipItem(oTemp, nSLOT)));
			}
		}
		nCOUNT = nCOUNT + 1;
	}
		
	if (sCharFix != "") PS_TintFixer(oPC);
		
	PS_ApplyPCWings(oPC);
	PS_ApplyPCTail(oPC);
		
	//if (GetIsObjectValid(oEssence))
	//{	PS_SetLocalInt(oEssence, "FIXSRR", 1);
		//DisplayMessageBox(oPC, 0, "IMPORTANT NOTICE: Your character has the opportunity to have wings or a tail. Visit the Styx Oarsman in the OOC room if you wish to receive these.");
		//PS_TintFixer(oPC);	}
	//else
			
	if (!GetIsObjectValid(oItem)) SendMessageToPC(oPC, "You appear to missing your essence. This could be bad. Contact a DM.");
		
	if (GetSubRace(oPC) == 138) // half-dragon
	{	
		// do dragonman racial heritage selection. store as var on essence
		ActionStartConversation(oPC, "ps_srr_conv_dbreath", TRUE, FALSE, TRUE, TRUE);
		
		// now set appropriate immunity
		int iType = PS_GetLocalInt(oItem, "DRAGONTYPE");
		int iImmunity;
		if (iType < 1)
		SendMessageToPC(oPC, "Cannot set Immunity type as Dragon heritage not selected. Use your breath ability to fix or if that fails, contact a member of the staff.");
		else
		{	
			switch (iType)
			{	
				case 2: // silver
	       		case 10: //white
					iImmunity = 2261;
					break;
				case 3: //copper
	       		case 7: //black
				case 9: //green
					iImmunity = 2282;
					break;
				case 1: //gold
				case 4: //brass
				case 6: //red
					iImmunity = 2260;
					break;
				case 5: // bronze
				case 8: //blue
					iImmunity = 2283;
					break;
			}
			FeatAdd(oPC, iImmunity, FALSE, TRUE, FALSE);
		}
	}
		
	if (nID == 0)
	{	
		SQLExecDirect("SELECT id FROM characterdata WHERE account='"+sAccount+"' AND name='"+sName+"'");
		while (SQLFetch() != SQL_ERROR)
		{ 
			nID = StringToInt(SQLGetData(1));
			PS_SetLocalInt(oItem,"ID",nID);
			PS_SetLocalInt(oPC,"ID",nID);
		}				
	}
		
	//update login into
	SQLExecDirect("UPDATE characterdata SET lastlogged=NOW(), ip='" + sIP + "', publickey='" + sKey + "' WHERE id=" + IntToString(nID));
	
	return FALSE;
}

void main()
{
	//SendMessageToPC(GetFirstPC(), "onpcloaded start");
	
	// set up the plugin commands in _aaa_first_login
	FirstLogin();
	object oPC = GetEnteringObject();
	if(!CheckIfNameExploiting(oPC)) return;
	
	string Legal = "";
	string ECL = "";
	int Template = 0;
	int Booted = FALSE;
	FF_ScrubVars(oPC);
	
	if (PS_GetLocalInt(oPC, "LAST_OOC_PORTAL") == 0) {
		PS_Timestamp_UNIX(oPC, "LAST_OOC_PORTAL");
	}
	
	DelayCommand(0.5f, PortIntoNewFactionSystem(oPC));
	
	if(GetIsPC(oPC) && !GetIsDM(oPC) && GetXP(oPC) == 0)
	{	
		//special race template
		object oItem = GetItemPossessedBy(oPC,"ps_specracetemplate");
		if(GetIsObjectValid(oItem))
		{	
			//SendMessageToPC(GetFirstPC(), "has valid templace object");
			Legal = PS_GetLocalString(oItem,"LEGAL");
			ECL = PS_GetLocalString(oItem,VAR_ECL);
			Template = 1;
			DestroyObject(oItem);
			//SendMessageToPC(GetFirstPC(), Legal+ECL+IntToString(Template));
		}
		
		// Give Newly created characters starting feats that they would have gotten
		// from ps_levelup at level 1 if it were called on character creation
		GiveStartingFeats(oPC);
		PS_GiveXPReward(oPC, 1);
		GiveStartingGold(oPC, 500);

		if (Template == 0) RemoveAllItems(oPC); //don't remove widgets on race templates
		CreateItemOnObject("ps_essence", oPC);
		//template
		if (Template == 1)
		{	
			//SendMessageToPC(GetFirstPC(), "setting to essence");
			oItem = PS_GetEssence(oPC);
			PS_SetLocalString(oItem, "LEGAL", Legal);
			//PS_SetLocalString(oItem, "ECL", ECL);
			PS_SetLocalInt(oItem, "OldSubrace", GetSubRace(oPC)); 
			SendMessageToPC(oPC, "Original subrace information stored: " + IntToString(GetSubRace(oPC)));			
		}
		

		Booted = prepChar(oPC);
		ExportSingleCharacter(oPC);
	}
	else
	{	
		Booted = prepChar(oPC);
	
		//adding shadowjump to existing chars
		int nCLASS = GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oPC);
		if (nCLASS > 3 && !GetHasFeat(2859, oPC) && !GetHasFeat(2860, oPC) && !GetHasFeat(2861, oPC))
		{	
			if (nCLASS < 6) FeatAdd(oPC, 2859, FALSE, TRUE, TRUE);
			else if (nCLASS < 10 ) FeatAdd(oPC, 2860, FALSE, TRUE, TRUE);
			else FeatAdd(oPC, 2861, FALSE, TRUE, TRUE);
		}
		
		ExportSingleCharacter(oPC);
	}
	
	object oCheck =  GetItemPossessedBy(oPC, "ps_essence");
	
	// If OldSubrace is not already set, set it!
	if (PS_GetLocalInt(oCheck, "OldSubrace") == 0 && PS_GetLocalString(oCheck, "Template") == "")
	{	PS_SetLocalInt(oCheck, "OldSubrace", GetSubRace(oPC));	}
	
	/*	Victim of crash during Word of Peace imprisonment effect is sent back to where they came from.	*/
	location lExdim = PS_GetLocalLocation(oCheck, "ExtraDim");
	if (GetIsLocationValid(lExdim))
	{	
		AssignCommand(oPC, JumpToLocation(lExdim));
		DelayCommand(3.0f, PS_DeleteLocalLocation(oCheck, "ExtraDim"));
	}
	
	/* 	If the character died less than 4 hours ago, is still dead, ensure they wind up where they died and 
		not in the OOC room. This is to prevent an exploit where changing one letter in the player login
		causes them to spawn into the OOC room and get a free respawn without penalty. */
	if (GetIsDead(oPC))
	{	
		SendMessageToPC(oPC, "You logged off while dead!");
		object oMod 		= GetModule();
		int iSinceBoot 		= PS_GetTimestamp_Age_Hours(oMod, "BootStamp");
		SendMessageToPC(oPC, "The module booted " + IntToString(iSinceBoot) + " hours ago.");
		int iSinceDied		= PS_GetTimestamp_Age_Hours(oCheck, "Deathstamp");
		SendMessageToPC(oPC, "You died " + IntToString(iSinceDied) + " hours ago.");
		location lDied		= PS_GetLocalLocation(oCheck, "Deathsite");
		string sAreaDied	= PS_GetLocalString(oCheck, "PC_DEATH_AREA");
		//SendMessageToPC(oPC, "You died in " + sAreaDied + ".");
		location lStart		= GetStartingLocation();
		location lReturn	= GetLocation(GetWaypointByTag("wp_ooc_death"));
		string sArea		= GetTag(GetArea(oPC));
		effect eRez			= EffectResurrection();
		effect eDeath 		= EffectDeath(FALSE, FALSE, TRUE);
		effect eKnockdown	= EffectKnockdown();
		if (sArea == "spawnroom")
		{	
			if (iSinceDied < 4 && iSinceDied >= iSinceBoot)
			{	
				//SendMessageToPC(oPC, "You should be jumping to where you died!");
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eRez, oPC);
				AssignCommand(oPC, JumpToLocation(lDied));
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oPC);
				DelayCommand(3.0f, PS_SetLocalLocation(oCheck, "Deathsite", lDied));
				DelayCommand(3.0f, PS_SetLocalString(oCheck, "PC_DEATH_AREA", sAreaDied));	
			}
		}
		else
		{	
			if (iSinceDied >= 4)
			{	
				SendMessageToPC(oPC, "You should be jumping to the oarsman!");
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eRez, oPC);
				AssignCommand(oPC, JumpToLocation(lReturn));
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oPC, 6.0f);
			}
		}
	}
	
	// Save current ECL to essence
	PS_CalculateECL(oPC);
	PS_EnforceMaxLevel(oPC);
	
	object oEssence	= GetItemPossessedBy(oPC,"ps_essence");
	if (PS_GetLocalInt(oEssence, "TempChange") != 1)
	{	
		PS_WingTailSetup(oPC);
		PS_ApplyPCTail(oPC);
		PS_ApplyPCWings(oPC);
	}
	
//	DelayCommand(6.0f, StackingEquipmentBugFix(oPC));

		
	// Remove possible exploit from casting Divine Power or other BABMinimum effects prior to reset or crash
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBABMinimum(1), oPC, 0.5f);
	
    DMFI_ClientEnter(oPC);

	
	SQLExecDirect("SELECT text FROM news ORDER BY id");
	string sNews = "";
	
	while (SQLFetch() != SQL_ERROR)
	{ 
		sNews = SQLGetData(1);
		DelayCommand(5.0, SendMessageToPC(oPC, sNews));
	}
	float delay=3.0;
	float delayInterval=0.2;

	if (Booted == FALSE) {
		CountSpells(oPC,0);
		PS_OnPCLoaded(oPC);
		ConvertBio(oPC);
		// it is VITALLY IMPORTANT that we update items BEFORE we update feats
		// in ff_update_feats because GetHasFeat() cannot differentiate between
		// a feat a char has on char and a feat a char has as a bonus feat on an 
		// item. So in the case of replacing old feats with new versions we have 
		// to check the items first otherwise we could get a false positive when
		// checking the character
		FF_UpdateLegacyItems(oPC);
		EnableFinesse();
		EnableCreatureFinesse();
		CheckTattoos(oPC);
		ScaleAdjust(oPC);
		SetClockOnForPlayer(oPC, TRUE);
		// call to class_mageslayer_utils
		MageSlayerLevels(oPC);
		PS_KnightLevels(oPC);
		ff_update_feats(oPC); // used to be ff_sneak_fix, now single source of all general feat updates
		DelayCommand(1.0f, GiveCreatureSkin(oPC));
	}
}