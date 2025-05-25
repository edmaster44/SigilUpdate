

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
	
	string sItemType = GetLocalString(oItem, "RuinedItem_Type");
	
	if (GetLocalInt(oPC, "RUINED_ARMOR") > 0) {
		SendMessageToPC(oPC, "You can discern nothing more about this bit of scrap metal.");
		return;
	}
	
	int nWeaponRank = GetSkillRank(SKILL_CRAFT_WEAPON, oPC);
	int nArmorRank = GetSkillRank(SKILL_CRAFT_ARMOR, oPC); 
	int nSpotRank = GetSkillRank(SKILL_SPOT, oPC); 
	int nLoreRank = GetSkillRank(SKILL_LORE, oPC); 
	
	int nSkill = SKILL_SPOT;
	if (sItemType == "Armor" || sItemType == "Shield") {
		if (nArmorRank > nSpotRank) {
			nSkill = SKILL_CRAFT_ARMOR;
		} else {
			nSkill = SKILL_SPOT;
		}
	} else if (sItemType == "Sword") {
		if (nWeaponRank > nSpotRank) {
			nSkill = SKILL_CRAFT_WEAPON;
		} else {
			nSkill = SKILL_SPOT;
		}
	} else {
		if (nLoreRank > nSpotRank) {
			nSkill = SKILL_LORE;
		} else {
			nSkill = SKILL_SPOT;
		}
	}
	
	if (GetIsTrainingSkillSuccessful(oPC, nSkill, 20)) {
	
		int nRand = d100();
		string sResult;
		if (nSkill == SKILL_CRAFT_ARMOR || nSkill == SKILL_CRAFT_WEAPON) {
			sResult = "This ruined "+sItemType+" looks like it went through something's digestive system or sat in a puddle too long. . or both. But you recognize its make to be Orthan.";
		
			sResult += "$$Ortho is the prime world where the Harmonium as a faction are said to have originated, and it is the center of their empire on the Primes. The Harmonium faction in Sigil recently broke with their Prime counterparts.";
			sResult += "$$Aside from evidence that someone from Ortho has been here at some point, this "+sItemType+" is only good for scrap metal now.";	
		} else if (nSkill == SKILL_LORE) {
			sResult = "You are able to make out a small symbol on this old and ruined "+sItemType+", which you recognize to be that of the Orthan Empire.";
				
			sResult += "$$Ortho is the prime world where the Harmonium as a faction are said to have originated, and it is the center of their empire on the Primes. The Harmonium faction in Sigil recently broke with their Prime counterparts.";
			sResult += "$$Aside from evidence that someone from Ortho has been here at some point, this "+sItemType+" is only good for scrap metal now.";
		} else {
			sResult = "You are able to make out a small symbol on this old and ruined "+sItemType+" which looks vaguely like that of the Harmonium to you.";
			sResult += "$$Aside from being a novelty, this "+sItemType+" is only good for scrap metal now.";
		}
		
		SendMessageToPC(oPC, sResult);
		SetDescription(oItem, sResult);
		SetTag(oItem, "foae_identified");
	
	} else {
		SendMessageToPC(oPC, "You can discern nothing about this bit of scrap metal.");
	}
	
	SetLocalInt(oPC, "RUINED_ARMOR", 1);
	
}