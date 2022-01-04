//v. 1.01

#include "dmfi_inc_initial"
#include "nwnx_sql"
#include "nwnx_srvadmin"
#include "ps_inc_functions"
#include "nwnx_character"
#include "ps_class_inc"
#include "ps_inc_advscript"
#include "ps_inc_polymorph"
#include "ps_inc_time"
#include "ps_inc_ecl"
#include "ps_inc_wingtail"
#include "ps_inc_bgspellfix"
#include "ginc_time"

const int nDailyXP = 300;
const int nDailyXPlevel = 100;

/*void StackingEquipmentBugFix(object oPC) {

	//In case we are somewhere unsafe, make me ethereal. Also give temporary stat boosts while gear is being removed
	effect eSanctuary = EffectEthereal();
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSanctuary, oPC, 8.0f);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_WISDOM, 12), oPC, 8.0f);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_INTELLIGENCE, 12), oPC, 8.0f);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_CHARISMA, 12), oPC, 8.0f);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_STRENGTH, 12), oPC, 8.0f);
	SendMessageToPC(oPC, "Re-equipping equipment for bugfix. Check the ground for any lost items before proceeding.");
	
	ClearAllActions();
	
	object oItem = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
	if (GetIsObjectValid(oItem)) {
		AssignCommand(oPC, ActionUnequipItem(oItem));
		DelayCommand(0.1f, AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_ARMS)));
	}
	
	oItem = GetItemInSlot(INVENTORY_SLOT_BELT, oPC);
	if (GetIsObjectValid(oItem)) {
		AssignCommand(oPC, ActionUnequipItem(oItem));
		DelayCommand(0.1f, AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_BELT)));
	}
	
	oItem = GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC);
	if (GetIsObjectValid(oItem)) {
		AssignCommand(oPC, ActionUnequipItem(oItem));
		DelayCommand(0.1f, AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_BOOTS)));
	}
	
	oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
	if (GetIsObjectValid(oItem)) {
		AssignCommand(oPC, ActionUnequipItem(oItem));
		DelayCommand(0.1f, AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CHEST)));
	}
	
	oItem = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);
	if (GetIsObjectValid(oItem)) {
		AssignCommand(oPC, ActionUnequipItem(oItem));
		DelayCommand(0.1f, AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_CLOAK)));
	}
	
	oItem = GetItemInSlot(INVENTORY_SLOT_HEAD, oPC);
	if (GetIsObjectValid(oItem)) {
		AssignCommand(oPC, ActionUnequipItem(oItem));
		DelayCommand(0.1f, AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_HEAD)));
	}
	
	oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	if (GetIsObjectValid(oItem)) {
		AssignCommand(oPC, ActionUnequipItem(oItem));
		DelayCommand(0.1f, AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_LEFTHAND)));
	}
	
	oItem = GetItemInSlot(INVENTORY_SLOT_LEFTRING, oPC);
	if (GetIsObjectValid(oItem)) {
		AssignCommand(oPC, ActionUnequipItem(oItem));
		DelayCommand(0.1f, AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_LEFTRING)));
	}
	
	oItem = GetItemInSlot(INVENTORY_SLOT_NECK, oPC);
	if (GetIsObjectValid(oItem)) {
		AssignCommand(oPC, ActionUnequipItem(oItem));
		DelayCommand(0.1f, AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_NECK)));
	}
	
	oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	if (GetIsObjectValid(oItem)) {
		AssignCommand(oPC, ActionUnequipItem(oItem));
		DelayCommand(0.1f, AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_RIGHTHAND)));
	}
	
	oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC);
	if (GetIsObjectValid(oItem)) {
		AssignCommand(oPC, ActionUnequipItem(oItem));
		DelayCommand(0.1f, AssignCommand(oPC, ActionEquipItem(oItem, INVENTORY_SLOT_RIGHTRING)));
	}

}*/

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
	object oItem = GetItemPossessedBy(oPC, "ps_essence");
	object oINVALID = OBJECT_INVALID;

	int nID = GetLocalInt(oItem,"ID");
	string sAccount = "";
	string sName = "";
	string sECL = PS_GetEssenceECL(oPC); //Edit by Clangeddin, this will take care of setting the proper ECL at login.
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
		
	SetLocalInt(oItem,"ID",nID);
	SetLocalInt(oPC,"ID",nID);
			
	string sDay = GetLocalString(oItem, "XPDay");
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
			
			SetLocalString(oItem,"XPDay",SQLGetData(4));
			//DebugMessageToPC(oPC,"xpday:" + GetLocalString(oItem,"XPDay"));
				
			int nModifiedXP = FloatToInt((nDailyXP + nDailyXPlevel * GetHitDice(oPC)) * PS_GetXPModifier(StringToInt(sECL)));
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
	if (GetLocalInt(oItem, "AppInitialized") != 1)
	{	
		PS_SaveOriginalAppearance(oPC);
		SetLocalInt(oItem, "AppInitialized", 1);
	}

	//Run check to see if any temp appearance changes are applied, and if so revert to Original.
	if (GetLocalInt(oItem, "TempChange") != 0)
	{	
		PS_RestoreOriginalAppearance(oPC);
		SetLocalInt(oItem, "TempChange", 0);
	}

	int iSUB = GetSubRace(oPC);
			
	//sECL = Get2DAString("racialsubtypes", "LA", iSUB);
	//SetLocalString(oItem,"ECL", sECL);	
	//SetLocalString(oPC,"ECL", sECL);
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
	//{	SetLocalInt(oEssence, "FIXSRR", 1);
		//DisplayMessageBox(oPC, 0, "IMPORTANT NOTICE: Your character has the opportunity to have wings or a tail. Visit the Styx Oarsman in the OOC room if you wish to receive these.");
		//PS_TintFixer(oPC);	}
	//else
			
	if (!GetIsObjectValid(oItem)) SendMessageToPC(oPC, "You appear to missing your essence. This could be bad. Contact a DM.");
		
	if (GetSubRace(oPC) == 138) // half-dragon
	{	
		// do dragonman racial heritage selection. store as var on essence
		ActionStartConversation(oPC, "ps_srr_conv_dbreath", TRUE, FALSE, TRUE, TRUE);
		
		// now set appropriate immunity
		int iType = GetLocalInt(oItem, "DRAGONTYPE");
		int iImmunity;
		if (iType < 1)
		SendMessageToPC(oPC, "Cannot set Immunity type as Dragon heritage not selected. Use your breath ability to fix or if that fails, contact a member of staff");
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
			SetLocalInt(oItem,"ID",nID);
			SetLocalInt(oPC,"ID",nID);
		}				
	}
		
	//update login into
	SQLExecDirect("UPDATE characterdata SET lastlogged=NOW(), ip='" + sIP + "', publickey='" + sKey + "' WHERE id=" + IntToString(nID));
	
	return FALSE;
}

void main()
{
	//SendMessageToPC(GetFirstPC(), "onpcloaded start");
	
	object oPC = GetEnteringObject();
	if(!CheckIfNameExploiting(oPC)) return;
	
	string Legal = "";
	string ECL = "";
	int Template = 0;
	int Booted = FALSE;
	
	if (GetLocalInt(oPC, "LAST_OOC_PORTAL") == 0) {
		PS_Timestamp_UNIX(oPC, "LAST_OOC_PORTAL");
	}
	
	if(GetIsPC(oPC) && !GetIsDM(oPC) && GetXP(oPC) == 0)
	{	
		//special race template
		object oItem = GetItemPossessedBy(oPC,"ps_specracetemplate");
		if(GetIsObjectValid(oItem))
		{	
			//SendMessageToPC(GetFirstPC(), "has valid templace object");
			Legal = GetLocalString(oItem,"LEGAL");
			ECL = GetLocalString(oItem,"ECL");
			Template = 1;
			DestroyObject(oItem);
			//SendMessageToPC(GetFirstPC(), Legal+ECL+IntToString(Template));
		}
			
		GiveXPToCreature(oPC, 1);
		GiveStartingGold(oPC, 500);
		if (Template == 0) RemoveAllItems(oPC); //don't remove widgets on race templates
		CreateItemOnObject("ps_essence", oPC);
		//template
		if (Template == 1)
		{	
			//SendMessageToPC(GetFirstPC(), "setting to essence");
			oItem = GetItemPossessedBy(oPC,"ps_essence");
			SetLocalString(oItem, "LEGAL", Legal);
			//SetLocalString(oItem, "ECL", ECL);
			SetLocalInt(oItem, "OldSubrace", GetSubRace(oPC)); 
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
	
	// If OldSubrace is not alredy set, set it!
	if (GetLocalInt(oCheck, "OldSubrace") == 0 && GetLocalString(oCheck, "Template") == "")
	{	SetLocalInt(oCheck, "OldSubrace", GetSubRace(oPC));	}
	
	/*	Victim of crash during Word of Peace imprisonment effect is sent back to where they came from.	*/
	location lExdim = GetLocalLocation(oCheck, "ExtraDim");
	if (GetIsLocationValid(lExdim))
	{	
		AssignCommand(oPC, JumpToLocation(lExdim));
		DelayCommand(3.0f, DeleteLocalLocation(oCheck, "ExtraDim"));
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
		location lDied		= GetLocalLocation(oCheck, "Deathsite");
		string sAreaDied	= GetLocalString(oCheck, "PC_DEATH_AREA");
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
				DelayCommand(3.0f, SetLocalLocation(oCheck, "Deathsite", lDied));
				DelayCommand(3.0f, SetLocalString(oCheck, "PC_DEATH_AREA", sAreaDied));	
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
	if (GetLocalInt(oEssence, "TempChange") != 1)
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
	
	if (Booted == FALSE) {
		CountSpells(oPC,0);
		PS_OnPCLoaded(oPC);
		SetClockOnForPlayer(oPC, TRUE);
	}
}