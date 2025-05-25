// Advanced scry script for SCoD by Agony_Aunt

#include "ps_inc_functions"

const int DISPLIST = 1;
const int SETDISPLEVEL = 2;
const int SETDISPBUILD = 3;
const int SETDISPLOC = 4;
const int SETDISPPREF = 5;
const int SETDISPALL = 6;
const int SETDISPNONE = 7;

const string SCRYLEVEL = "ADVSCRYLEVEL";
const string SCRYBUILD = "ADVSCRYBUILD";
const string SCRYLOCATION = "ADVSCRYLOCATION";
const string SCRYPREF = "ADVSCRYPREF"; //can list interest from predefined options

const int SCRYPREFNOTHING = 0;
const int SCRYPREFGRIND = 1;
const int SCRYPREFRP = 2;
const int SCRYPREFGANDRP = 3;
const int SCRYPREFOTHER = 4;
const int SCRYPREFANY = 5;

//AFK notification
int GetIsAFK(object oPC)
{
	int iFound=FALSE;
	effect eFirst = GetFirstEffect(oPC);
   
   	while (GetIsEffectValid(eFirst))
	{
		if (GetEffectSpellId(eFirst) == -999) // apparently -999 is AFK....
	    {
			iFound = TRUE;
		}
	 	eFirst = GetNextEffect(oPC);	 
	}
	
	return iFound;
}

void DisplayScryRow(object oCaller, object oPC, string sLevel, string sBuild, string sLoc, string sPref, int iTotallySecret)
{
	int iAFK = GetIsAFK(oPC);
	
	string sMessage = "<b><color=gold>" + GetName(oPC) + "</b></color>";
	
	if (iAFK == TRUE)
		sMessage += " <b><color=red>(AFK)</color></b>";
	
	if (iTotallySecret == TRUE)
	{
		sMessage += " <i>No details shared</i>";
		sMessage = "<color=gray>" + sMessage + "</color>";
	}
	else
	{
		sMessage +=	" Level: " + sLevel + " Build: " + sBuild + " Location: " + sLoc + " Prefers: " + sPref;
	}
	
		
	SendMessageToPC(oCaller, sMessage);
}

string GetClassName(int iClass)
{
	string sTLK = Get2DAString("classes", "Name", iClass);
	sTLK = GetStringByStrRef(StringToInt(sTLK));
	return sTLK;
}

string GetClassString(object oPC, int iPos)
{
	string sClass;
	int iLevel;
	
	int iClass = GetClassByPosition(iPos, oPC);
	
	if (iClass != CLASS_TYPE_INVALID)
	{
		sClass = GetClassName(iClass);
		iLevel = GetLevelByClass(iClass, oPC);
		sClass = sClass + "(" + IntToString(iLevel) + ")";
	}
	else
	{
		sClass = "";
	}

	return sClass;
}

void GenerateScryRow(object oCaller, object oPC)
{
	object oEssence = GetItemPossessedBy(oPC,"ps_essence");
	int iDispLevel = GetLocalInt(oEssence,SCRYLEVEL); 
	int iDispBuild = GetLocalInt(oEssence,SCRYBUILD); 
	int iDispLoc = GetLocalInt(oEssence,SCRYLOCATION);
	int iDispPref = GetLocalInt(oEssence,SCRYPREF);
	object oArea;
	string sLevel;
	string sBuild;
	string sLoc;
	string sPref;
	int iTotallySecret;
	
	if (iDispLevel == 0 && iDispBuild == 0 && iDispLoc == 0 && iDispPref == 0)
	{
		iTotallySecret = TRUE;
	}
	
	if (iDispLevel == 1)
		sLevel = IntToString(GetHitDice(oPC)) + " (" + IntToString(PS_GetLevel(oPC)) + ")";
	else
		sLevel = "? (?)";
		
	if (iDispBuild == 1)
	{
		string sTemp;
		sBuild = GetClassString(oPC, 1);
		sTemp = GetClassString(oPC, 2);
		if (sTemp != "")
		{
			sBuild += "/" + sTemp;
			sTemp = GetClassString(oPC, 3);
			if (sTemp != "")
			{
				sBuild += "/" + sTemp;
				sTemp = GetClassString(oPC, 4);
				if (sTemp != "")
				{
					sBuild += "/" + sTemp;
				}
			}
		}
	}	
	else
		sBuild = "Build Secret";
		
	if (iDispLoc == 1)
	{
		oArea = GetArea(oPC);
		if (GetIsObjectValid(oArea))
			sLoc = GetName(oArea);
		else
			sLoc = "In Transition";
	}
	else
		sLoc = "Location unknown";
		
	switch(iDispPref)
	{
		case SCRYPREFNOTHING: sPref = "No preference set"; break;
		case SCRYPREFGRIND: sPref = "Prefers to grind"; break;
		case SCRYPREFRP: sPref = "Prefers to Roleplay"; break;
		case SCRYPREFGANDRP: sPref = "Either RP or Grind, both good"; break;
		case SCRYPREFOTHER: sPref = "Likes alternative playstyles"; break;
		case SCRYPREFANY: sPref = "RP, grind, or other, its all good!!"; break;
		default: break;
	}

	DisplayScryRow(oCaller, oPC, sLevel, sBuild, sLoc, sPref, iTotallySecret);
}

void DisplayAdvancedScry(object oCaller)
{
	object oPC = GetFirstPC();
	while (GetIsObjectValid(oPC))
   	{
   		GenerateScryRow(oCaller, oPC);
		
		oPC = GetNextPC();
 	}
}

//acts as both listing function and for setting vars
// function is: 1 = display list, 2 = set level pref, 3 = build pref, 4 location, 5 pref.
// iVar is simply 1 or 0 to state whether it should be set except for pref which is
//  1=grinding, 2=roleplay, 3=Grinding and/or RP, 4=Other (eg: for ERP), 5=anything
void main(int iFunction, int iVar)
{
	object oPC = GetPCSpeaker();
	object oEssence = GetItemPossessedBy(oPC,"ps_essence");

	switch(iFunction)
	{
		// set time vars
		case DISPLIST: DisplayAdvancedScry(oPC); break;
		case SETDISPLEVEL: SetLocalInt(oEssence,SCRYLEVEL, iVar); break;
		case SETDISPBUILD: SetLocalInt(oEssence,SCRYBUILD, iVar); break;
		case SETDISPLOC: SetLocalInt(oEssence,SCRYLOCATION, iVar); break;
		case SETDISPPREF: SetLocalInt(oEssence,SCRYPREF, iVar); break;
		case SETDISPALL:
			{
				SetLocalInt(oEssence,SCRYLEVEL, 1); 
				SetLocalInt(oEssence,SCRYBUILD, 1);
				SetLocalInt(oEssence,SCRYLOCATION, 1);
				SetLocalInt(oEssence,SCRYPREF, 5); // anything
			}
			break;
		case SETDISPNONE:
			{
				SetLocalInt(oEssence,SCRYLEVEL, 0); 
				SetLocalInt(oEssence,SCRYBUILD, 0);
				SetLocalInt(oEssence,SCRYLOCATION, 0);
				SetLocalInt(oEssence,SCRYPREF, 0); // anything
			}
			break;
		default: break; 
	}
}