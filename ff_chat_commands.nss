// collection of chat commands by FlattedFifth

#include "nwnx_sql"
#include "ps_inc_functions"
#include "ServerExts"
#include "ff_update_legacy_items"
#include "ps_inc_advscript"
#include "ps_inc_randomitems"
#include "x2_inc_itemprop"
#include "nwnx_dae"
#include "ps_inc_wingtail"
#include "ff_sequencer"


int GetHasAllAccess(object oPC);
int GetIsTester(object oPC);

// a function that sends a tick message to the player every 6 seconds
// to be used for debugging purposes. 
void SixSecondTick(object oPC, int nRound = 1);

//allows roll of social skills with auto opposed rolls from nearby pcs and npcs
void RollSocialCheck(object oPC, int nChannel,  int nCommandLength = -1, string sMessage = "");

//gets area information for debugging purposes
string GetAreaInfo(object oArea, object oItem = OBJECT_INVALID);

string GetCasterInfo(object oPC);

string GetEffectInfo(object oPC);

//gets full pc information for bug reports
string GetDebugInfo(object oPC);

//gets all available information about a target non-pc creature
string GetCreatureInfo(object oCreature, object oCaller = OBJECT_INVALID, int bFromChat = FALSE);

//primary function
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
	sInput = PS_RemoveSpaces(sInput);
	object oItem;
	int nCommandLength = -1;
	
	if (sInput == "#"){
		sFeedback = "Please see full list of chat commands at:";
		sFeedback += "\nhttps://sigil-nwn2.fandom.com/wiki/Chat_Commands";
		SendMessageToPC(oSender, sFeedback);
		return TRUE;
	}
	else if (GetStringLeft(sInput, 4) == "#xp%"){
		if (GetIsDM(oSender) || (GetIsTester(oSender) && GetLocalInt(GetModule(), "SIGIL_DEV_MODE"))){
			string sRight = GetStringRight(sInput, GetStringLength(sInput) - 4);
			int nPercent = StringToInt(sRight);
			if (sRight == "off" || nPercent == 100){
				DeleteLocalFloat(GetModule(), "XPBOOST");
				sFeedback = "Turning off XP%";
			} else if (nPercent < 1 || nPercent > 500){
				sFeedback = "Invalid entry. Must be an integer between 1 and 500, inclusive.\n";
				sFeedback += "For example, 150 to give players 150% (aka 1.5X) XP or 80 to give them ";
				sFeedback += "only 80% of normal XP.\n";
				sFeedback += "If you are trying to turn XP% off, type #XP% OFF or #XP% 100.";
			} else {
				SetLocalFloat(GetModule(), "XPBOOST", IntToFloat(nPercent) / 100.0);
				sFeedback = "Setting XP gains to " + IntToString(nPercent) + "% of normal.\n";
				sFeedback = "This will last until you type #XP% OFF, #XP% 100, or until server reset";
			}
		} else {
			sFeedback = "On main server this command is only for DMs. On test server this command is only "; 
			sFeedback += "for DMs, Dev Team, and Admin staff.";
		}
		SendMessageToPC(oSender, sFeedback);
		return TRUE;
	}
	// toggle on and off local int to scribe scrolls at min caster level, see x2_inc_craft
	else if (sInput == "#scribemin"){
		if (GetLocalInt(oSender, "bScribeAtMinLvl")){
			SetLocalInt(oSender, "bScribeAtMinLvl", FALSE);
			sFeedback = "ScribeMin OFF\n";
			sFeedback += "You will now scribe scrolls as normal ";
			sFeedback += "until you type #ScribeMin again.";
		} else {
			SetLocalInt(oSender, "bScribeAtMinLvl", TRUE);
			sFeedback = "ScribeMin ON\n";
			sFeedback += "You will now scribe scrolls at minimum caster level until next server reset ";
			sFeedback += "or until you type #ScribeMin again.";
		}
		SendMessageToPC(oSender, sFeedback);
		return TRUE;
	}
	//turn dm reporting of social roll chat commands on or off
	if (sInput == "#togglesocial" && GetIsDM(oSender)){
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
		if (GetStringLeft(sInput, 9) == "#appraise") nCommandLength = 9;
		else nCommandLength = 7;
		RollSocialCheck(oSender, nChannel, nCommandLength, sMessage);
		return TRUE;
	}
	//BLUFF
	else if (GetStringLeft(sInput, 6) == "#bluff" || GetStringLeft(sInput, 4) == "#lie"){
		if (GetStringLeft(sInput, 6) == "#bluff") nCommandLength = 6;
		else nCommandLength = 4;
		RollSocialCheck(oSender, nChannel, nCommandLength, sMessage);
		return TRUE;
	}
	//DIPLOMACY
	else if (GetStringLeft(sInput, 10) == "#diplomacy" || GetStringLeft(sInput, 9) == "#persuade"){
		if (GetStringLeft(sInput, 10) == "#diplomacy") nCommandLength = 10;
		else nCommandLength = 9;
		RollSocialCheck(oSender, nChannel, nCommandLength, sMessage);
		return TRUE;
	}
	//INTIMIDATE
	else if (GetStringLeft(sInput, 11) == "#intimidate" || GetStringLeft(sInput, 7) == "#threat"){
		if (GetStringLeft(sInput, 11) == "#intimidate") nCommandLength = 11;
		else nCommandLength = 7;
		RollSocialCheck(oSender, nChannel, nCommandLength, sMessage);
		return TRUE;
	}
	//SLEIGHT_OF_HAND
	else if (GetStringLeft(sInput, 8) == "#sleight"){
		RollSocialCheck(oSender, nChannel, 8, sMessage);
		return TRUE;	
	} 
	else if (sInput == "#socialrollrules"){
		RollSocialCheck(oSender, nChannel, 255);
		return TRUE;
	} 
	else if (sInput == "#showcl"){
		SendMessageToPC(oSender, "Caster Level(s):\n" + GetCasterInfo(oSender));
		return TRUE;
	}
	// as above but including Alchemical Infusion caster lvl where applicable
	else if (sInput == "#showcraftcl"){ // new chat command for showing crafting caster level
		sFeedback = "Crafting Caster level: " + IntToString(GetRealCasterLevel(oSender, TRUE));
		SendMessageToPC(oSender, sFeedback);
		return TRUE;
	}
	// Shows ECL and percentage of combat xp deducted due to ecl
	else if (sInput == "#showecl"){
		int nECL = GetNewECL(oSender);
		sFeedback = "Your ECL is " + IntToString(nECL);
		if (nECL > 0)
			sFeedback += "\nECL combat XP tax: - " + PS_PrettyFloatString(GetECLXPTax(nECL, TRUE), 2) + "%";
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
	//gets a great deal of info in a server message that user can screenshot to send in a bug report
	else if (sInput == "#debuginfo"){
		sFeedback = GetDebugInfo(oSender);
		dae_LogEffects(oSender);
		SendMessageToPC(oSender, sFeedback);
		return TRUE;
	}
	// debugging command that gets info of the sender's current area
	else if (sInput == "#areainfo"){
		SendMessageToPC(oSender, GetAreaInfo(GetArea(oSender), oSender));
		return TRUE;
	}
	//debugging command that tells you the tag and resref of the targeted item
	else if (sInput == "#iteminfo"){
		oItem = GetPlayerCurrentTarget(oSender);
		int nItem = GetObjectType(oItem);
		if (!GetIsObjectValid(oItem)){
			sFeedback = "No object selected";
		} else if (nItem != OBJECT_TYPE_ITEM && nItem != OBJECT_TYPE_DOOR && 
			nItem != OBJECT_TYPE_PLACEABLE){
				sFeedback = "Invalid item";
		} else {
			sFeedback = "Tag: " + GetTag(oItem);
			sFeedback += "\nResRef: " + GetResRef(oItem);
			sFeedback += "\nBase item: " + IntToString(GetBaseItemType(oItem));
			sFeedback += "\nValue: " + IntToString(GetGoldPieceValue(oItem));
			if (PS_GetIsSequencerPot(oItem)){
				sFeedback += "Spell 1:  " +  IntToString(GetLocalInt(oItem, "X2_L_SPELLTRIGGER1")); 
				sFeedback += "Spell 2:  " + IntToString(GetLocalInt(oItem, "X2_L_SPELLTRIGGER2")); 
				sFeedback += "Spell 3:  " + IntToString(GetLocalInt(oItem, "X2_L_SPELLTRIGGER3"));
				sFeedback += "Num: " + IntToString(GetLocalInt(oItem, "X2_L_NUMTRIGGERS"));
			}
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
		if (GetLevelByClass(78, oSender) + GetLevelByClass(105, oSender) +
			GetLevelByClass(106, oSender) < 1){
				SendMessageToPC(oSender, "This command does nothing for non-vampires");
				return TRUE;
		}
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
		SendMessageToPC(oSender, sFeedback);
		return TRUE;
	}
	//debugging command that gets spell info during casting, see implementation in x2_inc_spellhook
	else if (sInput == "#spellinfo"){
		int bIsTester = GetIsTester(oSender); // performing this check will add IsTester local int used in spellhook
		int bSpellDebug = !GetLocalInt(oSender, "spelldebug");
		SetLocalInt(oSender, "spelldebug", bSpellDebug);
		if (bSpellDebug){
			sFeedback = "Turning on spell debugging messages";
			if (bIsTester) sFeedback += ", including engine level caster level.";
			else sFeedback += ".";
			sFeedback += "\nThis will remain in effect until you type #SpellInfo again or until server resets.";
		} else sFeedback = "Turning off spell debugging messages";
		SendMessageToPC(oSender, sFeedback);
		return TRUE;
	}
	//THE FOLLOWING ARE DEBUGGING COMMANDS THAT ONLY WORK IF USED BY A DM OR ON THE TEST SERVER
	if (GetLocalInt(GetModule(), "SIGIL_DEV_MODE") || GetIsDM(oSender)){
		if (sInput == "#testcraftcost"){
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
			if (sInput == "#removevfx"){
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
	
	//the following commands only work for specific, trusted players due to the nature of the information
	//given, particularly as it highlights the fact that caster level in terms of resisting dispells and
	//and overcoming SR is much, much lower as far as the engine is concerned for psion, psywar, knight,
	// and ranger
	if (GetIsTester(oSender)){
		if (sInput == "#killinfo"){
			int bXPDebug = !GetLocalInt(oSender, "xpdebug");
			SetLocalInt(oSender, "xpdebug", bXPDebug);
			if (bXPDebug){
				sFeedback = "Turning on combat kill debugging messages\nThis will remain in ";
				sFeedback += "effect until you type #KillInfo again or until server resets.";
			} else sFeedback = "Turning off combat kill debugging messages";
			SendMessageToPC(oSender, sFeedback);
			return TRUE;
		}
		else if (sInput == "#effectinfo"){
			oItem = GetPlayerCurrentTarget(oSender);
			if (!GetIsPC(oItem))
				oItem = oSender;
			dae_LogEffects(oItem);
			sFeedback = "EFFECT INFO FOR " + GetName(oItem) + "\n";
			sFeedback += GetEffectInfo(oItem);
			SendMessageToPC(oSender, sFeedback);
			return TRUE;
		}
		else if (sInput == "#creatureinfo"){
			oItem = GetPlayerCurrentTarget(oSender);
			if (!GetIsObjectValid(oItem))
				sFeedback = "No creature selected";
			else sFeedback = GetCreatureInfo(oItem, oSender, TRUE);
			SendMessageToPC(oSender, sFeedback);
			return TRUE;
		}
		else if (sInput == "#GetPersistentFeats"){
			string sLog = "List of persistent feat info:";
			sFeedback = "Writing persistent feat info to log file";
			int nMax = GetNum2DARows("feat");
			int i, nId, nPers, nAuto, nNameRef;
			string sScript;
			for (i = 0; i <= nMax; i++){
				nPers = StringToInt(Get2DAString("feat", "IsPersistent", i));
				nAuto = StringToInt(Get2DAString("feat", "Auto_Refresh", i));
				if (nAuto == 1 || nPers == 1){
					nId = StringToInt(Get2DAString("feat", "SPELLID", i));
					nNameRef = StringToInt(Get2DAString("feat", "Name", i));
					sScript = Get2DAString("spells", "ImpactScript", nId);
					sLog += "\nFeat ID: " + IntToString(i) + ", Name: " + GetStringByStrRef(nNameRef);
					sLog += ", Spell ID: " + IntToString(nId) + ", Script: " + sScript;
				}
			}
			WriteTimestampedLogEntry(sLog);
			SendMessageToPC(oSender, sFeedback);
			return TRUE;
		}
		else if (sInput == "#GetAllSpellScripts"){
			string sList = "";
			string sScript, sInstance;
			string sLog = "List of all spell scripts:";
			sFeedback = "Writing list of spell scripts to log";
			int nMax = GetNum2DARows("spells");
			int i;
			for (i = 1; i <= nMax; i++){
				sScript = GetStringLowerCase(Get2DAString("spells", "ImpactScript", i));
				if (sScript != "****"){
					sInstance = "|" + sScript + "|";
					if (FindSubString(sList, sInstance) == -1){
						sList += sInstance;
						sLog += "\n" + sScript;
					}
				}
			}
			WriteTimestampedLogEntry(sLog);
			SendMessageToPC(oSender, sFeedback);
			return TRUE;
		}
	}
	//end trusted player only debug commands
	//testers and test server only
	if (GetIsTester(oSender) && GetLocalInt(GetModule(), "SIGIL_DEV_MODE")){
		if (GetStringLeft(sInput, 12) == "#healwandmod"){
			sMessage = GetStringRight(sInput, GetStringLength(sInput) - 12);
			if (sMessage == ""){
				sFeedback = "Heal wand costs set to ";
				float fHealwandMod = GetLocalFloat(GetModule(), "HEAL_WAND_COST_MOD");
				if (fHealwandMod == 0.0) sFeedback += "100%";
				else sFeedback += PS_PrettyFloatString(fHealwandMod * 100.0) +"%";
			} else {
				SetLocalFloat(GetModule(), "HEAL_WAND_COST_MOD", StringToFloat(sMessage) / 100.0);
				sFeedback = "Setting heal wand costs to " + sMessage + "%";
			}
			SendMessageToPC(oSender, sFeedback);
			return TRUE;
		}
		else if (GetStringLeft(sInput, 8) == "#wandmod"){
			sMessage = GetStringRight(sInput, GetStringLength(sInput) - 8);
			if (sMessage == ""){
				sFeedback = "Non-heal wand costs set to ";
				float fwandMod = GetLocalFloat(GetModule(), "WAND_COST_MOD");
				if (fwandMod == 0.0) sFeedback += "100%";
				else sFeedback += PS_PrettyFloatString(fwandMod * 100.0) +"%";
			} else {
				SetLocalFloat(GetModule(), "WAND_COST_MOD", StringToFloat(sMessage) / 100.0);
				sFeedback = "Setting non-heal wand costs to " + sMessage + "%";
			}
			SendMessageToPC(oSender, sFeedback);
			return TRUE;
		}
		else if (GetStringLeft(sInput, 11) == "#healpotmod"){
			sMessage = GetStringRight(sInput, GetStringLength(sInput) - 11);
			if (sMessage == ""){
				sFeedback = "Heal pot costs set to ";
				float fHealpotMod = GetLocalFloat(GetModule(), "HEAL_POT_COST_MOD");
				if (fHealpotMod == 0.0) sFeedback += "100%";
				else sFeedback += PS_PrettyFloatString(fHealpotMod * 100.0) +"%";
			} else {
				SetLocalFloat(GetModule(), "HEAL_POT_COST_MOD", StringToFloat(sMessage) / 100.0);
				sFeedback = "Setting heal pot costs to " + sMessage + "%";
			}
			SendMessageToPC(oSender, sFeedback);
			return TRUE;
		}
		else if (GetStringLeft(sInput, 7) == "#potmod"){
			sMessage = GetStringRight(sInput, GetStringLength(sInput) - 7);
			if (sMessage == ""){
				sFeedback = "Non-heal pot costs set to ";
				float fpotMod = GetLocalFloat(GetModule(), "POT_COST_MOD");
				if (fpotMod == 0.0) sFeedback += "100%";
				else sFeedback += PS_PrettyFloatString(fpotMod * 100.0) +"%";
			} else {
				SetLocalFloat(GetModule(), "POT_COST_MOD", StringToFloat(sMessage) / 100.0);
				sFeedback = "Setting non-heal pot costs to " + sMessage + "%";
			}
			SendMessageToPC(oSender, sFeedback);
			return TRUE;
		}
		else if (GetStringLeft(sInput, 14) == "#healscrollmod"){
			sMessage = GetStringRight(sInput, GetStringLength(sInput) - 14);
			if (sMessage == ""){
				sFeedback = "Heal scroll costs set to ";
				float fHealScrollMod = GetLocalFloat(GetModule(), "HEAL_SCROLL_COST_MOD");
				if (fHealScrollMod == 0.0) sFeedback += "100%";
				else sFeedback += PS_PrettyFloatString(fHealScrollMod * 100.0) +"%";
			} else {
				SetLocalFloat(GetModule(), "HEAL_SCROLL_COST_MOD", StringToFloat(sMessage) / 100.0);
				sFeedback = "Setting heal scroll costs to " + sMessage + "%";
			}
			SendMessageToPC(oSender, sFeedback);
			return TRUE;
		}
		else if (GetStringLeft(sInput, 10) == "#scrollmod"){
			sMessage = GetStringRight(sInput, GetStringLength(sInput) - 10);
			if (sMessage == ""){
				sFeedback = "Non-heal scroll costs set to ";
				float fScrollMod = GetLocalFloat(GetModule(), "SCROLL_COST_MOD");
				if (fScrollMod == 0.0) sFeedback += "100%";
				else sFeedback += PS_PrettyFloatString(fScrollMod * 100.0) +"%";
			} else {
				SetLocalFloat(GetModule(), "SCROLL_COST_MOD", StringToFloat(sMessage) / 100.0);
				sFeedback = "Setting non-heal scroll costs to " + sMessage + "%";
			}
			SendMessageToPC(oSender, sFeedback);
			return TRUE;
		}
	}

	if (sFeedback != "") SendMessageToPC(oSender, sFeedback);
	return FALSE;
}

string GetCreatureInfo(object oCreature, object oCaller = OBJECT_INVALID, int bFromChat = FALSE){
	if ((GetIsPC(oCreature) || GetIsDM(oCreature)) && !GetIsDM(oCaller))
		return "This information cannot be gathered on players except by DMs";
		
	//note that we don't actually check if the target object type is creature because
	//some of this information, such as hit dice or ac, can apply to placeables
	string sDebug = "";
	if (bFromChat) sDebug = "Resref: " + GetResRef(oCreature);
	int nVar = StringToInt(Get2DAString("racialtypes", "Name", GetRacialType(oCreature)));
	sDebug += "\nRace: " + GetStringByStrRef(nVar) + " (ID: " + IntToString(nVar) + ")";
	nVar = StringToInt(Get2DAString("racialsubtypes", "Name", GetSubRace(oCreature)));
	sDebug += "\nSubRace: " + GetStringByStrRef(nVar) + " (ID: " + IntToString(nVar) + ")";
	sDebug += "\nHD: " + IntToString(PS_GetLevel(oCreature));
	float fVar = GetChallengeRating(oCreature);
	sDebug += "\nCR: " + PS_PrettyFloatString(fVar, 2);
	sDebug += "\nElite Rating: ";
	string sElite = GetLocalString(oCreature,"ELITE");
	if (sElite == "") sDebug += "0";
	else sDebug += sElite;
	if (GetIsTester(oCaller))
		sDebug += "\nMax HP: " + IntToString(GetMaxHitPoints(oCreature));
	sDebug += "\nAC: " + IntToString(GetAC(oCreature));
	nVar = GetBaseAttackBonus(oCreature);
	sDebug += "\nAB: " + IntToString(nVar + dae_GetOnHandAttackModifier(oCreature) - 2);
	
	if (bFromChat) sDebug += "\n" + GetEffectInfo(oCreature);
	
	return sDebug;
}

string GetDebugInfo(object oPC){
    object oArea = GetArea(oPC);
	int nVar;
    string sDebug = "PLEASE SCREENSHOT THIS INFO & INCLUDE IN BUG REPORTS";
    sDebug += "\nName: " + GetName(oPC);
	nVar = StringToInt(Get2DAString("racialtypes", "Name", GetRacialType(oPC)));
	sDebug += "\nRace: " + GetStringByStrRef(nVar) + " (ID: " + IntToString(nVar) + ")";
	nVar = StringToInt(Get2DAString("racialsubtypes", "Name", GetSubRace(oPC)));
	sDebug += "\nSubRace: " + GetStringByStrRef(nVar) + " (ID: " + IntToString(nVar) + ")";
	sDebug += "\nSize: ";
	nVar = GetCreatureSize(oPC);
	switch (nVar){
		case CREATURE_SIZE_TINY: sDebug += "Tiny"; break;
		case CREATURE_SIZE_SMALL: sDebug += "Small"; break;
		case CREATURE_SIZE_MEDIUM: sDebug += "Medium"; break;
		case CREATURE_SIZE_LARGE: sDebug += "Large"; break;
		case CREATURE_SIZE_HUGE: sDebug += "Huge"; break;
		default: sDebug += "Error"; break;
	}
    sDebug += "\nECL: " + IntToString(GetNewECL(oPC));
    sDebug += "\nCLASSES:";
    int i, nClass, nLvl;
    for (i = 1; i <= 4; i++){
        nClass = GetClassByPosition(i, oPC);
		if (nClass != CLASS_TYPE_INVALID){
			nLvl = GetLevelByClass(nClass, oPC);
			nVar = StringToInt(Get2DAString("classes", "Name", nClass));
			sDebug += "\n" + GetStringByStrRef(nVar) + " (ID: " + IntToString(nClass) + ")";
			sDebug += " Level: " + IntToString(nLvl);
        }
    }
	sDebug += "\nCASTER LEVEL(S):\n" + GetCasterInfo(oPC);
	sDebug += "\nEFFECTS:\n" + GetEffectInfo(oPC);
    sDebug += "\nAREA:\n" + GetAreaInfo(GetArea(oPC), oPC);
    return sDebug;
}

string GetAreaInfo(object oArea, object oItem = OBJECT_INVALID){
	string sInfo = "Area name: " + GetName(oArea);
	string sVar = GetTag(oArea);
	if (sVar != "") sInfo += "\nArea tag: " + sVar;
	sVar = GetResRef(oArea);
	if (sVar != "") sInfo += "\nToolset name: " + sVar;
	sInfo += "\nMap height: " + IntToString(GetAreaSize(AREA_HEIGHT, oArea));
	sInfo += "\nMap width: " + IntToString(GetAreaSize(AREA_WIDTH, oArea));
	if (oItem != OBJECT_INVALID){
		vector vPos = GetPosition(oItem);
		sInfo += "\nCommandLength: X=" + FloatToString(vPos.x, 2) + " Y=" + FloatToString(vPos.y, 2) + 
              " Z=" + FloatToString(vPos.z, 2);
		sInfo += "\nFacing: " + FloatToString(GetFacing(oItem), 2);
	}
	return sInfo;
}

string GetCasterInfo(object oSender){
	string sInfo = "";
	int nCL = PS_GetCasterLevel(oSender, CLASS_TYPE_BARD);
	if (nCL > 0) sInfo += "Bard: " + IntToString(nCL) + "\n";
	nCL = PS_GetCasterLevel(oSender, CLASS_TYPE_CLERIC);
	if (nCL > 0) sInfo += "Cleric: " + IntToString(nCL) + "\n";
	nCL = PS_GetCasterLevel(oSender, CLASS_TYPE_DRUID);
	if (nCL > 0) sInfo += "Druid: " + IntToString(nCL) + "\n";
	nCL = PS_GetCasterLevel(oSender, CLASS_TYPE_FAVORED_SOUL);
	if (nCL > 0) sInfo += "Favoured Soul: " + IntToString(nCL) + "\n";
	nCL = PS_GetCasterLevel(oSender, CLASS_TYPE_PALADIN);
	if (nCL > 0) sInfo += "Knight: " + IntToString(nCL) + "\n";
	nCL = PS_GetCasterLevel(oSender, CLASS_TYPE_PSION);
	if (nCL > 0) sInfo += "Psion: " + IntToString(nCL) + "\n";
	nCL = PS_GetCasterLevel(oSender, CLASS_PSYCHIC_WARRIOR);
	if (nCL > 0) sInfo += "Psychic Warrior: " + IntToString(nCL) + "\n";
	nCL = PS_GetCasterLevel(oSender, CLASS_TYPE_RANGER);
	if (nCL > 0) sInfo += "Ranger: " + IntToString(nCL) + "\n";
	nCL = PS_GetCasterLevel(oSender, CLASS_TYPE_SPIRIT_SHAMAN);
	if (nCL > 0) sInfo += "Shaman: " + IntToString(nCL) + "\n";
	nCL = PS_GetCasterLevel(oSender, CLASS_TYPE_SORCERER);
	if (nCL > 0) sInfo += "Sorcerer: " + IntToString(nCL) + "\n";
	nCL = PS_GetCasterLevel(oSender, CLASS_TYPE_WARLOCK);
	if (nCL > 0) sInfo += "Warlock: " + IntToString(nCL) + "\n";
	nCL = PS_GetCasterLevel(oSender, CLASS_TYPE_WIZARD);
	if (nCL > 0) sInfo += "Wizard: " + IntToString(nCL) + "\n";
	if (sInfo == "") sInfo = "No caster levels";
	return sInfo;
}

string GetEffectInfo(object oPC){
	int nId;
	string sId;
	int nType;
	string sPermIdList = "";
	string sTempIdList = "";
	string sPermInfo = "";
	string sTempInfo = "";
	int nNameRef;
	string sInfo;
	string sScript;
	string sCurrent = "none";
	effect eFX = GetFirstEffect(oPC);
	while (GetIsEffectValid(eFX)){
		nId = GetEffectSpellId(eFX);
		if (nId != -1){
			sId = "|" + IntToString(nId) + "|";
			nType = GetEffectSubType(eFX);
			if (GetEffectDurationType(eFX) == DURATION_TYPE_PERMANENT || 
				nType == SUBTYPE_SUPERNATURAL || nType == SUBTYPE_EXTRAORDINARY){
				if (FindSubString(sPermIdList, sId) == -1){
					sPermIdList += sId;
					sCurrent = "perm";
				} else sCurrent = "none";
			} else {
				if (FindSubString(sTempIdList, sId) == -1){
					sTempIdList += sId;
					sCurrent = "temp";
				} else sCurrent = "none";
			} 
			if (sCurrent != "none"){
				if (nId == 34050){
					sInfo = "Chat Bubbles";
				} else if (nId == 8675309){
					sInfo = "Item Set Boots AC";
				} else {
					nNameRef = StringToInt(Get2DAString("spells", "Name", nId));
					sInfo = GetStringByStrRef(nNameRef);
				}
				sInfo += " (ID: " + IntToString(nId);
				sScript = Get2DAString("spells", "ImpactScript", nId);
				if (sScript == "Bad Strrf" || sScript == "****")
					sScript = "NA";
				
				sInfo += ", " + sScript + ")\n";
				if 	(sCurrent == "perm") sPermInfo += sInfo;
				else if (sCurrent == "temp") sTempInfo += sInfo;
			}	
		}
		eFX = GetNextEffect(oPC);
	}
	sInfo = "CONTINUOUS EFFECTS:\n";
	if (sPermInfo == "") sInfo += "none\n";
	else sInfo += sPermInfo;
	sInfo += "TEMPORARY EFFECTS\n";
	if (sTempInfo == "") sInfo += "none\n";
	else sInfo += sTempInfo;
	
	return sInfo;
}

void RollSocialCheck(object oPC, int nChannel,  int nCommandLength = -1, string sMessage = ""){
	// this is the action that merely reports the rules for the social rolls.
	if (nCommandLength == 255){
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
	//strip the leading command off of sMessage to get the text the player is saying and the action
	// the player is performing
	string sCommand = GetStringLowerCase(GetStringLeft(sMessage, nCommandLength));
	sMessage = GetStringRight(sMessage, GetStringLength(sMessage) - nCommandLength);
	int nAction = -1;
	if (sCommand == "#appraise" || sCommand == "#haggle") nAction = SKILL_APPRAISE;
	else if (sCommand == "#bluff" || sCommand == "#lie") nAction = SKILL_BLUFF;
	else if (sCommand == "#diplomacy" || sCommand == "#persuade") nAction = SKILL_DIPLOMACY;
	else if (sCommand == "#intimidate" || sCommand == "#threat") nAction = SKILL_INTIMIDATE;
	else if (sCommand == "#sleight") nAction = SKILL_SLEIGHT_OF_HAND;
	
	if (nAction == -1) return;
	
	//strip leading spaces off of sMessage
	if (sMessage != ""){
		while (sMessage != "" && GetStringLeft(sMessage, 1) == " "){
			sMessage = GetSubString(sMessage, 1, GetStringLength(sMessage) - 1);
		}
	}
	
	// if the dm uses this while targeting a player or npc, then roll everything as if that player or npc
	// used the command
	if (GetIsDM(oPC)){
		object oTarget = GetPlayerCurrentTarget(oPC);
		if (GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
		oPC = oTarget;
		if (GetIsPC(oTarget)) sMessage = ""; // a DM should not be able to put words in a PCs mouth.
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

void SixSecondTick(object oPC, int nRound = 1){

	if (GetLocalInt(oPC, "6secondtick")){
		// Send the message to the player
		SendMessageToPC(oPC, "<c=cyan>Tick " + IntToString(nRound) + "</c>");
		nRound += 1;
		// Schedule the next tick after 6 seconds
		DelayCommand(6.0f, SixSecondTick(oPC, nRound));
	}
}

//certain debugging chat commands give information that we don't want widely known, 
//so some chat commands check the following two functions to see if the player is allowed to use them.
// Currently the only difference between "all access" group below and other testers is that the all access
// group can see a target's AC, HP, AB, and other combat stats that we could look up in the toolset if we
// wanted to.
// me (FlattedFifth and a small green monster), Ed, Jelkia, Morrigan, and anyone who is on as a dm
int GetHasAllAccess(object oPC){
	string sName = GetStringLowerCase(GetPCPlayerName(oPC));
	if (sName == "flattedfifth" || sName == "a small green monster" || sName == "edmaster44" ||
		sName == "jelkia" || sName == "morrigan" || GetIsDM(oPC)) 
			return TRUE;
	return FALSE;
}


int GetIsTester(object oPC){
	int bIsTester = FALSE;
	string sName = GetStringLowerCase(GetPCPlayerName(oPC));
	if (sName == "swordsaintmusashiden" || sName == "snailin8r" || sName == "unseen_boredom")
			bIsTester = TRUE;
	if (GetHasAllAccess(oPC)) bIsTester = TRUE;
	
	//set a local int to tell functions in other scripts how much to reveal
	if (bIsTester){
		if (!GetLocalInt(oPC, "IsTester"))
			SetLocalInt(oPC, "IsTester", TRUE);
	} else {
		if (GetLocalInt(oPC, "IsTester"))
			DeleteLocalInt(oPC, "IsTester");
	}
	
	return bIsTester;
}