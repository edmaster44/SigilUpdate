//Contains the epic quest pools for the moment
//Should move to database later; purely here for ease of access
//
//There are three epic level treasure pools of pre-made items
//replace / fill as appropriate for quest rewards; meant to give some
//randomness to end-game quests
//
//Mimi Fearthegn
//6/18/19

string PickFromQuestTreasureLow();
string PickFromQuestTreasureMed();
string PickFromQuestTreasureHigh();

//The "essential item" pool - it only contains "most needed items" by level range
//AC items mostly; returns an electrifier as the default
//nCR = the ideal PC's level (under 5, under 10, etc)
string PickEssentialItemReward(int nCR) {

	if (nCR < 5) {
	
		int nRand = Random(17)+1;
		switch(nRand) {
			case 1: return "nw_it_mneck001"; //natural armor +1
			case 2: return "nw_it_mneck001"; //natural armor +1
			case 3: return "nw_it_mneck012"; //natural armor +2
			case 4: return "ps_adventurer_boots1"; //dodge boots +1
			case 5: return "ps_adventurer_boots1"; //dodge boots +1
			case 6: return "nx2_cloat_prot_01"; //deflection cloak +1
			case 7: return "nx2_cloak_prot_02"; //deflection cloak +2
			case 8: return "nx2_ring_prot_01"; //deflection ring +1
			case 9: return "nx2_ring_prot_02"; //deflection ring +2
			case 10: return "ps_universal_coldironsword"; //cold iron sword
			case 11: return "ps_universal_silversword"; //silver sword
			case 12: return "it_quest_inviscloak"; //cloak of invisibility
			case 13: return "nw_it_mbracer002"; //bracers +1
			case 14: return "ps_ring_acidresistancelesser"; //lesser ring of resistance
			case 15: return "ps_ring_fireresistancelesser"; //lesser ring of resistance
			case 16: return "ps_torch_warding"; //magic torch
			case 17: return "ps_torch_shielding"; //magic torch
		}
		
	} else if (nCR < 10) {
	
		int nRand = Random(16)+1;
		switch(nRand) {
			case 1: return "nw_it_mneck012"; //natural armor +2
			case 2: return "nw_it_mneck013"; //natural armor +3
			case 3: return "nw_it_mneck013"; //natural armor +3
			case 4: return "ps_adventurer_boots2"; //dodge boots +2
			case 5: return "ps_adventurer_boots2"; //dodge boots +2
			case 6: return "nx2_cloat_prot_03"; //deflection cloak +3
			case 7: return "nx2_ring_prot_03"; //deflection ring +3
			case 8: return "ps_universal_coldironsword"; //cold iron sword
			case 9: return "ps_universal_silversword"; //silver sword
			case 10: return "it_quest_inviscloak"; //cloak of invisibility
			case 11: return "ps_misc_magicelectrifier"; //electrifier
			case 12: return "nw_it_mbracer007"; //bracers +2
			case 13: return "nw_it_mbracer008"; //bracers +3
			case 14: return "ps_ring_energyresist"; //ring of resistance
			case 15: return "ps_torch_warding"; //magic torch
			case 16: return "ps_torch_shielding"; //magic torch
		}
	} else if (nCR < 15) {
	
		int nRand = Random(21)+1;
		switch(nRand) {
			case 1: return "nw_it_mneck014"; //natural armor +4
			case 2: return "nw_it_mneck014"; //natural armor +4
			case 3: return "nw_it_mneck015"; //natural armor +5
			case 4: return "nx2_boots_hardy_02"; //hardiness +2
			case 5: return "nx2_boots_hardy_03"; //hardiness +3
			case 6: return "nx2_cloat_prot_04"; //deflection cloak +3
			case 7: return "nw_it_mring019"; //deflection ring +4
			case 8: return "nw_it_mring020"; //deflection ring +5
			case 9: return "ps_misc_magicelectrifier"; //electrifier
			case 10: return "nw_it_mbracer009"; //bracers +4
			case 11: return "nw_it_mbracer010"; //bracers +5
			case 12: return "nx2_ring_fres_major"; //fire resistance
			case 13: return "nx2_ring_eres_major"; //electrical resistance
			case 14: return "nx2_ring_cres_major"; //cold resistance
			case 15: return "nx2_ring_ares_major"; //acid resistance
			case 16: return "nx2_cloak_resist_03"; //resist cloak +3
			case 17: return "nx2_cloak_resist_04"; //resist cloak +4
			case 18: return "nx2_glove_dex_02"; //gloves of dex +2
			case 19: return "nx2_glove_dex_04"; //gloves of dex +4
			case 20: return "nx2_belt_str_02"; //belt of strength +2
			case 21: return "nx2_belt_str_04"; //belt of strength +4
		}
	} else if (nCR < 20) {
	
		int nRand = Random(23)+1;
		switch(nRand) {
			case 1: return "nw_it_mneck015"; //natural armor +5
			case 2: return "nw_it_mneck015"; //natural armor +5
			case 3: return "nx2_boots_hardy_03"; //hardiness +3
			case 4: return "nx2_boots_hardy_04"; //hardiness +4
			case 5: return "nx2_cloat_prot_05"; //deflection cloak +5
			case 6: return "nw_it_mring020"; //deflection ring +5
			case 7: return "ps_misc_magicelectrifier"; //electrifier
			case 8: return "nw_it_mbracer010"; //bracers +5
			case 9: return "nx2_ring_fres_major"; //fire resistance
			case 10: return "nx2_ring_eres_major"; //electrical resistance
			case 11: return "nx2_ring_cres_major"; //cold resistance
			case 12: return "nx2_ring_ares_major"; //acid resistance
			case 13: return "nx2_cloak_resist_04"; //resist cloak +4
			case 14: return "nx2_glove_dex_04"; //gloves of dex +4
			case 15: return "nx2_belt_str_04"; //belt of strength +4
			case 16: return "nx2_neck_wis_04"; //amulet of wisdom +4
			case 17: return "nx2_helm_int_04"; //headband of intellect +4
			case 18: return "nx2_cloak_cha_04"; //cloak of charisma +4
			case 19: return "ps_randomitem_token20"; //gambling ticket level 20
			case 20: return "ps_gad_trinket_shield"; //trinket
			case 21: return "ps_gad_trinket_restoration"; //trinket
			case 22: return "ps_gad_trinket_protfromalign"; //trinket
			case 23: return "ps_gad_trinket_deathward"; //trinket
		}
	} else {
	
		int nRand = Random(26)+1;
		switch(nRand) {
			case 1: return "nw_it_mneck015"; //natural armor +5
			case 2: return "nw_it_mneck015"; //natural armor +5
			case 3: return "nx2_boots_hardy_04"; //hardiness +4
			case 4: return "nx2_boots_hardy_04"; //hardiness +4
			case 5: return "nx2_cloat_prot_05"; //deflection cloak +5
			case 6: return "nw_it_mring020"; //deflection ring +5
			case 7: return "ps_misc_magicelectrifier"; //electrifier
			case 8: return "nw_it_mbracer010"; //bracers +5
			case 9: return "nx2_ring_fres_major"; //fire resistance
			case 10: return "nx2_ring_eres_major"; //electrical resistance
			case 11: return "nx2_ring_cres_major"; //cold resistance
			case 12: return "nx2_ring_ares_major"; //acid resistance
			case 13: return "nx2_cloak_resist_05"; //resist cloak +5
			case 14: return "nx2_glove_dex_06"; //gloves of dex +5
			case 15: return "nw_it_mbelt008"; //belt of strength +5
			case 16: return "nw_it_mneck011"; //amulet of wisdom +5
			case 17: return "nx2_helm_int_06"; //headband of intellect +5
			case 18: return "nx2_cloak_cha_06"; //cloak of charisma +5
			case 19: return "ps_randomitem_token30"; //gambling ticket level 30
			case 20: return "ps_misc_shapersdecensor"; //shapers decensor
			case 21: return "ps_misc_shapersalembic"; //shapers alembic
			case 22: return "ps_misc_shapersretort"; //shapers retort
			case 23: return "ps_gad_trinket_shield"; //trinket
			case 24: return "ps_gad_trinket_restoration"; //trinket
			case 25: return "ps_gad_trinket_protfromalign"; //trinket
			case 26: return "ps_gad_trinket_deathward"; //trinket
		}
	}
	
	return "ps_misc_magicelectrifier";

}

//picks out item from the treasure pools
//nPool can equal
//TREASURE_QUEST_LOW
//TREASURE_QUEST_MED
//TREASURE_QUEST_HIGH
string PickEpicLevelReward(int nPool) {

	switch(nPool) {
		case 5: return PickFromQuestTreasureLow(); break;
		case 6: return PickFromQuestTreasureMed(); break;
		case 7: return PickFromQuestTreasureHigh(); break;
	}

	return PickFromQuestTreasureLow();
}

//Epic Treasure Pool (low)
//Replace / modify list as needed
string PickFromQuestTreasureLow() {

	int numOfItems = 160; //number of items in the list below
	
	switch(Random(numOfItems)+1) {
	
		case 1: return "nw_maarcl0370";
		case 2: return "ed_belt_coolness";
		case 3: return "ed_cool_dagger";
		case 4: return "ed_toothpick";
		case 5: return "ed_shield_dark";
		case 6: return "ps_amor_bitolarry";
		case 7: return "ps_luca_amulet_carvedbones";
		case 8: return "ps_luca_frozentearofcania";
		case 9: return "ps_luca_hollybranch";
		case 10: return "ps_luca_holysymboloffaith";
		case 11: return "ps_luca_holysymbolofthehealer";
		case 12: return "ps_amulet_obsidian";
		case 13: return "ps_amulet_sensate";
		case 14: return "ps_luca_spiritedsymbol";
		case 15: return "ps_luca_stalkerscompass";
		case 16: return "ps_amulet_stinger";
		case 17: return "ps_amulet_weakness";
		case 18: return "ps_armor_blessingofshar";
		case 19: return "ps_armor_illusaryadventurer";
		case 20: return "ps_gad_dreadaxe2";
		case 21: return "ps_armor_nasty";
		case 22: return "ps_armor_otyugh";
		case 23: return "ps_armor_sequencer";
		case 24: return "ps_luca_twicecursedarmor";
		case 25: return "ps_bass_dflam";
		case 26: return "ps_luca_bitter_cold";
		case 27: return "ps_luca_belt_bardstrap";
		case 28: return "ps_luca_coilofendurence";
		case 29: return "ps_luca_belt_medicssatchel";
		case 30: return "ps_book_acook";
		case 31: return "ps_book_iggwilv";
		case 32: return "ps_luca_corruptionofblood";
		case 33: return "ps_luca_corruptionofblood_sorc";
		case 34: return "ps_luca_corruptionofthefavored";
		case 35: return "ps_luca_corruptionoftheland";
		case 36: return "ps_luca_corruptionofthemind";
		case 37: return "ps_luca_corruptionofthespirit";
		case 38: return "ps_luca_boot_silencesoles";
		case 39: return "ps_luca_talonsofthehamatula";
		case 40: return "ps_bow_guardian";
		case 41: return "ps_bplate_aot";
		case 42: return "ps_bracer_kaleido";
		case 43: return "ps_bracer_magus1";
		case 44: return "ps_luca_glovesoftheshieldbuckler";
		case 45: return "ps_luca_greaterglovesoftheshield";
		case 46: return "ps_luca_cloak_ebontiger";
		case 47: return "ps_luca_werewolfcloak";
		case 48: return "ps_luca_cloth_lesser_vestcaller";
		case 49: return "ps_luca_cloth_mystictheurge";
		case 50: return "ps_luca_cloth_vestcaller";
		case 51: return "ps_club_dwand";
		case 52: return "ps_dagger_tharizdun";
		case 53: return "ps_falc_sultan";
		case 54: return "ps_fullplate_soulplate";
		case 55: return "ps_gad_ring_mountain";
		case 56: return "ps_gauntlet_onehand";
		case 57: return "ps_giantaxe_dwarven";
		case 58: return "ps_giantclub_dryad";
		case 59: return "ps_giantclub_latern";
		case 60: return "ps_giantsword_cleanser";
		case 61: return "ps_giantsword_deathbringer";
		case 62: return "ps_giantsword_defender";
		case 63: return "ps_gloves_mindcatcher";
		case 64: return "ps_helm_urpriest";
		case 65: return "ps_helmet_circle1";
		case 66: return "ps_helmet_circle2";
		case 67: return "ps_helmet_circle3";
		case 68: return "ps_luca_priceofpower";
		case 69: return "ps_luca_safetygoggles";
		case 70: return "ps_luca_icefang";
		case 71: return "ps_lcrossbow_roguesfriend";
		case 72: return "ps_luca_effervescentaura";
		case 73: return "ps_longbow_forestdefense";
		case 74: return "ps_longbow_frostvolley";
		case 75: return "ps_luca_rainbow";
		case 76: return "ps_luca_corruptionoffaith";
		case 77: return "ps_mand_bleak";
		case 78: return "ps_luca_misc_phoenixfeather";
		case 79: return "ps_mstar_spikewis";
		case 80: return "ps_qstaff_ruby";
		case 81: return "ps_luca_shatteringstorm";
		case 82: return "ps_rapier_heartbleeder";
		case 83: return "ps_rapier_levistus";
		case 84: return "ps_luca_rapier_quickening";
		case 85: return "ps_ring_ancient";
		case 86: return "ps_ring_aureon";
		case 87: return "ps_luca_ring_divinitybeckons";
		case 88: return "ps_luca_ring_heroicvalor";
		case 89: return "ps_luca_ring_lies";
		case 90: return "ps_luca_ring_reignfire";
		case 91: return "ps_luca_ring_ringmouth";
		case 92: return "ps_luca_ringoftheheirophant";
		case 93: return "ps_ring_rottd";
		case 94: return "ps_luca_ring_spiritguidance";
		case 95: return "ps_luca_starband";
		case 96: return "ps_ring_swiftp";
		case 97: return "ps_luca_robesofregeneration";
		case 98: return "ps_luca_scimitar_defenderwilds";
		case 99: return "ps_scythe_deathscold";
		case 100: return "ps_luca_shield_elemental_escutch";
		case 101: return "ps_luca_onethousandcurses";
		case 102: return "ps_luca_favorofpazuzu";
		case 103: return "ps_sickle_sheela";
		case 104: return "ps_spea_pwhim";
		case 105: return "ps_spr_valk";
		case 106: return "ps_ssword_hathor";
		case 107: return "ps_luca_staff_ancestralrecall";
		case 108: return "ps_staff_ankh";
		case 109: return "ps_luca_cat_staff";
		case 110: return "ps_staff_ling";
		case 111: return "ps_luca_holygavel";
		case 112: return "ps_luca_rukus2";
		case 113: return "ps_wham_hanvil";
		case 114: return "ps_whip_scource";
		case 115: return "ps_whip_strike3";
		case 116: return "ps_whip_willing";
		case 117: return "ps_rapier_nails";
		case 118: return "ps_falchion_brightshadow";
		case 119: return "ps_halb_caxle";
		case 120: return "ps_luca_helm_wildhunt";
		case 121: return "ps_itemset_golem5";
		case 122: return "ps_itemset_golem6";
		case 123: return "ps_itemset_golem1";
		case 124: return "ps_gsword_reaver";
		case 125: return "ps_itemset_golem8";
		case 126: return "ps_itemset_golem4";
		case 127: return "ps_itemset_golem2";
		case 128: return "ps_mstar_carmaker";
		case 129: return "ps_luca_armor_wildhunt";
		case 130: return "ps_luca_shield_wildhunt";
		case 131: return "ps_itemset_golem3";
		case 132: return "ps_staff_zakine";
		case 133: return "ps_itemset_golem7";
		case 134: return "ps_dagger_sleeperagent";
		case 135: return "ps_gad_forbidden_sun";
		case 136: return "ps_mace_cross";
		case 137: return "ps_helmet_blindsight";
		case 138: return "ps_crft_ing_au";
		case 139: return "ps_crft_plk_ao";
		case 140: return "ps_cfrt_ing_by";
		case 141: return "ps_cfrt_ing_bg";
		case 142: return "ps_cfrt_ing_tt";
		case 143: return "ps_whammer_lawslongreach";
		case 144: return "ps_gad_grandblade";
		case 145: return "ps_qstaff_philosophysolidified2";
		case 146: return "nx2_boots_hardy_05";
		case 147: return "nw_it_mring0290";
		case 148: return "ps_gauntlet_spikedknuckles";
		case 149: return "n2_pca_archer";
		case 150: return "ps_helmet_whitedragon";
		case 151: return "ps_helmet_silverdragon";
		case 152: return "ps_helmet_shadowdragon";
		case 153: return "ps_helmet_reddragon";
		case 154: return "ps_helmet_greendragon";
		case 155: return "ps_helmet_golddragon";
		case 156: return "ps_helmet_copperdragon";
		case 157: return "ps_helmet_brassdragon";
		case 158: return "ps_helmet_bluedragon";
		case 159: return "ps_helmet_blackdragon";
		case 160: return "ps_ring_fieldsergeant";
	}
	
	return "";

}

//Epic Treasure Pool (Medium)
//Replace / modify list as needed
string PickFromQuestTreasureMed() {

	int numOfItems = 177; //number of items in the list below
	
	switch(Random(numOfItems)+1) {
		case 1: return "ps_morg_item1";
		case 2: return "ps_morg_item2";
		case 3: return "ps_morg_item3";
		case 4: return "ps_morg_item4";
		case 5: return "ps_morg_item5";
		case 6: return "ps_morg_item6";
		case 7: return "nw_maarcl0370";
		case 8: return "ps_morg_item8";
		case 9: return "ps_morg_item9";
		case 10: return "ps_morg_item10";
		case 11: return "ps_morg_item11";
		case 12: return "ps_morg_item12";
		case 13: return "ps_morg_item12";
		case 14: return "ps_morg_item17";
		case 15: return "ps_morg_item18";
		case 16: return "ps_morg_item20";
		case 17: return "ps_morg_item21";
		case 18: return "ps_morg_item22";
		case 19: return "ps_morg_item23";
		case 20: return "ps_morg_item24";
		case 21: return "ps_morg_item25";
		case 22: return "ps_morg_item26";
		case 23: return "ed_belt_coolness";
		case 24: return "ed_cool_dagger";
		case 25: return "ed_toothpick";
		case 26: return "ed_shield_dark";
		case 27: return "ps_amor_bitolarry";
		case 28: return "ps_luca_amulet_carvedbones";
		case 29: return "ps_luca_frozentearofcania";
		case 30: return "ps_luca_hollybranch";
		case 31: return "ps_luca_holysymboloffaith";
		case 32: return "ps_luca_holysymbolofthehealer";
		case 33: return "ps_amulet_obsidian";
		case 34: return "ps_amulet_sensate";
		case 35: return "ps_luca_spiritedsymbol";
		case 36: return "ps_luca_stalkerscompass";
		case 37: return "ps_amulet_stinger";
		case 38: return "ps_amulet_weakness";
		case 39: return "ps_armor_blessingofshar";
		case 40: return "ps_armor_illusaryadventurer";
		case 41: return "ps_gad_dreadaxe2";
		case 42: return "ps_armor_nasty";
		case 43: return "ps_armor_otyugh";
		case 44: return "ps_armor_sequencer";
		case 45: return "ps_luca_twicecursedarmor";
		case 46: return "ps_bass_dflam";
		case 47: return "ps_luca_bitter_cold";
		case 48: return "ps_luca_belt_bardstrap";
		case 49: return "ps_luca_coilofendurence";
		case 50: return "ps_luca_belt_medicssatchel";
		case 51: return "ps_book_acook";
		case 52: return "ps_book_iggwilv";
		case 53: return "ps_luca_corruptionofblood";
		case 54: return "ps_luca_corruptionofblood_sorc";
		case 55: return "ps_luca_corruptionofthefavored";
		case 56: return "ps_luca_corruptionoftheland";
		case 57: return "ps_luca_corruptionofthemind";
		case 58: return "ps_luca_corruptionofthespirit";
		case 59: return "ps_luca_boot_silencesoles";
		case 60: return "ps_luca_talonsofthehamatula";
		case 61: return "ps_bow_guardian";
		case 62: return "ps_bplate_aot";
		case 63: return "ps_bracer_kaleido";
		case 64: return "ps_bracer_magus1";
		case 65: return "ps_luca_glovesoftheshieldbuckler";
		case 66: return "ps_luca_greaterglovesoftheshield";
		case 67: return "ps_luca_cloak_ebontiger";
		case 68: return "ps_luca_werewolfcloak";
		case 69: return "ps_luca_cloth_lesser_vestcaller";
		case 70: return "ps_luca_cloth_mystictheurge";
		case 71: return "ps_luca_cloth_vestcaller";
		case 72: return "ps_club_dwand";
		case 73: return "ps_dagger_tharizdun";
		case 74: return "ps_falc_sultan";
		case 75: return "ps_fullplate_soulplate";
		case 76: return "ps_gad_ring_mountain";
		case 77: return "ps_gauntlet_onehand";
		case 78: return "ps_giantaxe_dwarven";
		case 79: return "ps_giantclub_dryad";
		case 80: return "ps_giantclub_latern";
		case 81: return "ps_giantsword_cleanser";
		case 82: return "ps_giantsword_deathbringer";
		case 83: return "ps_giantsword_defender";
		case 84: return "ps_gloves_mindcatcher";
		case 85: return "ps_helm_urpriest";
		case 86: return "ps_helmet_circle1";
		case 87: return "ps_helmet_circle2";
		case 88: return "ps_helmet_circle3";
		case 89: return "ps_luca_priceofpower";
		case 90: return "ps_luca_safetygoggles";
		case 91: return "ps_luca_icefang";
		case 92: return "ps_lcrossbow_roguesfriend";
		case 93: return "ps_luca_effervescentaura";
		case 94: return "ps_longbow_forestdefense";
		case 95: return "ps_longbow_frostvolley";
		case 96: return "ps_luca_rainbow";
		case 97: return "ps_luca_corruptionoffaith";
		case 98: return "ps_mand_bleak";
		case 99: return "ps_luca_misc_phoenixfeather";
		case 100: return "ps_mstar_spikewis";
		case 101: return "ps_qstaff_ruby";
		case 102: return "ps_luca_shatteringstorm";
		case 103: return "ps_rapier_heartbleeder";
		case 104: return "ps_rapier_levistus";
		case 105: return "ps_luca_rapier_quickening";
		case 106: return "ps_ring_ancient";
		case 107: return "ps_ring_aureon";
		case 108: return "ps_luca_ring_divinitybeckons";
		case 109: return "ps_luca_ring_heroicvalor";
		case 110: return "ps_luca_ring_lies";
		case 111: return "ps_luca_ring_reignfire";
		case 112: return "ps_luca_ring_ringmouth";
		case 113: return "ps_luca_ringoftheheirophant";
		case 114: return "ps_ring_rottd";
		case 115: return "ps_luca_ring_spiritguidance";
		case 116: return "ps_luca_starband";
		case 117: return "ps_ring_swiftp";
		case 118: return "ps_luca_robesofregeneration";
		case 119: return "ps_luca_scimitar_defenderwilds";
		case 120: return "ps_scythe_deathscold";
		case 121: return "ps_luca_shield_elemental_escutch";
		case 122: return "ps_luca_onethousandcurses";
		case 123: return "ps_luca_favorofpazuzu";
		case 124: return "ps_sickle_sheela";
		case 125: return "ps_spea_pwhim";
		case 126: return "ps_spr_valk";
		case 127: return "ps_ssword_hathor";
		case 128: return "ps_luca_staff_ancestralrecall";
		case 129: return "ps_staff_ankh";
		case 130: return "ps_luca_cat_staff";
		case 131: return "ps_staff_ling";
		case 132: return "ps_luca_holygavel";
		case 133: return "ps_luca_rukus2";
		case 134: return "ps_wham_hanvil";
		case 135: return "ps_whip_scource";
		case 136: return "ps_whip_strike3";
		case 137: return "ps_whip_willing";
		case 138: return "ps_rapier_nails";
		case 139: return "ps_falchion_brightshadow";
		case 140: return "ps_halb_caxle";
		case 141: return "ps_luca_helm_wildhunt";
		case 142: return "ps_itemset_golem5";
		case 143: return "ps_itemset_golem6";
		case 144: return "ps_itemset_golem1";
		case 145: return "ps_gsword_reaver";
		case 146: return "ps_itemset_golem8";
		case 147: return "ps_itemset_golem4";
		case 148: return "ps_itemset_golem2";
		case 149: return "ps_mstar_carmaker";
		case 150: return "ps_luca_armor_wildhunt";
		case 151: return "ps_luca_shield_wildhunt";
		case 152: return "ps_itemset_golem3";
		case 153: return "ps_staff_zakine";
		case 154: return "ps_itemset_golem7";
		case 155: return "ps_dagger_sleeperagent";
		case 156: return "ps_gad_forbidden_sun";
		case 157: return "ps_mace_cross";
		case 158: return "ps_helmet_blindsight";
		case 159: return "ps_crft_ing_au";
		case 160: return "ps_crft_plk_ao";
		case 161: return "ps_cfrt_ing_by";
		case 162: return "ps_cfrt_ing_bg";
		case 163: return "ps_cfrt_ing_tt";
		case 164: return "ps_whammer_lawslongreach";
		case 165: return "ps_gad_grandblade";
		case 166: return "ps_qstaff_philosophysolidified2";
		case 167: return "nx2_boots_hardy_05";
		case 168: return "nw_it_mring0290";
		case 169: return "ps_gauntlet_spikedknuckles";
		case 170: return "n2_pca_archer";
		case 171: return "ps_ring_yellowrhomboid";
		case 172: return "ps_ring_violetsphere";
		case 173: return "ps_ring_redrhomboid";
		case 174: return "ps_ring_orangesphere";
		case 175: return "ps_ring_greenrhomboid";
		case 176: return "ps_ring_bluesphere";
		case 177: return "ps_ring_fieldsergeant";
	}
	
	return "";

}

//Epic Treasure Pool (High)
//Replace / modify list as needed
string PickFromQuestTreasureHigh() {

	int numOfItems = 177; //number of items in the list below
	
	switch(Random(numOfItems)+1) {
	
		case 1: return "ps_morg_item1";
		case 2: return "ps_morg_item2";
		case 3: return "ps_morg_item3";
		case 4: return "ps_morg_item4";
		case 5: return "ps_morg_item5";
		case 6: return "ps_morg_item6";
		case 7: return "nw_maarcl0370";
		case 8: return "ps_morg_item8";
		case 9: return "ps_morg_item9";
		case 10: return "ps_morg_item10";
		case 11: return "ps_morg_item11";
		case 12: return "ps_morg_item12";
		case 13: return "ps_morg_item12";
		case 14: return "ps_morg_item17";
		case 15: return "ps_morg_item18";
		case 16: return "ps_morg_item20";
		case 17: return "ps_morg_item21";
		case 18: return "ps_morg_item22";
		case 19: return "ps_morg_item23";
		case 20: return "ps_morg_item24";
		case 21: return "ps_morg_item25";
		case 22: return "ps_morg_item26";
		case 23: return "ed_belt_coolness";
		case 24: return "ed_cool_dagger";
		case 25: return "ed_toothpick";
		case 26: return "ed_shield_dark";
		case 27: return "ps_amor_bitolarry";
		case 28: return "ps_luca_amulet_carvedbones";
		case 29: return "ps_luca_frozentearofcania";
		case 30: return "ps_luca_hollybranch";
		case 31: return "ps_luca_holysymboloffaith";
		case 32: return "ps_luca_holysymbolofthehealer";
		case 33: return "ps_amulet_obsidian";
		case 34: return "ps_amulet_sensate";
		case 35: return "ps_luca_spiritedsymbol";
		case 36: return "ps_luca_stalkerscompass";
		case 37: return "ps_amulet_stinger";
		case 38: return "ps_amulet_weakness";
		case 39: return "ps_armor_blessingofshar";
		case 40: return "ps_armor_illusaryadventurer";
		case 41: return "ps_gad_dreadaxe2";
		case 42: return "ps_armor_nasty";
		case 43: return "ps_armor_otyugh";
		case 44: return "ps_armor_sequencer";
		case 45: return "ps_luca_twicecursedarmor";
		case 46: return "ps_bass_dflam";
		case 47: return "ps_luca_bitter_cold";
		case 48: return "ps_luca_belt_bardstrap";
		case 49: return "ps_luca_coilofendurence";
		case 50: return "ps_luca_belt_medicssatchel";
		case 51: return "ps_book_acook";
		case 52: return "ps_book_iggwilv";
		case 53: return "ps_luca_corruptionofblood";
		case 54: return "ps_luca_corruptionofblood_sorc";
		case 55: return "ps_luca_corruptionofthefavored";
		case 56: return "ps_luca_corruptionoftheland";
		case 57: return "ps_luca_corruptionofthemind";
		case 58: return "ps_luca_corruptionofthespirit";
		case 59: return "ps_luca_boot_silencesoles";
		case 60: return "ps_luca_talonsofthehamatula";
		case 61: return "ps_bow_guardian";
		case 62: return "ps_bplate_aot";
		case 63: return "ps_bracer_kaleido";
		case 64: return "ps_bracer_magus1";
		case 65: return "ps_luca_glovesoftheshieldbuckler";
		case 66: return "ps_luca_greaterglovesoftheshield";
		case 67: return "ps_luca_cloak_ebontiger";
		case 68: return "ps_luca_werewolfcloak";
		case 69: return "ps_luca_cloth_lesser_vestcaller";
		case 70: return "ps_luca_cloth_mystictheurge";
		case 71: return "ps_luca_cloth_vestcaller";
		case 72: return "ps_club_dwand";
		case 73: return "ps_dagger_tharizdun";
		case 74: return "ps_falc_sultan";
		case 75: return "ps_fullplate_soulplate";
		case 76: return "ps_gad_ring_mountain";
		case 77: return "ps_gauntlet_onehand";
		case 78: return "ps_giantaxe_dwarven";
		case 79: return "ps_giantclub_dryad";
		case 80: return "ps_giantclub_latern";
		case 81: return "ps_giantsword_cleanser";
		case 82: return "ps_giantsword_deathbringer";
		case 83: return "ps_giantsword_defender";
		case 84: return "ps_gloves_mindcatcher";
		case 85: return "ps_helm_urpriest";
		case 86: return "ps_helmet_circle1";
		case 87: return "ps_helmet_circle2";
		case 88: return "ps_helmet_circle3";
		case 89: return "ps_luca_priceofpower";
		case 90: return "ps_luca_safetygoggles";
		case 91: return "ps_luca_icefang";
		case 92: return "ps_lcrossbow_roguesfriend";
		case 93: return "ps_luca_effervescentaura";
		case 94: return "ps_longbow_forestdefense";
		case 95: return "ps_longbow_frostvolley";
		case 96: return "ps_luca_rainbow";
		case 97: return "ps_luca_corruptionoffaith";
		case 98: return "ps_mand_bleak";
		case 99: return "ps_luca_misc_phoenixfeather";
		case 100: return "ps_mstar_spikewis";
		case 101: return "ps_qstaff_ruby";
		case 102: return "ps_luca_shatteringstorm";
		case 103: return "ps_rapier_heartbleeder";
		case 104: return "ps_rapier_levistus";
		case 105: return "ps_luca_rapier_quickening";
		case 106: return "ps_ring_ancient";
		case 107: return "ps_ring_aureon";
		case 108: return "ps_luca_ring_divinitybeckons";
		case 109: return "ps_luca_ring_heroicvalor";
		case 110: return "ps_luca_ring_lies";
		case 111: return "ps_luca_ring_reignfire";
		case 112: return "ps_luca_ring_ringmouth";
		case 113: return "ps_luca_ringoftheheirophant";
		case 114: return "ps_ring_rottd";
		case 115: return "ps_luca_ring_spiritguidance";
		case 116: return "ps_luca_starband";
		case 117: return "ps_ring_swiftp";
		case 118: return "ps_luca_robesofregeneration";
		case 119: return "ps_luca_scimitar_defenderwilds";
		case 120: return "ps_scythe_deathscold";
		case 121: return "ps_luca_shield_elemental_escutch";
		case 122: return "ps_luca_onethousandcurses";
		case 123: return "ps_luca_favorofpazuzu";
		case 124: return "ps_sickle_sheela";
		case 125: return "ps_spea_pwhim";
		case 126: return "ps_spr_valk";
		case 127: return "ps_ssword_hathor";
		case 128: return "ps_luca_staff_ancestralrecall";
		case 129: return "ps_staff_ankh";
		case 130: return "ps_luca_cat_staff";
		case 131: return "ps_staff_ling";
		case 132: return "ps_luca_holygavel";
		case 133: return "ps_luca_rukus2";
		case 134: return "ps_wham_hanvil";
		case 135: return "ps_whip_scource";
		case 136: return "ps_whip_strike3";
		case 137: return "ps_whip_willing";
		case 138: return "ps_rapier_nails";
		case 139: return "ps_falchion_brightshadow";
		case 140: return "ps_halb_caxle";
		case 141: return "ps_luca_helm_wildhunt";
		case 142: return "ps_itemset_golem5";
		case 143: return "ps_itemset_golem6";
		case 144: return "ps_itemset_golem1";
		case 145: return "ps_gsword_reaver";
		case 146: return "ps_itemset_golem8";
		case 147: return "ps_itemset_golem4";
		case 148: return "ps_itemset_golem2";
		case 149: return "ps_mstar_carmaker";
		case 150: return "ps_luca_armor_wildhunt";
		case 151: return "ps_luca_shield_wildhunt";
		case 152: return "ps_itemset_golem3";
		case 153: return "ps_staff_zakine";
		case 154: return "ps_itemset_golem7";
		case 155: return "ps_dagger_sleeperagent";
		case 156: return "ps_gad_forbidden_sun";
		case 157: return "ps_mace_cross";
		case 158: return "ps_helmet_blindsight";
		case 159: return "ps_crft_ing_au";
		case 160: return "ps_crft_plk_ao";
		case 161: return "ps_cfrt_ing_by";
		case 162: return "ps_cfrt_ing_bg";
		case 163: return "ps_cfrt_ing_tt";
		case 164: return "ps_whammer_lawslongreach";
		case 165: return "ps_gad_grandblade";
		case 166: return "ps_qstaff_philosophysolidified2";
		case 167: return "nx2_boots_hardy_05";
		case 168: return "nw_it_mring0290";
		case 169: return "ps_gauntlet_spikedknuckles";
		case 170: return "n2_pca_archer";
		case 171: return "ps_ring_yellowrhomboid";
		case 172: return "ps_ring_violetsphere";
		case 173: return "ps_ring_redrhomboid";
		case 174: return "ps_ring_orangesphere";
		case 175: return "ps_ring_greenrhomboid";
		case 176: return "ps_ring_bluesphere";
		case 177: return "ps_ring_fieldsergeant";
	}
	
	return "";

}