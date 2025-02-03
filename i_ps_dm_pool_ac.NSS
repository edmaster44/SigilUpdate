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
#include "nwnx_sql"
#include "ps_inc_functions"

void main()
{
	object oPC      = GetItemActivator();
	if(!GetIsDM(oPC))
	{
		return;
	}
	
    object oTarget = GetItemActivatedTarget();

	object oItem = GetItemPossessedBy(oTarget,"ps_essence");
    if(GetIsObjectValid(oItem))
    {
	 	int nID = GetLocalInt(oItem,"ID");
		string sECL = GetLocalString(oItem,"ECL");
		int nDMpool = 0;
		
		SQLExecDirect("SELECT dm_pool FROM characterdata WHERE id="+IntToString(nID));
		while (SQLFetch() != SQL_ERROR) { 
			nDMpool = StringToInt(SQLGetData(1));
		}	
		
		int nXPbonus = FloatToInt(1000.0 * PS_GetXPModifier(StringToInt(sECL)));
		nDMpool += nXPbonus;
		
		SQLExecDirect("UPDATE characterdata SET dm_pool=" + IntToString(nDMpool) + " WHERE id="+IntToString(nID));
		
		SendMessageToPC(oPC,"Character " + GetName(oTarget) + " is awarded " + IntToString(nXPbonus) + " to daily pool (adjusted for ECL if necessary), total is now: " + IntToString(nDMpool));
		
		SQLExecDirect("INSERT INTO logging (account,name,event,type) VALUES ('" + GetPCPlayerName(oPC) + "','" + GetName(oPC) + "','Daily pool increase given to " + GetName(oTarget) + " (" + GetPCPlayerName(oTarget) + ")',101)");
		
		return;
     }
}