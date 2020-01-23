//
/*
   Template for an Activate item script.
   This script will run each time an item's "custom activation" is used.
   
   How to use this script:
   Item needs an item property that will cause a custom activation such as Cast Spell:Unique Power
   
*/

#include "ps_inc_training" 

void main()
{
    object oPC      = GetItemActivator();
    object oItem    = GetItemActivated();
	
	if (GetLocalInt(oPC, "STRANGE_BADGE") > 0) {
		SendMessageToPC(oPC, "You are unable to place the faction this badge belongs to.");
		return;
	}
	
	if (GetIsTrainingSkillSuccessful(oPC, SKILL_LORE, 15)) {
	
		string sResult = "This badge has the distinctive sword of the Harmonium Sigil superimposed on the crescent blades of the Athar symbol. You are certain you've never seen this combination before, especially considering the famous animosity between the two factions.\n\n//OOC: Now that the badge has been identified, using this item does nothing.";
		SendMessageToPC(oPC, sResult);
		SetDescription(oItem, sResult);
		SetTag(oItem, "mirror_atharbadge");
	
	} else {
		SendMessageToPC(oPC, "You are unable to place the faction this badge belongs to.");
	}
	
	SetLocalInt(oPC, "STRANGE_BADGE", 1);
	
}