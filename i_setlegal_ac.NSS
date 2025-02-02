#include "nwnx_sql"

//
/*
   Template for an Activate item script.
   This script will run each time an item's "custom activation" is used.
   
   How to use this script:
   Item needs an item property that will cause a custom activation such as Cast Spell:Unique Power
   Replace the word "temp" (in line 1) with the tag of the item.  Rename the script with this name.  
    
   Additional Info:
   In general, all the item "tag-based" scripts will be named as follows:
   - a prefix ("i_" by defualt)
   - the tag of the item
   - a postfix indicating the item event.
   
   This script will be called automatically (by defualt) whether it exists or not.  If if does not exist, nothing happens.
   
   Note: this script runs on the module object, an important consideration for assigning actions.
      -ChazM
*/
// Name_Date

#include "x2_inc_spellhook" 

void main()
{
//SendMessageToPC(GetFirstPC(), "setlegal start");
	object oPC      = GetItemActivator();
	if(!GetIsDM(oPC))
	{
		return;
	}
	
    object oTarget = GetItemActivatedTarget();

	object oItem = GetItemPossessedBy(oTarget,"ps_essence");
    if(GetIsObjectValid(oItem))
    {
//SendMessageToPC(GetFirstPC(), "has essence "+PS_GetLocalString(oItem,"LEGAL"));
	 	string sLegal = PS_GetLocalString(oItem,"LEGAL");

		if(sLegal == "TRUE")
		{
//SendMessageToPC(GetFirstPC(), "setting to false");		
			SendMessageToPC(oPC,"Character " + GetName(oTarget) + " is now no longer legal");
			PS_SetLocalString(oItem,"LEGAL","");
			SQLExecDirect("INSERT INTO logging (account,name,event,type) VALUES ('" + 
				SQLEncodeSpecialChars(GetPCPlayerName(oPC)) + "','" + 
				SQLEncodeSpecialChars(GetName(oPC)) + "','Following character set to be NO LONGER LEGAL: " + 
				SQLEncodeSpecialChars(GetName(oTarget)) + " (" + 
				SQLEncodeSpecialChars(GetPCPlayerName(oTarget)) + ")',104)");
		}
		else
		{
//SendMessageToPC(GetFirstPC(), "setting to true");		
			SendMessageToPC(oPC,"Character " + GetName(oTarget) + " is set legal");
			PS_SetLocalString(oItem,"LEGAL","TRUE");
			SQLExecDirect("INSERT INTO logging (account,name,event,type) VALUES ('" + 
				SQLEncodeSpecialChars(GetPCPlayerName(oPC)) + "','" + 
				SQLEncodeSpecialChars(GetName(oPC)) + "','Following character set to LEGAL: " + 
				SQLEncodeSpecialChars(GetName(oTarget)) + " (" + 
				SQLEncodeSpecialChars(GetPCPlayerName(oTarget)) + ")',103)");
		}
		
		return;
     }
}