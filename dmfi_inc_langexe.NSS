////////////////////////////////////////////////////////////////////////////////
// dmfi_inc_langexe - DM Friendly Initiative - Code for /Languages
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           1/20/7
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////

/*	READ ME::   THE TOP TWO FUNCTIONS DEFINE THE PHB RULES FOR GRANTING DEFAULT
				LANGUAGES AND THEN DEFINING LANGUAGE CHOICES.  THESE ARE AS BY
				THE BOOK AS I COULD GET THEM.
				
				YOU CAN CUSTOMIZE THE LANGUAGE RULES BY ALTERING THE TOP TWO
				FUNCTIONS ONLY.  ONLY TOUCH THE TOP TWO FUNCTIONS.
				
				FOR CHANGES, YOU MUST RECOMPILE ALL SCRIPTS IN THE MODULE!!!!
*/


#include "dmfi_inc_tool"
#include "dmfi_inc_english"
#include "aaa_constants"
// ***************************** DECLARATIONS **********************************

string DMFI_GrantOutsider(object oPC);
void DMFI_GrantChoosenLang(object oPC, string sLang);

// FILE: dmfi_inc_langexe
//Purpose: Sets sLang as a valid language for oPC.  List starts at a value of 0.
//Includes a check for DMFI_IsLanguageKnown within this function.
void DMFI_GrantLanguage(object oPC, string sLang);

//FILE: dmfi_inc_langexe
//Purpose: Returns TRUE / FALSE whether sLang is known by oPC
int DMFI_IsLanguageKnown(object oPC, string sLang);

//FILE: dmfi_inc_langexe
//Purpose: Reports oTarget's languages to oDM for review
void DMFI_ListLanguages(object oDM, object oTarget);

//FILE: dmfi_inc_langexe
//Purpose: Returns a default language that has been linked to a new name via
//a plugin.  sLang is the name of the NEW Language - a default DMFI Language
//is returned.  If there is no link it returns ""
string DMFI_NewLanguage(string sLang);

//FILE: dmfi_inc_langexe
//Purpose: Removes sLang as a valid Language for oPC and decrements the max number
// of known languages.  The player is informed of the action.
int DMFI_RemoveLanguage(object oPC, string sLang);

//FILE: dmfi_inc_langexe
//Purpose: Sends sTranslate to any nearby speakers of sLang.  NOTE: sTranslate
//is the original text before it is translated so we just send it as is.
void DMFI_TranslateToSpeakers(object oSpeaker, string sTranslate, string sLang, object oUI);

// ****************************** FUNCTIONS ************************************

void DMFI_BuildChoosenList(object oPC)
{	
		DMFI_GrantChoosenLang(oPC, LNG_ABYSSAL);
		DMFI_GrantChoosenLang(oPC, LNG_AQUAN);
		DMFI_GrantChoosenLang(oPC, LNG_AURAN);
		DMFI_GrantChoosenLang(oPC, LNG_CELESTIAL);
		DMFI_GrantChoosenLang(oPC, LNG_DRACONIC);
		DMFI_GrantChoosenLang(oPC, LNG_DWARF);
		DMFI_GrantChoosenLang(oPC, LNG_ELVEN);
		DMFI_GrantChoosenLang(oPC, LNG_GIANT);
		DMFI_GrantChoosenLang(oPC, LNG_GNOME);
		DMFI_GrantChoosenLang(oPC, LNG_GOBLIN);
		DMFI_GrantChoosenLang(oPC, LNG_GNOLL);
		DMFI_GrantChoosenLang(oPC, LNG_HALFLING);
		DMFI_GrantChoosenLang(oPC, LNG_IGNAN);
		DMFI_GrantChoosenLang(oPC, LNG_INFERNAL);
		DMFI_GrantChoosenLang(oPC, LNG_ORC);
		DMFI_GrantChoosenLang(oPC, LNG_SYLVAN);
		DMFI_GrantChoosenLang(oPC, LNG_TERRAN);
		DMFI_GrantChoosenLang(oPC, LNG_UNDERCOMMON);
		DMFI_GrantChoosenLang(oPC, LNG_YUANTI);
/*
	// Make racial bonus languages available
	if (GetRacialType(oPC)==RACIAL_TYPE_DWARF)
	{
		DMFI_GrantChoosenLang(oPC, LNG_GIANT);
		DMFI_GrantChoosenLang(oPC, LNG_GNOME);
		DMFI_GrantChoosenLang(oPC, LNG_GOBLIN);
		DMFI_GrantChoosenLang(oPC, LNG_ORC);
		DMFI_GrantChoosenLang(oPC, LNG_TERRAN);
		DMFI_GrantChoosenLang(oPC, LNG_UNDERCOMMON);
	}
	else if (GetRacialType(oPC)==RACIAL_TYPE_ELF)
	{
		DMFI_GrantChoosenLang(oPC, LNG_DRACONIC);
		DMFI_GrantChoosenLang(oPC, LNG_GNOLL);
		DMFI_GrantChoosenLang(oPC, LNG_GNOME);
		DMFI_GrantChoosenLang(oPC, LNG_GOBLIN);
		DMFI_GrantChoosenLang(oPC, LNG_ORC);
		DMFI_GrantChoosenLang(oPC, LNG_SYLVAN);
	}
	else if ((GetRacialType(oPC)==RACIAL_TYPE_HUMAN) || (GetRacialType(oPC)==RACIAL_TYPE_HALFELF))
	{
		DMFI_GrantChoosenLang(oPC, LNG_ABYSSAL);
		DMFI_GrantChoosenLang(oPC, LNG_AQUAN);
		DMFI_GrantChoosenLang(oPC, LNG_AURAN);
		DMFI_GrantChoosenLang(oPC, LNG_CELESTIAL);
		DMFI_GrantChoosenLang(oPC, LNG_DRACONIC);
		DMFI_GrantChoosenLang(oPC, LNG_DWARF);
		DMFI_GrantChoosenLang(oPC, LNG_ELVEN);
		DMFI_GrantChoosenLang(oPC, LNG_GIANT);
		DMFI_GrantChoosenLang(oPC, LNG_GNOME);
		DMFI_GrantChoosenLang(oPC, LNG_GOBLIN);
		DMFI_GrantChoosenLang(oPC, LNG_GNOLL);
		DMFI_GrantChoosenLang(oPC, LNG_HALFLING);
		DMFI_GrantChoosenLang(oPC, LNG_IGNAN);
		DMFI_GrantChoosenLang(oPC, LNG_INFERNAL);
		DMFI_GrantChoosenLang(oPC, LNG_ORC);
		DMFI_GrantChoosenLang(oPC, LNG_SYLVAN);
		DMFI_GrantChoosenLang(oPC, LNG_TERRAN);
		DMFI_GrantChoosenLang(oPC, LNG_UNDERCOMMON);
	}
	else if (GetRacialType(oPC)==RACIAL_TYPE_HALFORC)
	{
		DMFI_GrantChoosenLang(oPC, LNG_DRACONIC);
		DMFI_GrantChoosenLang(oPC, LNG_GIANT);
		DMFI_GrantChoosenLang(oPC, LNG_GNOLL);
		DMFI_GrantChoosenLang(oPC, LNG_GOBLIN);
		DMFI_GrantChoosenLang(oPC, LNG_ABYSSAL);
	}	
	else if (GetRacialType(oPC)==RACIAL_TYPE_HALFLING)
	{
		DMFI_GrantChoosenLang(oPC, LNG_DWARF);
		DMFI_GrantChoosenLang(oPC, LNG_ELVEN);
		DMFI_GrantChoosenLang(oPC, LNG_GNOME);
		DMFI_GrantChoosenLang(oPC, LNG_GOBLIN);
		DMFI_GrantChoosenLang(oPC, LNG_ORC);
	}
	else if (GetRacialType(oPC)==RACIAL_TYPE_HALFORC)
	{
		DMFI_GrantChoosenLang(oPC, LNG_DRACONIC);
		DMFI_GrantChoosenLang(oPC, LNG_GIANT);
		DMFI_GrantChoosenLang(oPC, LNG_GNOLL);
		DMFI_GrantChoosenLang(oPC, LNG_GOBLIN);
		DMFI_GrantChoosenLang(oPC, LNG_ABYSSAL);
	}
	else if (GetRacialType(oPC)==RACIAL_TYPE_GNOME)
	{
		DMFI_GrantChoosenLang(oPC, LNG_DRACONIC);
		DMFI_GrantChoosenLang(oPC, LNG_DWARF);
		DMFI_GrantChoosenLang(oPC, LNG_ELVEN);
		DMFI_GrantChoosenLang(oPC, LNG_GIANT);
		DMFI_GrantChoosenLang(oPC, LNG_GOBLIN);
		DMFI_GrantChoosenLang(oPC, LNG_ORC);
	}
	else if (GetSubRace(oPC)==RACIAL_SUBTYPE_AASIMAR)
	{
		DMFI_GrantChoosenLang(oPC, LNG_AQUAN);
		DMFI_GrantChoosenLang(oPC, LNG_AURAN);
		DMFI_GrantChoosenLang(oPC, LNG_CELESTIAL);
		DMFI_GrantChoosenLang(oPC, LNG_ELVEN);
		DMFI_GrantChoosenLang(oPC, LNG_IGNAN);
		DMFI_GrantChoosenLang(oPC, LNG_SYLVAN);
		DMFI_GrantChoosenLang(oPC, LNG_TERRAN);
	}	
	else if (GetSubRace(oPC)==RACIAL_SUBTYPE_TIEFLING)
	{
		DMFI_GrantChoosenLang(oPC, LNG_ABYSSAL);
		DMFI_GrantChoosenLang(oPC, LNG_AQUAN);
		DMFI_GrantChoosenLang(oPC, LNG_AURAN);
		DMFI_GrantChoosenLang(oPC, LNG_IGNAN);
		DMFI_GrantChoosenLang(oPC, LNG_INFERNAL);
		DMFI_GrantChoosenLang(oPC, LNG_SYLVAN);
		DMFI_GrantChoosenLang(oPC, LNG_TERRAN);
	}	
	
	// Make CLASS bonus languages available
	if (GetLevelByClass(CLASS_TYPE_DRUID, oPC)!=0)
		DMFI_GrantChoosenLang(oPC, LNG_SYLVAN);
		
	if (GetLevelByClass(CLASS_TYPE_WIZARD, oPC)!=0)
		DMFI_GrantChoosenLang(oPC, LNG_DRACONIC);
*/	
}

void DMFI_GiveDefaultLanguages(object oPC)
{	// PURPOSE:  Grants languages as close as possible to 
	// PHB rules  1/19/7
	
	string sLang;
	// Grant basic Race related language
	switch(GetRacialType(oPC))
    {
        case RACIAL_TYPE_DWARF:                { sLang=LNG_DWARF; break;}
        case RACIAL_TYPE_ELF:                  { sLang=LNG_ELVEN; break;}
        case RACIAL_TYPE_HALFELF:              { sLang=LNG_ELVEN; break;}
        case RACIAL_TYPE_GNOME:                { sLang=LNG_GNOME; break;}
        case RACIAL_TYPE_HALFLING:             { sLang=LNG_HALFLING; break;}
        case RACIAL_TYPE_HUMANOID_ORC:         { sLang=LNG_ORC; break;}
        case RACIAL_TYPE_HALFORC:              { sLang=LNG_ORC; break;}
		case 32: /* Orc */						{ sLang=LNG_ORC; break;}
        case RACIAL_TYPE_ANIMAL: 				{ sLang=LNG_ANIMAL; break;}
		case RACIAL_TYPE_MAGICAL_BEAST:			{ sLang=LNG_ANIMAL; break;}
		case RACIAL_TYPE_FEY:					{ sLang=LNG_SYLVAN; break;}
		
		//case RACIAL_TYPE_OUTSIDER:
		//{
		//	sLang = DMFI_GrantOutsider(oPC);
		//	break;
		//}	
		case 12: //RACIAL_TYPE_HUMANOID_GOBLINOID
		{
			sLang=LNG_GOBLIN; break;
		}		
		/*case 13: //RACIAL_TYPE_HUMANOID_MONSTROUS (gnoll)
		{
			sLang=LNG_GNOLL; break;
		}*/
		case 15: //lizardfolk or kobold
		case 11: // dragon
		{
			sLang=LNG_DRACONIC; break;
		}
		case 18: //giant/ogre
		{
			sLang=LNG_GIANT; break;
		}
		case 31: //yuan-ti
		{
			sLang=LNG_YUANTI; break;
		}
		
		default: sLang=""; break;;
    }
	
	int iSRace = GetSubRace(oPC);
	
	switch (iSRace)
	{
		case 3: /*Drow*/ DMFI_GrantLanguage(oPC, LNG_DROWSIGN); break; 
		case RACIAL_SUBTYPE_AIR_GENASI: /*Air Genasi*/ DMFI_GrantLanguage(oPC, LNG_AURAN); break; 
		case RACIAL_SUBTYPE_EARTH_GENASI: /*Earth Genasi*/ DMFI_GrantLanguage(oPC, LNG_TERRAN); break; 
		case RACIAL_SUBTYPE_FIRE_GENASI: /*Fire Genasi*/ DMFI_GrantLanguage(oPC, LNG_IGNAN); break; 
		case RACIAL_SUBTYPE_WATER_GENASI: /*Earth Genasi*/ DMFI_GrantLanguage(oPC, LNG_AQUAN); break; 
		case RACIAL_SUBTYPE_ICEGENASI: /*Ice Genasi*/ DMFI_GrantLanguage(oPC, LNG_AURAN); DMFI_GrantLanguage(oPC, LNG_AQUAN); break; 
		case 41: /* Githyanki */ DMFI_GrantLanguage(oPC, LNG_DRACONIC); break;
		case 46: /* Half Celestial */ DMFI_GrantLanguage(oPC, LNG_CELESTIAL); break;
		case 53: /* Night Hag */ 
		{	DMFI_GrantLanguage(oPC, LNG_INFERNAL);
			DMFI_GrantLanguage(oPC, LNG_ABYSSAL);
			break;	}
		case 66: /* Gnoll */ DMFI_GrantLanguage(oPC, LNG_GNOLL); DMFI_GrantLanguage(oPC, LNG_ABYSSAL); break;
		case 67: /* Kobold */ DMFI_GrantLanguage(oPC, LNG_DRACONIC); break;
		case 69: /* Hezrou */ DMFI_GrantLanguage(oPC, LNG_ABYSSAL); break;
		case 72: /* Drider Male */ DMFI_GrantLanguage(oPC, LNG_DROWSIGN); break;
		case 73: /* Drider Female */ DMFI_GrantLanguage(oPC, LNG_DROWSIGN); break;
		case 120: DMFI_GrantLanguage(oPC, LNG_IGNAN); break;
		case 122: DMFI_GrantLanguage(oPC, LNG_IGNAN); break;
		case 186: DMFI_GrantLanguage(oPC, LNG_IGNAN); break;
		case 121: DMFI_GrantLanguage(oPC, LNG_AURAN); break;
		case 187: DMFI_GrantLanguage(oPC, LNG_AURAN); break;
		case 127: /* Eladrin */ DMFI_GrantLanguage(oPC, LNG_ELVEN); break;
		case 128: /* Eladrin */ DMFI_GrantLanguage(oPC, LNG_ELVEN); break;
		case 147: /* Minotaur */ DMFI_GrantLanguage(oPC, LNG_GIANT); break;
		case 158: DMFI_GrantLanguage(oPC, LNG_TERRAN); break;
		case 184: DMFI_GrantLanguage(oPC, LNG_TERRAN); break;
		case 188: DMFI_GrantLanguage(oPC, LNG_TERRAN); break;
		case 163: /* Archons */ DMFI_GrantLanguage(oPC, LNG_CELESTIAL); break;
		case 176: /* Archons */ DMFI_GrantLanguage(oPC, LNG_CELESTIAL); break;
		case 193: /* Eladrin */ DMFI_GrantLanguage(oPC, LNG_CELESTIAL); break;
		case 194: /* Tanar'ri */ DMFI_GrantLanguage(oPC, LNG_ABYSSAL); break;
		case 195: /* Baatezu */ DMFI_GrantLanguage(oPC, LNG_INFERNAL); break;
		case 203: /* Aasimon */ DMFI_GrantLanguage(oPC, LNG_CELESTIAL); break;
		case 220: /* Quasit */ DMFI_GrantLanguage(oPC, LNG_ABYSSAL); break;
		case 221: /* Imp */ DMFI_GrantLanguage(oPC, LNG_INFERNAL); break;
		case 232: /* Treant */ DMFI_GrantLanguage(oPC, LNG_SYLVAN); break;
	}
	
	 
	if (sLang!="")  
		DMFI_GrantLanguage(oPC, sLang);
	 
	if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC)!=0)
		DMFI_GrantOutsider(oPC);	
		
	if (GetRacialType(oPC)==RACIAL_TYPE_GNOME)	
		DMFI_GrantLanguage(oPC, LNG_ANIMAL);
	
	if (GetLevelByClass(CLASS_TYPE_DRAGONDISCIPLE, oPC)!=0)
	 	DMFI_GrantLanguage(oPC, LNG_DRACONIC);
 	
	if (GetLevelByClass(CLASS_TYPE_DRUID, oPC)!=0)
	 	DMFI_GrantLanguage(oPC, LNG_DRUIDIC); 
	 
	if (GetLevelByClass(CLASS_TYPE_ROGUE, oPC)!=0)
	 	DMFI_GrantLanguage(oPC, LNG_CANT);
		
	if (GetLevelByClass(CLASS_TYPE_HALFDRAGON_PRC, oPC)!=0)
		DMFI_GrantLanguage(oPC, LNG_DRACONIC);
		
	if (GetLevelByClass(CLASS_TYPE_HALFOUTSIDER_PRC, oPC)!=0)
		DMFI_GrantOutsider(oPC);

}	 
	 


///////////////////// DO NOT EDIT BELOW THIS!! ///////////////////////////////


void DMFI_GrantChoosenLang(object oPC, string sLang)
{
	object oTool = DMFI_GetTool(oPC);
	
	if (!DMFI_IsLanguageKnown(oPC, sLang))
		AddStringElement(DMFI_CapitalizeWord(sLang), PG_LIST_POSSLANGUAGE, oTool);
}		


string DMFI_GrantOutsider(object oPC)
{
	string sLang;
	if (GetAlignmentGoodEvil(oPC)==ALIGNMENT_GOOD)
		sLang=LNG_CELESTIAL;
	else
	{
		if (GetAlignmentLawChaos(oPC)==ALIGNMENT_CHAOTIC)
			sLang=LNG_ABYSSAL;
		else
			sLang=LNG_INFERNAL;
	}
	
	return sLang;				
}			


void DMFI_GrantChoosenLanguages(object oPC)
{
	object oTool;
	int nScore = GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE);
	int nMod = (nScore-10);
	if (nMod != 0) {
	nMod = nMod/2;
	}
	if (nMod > 0)
	{
		// clear old data
		oTool=DMFI_GetTool(oPC);
		DeleteList(PG_LIST_POSSLANGUAGE, oTool);
	
		// build a current list
		DMFI_BuildChoosenList(oPC);
		
		SetLocalInt(oPC, DMFI_CHOOSE, nMod);
		DMFI_ClearUIData(oPC);
		SetLocalString(oPC, DMFI_LAST_UI_COM, PRM_GRANT + PRM_);
		SetLocalString(oPC, DMFI_UI_PAGE, PG_LIST_POSSLANGUAGE);
		SetLocalString(oPC, DMFI_UI_LIST_TITLE, CV_PROMPT_CHOOSE + IntToString(nMod));
		DMFI_ShowDMListUI(oPC, SCREEN_DMFI_CHOOSE);
	}
}

void DMFI_GrantLanguage(object oPC, string sLang)
{  //Purpose: Sets sLang as a valid Language for oPC.
   //Original Scripter: Demetrious
   //Last Modified By: Demetrious 1/1/7
   	object oTool = DMFI_GetTool(oPC);
   	if (!DMFI_IsLanguageKnown(oPC, sLang))
   	{   
   		int n = GetLocalInt(oTool, DMFI_STRING_LANGUAGE+DMFI_STRING_MAX);
   		SendText(oPC, TXT_LANGUAGE + DMFI_CapitalizeWord(sLang), FALSE, COLOR_GREY);
   		sLang = GetStringLowerCase(sLang);
   		SetLocalString(oTool, DMFI_STRING_LANGUAGE + IntToString(n), sLang);
   		n++;
   		SetLocalInt(oTool, DMFI_STRING_LANGUAGE+DMFI_STRING_MAX, n);
	}
	else
	    SendText(oPC, TXT_LANGUAGE_KNOWN + DMFI_CapitalizeWord(sLang), FALSE, COLOR_GREY);
}

int DMFI_IsLanguageKnown(object oPC, string sLang)
{ 
  //Purpose: Returns TRUE / FALSE whether sLang is known
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 6/28/6
  object oTool = DMFI_GetTool(oPC);
  int n;
  int nMax = GetLocalInt(oTool, DMFI_STRING_LANGUAGE + DMFI_STRING_MAX);
  string sTest;
  // All languages stored in lower case strings.
  sLang = GetStringLowerCase(sLang);

  for (n=0; n<nMax; n++)
  {
    sTest = GetLocalString(oTool, DMFI_STRING_LANGUAGE + IntToString(n));
    if (sTest==sLang) return TRUE;
  }
  return FALSE;
}

void DMFI_ListLanguages(object oDM, object oTarget)
{ //Purpose:  Reports oTarget's known languages to oPC
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 10/16/6
    object oTool = DMFI_GetTool(oTarget);
  	string sMess;
    string sLang;
    int n;
	int nMax;
    
	sMess = TXT_LANGUAGE_LIST + GetName(oTarget) + "\n";
	
	if (DMFI_GetIsDM(oTarget))
	{
		SendText(oDM, sMess + TXT_ALL_LANGUAGES, FALSE, COLOR_GREY);
		return;
	}	

	nMax = GetLocalInt(oTool, DMFI_STRING_LANGUAGE + DMFI_STRING_MAX);
    for (n=0; n<nMax; n++)
    {
        sLang = DMFI_CapitalizeWord(GetLocalString(oTool, DMFI_STRING_LANGUAGE + IntToString(n)));
        sMess = sMess + TXT_LANGUAGE + sLang + "\n";
    }
    if (nMax==0) sMess = TXT_NO_LANGUAGE;

    SendText(oDM, sMess, FALSE, COLOR_GREY);
}

string DMFI_NewLanguage(string sLang)
{ //Purpose: Returns a default language that has been linked to a new name via
  //a plugin.
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 6/28/6
    string sDefault = GetLocalString(GetModule(), sLang);
	if (sDefault!="") return sDefault;
	
    return sLang;
}

int DMFI_RemoveLanguage(object oPC, string sLang)
{  //Purpose: Removes sLang as a valid Language for oPC.  The player is informed
   //of the action.
   //Original Scripter: Demetrious
   //Last Modified By: Demetrious 1/26/7
   object oTool = DMFI_GetTool(oPC);
   string sTemp;
   int nReturn = FALSE;
   int n=0;
   int nMax = GetLocalInt(oTool, DMFI_STRING_LANGUAGE+DMFI_STRING_MAX);
   sLang = GetStringLowerCase(sLang);
  
   while (n<nMax)
   {
        if (GetLocalString(oTool, DMFI_STRING_LANGUAGE + IntToString(n))==sLang)
        { // Match - remove language
            CloseGUIScreen(oPC, SCREEN_DMFI_TEXT);
		
			nReturn=TRUE;
   			SetLocalInt(oTool, DMFI_STRING_LANGUAGE + DMFI_STRING_MAX, nMax-1);
			SendText(oPC, TXT_LANGUAGE_REMOVED + sLang, TRUE, COLOR_GREY);
			
            while (n<nMax)
            {
                sTemp = GetLocalString(oTool, DMFI_STRING_LANGUAGE + IntToString(n+1));
                SetLocalString(oTool, DMFI_STRING_LANGUAGE + IntToString(n), sTemp);
                n++;
            }
        }
        n++;
   }

   return nReturn;
}

void DMFI_TranslateToSpeakers(object oSpeaker, string sTranslate, string sLang, object oUI)
{ //Purpose: Sends sTranslate to any nearby speakers of sLang
  //Original Scripter: Demetrious
  //Last Modified By: Demetrious 1/10/7
    int nTest;
	int n=1;
    if ((sLang==LNG_COMMON) || (sLang=="")) return;
	
	SendText(oUI, GetName(oSpeaker) + " : " + sTranslate, FALSE, COLOR_BROWN);
			
	object oListener = GetFirstPC();
    while (GetIsObjectValid(oListener))
    {
        if (GetArea(oSpeaker)==GetArea(oListener)) 
        { 
			if ((oListener!=oSpeaker) && GetDistanceBetween(oSpeaker, oListener)<20.0)
            {
                if (DMFI_IsLanguageKnown(oListener, sLang) || DMFI_GetIsDM(oListener) || GetIsDMPossessed(oListener) || GetIsDM(GetMaster(oListener)) )
                { // Speaks language
          		    SendText(oListener, PRM_ + GetName(oSpeaker) + PRM_ + TXT_TRANSLATED + DMFI_CapitalizeWord(sLang) + PRM_ + sTranslate, FALSE, COLOR_GREY);
 				}  // Speaks language
				else 
				{   
				  if (DMFI_ENABLE_LORELANG ==TRUE) //Qk: added as option
				    {
					nTest = (d20() + GetSkillRank(SKILL_LORE, oListener));
					if (nTest>20)
					   {
						SendText(oListener, TXT_TRANSLATED_LORE, FALSE, COLOR_GREY);
						SendText(oListener, GetName(oSpeaker) + PRM_ + TXT_TRANSLATED + sLang + PRM_ + sTranslate, FALSE, COLOR_GREY);
					   }
					}
				}		
            }
		}
		oListener = GetNextPC();
    }
}

//void main()  {}