//::///////////////////////////////////////////////
//:: ComeAndSee Count Spells
//:: Purpose: Counts how many spells a wizard knows
//:: Created By: ComeAndSee - based on work by Rasael (Baldurs Gate)
//:://////////////////////////////////////////////

#include "nwnx_sql"
#include "ps_inc_achievements"

void CheckSpells(int iSorceror, object oPC);
int GetSpellCount(object oPC);
int CountSpellsSQL(object oPC);
int GetClassPosition(object oPC);

void UpdateSpellListing(object oPC, int iKnown)
{
   	string name = SQLEncodeSpecialChars(GetName(oPC));
   	string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));

   	string sQuery = "INSERT INTO `spellids_count` VALUES ('"+name+"','"+act+"','"+IntToString(iKnown)+"') on DUPLICATE KEY UPDATE `count`='"+IntToString(iKnown)+"';";
   	SQLExecDirect(sQuery);
   
   	SendMessageToPC(oPC,"Spellbook: You know "+IntToString(iKnown )+" spells! (wizard)");
}

void RemoveSpells(object oPC, int iKnown)
{
   	int iRemove = iKnown - 250;

   	if(iRemove == 0) 
		return;
         
   	int iCount;  
   	int ClassPosition = GetClassPosition(oPC);
	
   	if (ClassPosition == 255) 
		return;
   
   	SQLExecDirect("SELECT `spellid` FROM `spellids`;");
   
   	while(SQLFetch())
   	{
   		if(iCount == iRemove) 
			break;
   
   		int iSpell = StringToInt(SQLGetData(1));
   
   		if(GetSpellKnown(oPC, iSpell))
   		{
   			SetSpellKnown(oPC, ClassPosition, iSpell, FALSE, TRUE);
   			SendMessageToPC(oPC,"Spell-Book: Removed spell id - "+IntToString(iSpell));
   			iCount++;
   		}
   	}
	
	DelayCommand(1.0f, AddAchievement(oPC, 46));
   
   	UpdateSpellListing(oPC, iKnown - (iKnown - 250));   
}

void CountSpells(object oPC, int adjust)
{
   	//Adjust: 0 = Login, 1 = LevelUp

   	if(GetLevelByClass(CLASS_TYPE_WIZARD, oPC) > 0)
   	{
   		int SpellCount = GetSpellCount(oPC);
   
   		if (SpellCount == 0 && adjust == 0 || adjust == 1)
   		{   
   			SendMessageToPC(oPC, "Spell-Book: Counting spells, this may take a moment.");
   
   			int iKnown = CountSpellsSQL(oPC);
   
   			if (iKnown > 245) SendMessageToPC(oPC, "Spell-Book: You know 245 spells or more, if you reach 250 spells known your spellbook will be randomly trimmed");
   
   			if (iKnown > 250)
   			{
   				SendMessageToPC(oPC, "Spell-Book: Rules violation, you know 250 spells or more. The amount known will now be reduced."); 
   				RemoveSpells(oPC, iKnown);
   				return;
  		 	}
   
			UpdateSpellListing(oPC, iKnown);
   		}
   	}
   
}

void OnSeverLoadPopulateSpellSQL()
{
   	int iCount; int iMax = 2689; string sClass;

   	while(iMax > iCount)
   	{	   
      		sClass = Get2DAString("spells", "Wiz_Sorc", iCount);
      		if(sClass != "") SQLExecDirect("INSERT IGNORE INTO `spellids` VALUES ('"+IntToString(iCount)+"');");
      		iCount++;
   	}
}

int GetClassPosition(object oPC)
{
   	int iSlotNumber; int iClass;
   
   	for (iSlotNumber = 1; iSlotNumber <= 4; iSlotNumber++) 
   	{
     	 	iClass = GetClassByPosition( iSlotNumber, oPC);
      
      		if ( iClass == 255 )
         		break;
         
      		if(iClass == CLASS_TYPE_WIZARD)   
      		{
      			return iSlotNumber - 1;
      			break;
      		}
   	}
   
   	return 255;
}

int GetSpellCount(object oPC)
{
   	string name = SQLEncodeSpecialChars(GetName(oPC));
   	string act = SQLEncodeSpecialChars(GetPCPlayerName(oPC));

   	SQLExecDirect("SELECT `count` FROM `spellids_count` WHERE `name`='"+name+"' AND `act`='"+act+"';");
   	SQLFetch();
   
   	return StringToInt(SQLGetData(1));
}

int CountSpellsSQL(object oPC)
{
   	int iKnown = 0;

   	SQLExecDirect("SELECT `spellid` FROM `spellids`;");
   
   	while(SQLFetch())
   	{
   		int iSpell = StringToInt(SQLGetData(1));
   	
   		if(GetSpellKnown(oPC, iSpell)) 
			iKnown++;
   	}
   
   	return iKnown++;   
}