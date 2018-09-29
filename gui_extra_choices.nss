#include "aaa_constants"
#include "ps_inc_advscript"
#include "ps_inc_functions"

int CheckEpiteth(int nCLASS, object oPC)
{
	object 	oItem		= GetItemPossessedBy(oPC,"ps_essence");
	
	switch(nCLASS)
	{
		case 42:	if (GetHasFeat(2629)==TRUE) return TRUE;
					else if (GetHasFeat(2630)==TRUE) return TRUE;
					else if (GetHasFeat(2631)==TRUE) return TRUE;
					else if (GetHasFeat(2632)==TRUE) return TRUE;
					else break; //CelestialEnvoy
		case 49:	if (GetHasFeat(2496)==TRUE) return TRUE;
					else if (GetHasFeat(2497)==TRUE) return TRUE;
					else if (GetHasFeat(2498)==TRUE) return TRUE;
					else if (GetHasFeat(2499)==TRUE) return TRUE;
					else if (GetHasFeat(2500)==TRUE) return TRUE;
					else if (GetHasFeat(2501)==TRUE) return TRUE;
					else if (GetHasFeat(2502)==TRUE) return TRUE;
					else if (GetHasFeat(2503)==TRUE) return TRUE;
					else if (GetHasFeat(2504)==TRUE) return TRUE;
					else if (GetHasFeat(2505)==TRUE) return TRUE;
					else if (GetHasFeat(2506)==TRUE) return TRUE;
					else if (GetHasFeat(2507)==TRUE) return TRUE;
					else if (GetHasFeat(2508)==TRUE) return TRUE;
					else if (GetHasFeat(2509)==TRUE) return TRUE;
					else if (GetHasFeat(2510)==TRUE) return TRUE;
					else if (GetHasFeat(2511)==TRUE) return TRUE;
					else if (GetHasFeat(2512)==TRUE) return TRUE;
					else break; //Draconic Heritage
		case 62:	if (GetHasFeat(2781)==TRUE) return TRUE; //Dark Flight
					else if (GetHasFeat(2556)==TRUE) return TRUE; //Supernatural Sight
					else break; //Half-Fiend Wings/Eyes
		case 104:	if (GetHasFeat(2592)==TRUE) return TRUE; // Lycan Affliction - Werewolf
					else if (GetHasFeat(2593)==TRUE) return TRUE; //Lycan Affliction - Wererat
					else if (GetHasFeat(2610)==TRUE) return TRUE; //Lycan Affliction - Wereboar
					else if (GetHasFeat(2656)==TRUE) return TRUE; //Lycan Affliction - Weretiger
					else break; //Lycan Affliction
		case 108:	if (GetHasFeat(1092)==TRUE) return TRUE; //Craft Magic Arcms and Armor
					else if (GetHasFeat(946)==TRUE) return TRUE; //Craft Wand
					else if (GetHasFeat(1093)==TRUE) return TRUE; // Craft Wonderous Items
					else break; //Gray Slaad Chaotic Crafting
		case 621:	if (GetHasFeat(2179)==TRUE) return TRUE; //Bright Flight
					else if (GetHasFeat(2556)==TRUE) return TRUE; //Supernatural Sight
					else break; //Half-Celestial Wings/Eyes
		case 499:	if (GetHasFeat(288)==TRUE) return TRUE;
					else if (GetHasFeat(220)==TRUE) return TRUE;
					else break; //Half-Dragon Wings
	}
	return FALSE;
}

int GetRelevantClass(object oPC)
{
	if ((GetLevelByClass(42, oPC) > 0) && (CheckEpiteth(42, oPC) == FALSE)) return 42; //Celestial Envoy
	if ((GetLevelByClass(49, oPC) > 0) && (CheckEpiteth(49, oPC) == FALSE)) return 49; //Draconic Heritage
	if ((GetLevelByClass(62, oPC) >= 6) && (GetHasFeat(2537, oPC)) && (CheckEpiteth(62, oPC) == FALSE)) return 62; //Half-Fiend Wings/Eyes
	if ((GetLevelByClass(104, oPC) > 0) && (CheckEpiteth(104, oPC) == FALSE)) return 104; //Lycan Affliction
	if ((GetLevelByClass(106, oPC) >= 5)) return 106; //VampMal L5 Bonus Feat
	if ((GetLevelByClass(108, oPC) >= 6)) return 108; //Gray Slaad Chaotic Crafting
	if ((GetLevelByClass(62, oPC) >= 6) && (GetHasFeat(2538, oPC)) && (CheckEpiteth(621, oPC) == FALSE)) return 621; //Half-Celestial Wings/Eyes
	if ((GetLevelByClass(49, oPC) >= 6) && (CheckEpiteth(499, oPC) == FALSE)) return 499; //Half-Dragon Wings
	else return -1;
}

int GetEpiteth(int nCLASS, int nCOUNT)
{
	switch(nCLASS)
	{
		case 42: switch(nCOUNT) //Celestial Envoy
		{
			case 1: return 2629;
			case 2: return 2630;
			case 3: return 2631;
			case 4: return 2632;
		}	break;
		case 49: switch(nCOUNT) //Draconic Heritage
		{	
			case 1: return 2496; //White
			case 2: return 2497; //Black
			case 3: return 2498; //Green
			case 4: return 2499; //Blue
			case 5: return 2500; //Red
			case 6:	return 2501; //Brass
			case 7: return 2502; //Copper
			case 8: return 2503; //Bronze
			case 9: return 2504; //Silver
			case 10: return 2505; //Gold
			case 11: return 2506; //Amethyst
			case 12: return 2507; //Crystal
			case 13: return 2508; //Emerald
			case 14: return 2509; //Sapphire
			case 15: return 2510; //Topaz
			case 16: return 2511; //Shadow
			case 17: return 2512; //Fang
		}	break;
		case 62: switch(nCOUNT) //Half-Fiend Wings/Eyes
		{
			case 1: return 2781; //Dark Flight
			case 2: return 2556; //Supernatural Sight
		}	break;
		case 104: switch(nCOUNT) //Lycan Affliction
		{
			case 1: return 2592; //Werewolf
			case 2: return 2593; //Wererat
			case 3: return 2610; //Wereboar
			case 4: return 2656; //Weretiger
		}	break;
		case 106: switch(nCOUNT) //VampMal l5 Bonus Feat
		{
			case 1: return 0;		//Alertness
			case 2: return 24;		//Lightning Reflexes
			case 3: return 377;		//Improved Initiative
			case 4: return 11;		//Empower Spell
			case 5: return 12;		//Extend Spell
			case 6: return 25;		//Maximize Spell
			case 7: return 29;		//Quicken Spell
			case 8: return 33;		//Silent Spell
			case 9: return 37;		//Still Spell
			case 10: return 35; 	//Spell Focus: Abjuration
			case 11: return	166;	//Spell Focus: Conjuration
			case 12: return 167;	//Spell Focus: Divination
			case 13: return 168;	//Spell Focus: Enchantment
			case 14: return 169;	//Spell Focus: Evocation
			case 15: return 170;	//Spell Focus: Illusion
			case 16: return 171;	//Spell Focus: Necromancy
			case 17: return 172;	//Spell Focus: Transmutation 
			case 18: return 36;		//Spell Penetration
		}
		case 108: switch(nCOUNT) //Gray Slaad Chaotic Crafting
		{
			case 1: return 946;		// Craft Wand
			case 2: return 1092;	// Craft Magic Arms and Armor
			case 3: return 1093;	// Craft Wondrous Items
		}	break;
		case 621: switch(nCOUNT) //Half-Celestial Wings/Eyes
		{
			case 1: return 2179; //Bright Flight
			case 2: return 2556; //Supernatural Sight
		}	break;
		case 499: switch(nCOUNT) //Half-Dragon Wings
		{
			case 1: return 288; //Wings
			case 2: return 220; //Wingless
		}	break;
	}
	return -1;
}

string GetClassSubtitle(int nCLASS)
{
	switch(nCLASS)
	{
		case 42: return "You must select which member of the Hebdomad to serve. This selection determines the bonus feats gained at levels 2, 3 and 5. "; //Celestial Envoy
		case 49: return "You must select your draconic heritage. This selection determines your breath weapon, immunities, and draconic magic."; //Draconic Heritage
		case 62: return "You must select either fiendish wings or supernatural sight."; //Half-Fiend
		case 104: return "You must select your lycanthropic affliction."; //Lycanthrope
		case 106: return "You must select your bonus feat."; //VampMal
		case 108: return "You must select your bonus crafting feat."; //Gray Slaad
		case 621: return "You must select either celestial wings or supernatural sight."; //Half-Celestial
		case 499: return "Your draconic heritage allows you to select wings if you so choose. This choice is permanent."; //Half-Dragon Wings
	}
	return "";
}

int GetTitle(int nCLASS)
{
	switch(nCLASS)
	{
		case 42: return 16780035; //Celestial Envoy
		case 49: return 16779948; //Draconic Heritage
		case 62: return 16780074; //Outsider Apotheosis
		case 104: return 16780463; //Lycan Affliction
		case 106: return 16780457; //VampMal L5 Bonus Feat
		case 108: return 16780538; //Gray Slaad Chaotic Crafting
		case 621: return 16780074; //Outsider Apotheosis
		case 499: return 16780036; //Half-Dragon Wings
	}
	return -1;
}

void PopulateList(object oPC, int nCLASS, int nPAGE, string sSCREEN)
{
	if (nPAGE <= 0) SetGUIObjectDisabled(oPC, sSCREEN, "CHOICES_PREV", TRUE);
	else SetGUIObjectDisabled(oPC, sSCREEN, "CHOICES_PREV", FALSE);
	string sICON;
	int nNAME;
	int nEPITETH;
	int nCOUNT = 1;
	while (nCOUNT <= 10)
	{
		SetGUIObjectHidden(oPC, sSCREEN, "CHOICE_PANE_"+IntToString(nCOUNT), TRUE);
		nCOUNT = nCOUNT + 1;
	}
	
	nCOUNT = 1;
	
	while (nCOUNT <= 10)
	{
		nEPITETH = GetEpiteth(nCLASS, nPAGE*10 + nCOUNT);
		if (nEPITETH == -1)
		{
			SetGUIObjectDisabled(oPC, sSCREEN, "CHOICES_NEXT", TRUE);
			break;
		}
		else SetGUIObjectDisabled(oPC, sSCREEN, "CHOICES_NEXT", FALSE);
		SetGUIObjectHidden(oPC, sSCREEN, "CHOICE_PANE_"+IntToString(nCOUNT), FALSE);
		sICON = Get2DAString("feat", "ICON", nEPITETH) + ".tga";
		nNAME = StringToInt(Get2DAString("feat", "FEAT", nEPITETH));
		SetGUITexture(oPC, sSCREEN, "CHOICE_ICON_"+IntToString(nCOUNT), sICON);
		SetGUIObjectText(oPC, sSCREEN, "CHOICE_TEXT_"+IntToString(nCOUNT), nNAME, "");
		SetLocalGUIVariable(oPC, sSCREEN, nCOUNT, IntToString(nEPITETH));
		nCOUNT = nCOUNT + 1;
	}
	
}

void main(string sCOMMAND, string sFEAT)
{
	object oPC = OBJECT_SELF;
	int nCLASS = GetRelevantClass(oPC);
	int nPAGE = GetLocalInt(oPC, "EXTRA_UI_PAGE");
	if (nCLASS == -1) return;
	string sSCREEN = "SCREEN_EXTRA_CHOICES";
	if (sCOMMAND == "START") 
	{
		int nTITLE = GetTitle(nCLASS);
		DisplayGuiScreen(oPC, sSCREEN, TRUE, "extra_choices.xml");
		SetGUIObjectText(oPC, sSCREEN, "CHOICE_TITLE", nTITLE, "");
		SetGUIObjectText(oPC, sSCREEN, "CHOICE_SUBTITLE", -1, GetClassSubtitle(nCLASS));
		SetGUIObjectDisabled(oPC, sSCREEN, "CHOICES_OK", TRUE);
		SetLocalInt(oPC, "EXTRA_UI_PAGE", 0);
		PopulateList(oPC, nCLASS, 0, sSCREEN);
	}
	else if (sCOMMAND == "SELECT")
	{
		int nFEAT = StringToInt(sFEAT);
		int nDESC = StringToInt(Get2DAString("feat", "DESCRIPTION", nFEAT));
		SetGUIObjectText(oPC, sSCREEN, "CHOICE_DESCRIPTION", nDESC, "");
		SetLocalInt(oPC, "EXTRA_CHOICES_ADD", nFEAT);
		SetGUIObjectDisabled(oPC, sSCREEN, "CHOICES_OK", FALSE);
	}
	else if (sCOMMAND == "CONFIRM")
	{
		int nADD = GetLocalInt(oPC, "EXTRA_CHOICES_ADD");
		CloseGUIScreen(oPC, sSCREEN);
		FeatAdd(oPC, nADD, FALSE, FALSE, TRUE);
		DeleteLocalInt(oPC, "EXTRA_UI_PAGE");
	}
	else if (sCOMMAND == "PREV")
	{
		nPAGE = nPAGE - 1;
		SetLocalInt(oPC, "EXTRA_UI_PAGE", nPAGE);
		DelayCommand(0.0f, PopulateList(oPC, nCLASS, nPAGE, sSCREEN));
	}
	else if (sCOMMAND == "NEXT")
	{
		nPAGE = nPAGE + 1;
		SetLocalInt(oPC, "EXTRA_UI_PAGE", nPAGE);
		DelayCommand(0.0f, PopulateList(oPC, nCLASS, nPAGE, sSCREEN));
	}
}