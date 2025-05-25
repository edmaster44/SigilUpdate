#include "aaa_constants"
#include "ps_inc_advscript"
#include "ps_inc_functions"
#include "ps_inc_wingtail"

int CheckEpiteth(int nCLASS, object oPC)
{
	object 	oItem		= GetItemPossessedBy(oPC,"ps_essence");
	
	switch(nCLASS)
	{
		case 17:    if (GetHasFeat(2178, oPC, TRUE)==TRUE) return TRUE;
					else if (GetHasFeat(3008, oPC, TRUE)==TRUE) return TRUE;
					else if (GetHasFeat(3009, oPC, TRUE)==TRUE) return TRUE;
					else if (GetHasFeat(3010, oPC, TRUE)==TRUE) return TRUE;
					else if (GetHasFeat(3011, oPC, TRUE)==TRUE) return TRUE;
					else if (GetHasFeat(3012, oPC, TRUE)==TRUE) return TRUE;
					else break; //Fey
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
					else if (GetHasFeat(3021)== TRUE) return TRUE;//Mezzo Wings
					else if (GetHasFeat(3022)== TRUE) return TRUE;//Erinyes Wings
					else if (GetHasFeat(3023)== TRUE) return TRUE;//Tattered Wings
					else if (GetHasFeat(3024)== TRUE) return TRUE;//New celestial Wings
					else break; //Half-Fiend Wings/Eyes
		case 76:	if (GetHasFeat(2781)==TRUE) return TRUE; //Dark Flight
					else if (GetHasFeat(2556)==TRUE) return TRUE; //Supernatural Sight
					else if (GetHasFeat(3021)== TRUE) return TRUE;//Mezzo Wings
					else if (GetHasFeat(3022)== TRUE) return TRUE;//Erinyes Wings
					else if (GetHasFeat(3023)== TRUE) return TRUE;//Tattered Wings
					else if (GetHasFeat(3024)== TRUE) return TRUE;//New celestial Wings
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
					
		case 110: 	if (GetHasFeat(21470)==TRUE) return TRUE;//Psychic Warrior, Lurk Path
				  	else if (GetHasFeat(21471)==TRUE) return TRUE;
				  	else break;
					
		case 114:	if (GetHasFeat(FEAT_HALFVAMPIRE)==TRUE) return TRUE;//Half Vampire
					else if (GetHasFeat(FEAT_FETCH)==TRUE) return TRUE;//Fetch
					else if (GetHasFeat(FEAT_GHUL)==TRUE) return TRUE;//Ghul
					else if (GetHasFeat(FEAT_GHAEDEN)==TRUE) return TRUE;//Ghaeden
					else break;			
		case 621:	if (GetHasFeat(2179)==TRUE) return TRUE; //Bright Flight
					else if (GetHasFeat(2556)==TRUE) return TRUE; //Supernatural Sight
					else if (GetHasFeat(3024)== TRUE) return TRUE;//New celestial Wings
					else break; //Half-Celestial Wings/Eyes
		case 761:	if (GetHasFeat(2179)==TRUE) return TRUE; //Bright Flight
					else if (GetHasFeat(2556)==TRUE) return TRUE; //Supernatural Sight
					else if (GetHasFeat(3024)== TRUE) return TRUE;//New celestial Wings	
					else break; //Half-Celestial Wings/Eyes	
		case 499:	if (GetHasFeat(288)==TRUE) return TRUE;
					else if (GetHasFeat(220)==TRUE) return TRUE;
					else break; //Half-Dragon Wings
	}
	return FALSE;
}

int GetRelevantClass(object oPC) {

	if ((GetLevelByClass(42, oPC) > 0) && (CheckEpiteth(42, oPC) == FALSE)) return 42; //Celestial Envoy
	if ((GetLevelByClass(49, oPC) > 0) && (CheckEpiteth(49, oPC) == FALSE)) return 49; //Draconic Heritage
	if ((GetLevelByClass(62, oPC) >= 6) && (GetHasFeat(2537, oPC)) && (CheckEpiteth(62, oPC) == FALSE)) return 62; //Half-Fiend Wings/Eyes
	if ((GetLevelByClass(62, oPC) >= 6) && (GetHasFeat(2538, oPC)) && (CheckEpiteth(621, oPC) == FALSE)) return 621; //Half-Celestial Wings/Eyes, Magic
	if ((GetLevelByClass(76, oPC) >= 6) && (GetHasFeat(2537, oPC)) && (CheckEpiteth(62, oPC) == FALSE)) return 62; //Half-Fiend(magic path) Wings/Eyes, Magic
	if ((GetLevelByClass(76, oPC) >= 6) && (GetHasFeat(2538, oPC)) && (CheckEpiteth(621, oPC) == FALSE)) return 621; //Half-Celestial(Magic path) Wings/Eyes, Magic
	if ((GetLevelByClass(104, oPC) > 0) && (CheckEpiteth(104, oPC) == FALSE)) return 104; //Lycan Affliction
	if ((GetLevelByClass(106, oPC) >= 5) && (GetHasFeat(2584, oPC))) return 106; //VampMal L5 Bonus Feat
	if ((GetLevelByClass(108, oPC) >= 6)) return 108; //Gray Slaad Chaotic Crafting
	if ((GetLevelByClass(110,oPC) > 0 ) && (CheckEpiteth(110,oPC) == FALSE)) return 110;//Psychic Warrior
	if ((GetLevelByClass(114,oPC) > 0 ) && (CheckEpiteth(114,oPC) == FALSE)) return 114;//Half Undead
	if ((GetLevelByClass(49, oPC) >= 6) && (CheckEpiteth(499, oPC) == FALSE)) return 499; //Half-Dragon Wings
	if (GetRacialType(oPC) == RACIAL_TYPE_FEY && GetHasFeat(2843, oPC) && (CheckEpiteth(CLASS_TYPE_FEY, oPC) == FALSE)) return CLASS_TYPE_FEY;
	else return -1;
}

int GetEpiteth(int nCLASS, int nCOUNT)
{
	switch(nCLASS)
	{
		case CLASS_TYPE_FEY: switch(nCOUNT) //Fey Trait
		{
			case 1: return 3008;
			case 2: return 3009;
			case 3: return 3010;
			case 4: return 3011;
			case 5: return 3012;
			case 6: return 2178;
		} break;
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
			case 3: return 3021;//Mezzoloth wings
			case 4:return 3022;//Erinyes Wings
			case 5:return 3023; //Tattered Fiend Wings
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
		} break;
		case 108: switch(nCOUNT) //Gray Slaad Chaotic Crafting
		{
			case 1: return 946;		// Craft Wand
			case 2: return 1092;	// Craft Magic Arms and Armor
			case 3: return 1093;	// Craft Wondrous Items
		} break;

		case 110: switch(nCOUNT)//Psychic Warrior Paths
		{
			case 1: return 21470; // Lurk Path
			case 2: return 21471; // Feral Path
			
		} break;
		case 114: switch(nCOUNT)//Half Undead Heritage
		{
			case 1: return FEAT_HALFVAMPIRE;
			case 2: return FEAT_FETCH;
			case 3: return FEAT_GHUL;
			case 4:	return FEAT_GHAEDEN;
		} break;
		case 621: switch(nCOUNT) //Half-Celestial Wings/Eyes
		{
			case 1: return 2179; //Bright Flight
			case 2: return 2556; //Supernatural Sight
			case 3: return 3024; //New Celestial Wings
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
		case CLASS_TYPE_FEY: return "You must select which fey trait you want. Keep in mind - Fey Trait: Hypnotism will add butterfly wings, and the Scent feat will add a tail.";
		case 42: return "You must select which member of the Hebdomad to serve. This selection determines the bonus feats gained at levels 2, 3 and 5. "; //Celestial Envoy
		case 49: return "You must select your draconic heritage. This selection determines your breath weapon, immunities, and draconic magic."; //Draconic Heritage
		case 62: return "You must select either fiendish wings or supernatural sight."; //Half-Fiend
		case 104: return "You must select your lycanthropic affliction."; //Lycanthrope
		case 106: return "You must select your bonus feat."; //VampMal
		case 108: return "You must select your bonus crafting feat."; //Gray Slaad
		case 110: return "You must Select Your Psychic Warrior Path";//Psychic Warrior
		case 114: return "You must Select your Undead Heritage";//Half-Undead
		case 621: return "You must select either celestial wings or supernatural sight."; //Half-Celestial
		case 499: return "Your draconic heritage allows you to select wings if you so choose. This choice is permanent."; //Half-Dragon Wings
	}
	return "";
}

int GetTitle(int nCLASS)
{
	switch(nCLASS)
	{
		case CLASS_TYPE_FEY: return 16780659; //Fey Trait
		case 42: return 16780035; //Celestial Envoy
		case 49: return 16779948; //Draconic Heritage
		case 62: return 16780074; //Outsider Apotheosis
		case 104: return 16780463; //Lycan Affliction
		case 106: return 16780457; //VampMal L5 Bonus Feat
		case 108: return 16780538; //Gray Slaad Chaotic Crafting
		case 110: return 16781147; // Psychic warrior path
		case 114: return 16781148;//Half-Undead Heritage
		case 621: return 16780074; //Outsider Apotheosis
		case 499: return 16780036; //Half-Dragon Wings
	}
	return -1;
}

string GetEpitethName(int nFeat) {

	//Scent feat w/ tail
	if (nFeat == 2178) {
		return "Fey Senses";
	}
	
	int nNAME = StringToInt(Get2DAString("feat", "FEAT", nFeat));
	return GetStringByStrRef(nNAME);
}

string GetEpitethDescription(int nFeat) {
	
	//Scent feat w/ tail
	if (nFeat == 2178) {
		return "You gain the Scent feat, and a tail.";
	}
	
	int nDESC = StringToInt(Get2DAString("feat", "DESCRIPTION", nFeat));
	return GetStringByStrRef(nDESC);

}

void PopulateList(object oPC, int nCLASS, int nPAGE, string sSCREEN)
{
	if (nPAGE <= 0) SetGUIObjectDisabled(oPC, sSCREEN, "CHOICES_PREV", TRUE);
	else SetGUIObjectDisabled(oPC, sSCREEN, "CHOICES_PREV", FALSE);
	string sICON;
	string sNAME;
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
		sNAME = GetEpitethName(nEPITETH);
		SetGUITexture(oPC, sSCREEN, "CHOICE_ICON_"+IntToString(nCOUNT), sICON);
		SetGUIObjectText(oPC, sSCREEN, "CHOICE_TEXT_"+IntToString(nCOUNT), -1, sNAME);
		SetLocalGUIVariable(oPC, sSCREEN, nCOUNT, IntToString(nEPITETH));
		nCOUNT = nCOUNT + 1;
	}
	
}

void AddEpithetFeat(object oPC, int nFeat) {

	//Special fey feat double additions
	if (GetRacialType(oPC) == RACIAL_TYPE_FEY) {
		if (nFeat == 2178) { //Huldre Tail!
			if (GetGender(oPC) == GENDER_MALE) PS_SetTailNumber(oPC, 27);
			else  PS_SetTailNumber(oPC, 26);
			PS_ApplyPCTail(oPC);
		} else if (nFeat == 3008) {
			FeatAdd(oPC, 2120, FALSE, FALSE, TRUE); //Wings feat!
			
			if (GetGender(oPC) == GENDER_MALE) PS_SetWingNumber(oPC, 79);
			else  PS_SetWingNumber(oPC, 78);
			PS_ApplyPCWings(oPC);
		} else if (nFeat == 3009) {
			FeatAdd(oPC, 3013, FALSE, FALSE, TRUE);
			FeatAdd(oPC, 3014, FALSE, FALSE, TRUE);
		} else if (nFeat == 3010) {
			FeatAdd(oPC, 3015, FALSE, FALSE, TRUE);
			FeatAdd(oPC, 3016, FALSE, FALSE, TRUE);
		}
	}
	
	FeatAdd(oPC, nFeat, FALSE, FALSE, TRUE);
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
		string sDESC = GetEpitethDescription(nFEAT);
		SetGUIObjectText(oPC, sSCREEN, "CHOICE_DESCRIPTION", -1, sDESC);
		SetLocalInt(oPC, "EXTRA_CHOICES_ADD", nFEAT);
		SetGUIObjectDisabled(oPC, sSCREEN, "CHOICES_OK", FALSE);
	}
	else if (sCOMMAND == "CONFIRM")
	{
		int nADD = GetLocalInt(oPC, "EXTRA_CHOICES_ADD");
		CloseGUIScreen(oPC, sSCREEN);
		AddEpithetFeat(oPC, nADD);
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