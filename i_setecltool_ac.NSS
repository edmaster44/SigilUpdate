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

void SetECL(object oPC, object oTarget, string nECL)
{
   object oItem = GetItemPossessedBy(oTarget,"ps_essence");
   if(GetIsObjectValid(oItem))
   {
//SendMessageToPC(GetFirstPC(), "setting on essence"+nECL);   
		//SpeakString(GetLocalString(oItem,"ECL"));
		SetLocalString(oItem,"ECL",nECL);
		SetLocalString(oTarget,"ECL",nECL);
		SetLocalString(oItem, "ECL_Manual",nECL);
		//SpeakString("ECL" + nECL,TALKVOLUME_SHOUT);
		
		SQLExecDirect("INSERT INTO logging (account,name,event,type) VALUES ('" + GetPCPlayerName(oPC) + "','" + GetName(oPC) + "','ECL " + nECL + " given to " + GetName(oTarget) + " (" + GetPCPlayerName(oTarget) + ")',102)");

		return;
   }
}

void main()
{
    object oPC      = GetItemActivator();
    object oItem    = GetItemActivated();
    object oTarget  = GetItemActivatedTarget();
    location lTarget = GetItemActivatedTargetLocation();

	//The PC will technically start a conversation with himself
	//You should add some odd little sound to the first line in the
	//conversation file, or the PC will give his normal voicegreeting.

	if(!GetIsDM(oPC))
	{
		return;
	}
	
	if(oPC == oTarget)
	{ //select ECL
//SendMessageToPC(GetFirstPC(), "setting ecl on self");
		AssignCommand(oPC, ActionStartConversation(oPC, "ps_conv_set_ecl_player", FALSE, FALSE, FALSE, TRUE));
	}
	else
	{ //set target ECL
//SendMessageToPC(GetFirstPC(), "setting ecl on player" + GetLocalString(oItem, "ECL"));
		SetECL(oPC, oTarget, GetLocalString(oItem, "ECL"));
	}
}