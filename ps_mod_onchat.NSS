//v 0.1
//reward players roleplaying
#include "nwnx_sql"
#include "ps_inc_functions"

void GiveXPTick(object oPC) {

	int baseTick = 10;
	baseTick += d20();

	SendMessageToPC(oPC, "Experience awarded for RP:");
	GiveXPToCreature(oPC, baseTick);

}

void awardXP(object oPC, int XPamount)
{
	object oItem = GetItemPossessedBy(oPC,"ps_essence");
	
	float fRand = IntToFloat(Random(6));
	DelayCommand(fRand, GiveXPTick(oPC));
	
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
	if(d100() < 75)
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

int StartingConditional(object oSender, object oTarget, int nChannel, string sMessage)
{ 
	string MessageToSend;

	// Dispatch the message to Sigil.TextCommands first and if it handles the
	// message then don't forward it on.
	if (ForwardMessageToTextCommands(oSender, oTarget, nChannel, sMessage) == FALSE)
	{
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