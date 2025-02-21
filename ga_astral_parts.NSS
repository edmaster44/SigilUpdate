// Created by Agony_Aunt for SCoD server

#include "nw_i0_plot"
#include "ps_inc_functions"

// Script is used by both Ghyris and the Rakashka for removing the quest items and rewarding
// iRewarder should be 1 if it is Ghyris who will give gold and 2 for Rakashka who will give XP.
void main (int iRewarder)
{
 	int iTotalItems;
	int iAmount;
    object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	int iLevel = GetTotalLevels(oPC, FALSE);
	string sItemTag = "astral_quest_obj";
	int iLoreMod = GetSkillRank(SKILL_LORE, oPC, FALSE);
	if (iLoreMod < 1) iLoreMod = 1;
	int iAppraiseMod = GetSkillRank(SKILL_APPRAISE, oPC, FALSE);
	if (iAppraiseMod < 1) iAppraiseMod = 1;
	
    iTotalItems = GetNumItems(oPC, sItemTag);
	TakeNumItems(oPC, sItemTag, iTotalItems);
	
	if (iRewarder == 1)
	{
		iAmount = (31 - iLevel) * iAppraiseMod * iTotalItems;
		GiveGoldToCreature(oPC, iAmount, TRUE);
	}
	else if (iRewarder == 2)
	{
		iAmount = (31 - iLevel) * iLoreMod * iTotalItems;
		if (ALLOW_ECL_LEVEL_30 && !TAX_ASTRAL_FOR_ECL)
			GiveXPToCreature(oPC, iAmount);
		else PS_GiveXPReward(oPC, iAmount);
	}
	else
	{
		// not a valid option, do nothing
	}
}