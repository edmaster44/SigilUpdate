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
    object oPC      = GetItemActivator();
    object oItem    = GetItemActivated();
    object oTarget  = GetItemActivatedTarget();
    location lTarget = GetItemActivatedTargetLocation();

	//The PC will technically start a conversation with himself
	//You should add some odd little sound to the first line in the
	//conversation file, or the PC will give his normal voicegreeting.

	//AssignCommand(oPC, ActionStartConversation(oPC, "ps_conv_set_ecl_deleteme", FALSE, FALSE, TRUE, FALSE));
	AssignCommand(oPC, ActionStartConversation(oPC, "ps_conv_racetemplate", TRUE, FALSE, TRUE, FALSE));
}