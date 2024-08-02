//requires ps_inc_functions, included in ps_inc_training
#include "ps_inc_training"
#include "nw_i0_plot"
// 1 = break
// 2 = fix
// 3 = loot
// 4 = loot no roll
// 5 = take quest items, give reward

//generates a quest or crafting item
//or cogs
void GenerateTreasure(object oPC) {
	
	int nRand = d100();
	
	if (nRand <= 8) {
		
		SendMessageToPC(oPC, "You find a valuable piece of machinery which can be repurposed as a crafting component.");
		int n = Random(5)+1;
		switch(n) {
			case 1: CreateItemOnObject("ps_cfrt_ing_ab", oPC);
			case 2: CreateItemOnObject("ps_crft_neufly", oPC);
			case 3: CreateItemOnObject("ps_crft_formamb", oPC);
			case 4: CreateItemOnObject("ps_crft_reggear", oPC);
			case 5: CreateItemOnObject("ps_golem_brass", oPC);
			default: CreateItemOnObject("N2_CRFT_DIST041", oPC);
		}
		
	} else if (nRand <= 25) {
	
		SendMessageToPC(oPC, "You find a piece of machinery which has been altered by some sort of corruption.");
		CreateItemOnObject("ps_questobject_mechanus", oPC);
		int iQuestEntry = GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + "ps_quest_brokengears");
		if (iQuestEntry >= 1) {
			AddJournalQuestEntry("ps_quest_brokengears", 2, oPC, 0, 0, 0);
		}
	
	}/* else if (nRand <= 50) {
	
		SendMessageToPC(oPC, "You find a perfectly formed gear.");
		CreateItemOnObject("N2_CRFT_DIST041", oPC);
		
	}*/ else {
	
		int n = Random(3)+1;
		SendMessageToPC(oPC, "The tiny gears which make up this machine look remarkably like cog coins.");
		CreateItemOnObject("ps_miscstack_coinage-cogcoin", oPC, n);
	
	}
}

//gets a general utility item from the noob store
void GenerateStarterItem(object oPC) {

	int n = Random(17)+1;
	switch(n) {
		case 1: CreateItemOnObject("ps_container_adventurers", oPC);
		case 2: CreateItemOnObject("ps_belt_fitness", oPC);
		case 3: CreateItemOnObject("ps_breaplate_savinggrace", oPC);
		case 4: CreateItemOnObject("ps_chainshi_savinggrace", oPC);
		case 5: CreateItemOnObject("ps_cloak_positiveenergy", oPC);
		case 6: CreateItemOnObject("ps_clothes_savinggrace", oPC);
		case 7: CreateItemOnObject("ps_amulet_enduring", oPC);
		case 8: CreateItemOnObject("ps_fullplate_savinggrace", oPC);
		case 9: CreateItemOnObject("ps_helmet_clearsight", oPC);
		case 10: CreateItemOnObject("ps_padded_savinggrace", oPC);
		case 11: CreateItemOnObject("ps_gauntlet_planar", oPC);
		case 12: CreateItemOnObject("ps_ring_illusions", oPC);
		case 13: CreateItemOnObject("ps_ring_removal", oPC);
		case 14: CreateItemOnObject("ps_cloth_magicsubtlety", oPC);
		case 15: CreateItemOnObject("ps_boots_shiftysteps", oPC);
		case 16: CreateItemOnObject("ps_studded_savinggrace", oPC);
		case 17: CreateItemOnObject("ps_bracer_wardingwrists", oPC);
		default: CreateItemOnObject("ps_container_adventurers", oPC);
	}
	
}

void main (int nAction, int nDC) {

	object oPC = GetPCSpeaker();
	string sTag = GetTag(OBJECT_SELF);
	if (nAction == 1) {
		SetLocalInt(oPC, sTag+"_broken", 1);
	} else if (nAction == 2) {
		SetLocalInt(oPC, sTag+"_fixed", 1);
		
		if (d100() <= 15) {
			SendMessageToPC(oPC, "You find a piece of machinery which has been altered by some sort of corruption.");
			CreateItemOnObject("ps_questobject_mechanus", oPC);
			int iQuestEntry = GetLocalInt(oPC, "NW_JOURNAL_ENTRY" + "ps_quest_brokengears");
			if (iQuestEntry >= 1) {
				AddJournalQuestEntry("ps_quest_brokengears", 2, oPC, 0, 0, 0);
			}
		
		} else {
			GenerateTreasure(oPC);
		}
	} else if (nAction == 3) {
		if (GetIsTrainingSkillSuccessful(oPC, SKILL_DISABLE_TRAP, nDC)) {
			GenerateTreasure(oPC);
		} else {
			SendMessageToPC(oPC, "You are not able to scavenge anything interesting.");
		}
		SetLocalInt(oPC, sTag+"_broken", 1);
	} else if (nAction == 4) {
	
		GenerateTreasure(oPC);
		SetLocalInt(oPC, sTag+"_broken", 1);
		
	} else if (nAction == 5) {
	
		AddJournalQuestEntry("ps_quest_brokengears", 3, oPC, 0, 0, 0);
		
		int nTotalItem = GetNumItems( oPC, "ps_questobject_mechanus" );
		TakeNumItems(oPC, "ps_questobject_mechanus", nTotalItem);
		
		int xp_reward = 35;
		int gold_reward = 120;
		int xp = xp_reward*nTotalItem;
		PS_GiveXPReward(oPC, xp);
		if (nTotalItem >= 4) {
			GenerateStarterItem(oPC);
		} else {
			int nGold = gold_reward*nTotalItem;
			GiveGoldToCreature(oPC, nGold);
		}
		
	}

}