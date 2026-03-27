//v 0.1
//reward players roleplaying
#include "nwnx_sql"
#include "ps_inc_functions"
#include "ServerExts"
#include "ff_update_legacy_items"
#include "ps_inc_advscript"
#include "ps_inc_randomitems"
#include "x2_inc_itemprop"


int GetIsVamp(object oPC){
	int nVamp = GetLevelByClass(78, oPC) + GetLevelByClass(105, oPC) 
		+ GetLevelByClass(106, oPC);
	if (nVamp >= 1) return TRUE;
	return FALSE;
}


int IsAuthorizedToUseThisCmd(object oPC)
{
    if(GetIsDM(oPC))  return TRUE;
    return FALSE;
}


void SendTellMessageToAllPlayersInArea(object oSender, string sMessage)
{
    object oTarget = GetFirstPC();
    while (GetIsObjectValid(oTarget))
    {
    if (GetArea(oSender) == GetArea(oTarget))
    {
        ServerExts_SendChatMessage(oSender,oTarget,CHAT_MODE_SHOUT,sMessage,FALSE);
    }
        oTarget = GetNextPC();
    }
}



void GiveXPTick(object oPC) {

	if (PS_GetLevel(oPC) >= 30  && !ALLOW_ECL_LEVEL_30)
		return;

	int lastDone = CheckTimeStamp(oPC, "RP_EXP_AWARDED_LAST");
	if (lastDone < 900‬) //happens once per 15 minutes, max
		return;
	TimeStamp(oPC, "RP_EXP_AWARDED_LAST");

	int baseTick = 10;
	baseTick += d20();

	SendMessageToPC(oPC, "Experience awarded for RP:");
	//PS_GiveXPReward(oPC, baseTick); // xp rewards for rp do not get taxed for ECL
	GiveXPToCreature(oPC, baseTick);

}

void awardXP(object oPC, int XPamount)
{
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
	
	DelayCommand(1.0f, GiveXPTick(oPC));
	
	if( GetIsObjectValid(oItem) )
	{
		string sID = PS_GetCharID(oPC);
		
		SQLExecDirect("SELECT rp_pool FROM characterdata WHERE id=" + sID);

		if (SQLFetch() != SQL_ERROR) { 
			int nECL = StringToInt(GetLocalString(oItem,"ECL"));
			int nRPpool = StringToInt(SQLGetData(1));

			nRPpool += FloatToInt(XPamount*PS_GetXPModifier(nECL));
			SQLExecDirect("UPDATE characterdata set rp_pool=" + IntToString(nRPpool) + " WHERE id=" + sID);		
		}
		
	}

}

int isNotAlone(object oPC)
{
	object oArea = GetArea(oPC);
	
	object oPCIterator = GetFirstPC();
	
	while (GetIsObjectValid(oPCIterator) == TRUE){
		if (GetArea(oPCIterator) == oArea && oPC != oPCIterator)
			return TRUE;
		oPCIterator = GetNextPC();
	}
	return FALSE;
}

int ForwardMessageToTextCommands(object oSender, object oTarget, int nChannel, string sMessage)
{
	ClearScriptParams();
	AddScriptParameterObject(oSender);
	AddScriptParameterObject(oTarget);
	AddScriptParameterInt(nChannel);
	AddScriptParameterString(sMessage);
	return ExecuteScriptEnhanced("Sigil.TextCommands", OBJECT_SELF, TRUE);
}

string ExpandMessage(object oSender, string sMessage)
{
	//
	// Only interested if color emotes are enabled.
	//

	if ((PS_GetPCFlags(oSender) & PS_PC_FLAG_COLOR_EMOTES) == 0)
	{
		return sMessage;
	}

	//
	// Expand color macros.
	//

	return PS_ColorizeChatMessage(sMessage);
}

void ApplyRPXP(object oSender, object oTarget, int nChannel, string sMessage)
{
	if(d100() < 85)
		return; //award randomly
			
	if (GetStringLeft(sMessage, 1) == " " || GetStringRight(sMessage, 1) == " " ||
		GetStringLeft(sMessage, 2) == "\\" || GetStringRight(sMessage, 2) == "\\" ||
		GetStringLeft(sMessage, 1) == "/" || GetStringRight(sMessage, 1) == "/" ||
		GetStringLeft(sMessage, 1) == "(" || GetStringRight(sMessage, 1) == "(" ||
		GetStringLeft(sMessage, 1) == ")" || GetStringRight(sMessage, 1) == ")" ||
		GetStringLeft(sMessage, 1) == "#" || GetStringRight(sMessage, 1) == "#" ||
		GetStringUpperCase(GetStringLeft(sMessage, 3)) == "OOC" ||
		GetStringUpperCase(GetStringRight(sMessage, 3)) == "OOC")
		return;
	
	if (GetTag(GetArea(oSender)) == "spawnroom" ||
		GetTag(GetArea(oSender)) == "ps_area_oocroom" ||
		GetTag(GetArea(oSender)) == "ps_area_sigil-gymnasiumarena" ||
		GetTag(GetArea(oSender)) == "ps_area_dmlair")
		return;
			
	while (GetIsObjectValid(GetMaster(oSender)))
 	{
 		oSender=GetMaster(oSender);
 	}

	if (!GetIsPC(oSender) || nChannel != CHAT_MODE_TALK ) 
	{
	    return;
	}

	if(isNotAlone(oSender))
	{
		int nAward = 100 + FloatToInt(log(GetStringLength(sMessage)/5.0)*45.0);
		
		if ( nAward > 0 )
		{
			if ( nAward > 100 )
				nAward = 100;
			awardXP(oSender, nAward);
		}
	}
}

// a function that sends a tick message to the player every 6 seconds
// to be used for debugging purposes. 
void SixSecondTick(object oPC, int nRound = 1){

	if (GetLocalInt(oPC, "6secondtick")){
		// Send the message to the player
		SendMessageToPC(oPC, "<c=cyan>Tick " + IntToString(nRound) + "</c>");
		nRound += 1;
		// Schedule the next tick after 6 seconds
		DelayCommand(6.0f, SixSecondTick(oPC, nRound));
	}
}

void RollSocialCheck(object oPC, int nAction, int nChannel,  string sMessage = ""){
	// this is the action that merely reports the rules for the social rolls.
	if (nAction == 255){
		sMessage = "<c=lightgreen>There are social skill roll chat commands you can use to facilitate";
		sMessage +=" adding dice rolls into your RP, but these are meant to ENHANCE RP, not REPLACE it. This is not ";
		sMessage +="mind control and other players are perfectly free to ignore the outcome of a dice roll if they believe";
		sMessage +=" that the RP does not warrant the outcome of the dice. No player can tell another player how to RP their";
		sMessage +=" character. Ever.\n\n";
		sMessage +="Usage: Either say what you mean to say (if anything) and then type the command, such as:\n";
		sMessage +="'No, those trousers don't make your bottom look big'\n";
		sMessage +="#Lie\n";
		sMessage +="Or type the command followed by what you want to say, such as:\n";
		sMessage +="#Lie This slaadi stew is delicious!\n\n";
		sMessage +="The commands are:\n\n";
		sMessage +="#Appraise or #Haggle:\n";
		sMessage +="You roll highest of: Appraise, 2/3 Bluff, 2/3 Diplomacy, or 2/3 Perform.\n";
		sMessage +="Nearby PCs roll highest of: Appraise, 2/3 Will Save, 2/3 Bluff, or  2/3 Diplomacy.\n\n";
		sMessage +="#Bluff or #Lie:\n";
		sMessage +="You roll highest of: Bluff, 2/3 Diplomacy, or 2/3 Perform.\n";
		sMessage +="Nearby PCs roll highest of: Bluff, Spot, Listen, or 2/3 Diplomacy.\n\n";
		sMessage +="#Diplomacy or #Persuade:\n";
		sMessage +="You roll highest of: Diplomacy, 2/3 Bluff, or 2/3 Perform.\n";
		sMessage +="Nearby PCs roll highest of: Concentration, Diplomacy, 2/3 Will Save, or 2/3 Bluff\n\n";
		sMessage +="#Intimidate or #Threat:\n";
		sMessage +="You roll highest of: Intimidate, 2/3 Bluff, 2/3 Diplomacy, or 2/3 Perform.\n";
		sMessage +="Nearby PCs roll highest of: Intimidate, Concentration, 2/3 Will, or 2/3 Diplomacy.\n\n";
		sMessage +="#Sleight:\n";
		sMessage +="You roll higher of: Sleight of Hand or 1/3 Reflex save.\n";
		sMessage +="Nearby PCs roll highest of: Spot, 2/3 Sleight of Hand, or 1/2 Search.\n\n"; 
		sMessage +="You will see the result of your roll. You will not see the result of other's rolls.";
		sMessage +=" Other PCs will see only whether they succeeded or failed vs your roll except for in the";
		sMessage +=" case of Bluff and Sleight of Hand; if they fail their rolls versus you in those skills then ";
		sMessage +="they will see no message.\nKeep in mind some important rules:\n";
		sMessage +="1: Again, players are free to ignore the dice outcome. You can't tell them how to RP.\n";
		sMessage +="2: DMs see all of the outcomes of these rolls, so during DM events do NOT use ";
		sMessage +="them unless a DM ASKS you to. Otherwise you will spam up the DM channel and have an angry DM.\n";
		sMessage += "Please see sigil-nwn2.fandom.com/wiki/Chat_Commands for more chat command info.\n";
		sMessage +="Have fun and Happy Roleplaying! -FlattedFifth</c>";
		SendMessageToPC(oPC, sMessage);
		return;
	}
	
	// if the dm uses this while targeting a player or npc, then roll everything as if that player or npc
	// used the command
	if (GetIsDM(oPC)){
		object oTarget = GetPlayerCurrentTarget(oPC);
		if (GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
		oPC = oTarget;
		if (GetIsPC(oTarget)) sMessage = ""; // a DM should not be able to put words in a PCs mouth.
	}
	//strip leading spaces off of sMessage
	if (sMessage != ""){
		while (sMessage != "" && GetStringLeft(sMessage, 1) == " "){
			sMessage = GetSubString(sMessage, 1, GetStringLength(sMessage) - 1);
		}
	}
	
	//int nNoSkillPenalty = 5;
	int nSkill = -1;
	int nOpSkill = -1; 
	int nDC;
	string sPlayerMessage = "<c=lightgreen>You attempt to ";
	string sListenerMessage = "";
	int bMindImmune;
	int nBluff; int nDipl; int nPerf; int nOpSearch; int nOpSleight;
	int nOpBluff; int nOpDipl; int nOpIntim; int nOpPerf; int nOpCon; int nOpSpot; int nOpListen; int nOpWill;
	float fRange = RADIUS_SIZE_HUGE;
	if (nAction == SKILL_SLEIGHT_OF_HAND || nChannel == CHAT_MODE_WHISPER)
		fRange = RADIUS_SIZE_MEDIUM;
	string sName = GetFirstName(oPC) + " " + GetLastName(oPC);
	string sWinMessage;
	string sLoseMessage;
	string sDmAddendum;
	string sAction;
	string sDmMessage = sName + " has attempted to ";

	switch (nAction){
		case SKILL_APPRAISE:{
			sAction = "HAGGLE";
			nSkill = GetSkillRank(SKILL_APPRAISE, oPC);
			nBluff = (GetSkillRank(SKILL_BLUFF, oPC) / 3) * 2;
			nDipl = (GetSkillRank(SKILL_DIPLOMACY, oPC) / 3) * 2;
			nPerf = (GetSkillRank(SKILL_PERFORM, oPC) / 3) * 2;
			if (nBluff > nSkill) nSkill = nBluff;
			if (nDipl > nSkill) nSkill = nDipl;
			if (nPerf > nSkill) nSkill = nPerf;
			break;
		}
		case SKILL_BLUFF:{
			sAction = "LIE";
			nSkill = GetSkillRank(SKILL_BLUFF, oPC);
			nDipl = (GetSkillRank(SKILL_DIPLOMACY, oPC) / 3) * 2;
			nPerf = (GetSkillRank(SKILL_PERFORM, oPC) / 3) * 2;
			if (nDipl > nSkill) nSkill = nDipl;
			if (nPerf > nSkill) nSkill = nPerf;
			break;
		}
		case SKILL_DIPLOMACY:{
			sAction = "PERSUADE";
			nSkill = GetSkillRank(SKILL_DIPLOMACY, oPC);
			nBluff = (GetSkillRank(SKILL_BLUFF, oPC) / 3) * 2;
			nPerf = (GetSkillRank(SKILL_PERFORM, oPC) / 3) * 2;
			if (nBluff > nSkill) nSkill = nBluff;
			if (nPerf > nSkill) nSkill = nPerf;
			break;
		}
		case SKILL_INTIMIDATE:{
			sAction = "INTIMIDATE";
			nSkill = GetSkillRank(SKILL_INTIMIDATE, oPC);
			nBluff = (GetSkillRank(SKILL_BLUFF, oPC) / 3) * 2;
			nDipl = (GetSkillRank(SKILL_DIPLOMACY, oPC) / 3) * 2;
			nPerf = (GetSkillRank(SKILL_PERFORM, oPC) / 3) * 2;
			if (nBluff > nSkill) nSkill = nBluff;
			if (nDipl > nSkill) nSkill = nDipl;
			if (nPerf > nSkill) nSkill = nPerf;
			break;
		}
		case SKILL_SLEIGHT_OF_HAND:{
			sAction = "perform SLEIGHT OF HAND";
			nSkill = GetSkillRank(SKILL_SLEIGHT_OF_HAND, oPC);
			int nRefl = GetReflexSavingThrow(oPC) / 3;
			if (nRefl > nSkill) nSkill = nRefl;
			break;
		}
		default: break;
	}
	if (nSkill == -1) return;
	
	nDC = d20() + nSkill;
	// OPTIONAL: Impose a penalty on anyone attempting to perform a skill in which they have 0 base points
	//if (GetSkillRank(nAction, oPC, TRUE) == 0) nDC -= nNoSkillPenalty;
	if (GetIsPC(oPC)){
		sPlayerMessage += sAction + " with a roll of " + IntToString(nDC) + ".</c>\n";
		if (!GetLocalInt(oPC, "ToldSocialRollRules")){
			sPlayerMessage += "<c=red>( type #SocialRollRules for rules about this feature )</c>";
			SetLocalInt(oPC, "ToldSocialRollRules", TRUE);
		}
		SendMessageToPC(oPC, sPlayerMessage);
	}
	
	sDmMessage += sAction + " with a roll of " + IntToString(nDC) + ".\n";
	
	// if the last time the pc spoke before invoking this command was within 2 minutes ago, 
	// echo it back to the dm in case it's relevant
	if (GetIsPC(oPC)){
		int bShowPreviousMessage = (PS_GetTime() - GetLocalInt(oPC, "LastTimeSpoke") <= 120) ? TRUE : FALSE;
		string sLastMessage = GetLocalString(oPC, "LastChatMessage");
		if (sLastMessage == "") bShowPreviousMessage = FALSE;
		if (bShowPreviousMessage){
			if (sMessage != "") sDmMessage += "First they ";
			else sDmMessage += "They ";
			if (GetLocalInt(oPC, "LastChatChannel") == CHAT_MODE_WHISPER) sDmMessage += "<i>whispered</i> '";
			else sDmMessage += "<i>said</i> '";
			sDmMessage += sLastMessage + "'\n";
		}
		// if the sMessage arg is not empty then that means the player used the command in front of the text, 
		// such as #Threat Give me your lunch money, punk!, and so we repeat that to the dm.
		if (sMessage != ""){
			if (bShowPreviousMessage) sDmMessage += "And then they ";
			else sDmMessage += "They ";
			if (nChannel == CHAT_MODE_WHISPER) sDmMessage += "<i>whispered</i> '";
			else sDmMessage += "<i>said</i> '";
			sDmMessage += sMessage + "'\n";
		}
	}
	
	
	location lLoc = GetLocation(oPC);
	object oListener = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lLoc);
	while (GetIsObjectValid(oListener)){
		if (oListener != oPC && !GetIsDM(oPC)){
			sListenerMessage = "";
			bMindImmune = (GetIsImmune(oListener, IMMUNITY_TYPE_MIND_SPELLS, oPC) ||
				GetIsImmune(oListener, IMMUNITY_TYPE_FEAR, oPC));
			
			switch (nAction){
				case SKILL_APPRAISE:{
					nOpSkill = GetSkillRank(SKILL_APPRAISE, oListener);
					nOpBluff = (GetSkillRank(SKILL_BLUFF, oListener) / 3) * 2;
					nOpDipl = (GetSkillRank(SKILL_DIPLOMACY, oListener) / 3) * 2;
					nOpCon = (GetSkillRank(SKILL_CONCENTRATION, oListener) / 3) * 2;
					nOpWill = (GetWillSavingThrow(oListener) / 3) * 2;
					if (nOpBluff > nOpSkill) nOpSkill = nOpBluff;
					if (nOpDipl > nOpSkill) nOpSkill = nOpDipl;
					if (nOpCon > nOpSkill) nOpSkill = nOpCon;
					if (nOpWill > nOpSkill) nOpSkill = nOpWill;
					sWinMessage = "You're not convinced that " + sName + " has any notion of true value.";
					sLoseMessage = sName + " may have a point about the value.";
					sDmAddendum = " on their barter roll ";
					break;
				}
				case SKILL_BLUFF:{
					nOpSkill = GetSkillRank(SKILL_BLUFF, oListener);
					nOpDipl = (GetSkillRank(SKILL_DIPLOMACY, oListener) / 3) * 2;
					nOpSpot = GetSkillRank(SKILL_SPOT, oListener);
					nOpListen = GetSkillRank(SKILL_LISTEN, oListener);
					if (nOpDipl > nOpSkill) nOpSkill = nOpDipl;
					if (nOpSpot > nOpSkill) nOpSkill = nOpSpot;
					if (nOpListen > nOpSkill) nOpSkill = nOpListen;
					sWinMessage = "You suspect that " + sName + " is lying.";
					sLoseMessage = "";
					sDmAddendum = " on their roll to see through the lie ";
					break;
				}
				case SKILL_DIPLOMACY:{
					nOpSkill = GetSkillRank(SKILL_DIPLOMACY, oListener);
					nOpBluff = (GetSkillRank(SKILL_BLUFF, oListener) / 3) * 2;
					nOpCon = GetSkillRank(SKILL_CONCENTRATION, oListener);
					nOpWill = (GetWillSavingThrow(oListener) / 3) * 2;
					if (nOpBluff > nOpSkill) nOpSkill = nOpBluff;
					if (nOpCon > nOpSkill) nOpSkill = nOpCon;
					if (nOpWill > nOpSkill) nOpSkill = nOpWill;
					sWinMessage = "You do not find " + sName + " very convincing.";
					sLoseMessage = "You find " + sName + " very convincing.";
					sDmAddendum = " on their roll to resist persuasion ";
					break;
				}
				case SKILL_INTIMIDATE:{
					nOpSkill = GetSkillRank(SKILL_INTIMIDATE, oListener);
					nOpCon = GetSkillRank(SKILL_CONCENTRATION, oListener);
					nOpDipl = (GetSkillRank(SKILL_DIPLOMACY, oListener) / 3) * 2;
					nOpWill = (GetWillSavingThrow(oListener) / 3) * 2;
					if (nOpCon > nOpSkill) nOpSkill = nOpCon;
					if (nOpDipl > nOpSkill) nOpSkill = nOpDipl;
					if (nOpWill > nOpSkill) nOpSkill = nOpWill;
					sWinMessage = "You do not find " + sName + " very intimidating.";
					if (bMindImmune){
						sLoseMessage = "You would find " + sName + " very intimidating if you were not immune";
						sLoseMessage += " to fear. However, you believe they are serious.";
					} else sLoseMessage = "You find " + sName + " very intimidating.";
					sDmAddendum = " on their roll to resist intimidation ";
					break;
				}
				case SKILL_SLEIGHT_OF_HAND:{
					nOpSkill = GetSkillRank(SKILL_SPOT, oListener);
					nOpSearch = GetSkillRank(SKILL_SEARCH, oListener) / 2;
					nOpSleight = (GetSkillRank(SKILL_SLEIGHT_OF_HAND, oListener) / 3) * 2;
					if (nOpSearch > nOpSkill) nOpSkill = nOpSearch;
					if (nOpSleight > nOpSkill) nOpSkill = nOpSleight;
					sWinMessage = "You spot " + sName + " performing sleight of hand.";
					sLoseMessage = "";
					sDmAddendum = " on their roll to spot sleight of hand ";
					break;
				}
				default: break;
			
			}
			if (nOpSkill != -1){
				nOpSkill += d20();
				// OPTIONAL: Impose a penalty on anyone attempting to resist a skill in which they have 
				// 0 base points
				/*
				if ((nAction == SKILL_SLEIGHT_OF_HAND && GetSkillRank(SKILL_SPOT, oListener, TRUE) == 0) ||
					(nAction != SKILL_SLEIGHT_OF_HAND && GetSkillRank(nAction, oListener, TRUE) == 0)) 
						nOpSkill -= nNoSkillPenalty;
				*/
				sDmMessage += GetFirstName(oListener) + " " + GetLastName(oListener);
				sDmMessage += (nOpSkill >= nDC) ? " SUCCEEDED" : " FAILED";
				sDmMessage += sDmAddendum;
				sDmMessage += "with a roll of " + IntToString(nOpSkill);
				if (nAction == SKILL_INTIMIDATE && nOpSkill < nDC && bMindImmune){
					sDmMessage += " but is immune to fear";
				}
				sDmMessage += ".\n";
				sListenerMessage = (nOpSkill >= nDC) ? sWinMessage : sLoseMessage;
			
				if (sListenerMessage != "" && GetIsPC(oListener)){
					sListenerMessage = "<c=lightgreen>" + sListenerMessage + "</c>\n";
					if (!GetLocalInt(oListener, "ToldSocialRollRules")){
						sListenerMessage += "<c=red>(This is a suggestion based on a dice roll, not a command)\n";
						sListenerMessage += "( type #SocialRollRules for rules about this feature )</c>";
						SetLocalInt(oListener, "ToldSocialRollRules", TRUE);
					}
					SendMessageToPC(oListener, sListenerMessage);
				}
			}
		}
		oListener = GetNextObjectInShape(SHAPE_SPHERE, fRange, lLoc);
	}
	if (sMessage != "")
		SendChatMessage(oPC, OBJECT_INVALID, nChannel, sMessage);
		
	object oDM = GetFirstPC();
	while (GetIsObjectValid(oDM)){
		if (GetIsDM(oDM)){
			if (!GetLocalInt(oDM, "MUTE_SOCIAL"))
				SendMessageToPC(oDM, sDmMessage);
		}
		oDM = GetNextPC();
	}
}

// collection of simple chat commands by FlattedFifth
int GetIsFFcommand(object oSender, int nChannel, string sMessage){

	if (nChannel != CHAT_MODE_TALK && nChannel != CHAT_MODE_WHISPER)
		return FALSE;
	
	//store last non-command chat message for use in RollSocialCheck()
	if (GetIsPC(oSender)){
		if (GetSubString(sMessage, 0, 1) != "#"){
			SetLocalString(oSender, "LastChatMessage", sMessage);
			SetLocalInt(oSender, "LastChatChannel", nChannel);
			SetLocalInt(oSender, "LastTimeSpoke", PS_GetTime());
			return FALSE;
		}
	}
	string sFeedback = "";
	string sInput = GetStringLowerCase(sMessage);
	object oItem;
	int nPos;
	
	// toggle on and off local int to scribe scrolls at min caster level, see x2_inc_craft
	if (sInput == "#scribemin"){
		if (GetLocalInt(oSender, "bScribeAtMinLvl")){
			SetLocalInt(oSender, "bScribeAtMinLvl", FALSE);
			sFeedback = "ScribeMin OFF\n";
			sFeedback += "You will now scribe scrolls as normal until next server reset ";
			sFeedback += "or until ScribeMin turned on.";
		} else {
			SetLocalInt(oSender, "bScribeAtMinLvl", TRUE);
			sFeedback = "ScribeMin ON\n";
			sFeedback += "You will now scribe scrolls at minimum caster level until next server reset ";
			sFeedback += "or until ScribeMin turned off.";
		}
		SendMessageToPC(oSender, sFeedback);
		return TRUE;
	//turn dm reporting of social roll chat commands on or off
	} else if (sInput == "#togglesocial" && GetIsDM(oSender)){
		int nMuted = GetLocalInt(oSender, "MUTE_SOCIAL");
		if (nMuted){
			sFeedback = "Turning on reporting of social skill chat commands";
			SetLocalInt(oSender, "MUTE_SOCIAL", FALSE);
		} else {
			sFeedback = "Turning off reporting of social skill chat commands";
			SetLocalInt(oSender, "MUTE_SOCIAL", TRUE);
		}
		SendMessageToPC(oSender, sFeedback);
		return TRUE;
	}
	// APPRAISE
	else if (GetStringLeft(sInput, 9) == "#appraise" || GetStringLeft(sInput, 7) == "#haggle"){ 
		if (GetStringLeft(sInput, 9) == "#appraise") nPos = 9;
		else nPos = 7;
		sMessage = GetSubString(sMessage, nPos, GetStringLength(sMessage) - nPos);
		RollSocialCheck(oSender, SKILL_APPRAISE, nChannel, sMessage);
		return TRUE;
	}
	//BLUFF
	else if (GetStringLeft(sInput, 6) == "#bluff" || GetStringLeft(sInput, 4) == "#lie"){
		if (GetStringLeft(sInput, 6) == "#bluff") nPos = 6;
		else nPos = 4;
		sMessage = GetSubString(sMessage, nPos, GetStringLength(sMessage) - nPos);
		RollSocialCheck(oSender, SKILL_BLUFF, nChannel, sMessage);
		return TRUE;
	}
	//DIPLOMACY
	else if (GetStringLeft(sInput, 10) == "#diplomacy" || GetStringLeft(sInput, 9) == "#persuade"){
		if (GetStringLeft(sInput, 10) == "#diplomacy") nPos = 10;
		else nPos = 9;
		sMessage = GetSubString(sMessage, nPos, GetStringLength(sMessage) - nPos);
		RollSocialCheck(oSender, SKILL_DIPLOMACY, nChannel, sMessage);
		return TRUE;
	}
	//INTIMIDATE
	else if (GetStringLeft(sInput, 11) == "#intimidate" || GetStringLeft(sInput, 7) == "#threat"){
		if (GetStringLeft(sInput, 11) == "#intimidate") nPos = 11;
		else nPos = 7;
		sMessage = GetSubString(sMessage, nPos, GetStringLength(sMessage) - nPos);
		RollSocialCheck(oSender, SKILL_INTIMIDATE, nChannel, sMessage);
		return TRUE;
	}
	//SLEIGHT_OF_HAND
	else if (GetStringLeft(sInput, 8) == "#sleight"){
		sMessage = GetSubString(sMessage, 8, GetStringLength(sMessage) - 8);
		RollSocialCheck(oSender, SKILL_SLEIGHT_OF_HAND, nChannel, sMessage);
		return TRUE;	
	} 
	else if (sInput == "#socialrollrules"){
		RollSocialCheck(oSender, 255, nChannel);
		return TRUE;
	} 
	else if (sInput == "#showcl"){
		int nBard = PS_GetCasterLevel(oSender, CLASS_TYPE_BARD);
		int nCleric = PS_GetCasterLevel(oSender, CLASS_TYPE_CLERIC);
		int nDruid = PS_GetCasterLevel(oSender, CLASS_TYPE_DRUID);
		int nFavoured = PS_GetCasterLevel(oSender, CLASS_TYPE_FAVORED_SOUL);
		int nKnight = PS_GetCasterLevel(oSender, CLASS_TYPE_PALADIN);
		int nPsion = PS_GetCasterLevel(oSender, CLASS_TYPE_PSION);
		int nPsywar = PS_GetCasterLevel(oSender, CLASS_PSYCHIC_WARRIOR);
		int nRanger = PS_GetCasterLevel(oSender, CLASS_TYPE_RANGER);
		int nShaman = PS_GetCasterLevel(oSender, CLASS_TYPE_SPIRIT_SHAMAN);
		int nSorc = PS_GetCasterLevel(oSender, CLASS_TYPE_SORCERER);
		int nWarlock = PS_GetCasterLevel(oSender, CLASS_TYPE_WARLOCK);
		int nWizard = PS_GetCasterLevel(oSender, CLASS_TYPE_WIZARD);
		sFeedback = "";
		if (nBard > 0) sFeedback += "\nBard: " + IntToString(nBard);
		if (nCleric > 0) sFeedback += "\nCleric: " + IntToString(nCleric);
		if (nDruid > 0) sFeedback += "\nDruid: " + IntToString(nDruid);
		if (nFavoured > 0) sFeedback += "\nFavoured Soul: " + IntToString(nFavoured);
		if (nKnight > 0) sFeedback += "\nKnight: " + IntToString(nKnight);
		if (nPsion > 0) sFeedback += "\nPsion: " + IntToString(nPsion);
		if (nPsywar > 0) sFeedback += "\nPsychic Warrior: " + IntToString(nPsywar);
		if (nRanger > 0) sFeedback += "\nRanger: " + IntToString(nRanger);
		if (nShaman > 0) sFeedback += "\nShaman: " + IntToString(nShaman);
		if (nSorc > 0) sFeedback += "\nSorcerer: " + IntToString(nSorc);
		if (nWarlock > 0) sFeedback += "\nWarlock: " + IntToString(nWarlock);
		if (nWizard > 0) sFeedback += "\nWizard: " + IntToString(nWizard);
		if (sFeedback == "") sFeedback = "You have no caster levels";
		else sFeedback = "Caster Level(s):" + sFeedback;
		SendMessageToPC(oSender, sFeedback);
		return TRUE;
	}
	// as above but including Alchemical Infusion caster lvl where applicable
	else if (sInput == "#showcraftcl"){ // new chat command for showing crafting caster level
		sFeedback = "Crafting Caster level: " + IntToString(GetRealCasterLevel(oSender, TRUE));
		SendMessageToPC(oSender, sFeedback);
		return TRUE;
	}
	// Shows ECL if allowing ECL characters to reach lvl 30, otherwise shows level adjustment
	else if (sInput == "#showecl"){
		int nECL = 0;
		if (ALLOW_ECL_LEVEL_30){
			sFeedback = "Your ECL is ";
			nECL = GetNewECL(oSender);
		} else {
			sFeedback = "Your Level Adjustment is ";
			PS_CalculateECL(oSender);
			nECL = PS_GetEssenceECL(oSender);
		}
		sFeedback += IntToString(nECL);
		SendMessageToPC(oSender, sFeedback);
		return TRUE;
	}
	// toggles on and off a tick in cyan text sent to user every 6 seconds.
	// note that this is NOT synced to combat rounds but is simply every 6 seconds.
	else if (sInput == "#tick"){
		if (!GetLocalInt(oSender, "6secondtick")){
			SetLocalInt(oSender, "6secondtick", TRUE);
			sFeedback = "Starting Tick";
			SixSecondTick(oSender);
		} else {
			SetLocalInt(oSender, "6secondtick", FALSE);
			sFeedback = "Stopping Tick";	
		}
		SendMessageToPC(oSender, sFeedback);
		return TRUE;
	}
	//debugging command that gets spell info during casting, see implementation in x2_inc_spellhook
	// called there and in psi_spellhook
	else if (sInput == "#spellinfo"){
		oItem = PS_GetEssence(oSender);
		int bSpellDebug = !GetLocalInt(oItem, "spelldebug");
		SetLocalInt(oItem, "spelldebug", bSpellDebug);
		if (bSpellDebug) sFeedback = "Turning on spell debugging messages";
		else sFeedback = "Turning off spell debugging messages";
		SendMessageToPC(oSender, sFeedback);
		return TRUE;
	}
	//debugging command that tells you the tag and resref of the targeted item
	else if (sInput == "#iteminfo"){
		oItem = GetPlayerCurrentTarget(oSender);
		if (!GetIsObjectValid(oItem))
			sFeedback = "No object selected";
		else {
			sFeedback = "The item Tag is " + GetTag(oItem);
			sFeedback += "\nThe ResRef is " + GetResRef(oItem);
		}
		SendMessageToPC(oSender, sFeedback);
		return TRUE;
	}
	else if (sInput == "#fixsetitems"){
		sFeedback = "Scanning inventory for set items and repairing their tags and variables.";
		sFeedback += "\nThis should fix any set items broken by the appearance changer.";
		sFeedback += "\nIf this does not work, contact a DM on our Discord server.";
		SendMessageToPC(oSender, sFeedback);
		FF_UpdateLegacyItems(oSender, TRUE);
		sFeedback = "Finished repairing set items";
		SendMessageToPC(oSender, sFeedback);
		return TRUE;
	}
	else if (sInput == "#getcreatureappearance"){
		oItem = GetPlayerCurrentTarget(oSender);
		if (GetObjectType(oItem) != OBJECT_TYPE_CREATURE){
			oItem = oSender;
			sFeedback = "Appearance data for this character:";
		} else sFeedback = "Appearance data for targeted creature:";
		
		struct CreatureCoreAppearance app = PS_GetCreatureCoreAppearance(oItem);
		sFeedback += "\nAppearance Type = " + IntToString(app.AppearanceType);
		sFeedback += "\nHead = " + IntToString(app.HeadVariation);
		sFeedback += "\nHair = " + IntToString(app.HairVariation);
		sFeedback += "\nBeard = " + IntToString(app.FacialHairVariation);
		sFeedback += "\nTail = " + IntToString(app.TailVariation);
		sFeedback += "\nWings = " + IntToString(app.WingVariation);
		sFeedback += "\nGender = " + IntToString(app.Gender);
		sFeedback += "\nSkin Colour = " + IntToString(app.SkinColor);
		sFeedback += "\nRace = " + IntToString(GetRacialType(oItem));
		sFeedback += "\nSubRace = " + IntToString(GetSubRace(oItem));
		sFeedback += "\n";
		SendMessageToPC(oSender, sFeedback);
		return TRUE;
	}
	else if (GetStringLeft(sInput, 9) == "#vampeyes"){
		if (!GetIsVamp(oSender)) sFeedback = "This command does nothing for non-vampires";
		else {
			oItem = PS_GetEssence(oSender);
			if (sInput == "#vampeyesbat"){
				int nBat = !GetLocalInt(oItem, "vampeyesoffbat");
				SetLocalInt(oItem, "vampeyesoffbat", nBat);
				if (nBat) sFeedback = "Turning off eye glow for bat form";
				else sFeedback = "Turning on eye glow for bat form";
			} else if (sInput == "#vampeyesbeast"){
				int nBeast = !GetLocalInt(oItem, "vampeyesoffbeast");
				SetLocalInt(oItem, "vampeyesoffbeast", nBeast);
				if (nBeast) sFeedback = "Turning off eye glow for beast form";
				else sFeedback = "Turning on eye glow for beast form";
			} else if (sInput == "#vampeyesgas"){
				int nGas = !GetLocalInt(oItem, "vampeyesoffgas");
				SetLocalInt(oItem, "vampeyesoffgas", nGas);
				if (nGas) sFeedback = "Turning off eye glow for gaseous form";
				else sFeedback = "Turning on eye glow for gaseous form";
			} else {
				sFeedback = "Invalid command. Valid commands are #VampEyesBat, #VampEyesBeast, ";
				sFeedback += "and #VampEyesGas";
			}
		}
		SendMessageToPC(oSender, sFeedback);
		return TRUE;
	}
	//THE FOLLOWING ARE DEBUGGING COMMANDS THAT ONLY WORK IF USED BY A DM OR ON THE TEST SERVER
	if (GetLocalInt(GetModule(), "SIGIL_DEV_MODE") || GetIsDM(oSender)){
		if (GetStringLeft(sInput, 8) == "#trinket"){
			sFeedback = "Generating trinket";
			int nRank;
			if (sInput == "#trinket1") nRank = 1;
			else if (sInput == "#trinket2") nRank = 2;
			else if (sInput == "#trinket3") nRank = 3;
			else if (sInput == "#trinket4") nRank = 4;
			else if (sInput == "#trinket5") nRank = 5;
			else if (sInput == "#trinket6") nRank = 6;
			else nRank = d6();
			CreateTrinketOnTarget(oSender, nRank);
			SendMessageToPC(oSender, sFeedback);
			return TRUE;
		}
		else if (sInput == "#testcraftcost"){
			if (GetLocalInt(oSender, "TestCraftCost")){
				SetLocalInt(oSender, "TestCraftCost", FALSE);
				sFeedback = "Turning off craft costs.";
			} else {
				SetLocalInt(oSender, "TestCraftCost", TRUE);
				sFeedback = "Turning on craft costs.";
			}
			SendMessageToPC(oSender, sFeedback);
			return TRUE;
		}
		// generate some random arrows. Will be used to test changes to arrow sellability.
		// Note that we should also make a "quiver" on the test server while testing this
		// so that we can make sure ammo generated by those still won't sell. I think THE
		// tag for those is "returning" but I will have to use #iteminfo to be sure.
		else if (sInput == "#gen_arrows"){
			oItem = CreateItemOnObject("ps_arrow_acid", oSender, d10(2)); 
			oItem = CreateItemOnObject("ps_arrow_alchemicalsilver", oSender, d10(2));
			oItem = CreateItemOnObject("ps_arrow_mundane", oSender, d10(2));
			return TRUE;
		}
		// add visual fx to a weapon. possible commands are #addvfxgood, #addvfxevil
		// #addvfxacid, #addvfxcold, #addvfxelectric, #addvfxfire, #addvfxsonic, #removevfx
		else if (GetStringLeft(sInput, 7) == "#addvfx" || sInput == "#removevfx"){
			oItem = GetPlayerCurrentTarget(oSender);
			if (!GetIsObjectValid(oItem)) oItem = oSender;
			if (GetObjectType(oItem) == OBJECT_TYPE_CREATURE)
				oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oItem);
			if (!IPGetIsWeapon(oItem)){
				sFeedback = "You must target a weapon or a creature holding a weapon in its right hand";
				SendMessageToPC(oSender, sFeedback);
				return TRUE;
			}
			if (sInput == "removevfx"){
				itemproperty ip = GetFirstItemProperty(oItem);
				while (GetIsItemPropertyValid(ip)){
					if (GetItemPropertyType(ip) == 83)
						RemoveItemProperty(oItem, ip);
					ip = GetNextItemProperty(oItem);
				}
				sFeedback = "VFX removed. Note that it is not possible to remove vfx tied to damage ";
				sFeedback += "properties of 1d6 or greater";
				SendMessageToPC(oSender, sFeedback);
				return TRUE;
			}
			int nVis = -1;
			string sVis = GetStringRight(sInput, GetStringLength(sInput) - 7);
			if (sVis == "evil") nVis = ITEM_VISUAL_EVIL;
			else if (sVis == "good" ) nVis = ITEM_VISUAL_HOLY;
			else if (sVis == "acid") nVis = ITEM_VISUAL_ACID;
			else if (sVis == "cold") nVis = ITEM_VISUAL_COLD;
			else if (sVis == "electric") nVis = ITEM_VISUAL_ELECTRICAL;
			else if (sVis == "fire") nVis = ITEM_VISUAL_FIRE;
			else if (sVis == "sonic") nVis = ITEM_VISUAL_SONIC;
			else {	sFeedback = "Invalid command. Please use #AddVFXgood, #AddVFXevil, ";
				sFeedback += "#AddVFXacid, #AddVFXcold, #AddVFXelectric, #AddVFXfire, #AddVFXsonic,";
				sFeedback += " or #RemoveVFX";
			}
			if (nVis != -1){
				itemproperty ipGlow = ItemPropertyVisualEffect(nVis);
				AddItemProperty(DURATION_TYPE_PERMANENT, ipGlow, oItem);
				sFeedback = sVis + " VFX applied";
			}
			SendMessageToPC(oSender, sFeedback);
			return TRUE;
		}
	}
	//END DM OR TEST SERVER ONLY COMMANDS

	if (sFeedback != "") SendMessageToPC(oSender, sFeedback);
	return FALSE;
}

int StartingConditional(object oSender, object oTarget, int nChannel, string sMessage)
{ 

	// if sending to the dm channel, echo it to the sender
	if (nChannel == CHAT_MODE_SILENT_SHOUT && GetIsPC(oSender))
	{
		SendMessageToPC(oSender, "You sent to DM channel: '" + sMessage + "'");
	}
	
	// if message is a chat command by FlattedFifth, do not forward text to chat
	if (GetIsFFcommand(oSender, nChannel, sMessage)) return FALSE;
	
	string MessageToSend;

	// Dispatch the message to Sigil.TextCommands first and if it handles the
	// message then don't forward it on.
	if (ForwardMessageToTextCommands(oSender, oTarget, nChannel, sMessage) == FALSE)
	{
		return FALSE;
	}
	
	//at this point, any chat commands will have been processed so we can return an error message
	// if the message starts with #
	if (GetSubString(sMessage, 0, 1) == "#"){
		string sError = "Invalid chat command. For a full list of chat commands, please see our wiki";
		sError += " at sigil-nwn2.fandom.com/wiki/Chat_Commands";
		SendMessageToPC(oSender, sError);
		return FALSE;
	}

	switch (nChannel)
	{

	case CHAT_MODE_TALK:
	case CHAT_MODE_SHOUT:
	case CHAT_MODE_WHISPER:
	case CHAT_MODE_PARTY:
		MessageToSend = ExpandMessage(oSender, sMessage);
		break;

	}

	// Changing how this works so a tell to self causes the status to change to avoid public notifications
	// on the talk channel about notell being set.
	if ((GetIsPC(oSender) || GetIsDM(oSender)) && nChannel == CHAT_MODE_TELL)
	{
		if (oSender == oTarget)
		{
			if (GetStringLeft(sMessage, 6) == "notell")
			{
				if (sMessage == "notell" || sMessage == "notell " || sMessage == "notell on")
				{
					SetLocalString(oSender, "NO_TELL", "This player isn't accepting tells at this moment.");
					SendMessageToPC(oSender, "<C=GOLD>Auto-response is active and set to default message. To disable use <i>notell off</i>.");
				}
				else if (sMessage == "notell off")
				{
					SendMessageToPC(oSender, "<C=GOLD>Auto-response disabled.");
					SetLocalString(oSender, "NO_TELL", "");
				}
				else
				{
					string sNoTellMessage = GetStringRight(sMessage, GetStringLength(sMessage) - 7);
					SetLocalString(oSender, "NO_TELL", sNoTellMessage);
					SendMessageToPC(oSender, "<C=GOLD>Auto-response set to: " + sNoTellMessage);
				} 	
			}
			else if (GetStringLeft(sMessage, 7) == "suicide")
			{
				SendMessageToPC(oSender, "<c=red>Through early morning fog I see, visions of the things to be, the pains that are withheld for me, I realize and I can see...");
				SendMessageToPC(oSender, "<c=red>That suicide is painless, It brings on many changes, and I can take or leave it if I please.");
				effect eDeath = EffectDeath(TRUE, TRUE, TRUE, TRUE);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oSender);
			}
			else if (GetStringLeft(sMessage, 8) == "autosave")
			{
				if (sMessage == "autosave on" | sMessage == "autosave" | sMessage == "autosave ")
				{
					SetLocalInt(oSender, "AutoSave", 0); // yes, we use 0 because if someone hasn't specified we want default to be autosave
					SendMessageToPC(oSender, "<C=GOLD>Auto-save on area transition enabled.");
				}
				else if (sMessage == "autosave off")
				{
					SetLocalInt(oSender, "AutoSave", 1);
					SendMessageToPC(oSender, "<C=GOLD>Auto-save on area transition disabled. To enable use <i>autosave on</i>.");
					SendMessageToPC(oSender, "<C=CRIMSON><b>WARNING!!!: Do not complain to DMs about loss of gold/items/XP in event of server crash if you are using this option.");
					SendMessageToPC(oSender, "<C=CRIMSON><b>WARNING!!!: Remember to save your character manually before exiting the server if using this option.");
				}
				else
				{
					SendMessageToPC(oSender, "<C=GOLD>Invalid use of autosave function. Use either <i>autosave</i> or <i>autosave on</i> to enable or <i>autosave off</i> to disable.");
				}
			}
			
			 if (GetStringLeft(sMessage,9)=="areashout")
			{		
				if(GetIsDM(oSender))
				{
				//	SendMessageToPC(oSender,"Sorry, This command isn't available to Players.");
				int iStringLength; 
				iStringLength = GetStringLength(sMessage);
				sMessage = GetStringRight(sMessage,iStringLength-11);
				SetLocalInt(oSender, "areashout", 1);
				SendTellMessageToAllPlayersInArea(oSender,"<I><C=yellow>Area Shout:</C></i> "+sMessage);    
				}
			
        		
				}
			else if (GetStringLeft(sMessage, 11) == "description")
			{
				// self description functions
				// options are del, new, and add.  If no option is set then give usage info.
				string sDesc = GetStringRight(sMessage, GetStringLength(sMessage) - 12);
				string sParam = GetStringLeft(sDesc, 3);
				//string sCRLF = GetStringByStrRef(16777631);
				
				sDesc = GetStringRight(sDesc, GetStringLength(sDesc) - 4);
				
				if (sDesc != "") sDesc = ParseTellDescription(sDesc);
				
				if (sParam == "new" && sDesc != "")
				{
					SetDescription(oSender, sDesc);
				}
				else if (sParam == "add" && sDesc != "")
				{
					SetDescription(oSender, GetDescription(oSender) + " " + sDesc);
				}
				else if (sParam == "del")
				{
					SetDescription(oSender, "");
				}
				else if (sParam == "say")
				{
					SendMessageToPC(oSender, "<color=gold>Description currently set to:");
					SendMessageToPC(oSender, "<color=white>" + GetDescription(oSender));
				}
				else
				{
					SendMessageToPC(oSender, "<C=RED><b>ERROR:</b> Incorrect usage of description function. Must follow the format of ''description <i>parameter</i> <i>text</i>'' where paramter equals add (add to existing description), new (replace existing), or del (remove description).  If using del no text is required afterwards and will be ignored.");
				}
			}
			else if (GetStringLeft(sMessage, 8) == "itemdesc")
			{
				// self description functions
				// options are del, new, and add.  If no option is set then give usage info.
				object oInvItem = GetPlayerCurrentTarget(oSender);
				object oHolder = GetItemPossessor(oInvItem);
				if (oHolder != oSender)
				{	SendMessageToPC(oSender, "<C=RED>You may not change the description of an item not in your inventory.</C>");
					return TRUE;	}
				else
				{	string sDesc = GetStringRight(sMessage, GetStringLength(sMessage) - 9);
					string sParam = GetStringLeft(sDesc, 3);
				
					sDesc = GetStringRight(sDesc, GetStringLength(sDesc) - 4);
				
					if (sDesc != "") sDesc = ParseTellDescription(sDesc);
				
					if (sParam == "new" && sDesc != "")
					{	SetDescription(oInvItem, sDesc);	}
					else if (sParam == "add" && sDesc != "")
					{	SetDescription(oInvItem, GetDescription(oSender) + " " + sDesc);	}
					else if (sParam == "del")
					{SetDescription(oInvItem, "");	}
					else if (sParam == "say")
					{	SendMessageToPC(oSender, "<color=gold>Item description currently set to:");
						SendMessageToPC(oSender, "<color=white>" + GetDescription(oInvItem));
					}
					else
					{
					SendMessageToPC(oSender, "<C=RED><b>ERROR:</b> Incorrect usage of description function. Must follow the format of ''description <i>parameter</i> <i>text</i>'' where paramter equals add (add to existing description), new (replace existing), or del (remove description).  If using del no text is required afterwards and will be ignored.");
					}
				}
			return TRUE;
			}
		}
		// so oSender != oTarget
		else
		{
			string sNoTellMessage = GetLocalString(oTarget, "NO_TELL");
			if (sNoTellMessage != "")
				SendMessageToPC(oSender, "<C=GOLD>[AUTO-RESPONSE]: " + sNoTellMessage);
		}
	}
			
	//NO TELLS END

	ApplyRPXP(oSender, oTarget, nChannel, sMessage);

	//
	// If there is a replacement message to send, send the replacement.  Else
	// allow the original message through.  Do not invoke the callback for a
	// replacement message.
	//

	if (MessageToSend != "")
	{
		SendChatMessage(oSender, oTarget, nChannel, MessageToSend, FALSE);
		return FALSE;
	}

	return TRUE;
}