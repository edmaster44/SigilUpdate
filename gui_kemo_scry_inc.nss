#include "ps_inc_functions"
#include "ps_inc_faction"

/*string ScryFaction(object oPC, object oESS)
{
	object oBadge;
	int nINF;						
	int nFaction = GetFaction(oPC);
	switch (nFaction)
	{
		case 1: return "Prime"; break;
		case FACTION_FREE_LEAGUE: return "Free League"; break;
		case FACTION_ATHAR: return "Athar"; break;
		case FACTION_BELIEVERS_OF_THE_SOURCE: return "Believers of the Source"; break;
		case FACTION_BLEAK_CABAL: return "Bleak Cabal"; break;
		case FACTION_DOOMGUARD: return "Doomguard"; break;
		case FACTION_DUSTMEN: return "Dustmen"; break;
		case FACTION_FATED: return "Fated"; break;
		case FACTION_FRATERNITY_OF_ORDER: return "Fraternity of Order"; break;
		case FACTION_HARMONIUM: return "Harmonium"; break;
		case FACTION_MERCYKILLERS: return "Mercykillers"; break;
		case FACTION_REVOLUTIONARY_LEAGUE: //Anarchists can infiltrate
			oBadge = GetItemPossessedBy(oPC ,"ps_faction_badge");
			if ((PS_GetLocalInt(oBadge, "Faction") == 12)&&(PS_GetLocalInt(oBadge, "Infiltrated") == TRUE)) nINF = PS_GetLocalInt(oBadge, "InfiltratedFaction");
			else nINF = PS_GetLocalInt(oBadge, "Faction");
			switch (nINF)
			{
				case 1: return "Prime"; break;
				case 2: return "Free League"; break;
				case 3: return "Athar"; break;
				case 4: return "Believers of the Source"; break;
				case 5: return "Bleak Cabal"; break;
				case 6: return "Doomguard"; break;
				case 7: return "Dustmen"; break;
				case 8: return "Fated"; break;
				case 9: return "Fraternity of Order"; break;
				case 10: return "Harmonium"; break;
				case 11: return "Mercykillers"; break;
				case 13: return "Sign of One"; break;
				case 14: return "Society of Sensation"; break;
				case 15: return "Transcendent Order"; break;
				case 16: return "Xaositects"; break;
				case 17: return "None"; break;
				case 18: return "Undecided"; break;
				default: return "Revolutionary League";
			}
			break;
		case FACTION_SIGN_OF_ONE: return "Sign of One"; break;
		case FACTION_SOCIETY_OF_SENSATION: return "Society of Sensation"; break;
		case FACTION_TRASCENDENT_ORDER: return "Transcendent Order"; break;
		case FACTION_XAOSITECTS: return "Xaositects"; break;
		case 17: return "None"; break;
		case 18: return "Undecided"; break;
		case FACTION_RINGGIVERS: return "Ring-Giver"; break;
	}
	return "";
}*/

string GetSortRelevant(object oPC, object oList, string sSORT)
{
	int nSORT = StringToInt(sSORT);
	int nLVL;
	string sTXT;
	int nHIDDEN = 0;
	object oESS = GetItemPossessedBy(oList,"ps_essence");
	switch(nSORT)
	{
		case 0: sTXT = GetPCPlayerName(oList);
				break; //SortByPlayer
		case 1: sTXT = GetFirstName(oList);
				break; //SortByName
		case 2: sTXT = FactionIdToName(GetFaction(oList));
				if (PS_GetLocalInt(oESS,"KScry_Faction")==0&&GetIsDM(oPC)==FALSE) nHIDDEN = 1;
				break; //SortByFaction
		case 3: sTXT = GetName(GetArea(oList));
				if (PS_GetLocalInt(oESS,"KScry_Location")==1&&GetIsDM(oPC)==FALSE) nHIDDEN = 1;
				break; //SortByArea
		case 4: nLVL = PS_GetLevel(oList);
				sTXT = IntToString(nLVL);
				if (nLVL < 10) sTXT = "0"+sTXT;
				if (PS_GetLocalInt(oESS,"KScry_Level")==0&&GetIsDM(oPC)==FALSE) nHIDDEN = 1;
				break; //SortByLevel
		case 5: sTXT = PS_GetLocalString(oList, "KScry_Status");
				if (sTXT == "") sTXT = "   ";
				break; //SortByStatus
	}
	if (nHIDDEN == 1) sTXT = "????";
	return sTXT;
}

void ChangeList(int nANON, object oPC, object oList, string sRow, int nSTART)
{
	object oESS = GetItemPossessedBy(oList,"ps_essence");
	int	nPCLevel = PS_GetLocalInt(oESS, "KScry_Level");
	int	nPCFaction = PS_GetLocalInt(oESS, "KScry_Faction");
	int	nPCLocation = PS_GetLocalInt(oESS, "KScry_Location");
	string sPCStatus = PS_GetLocalString(oList, "KScry_Status");
	if (sPCStatus == "") sPCStatus = "    ";
	string sPCName = GetFirstName(oList);
	string sPlayerName = GetPCPlayerName(oList);
	string sPCLevel;
	string sPCFaction;
	string sPCArea;
	if ((nPCLevel != 0)||(GetIsDM(oPC))) sPCLevel = IntToString(PS_GetLevel(oList));
	else sPCLevel = "??";
	if ((nPCFaction == 0)&&(GetIsDM(oPC)==FALSE)) sPCFaction = "????";
	else if (nPCFaction == 2) sPCFaction = "Seeking";
	else sPCFaction = FactionIdToName(GetFaction(oList));
	if ((nPCLocation != 1)||(GetIsDM(oPC))) sPCArea = GetName(GetArea(oList));
	else sPCArea = "????";
	if (GetIsDM(oPC) && nANON == 1) sPCName = sPCName+"*";
	string sTextFields = "KEMO_SCRY_NAME="+sPCName+";" +
				"KEMO_SCRY_PLAYER="+sPlayerName+";" +
				"KEMO_SCRY_FACTION="+sPCFaction+";" +
				"KEMO_SCRY_AREA="+sPCArea+";" +
				"KEMO_SCRY_LEVEL="+sPCLevel+";" +
				"KEMO_SCRY_LFGAFK="+sPCStatus;
	if (nSTART == 0) AddListBoxRow(oPC,"KEMO_SCRY_PANEL","KEMO_SCRY_LIST",sRow,sTextFields,"","","");
	else ModifyListBoxRow(oPC,"KEMO_SCRY_PANEL","KEMO_SCRY_LIST",sRow,sTextFields,"","","");
}