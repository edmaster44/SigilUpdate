//Max 23
string GetFromValMiscList(int nRandom) {
	string sItem = "";
	switch (nRandom) {
		case 1: sItem="ps_valmisc_enigmabottle"; break;
		case 2: sItem="ps_valmisc_gnomishminestock"; break;
		case 3: sItem="ps_valmisc_spirithawkfeather"; break;
		case 4: sItem="ps_valmisc_kutunuoleaves"; break;
		case 5: sItem="ps_valmisc_hellfirepowder"; break;
		case 6: sItem="ps_valmisc_goldtrophy"; break;
		case 7: sItem="ps_valmisc_mithrilscepter"; break;
		case 8: sItem="ps_valmisc_smallmirror"; break;	
		case 9: sItem="ps_valmisc_armoroil"; break;	
		case 10: sItem="ps_valmisc_bagofwind"; break;				
		case 11: sItem="ps_valmisc_beginnersalembic"; break;				
		case 12: sItem="ps_valmisc_beginnersdecensor"; break;				
		case 13: sItem="ps_valmisc_beginnersretort"; break;				
		case 14: sItem="ps_valmisc_bottledpest"; break;				
		case 15: sItem="ps_valmisc_disrupt"; break;				
		case 16: sItem="ps_valmisc_glyph"; break;				
		case 17: sItem="ps_valmisc_healingmushrooms"; break;				
		case 18: sItem="ps_valmisc_oilweapon"; break;				
		case 19: sItem="ps_valmisc_sandblindness"; break;				
		case 20: sItem="ps_valmisc_skeletonkey"; break;				
		case 21: sItem="ps_valmisc_webcannister"; break;				
		case 22: sItem="ps_valmisc_embalming"; break;					
		case 23: sItem="ps_valmisc_unbinding"; break;				
	}		
	return sItem;		
}

//Max 96
string GetFromRuneList(int nRandom) {
	int nRandom = Random(96) + 1;
	string sItem = "ps_rune_";
		
	if (nRandom < 10) 	{
		sItem += "0";
	}
		
	sItem += IntToString(nRandom);	
	return sItem;	
}

//Max 5
string GetFromPaintingList(int nRandom) {
	string sRes = "";
	switch (nRandom) {
		case 1: sRes = "ps_painting_ladyofpain"; break;
		case 2: sRes = "ps_painting_liquidmoon"; break; 
		case 3: sRes = "ps_painting_multiverse"; break; 
		case 4: sRes = "ps_painting_solitude"; break; 
		case 5: sRes = "ps_painting_whirlpool"; break;
	}
	return sRes;
}

//Max 13/14
string GetFromGrenadeList(int nRandom, int nTreasureLevel) {
	string sRes = "";
	if (nTreasureLevel <= 1) {
		switch (nRandom) {
			case 1: sRes = "x2_it_firebomb"; break;
			case 2: sRes = "n2_it_acid_2"; break;
			case 3: sRes = "n2_it_acid_3"; break;
			case 4: sRes = "n2_it_chok_2"; break;
			case 5: sRes = "n2_it_chok_3"; break;
			case 6: sRes = "n2_it_alch_2"; break;
			case 7: sRes = "n2_it_alch_3"; break;
			case 8: sRes = "n2_it_tang_2"; break;
			case 9: sRes = "n2_it_tang_3"; break;
			case 10: sRes = "n2_it_holy_2"; break;
			case 11: sRes = "n2_it_holy_3"; break;
			case 12: sRes = "n2_it_thun_2"; break;
			case 13: sRes = "n2_it_thun_3"; break;
		}
	} else {
		switch (nRandom) {
			case 1: sRes = "ps_grenade_stonehold"; break;
			case 2: sRes = "ps_grenade_massreduceperson"; break;
			case 3: sRes = "ps_grenade_inferno"; break;
			case 4: sRes = "ps_grenade_hissofsleep"; break;
			case 5: sRes = "ps_grenade_greatercreepingcold";  break;
			case 6: sRes = "ps_grenade_fear";  break;
			case 7: sRes = "ps_grenade_cloudkill";  break;
			case 8: sRes = "ps_grenade_charmmonster";  break;
			case 9: sRes = "n2_it_acid_4"; break;
			case 10: sRes = "n2_it_chok_4"; break;
			case 11: sRes = "n2_it_alch_4"; break;
			case 12: sRes = "n2_it_tang_4"; break;
			case 13: sRes = "n2_it_holy_4"; break;
			case 14: sRes = "n2_it_thun_4"; break;
		}
	}
	return sRes;
}

//Max 7
string GetFromCoinList(int nRandom) {
	string sRes = "";
	switch (nRandom) {
		case 1: sRes = "ps_miscstack_coinage-torus"; break; //ale
		case 2: sRes = "ps_miscstack_coinage-lodestone"; break; // wine
		case 3: sRes = "ps_miscstack_coinage-glitterglas"; break; // spirits
		case 4: sRes = "ps_miscstack_coinage-cogcoin"; break; //torch
		case 5: sRes = "ps_miscstack_coinage-achsteel";  break;
		case 6: sRes = "ps_misc_coinage-rainbow";  break;
		case 7: sRes = "ps_misc_coinage-pinecoin";  break;
	}
	return sRes;
}

//Max 10
string GetFromJunkList(int nRandom) {
	string sRes = "";
	switch (nRandom) {
		case 1: sRes = "NW_IT_MPOTION021"; break; //ale
		case 2: sRes = "NW_IT_MPOTION023"; break; // wine
		case 3: sRes = "NW_IT_MPOTION022"; break; // spirits
		case 4: sRes = "NW_IT_TORCH001"; break; //torch
		case 5: sRes = "nw_it_mring021";  break;
		case 6: sRes = "nw_it_mneck020";  break;
		case 7: sRes = "nw_it_mring022";  break;
		case 8: sRes = "nw_it_mneck023";  break;
		case 9: sRes = "nw_it_mneck021";  break;
		case 10: sRes = "nw_it_mring023";  break;
	}
	return sRes;
}

//max 10
string GetFromDrugList(int nRandom) {
	string sRes = "";
	switch (nRandom) {
		case 1: sRes = "ps_drug_liquidpain"; break; //ale
		case 2: sRes = "ps_drug_baccaran"; break; // wine
		case 3: sRes = "ps_drug_devilweed"; break; // spirits
		case 4: sRes = "ps_drug_luhix"; break; //torch
		case 5: sRes = "ps_drug_dreammist";  break;
		case 6: sRes = "ps_drug_mushroompowder";  break;
		case 7: sRes = "ps_drug_redflowerleaves";  break;
		case 8: sRes = "ps_drug_sannish";  break;
		case 9: sRes = "ps_drug_terranbrandy";  break;
		case 10: sRes = "ps_drug_vodare";  break;
	}
	return sRes;
}

string GetPotionFromList(object oTarget, int nRandom, int nTreasureType = 1) {

	string sPotion = "";
	if (nTreasureType == TREASURE_LOW) {
        switch (nRandom) {
			case 1: sPotion = "ps_potions1_01"; break;
			case 2: sPotion = "ps_potions1_02"; break;
			case 3: sPotion = "ps_potions1_03"; break;
			case 4: sPotion = "ps_potions1_04"; break;
			case 7: sPotion = "ps_potions1_05"; break;
			case 10: sPotion = "ps_potions1_06"; break;
			case 11: sPotion = "ps_potions1_07"; break;
			case 12: sPotion = "ps_potions1_08"; break;
			case 13: sPotion = "ps_potions1_09"; break;
			case 14: sPotion = "ps_potions2_01"; break;
			case 16: sPotion = "ps_potions2_02"; break;
			case 17: sPotion = "ps_potions2_03"; break;
			case 18: sPotion = "ps_potions2_04"; break;
			case 19: sPotion = "ps_potions2_05"; break;
			case 22: sPotion = "ps_potions2_06"; break;
			case 23: sPotion = "ps_potions2_07"; break;
			case 24: sPotion = "ps_potions2_08"; break;
			case 25: sPotion = "ps_potions2_09"; break;
			case 26: sPotion = "ps_potions2_10"; break;
			case 27: sPotion = "ps_potions2_11"; break;
			case 29: sPotion = "ps_potions2_12"; break;
			case 30: sPotion = "ps_potions2_13"; break;
			case 31: sPotion = "ps_potions2_14"; break;
			case 32: sPotion = "ps_potion_lessersequencer"; break;
			default: sPotion = ""; break;
		}
		return sPotion;
	} else if (nTreasureType == TREASURE_MEDIUM) {
        switch (nRandom) {
			case 1: sPotion = "ps_potions3_01"; break;
			case 2: sPotion = "ps_potions3_02"; break;
			case 3: sPotion = "ps_potions3_03"; break;
			case 4: sPotion = "ps_potions3_04"; break;
			case 5: sPotion = "ps_potions3_05"; break;
			case 6: sPotion = "ps_potions3_06"; break;
			case 7: sPotion = "ps_potions3_07"; break;
			case 8: sPotion = "ps_potions3_08"; break;
			case 9: sPotion = "ps_potions3_09"; break;
			case 10: sPotion = "ps_potions4_01"; break;
			case 11: sPotion = "ps_potions4_02"; break;
			case 12: sPotion = "ps_potions4_03"; break;
			case 13: sPotion = "ps_potions4_04"; break;
			case 14: sPotion = "ps_potions4_05"; break;
			case 15: sPotion = "ps_potions4_06"; break;
			case 16: sPotion = "ps_potion_lessersequencer"; break;
			case 17: sPotion = "ps_potion_jhuild"; break;
			case 18: sPotion = "ps_potion_sequencer"; break;
		}
	} else if (nTreasureType == TREASURE_HIGH) {
        switch (nRandom) {
			case 1: sPotion = "ps_potions5_01"; break;
			case 2: sPotion = "ps_potions5_02"; break;
			case 3: sPotion = "ps_potion_greatersequencer"; break;
		}
    }
	return sPotion;
}

//Max 7
string GetOrdinaryJewelryFromList(int nRandom) {
	string sJewel = "";
	switch (nRandom) {
		case 1: sJewel = "nw_it_mneck020";   break;
		case 2: sJewel = "nw_it_mring021";   break;
		case 3: sJewel = "nw_it_mneck021";   break;
		case 4: sJewel = "nw_it_mring022";   break;
		case 5: sJewel = "nw_it_mneck023";   break;
		case 6: sJewel = "nw_it_mneck022";   break;
		case 7: sJewel = "nw_it_mring023";   break;
	} 
	return sJewel;
}

//Max 64
string GetAmmoFromList(int nRandom) {
        string sAmmo = "";
            switch (nRandom)
            {
				case 1: sAmmo = "ps_arrow_+1";  break;
				case 2: sAmmo = "ps_arrow_+2";  break;
				case 3: sAmmo = "ps_arrow_alchemicalsilver";  break;
				case 4: sAmmo = "ps_arrow_coldiron";  break;
				case 5: sAmmo = "ps_arrow_mildpoison";  break;
				case 6: sAmmo = "ps_arrow_acid";  break;
				case 7: sAmmo = "ps_arrow_fire";  break;
				case 8: sAmmo = "ps_arrow_frost";  break;
				case 9: sAmmo = "ps_arrow_electric";  break;
				case 10: sAmmo = "ps_arrow_piercing";  break;
				case 11: sAmmo = "ps_arrow_vampiric";  break;
				case 12: sAmmo = "ps_bolt_alchemicalsilver";  break;
				case 13: sAmmo = "ps_bolt_+1";  break;
				case 14: sAmmo = "ps_bolt_+2";  break;
				case 15: sAmmo = "ps_bolt_fire";  break;
				case 16: sAmmo = "ps_bolt_frost";  break;
				case 17: sAmmo = "ps_bolt_electric";  break;
				case 18: sAmmo = "ps_bolt_piercing";  break;
				case 19: sAmmo = "ps_bolt_coldiron";  break;
				case 20: sAmmo = "ps_bolt_mildpoison";  break;
				case 21: sAmmo = "ps_bolt_paralytic";  break;
				case 22: sAmmo = "ps_bullet_+1";  break;
				case 23: sAmmo = "ps_bullet_alchemicalsilver";  break;
				case 24: sAmmo = "ps_bullet_+2";  break;
				case 25: sAmmo = "ps_bullet_coldiron";  break;
				case 26: sAmmo = "ps_bullet_frost";  break;
				case 27: sAmmo = "ps_bullet_electric";  break;
				case 28: sAmmo = "ps_bullet_fire";  break;
				case 29: sAmmo = "nw_wammar001"; break;
                case 30: sAmmo = "nw_wammbo001"; break;
                case 33: sAmmo = "nw_wammbo002"; break;
				case 34: sAmmo = "ps_arrow_+3";  break;
				case 35: sAmmo = "ps_arrow_+4";  break;
				case 36: sAmmo = "ps_arrow_freezing";  break;
				case 37: sAmmo = "ps_arrow_slowing";  break;
				case 38: sAmmo = "ps_arrow_bleeding";  break;
				case 39: sAmmo = "ps_bolt_+4";  break;
				case 40: sAmmo = "ps_bolt_+3";  break;
				case 41: sAmmo = "ps_bullet_+3";  break;
				case 42: sAmmo = "ps_bullet_+4";  break;
				case 43: sAmmo = "ps_bullet_screaming";  break;
				case 44: sAmmo = "ps_bullet_smiting";  break;
				case 45: sAmmo = "ps_bullet_farelsgold";  break;
				case 46: sAmmo = "ps_bullet_giantsbane";  break;
                case 47: sAmmo = "nw_wammbo003";  break;
                case 48: sAmmo = "nw_wammbu002";  break;
                case 49: sAmmo = "nw_wammar002";  break;
                case 50: sAmmo = "nw_wammar003"; break;
                case 51: sAmmo = "nw_wammar004"; break;
                case 52: sAmmo = "nw_wammar005"; break;
                case 53: sAmmo = "nw_wammar006"; break;
                case 54: sAmmo = "nw_wammbo004";  break;
                case 55: sAmmo = "nw_wammbo005"; break;
                case 56: sAmmo = "nw_wammbu004"; break;
                case 57: sAmmo = "nw_wammbu005"; break;
                case 58: sAmmo = "nw_wammbu006"; break;
                case 59: sAmmo = "nw_wammbu007"; break;
				case 60: sAmmo = "ps_arrow_adamantine";  break;
				case 61: sAmmo = "ps_bolt_adamantine";  break;
				case 62: sAmmo = "ps_bullet_adamantine";  break;
                case 63: sAmmo = "nw_wammbu001";      break;
                case 64: sAmmo = "nw_wammbu003";     break;
            }
		return sAmmo;
}

//Max 30 / 26
string GetKitsFromList(int nRandom, int nTreasureLevel = 0) {
	string sKit = "";
	if (nTreasureLevel <= 1) { // < 10
		switch (nRandom) {
        	case 1: sKit = "nw_it_picks001";   break;
        	case 2: sKit = "nw_it_picks002";   break;
        	case 3: sKit = "nw_it_picks003";   break;
        	case 4: sKit = "nw_it_picks004";   break;
        	case 5: sKit = "nw_it_medkit001";   break;
        	case 6: sKit = "nw_it_medkit002";   break;
        	case 7: sKit = "nw_it_medkit003";   break;
            case 8: sKit = "nw_it_trap001";    break;
            case 9: sKit = "nw_it_trap029";    break;
            case 10: sKit = "nw_it_trap033";    break;
            case 14: sKit = "nw_it_trap002";    break;
            case 15: sKit = "nw_it_trap030";    break;
            case 16: sKit = "nw_it_trap037";    break;
            case 17: sKit = "nw_it_trap034";   break;
            case 18: sKit = "nw_it_trap005";   break;
            case 19: sKit = "nw_it_trap038";   break;
            case 20: sKit = "nw_it_trap041";   break;
            case 21: sKit = "nw_it_trap003";    break;
            case 22: sKit = "nw_it_trap031";   break;
            case 23: sKit = "nw_it_trap035";   break;
            case 24: sKit = "nw_it_trap006";   break;
            case 25: sKit = "nw_it_trap042";   break;
            case 26: sKit = "nw_it_trap004";   break;
            case 27: sKit = "nw_it_trap032";   break;
            case 28: sKit = "nw_it_trap039";    break;
            case 29: sKit = "nw_it_trap009";   break;
            case 30: sKit = "nw_it_trap036";   break;
		}
	} else if (nTreasureLevel <= 2) { // < 20
		switch (nRandom) {
        	case 1: sKit = "nw_it_medkit004";   break;
            case 2: sKit = "nw_it_trap013";   break;
            case 3: sKit = "nw_it_trap040";  break;
            case 4: sKit = "nw_it_trap007";  break;
            case 5: sKit = "nw_it_trap043";  break;
            case 6: sKit = "nw_it_trap010";  break;
            case 7: sKit = "nw_it_trap017";  break;
            case 8: sKit = "nw_it_trap021"; break;
            case 9: sKit = "nw_it_trap014"; break;
            case 10: sKit = "nw_it_trap025"; break;
            case 11: sKit = "nw_it_trap008";  break;
            case 12: sKit = "nw_it_trap044";  break;
            case 13: sKit = "nw_it_trap018";  break;
            case 14: sKit = "nw_it_trap011";  break;
            case 15: sKit = "nw_it_trap022";  break;
            case 16: sKit = "nw_it_trap026";  break;
            case 17: sKit = "nw_it_trap015"; break;
            case 18: sKit = "nw_it_trap012"; break;
            case 19: sKit = "nw_it_trap019"; break;
            case 20: sKit = "nw_it_trap023"; break;
            case 21: sKit = "nw_it_trap016"; break;
            case 23: sKit = "nw_it_trap027"; break;
            case 24: sKit = "nw_it_trap020"; break;
            case 25: sKit = "nw_it_trap024"; break;
            case 26: sKit = "nw_it_trap028"; break;
		}
	} 
	return sKit;
}

//Max 90 / 83 / 53
string GetArmorFromList(int nRandom, int nTreasureLevel) {
	string sItem = "";
	if (nTreasureLevel <= 1) {
		switch (nRandom) {
			case 1: sItem = "ps_lightarmor_broewndefamily";  break;
			case 2: sItem = "ps_lightarmor_jaredwidowmaker";  break;
			case 3: sItem = "ps_clothing_lessermagesrobe";  break;
			case 4: sItem = "ps_clothing_lessersorcerersrobe";  break;
			case 5: sItem = "ps_clothing_vestofescape";  break;
			case 6: sItem = "ps_armor_astralbreast";  break;
			case 7: sItem = "ps_mediumarmor_scattertrailhide";  break;
			case 8: sItem = "ps_heavyarmor_freedom";  break;
			case 9: sItem = "ps_armor_astralband";  break;
			case 10: sItem = "ps_armor_astralfull";  break;
			case 11: sItem = "ps_armor_astralhalf";  break;
			case 12: sItem = "NW_MCLOTH011";  break;
			case 13: sItem = "NW_MCLOTH014";  break;
			case 14: sItem = "NW_MCLOTH013";  break;
			case 15: sItem = "NW_MCLOTH006";  break;
			case 16: sItem = "X0_CLOTH003";  break;
			case 17: sItem = "NW_MCLOTH017";  break;
			case 18: sItem = "NW_MCLOTH015";  break;
			case 19: sItem = "NW_MCLOTH018";  break;
			case 20: sItem = "NW_MCLOTH019";  break;
			case 21: sItem = "NW_MAARCL021";  break;
			case 22: sItem = "NW_AARCL011";  break;
			case 23: sItem = "NW_MAARCL051";  break;
			case 24: sItem = "NW_MAARCL064";  break;
			case 25: sItem = "n2_pca_bguard";  break;
			case 26: sItem = "mwa_hvbm_drk_3";  break;
			case 27: sItem = "mwa_hvfp_drk_3";  break;
			case 28: sItem = "mwa_hvhp_drk_3";  break;
			case 29: sItem = "NW_MAARCL024";  break;
			case 30: sItem = "NW_MAARCL022";  break;
			case 31: sItem = "NW_AARCL007";  break;
			case 32: sItem = "NW_MAARCL053";  break;
			case 33: sItem = "NW_MAARCL068";  break;
			case 34: sItem = "NW_AARCL006";  break;
			case 35: sItem = "NW_MAARCL052";  break;
			case 36: sItem = "NW_MAARCL069";  break;
			case 37: sItem = "NW_MAARCL026";  break;
			case 38: sItem = "NW_MAARCL059";  break;
			case 39: sItem = "mwa_ltcs_ada_4";  break;
			case 40: sItem = "NW_MAARCL011";  break;
			case 41: sItem = "NW_MAARCL013";  break;
			case 42: sItem = "NW_MAARCL032";  break;
			case 43: sItem = "NW_MAARCL012";  break;
			case 44: sItem = "P_HHM_CH01";  break;
			case 45: sItem = "NW_MAARCL046";  break;
			case 46: sItem = "NW_MAARCL067";  break;
			case 47: sItem = "mwa_ltcs_drk_3";  break;
			case 48: sItem = "NW_AARCL001";  break;
			case 49: sItem = "NW_MAARCL044";  break;
			case 50: sItem = "NW_MAARCL071";  break;
			case 51: sItem = "NW_MAARCL072";  break;
			case 52: sItem = "NW_MAARCL043";  break;
			case 53: sItem = "NW_AARCL009";  break;
			case 54: sItem = "NW_MAARCL007";  break;
			case 55: sItem = "NW_AARCL002";  break;
			case 56: sItem = "NW_MAARCL045";  break;
			case 57: sItem = "NW_MAARCL075";  break;
			case 58: sItem = "NW_MAARCL065";  break;
			case 59: sItem = "NW_MAARCL049";  break;
			case 60: sItem = "NW_AARCL010";  break;
			case 61: sItem = "NW_AARCL004";  break;
			case 62: sItem = "NW_MAARCL035";  break;
			case 63: sItem = "NW_MAARCL066";  break;
			case 64: sItem = "mwa_mdbp_drk_3";  break;
			case 65: sItem = "mwa_mdsm_drk_3";  break;
			case 66: sItem = "mwa_mdcm_drk_3";  break;
			case 67: sItem = "NW_AARCL008";  break;
			case 68: sItem = "NW_MAARCL047";  break;
			case 69: sItem = "NW_MAARCL070";  break;
			case 70: sItem = "NW_AARCL003";  break;
			case 71: sItem = "NW_MAARCL048";  break;
			case 72: sItem = "NW_MAARCL073";  break;
			case 73: sItem = "ps_breastplate_sunflame";  break;
			case 74: sItem = "ps_hide_beastskin";  break;
			case 75: sItem = "ps_bonearmor";  break;
			case 76: sItem = "ps_cinderarmor";  break;
			case 77: sItem = "ps_leather_zombie";  break;
			case 78: sItem = "ps_rags_cursed-1";  break;
			case 79: sItem = "ps_bandedmail_cursed-1";  break;
			case 80: sItem = "ps_fullplate_cursed-1";  break;
			case 81: sItem = "ps_halfplate_cursed-1";  break;
			case 82: sItem = "ps_chainshirt_cursed-1";  break;
			case 83: sItem = "ps_leather_cursed-1";  break;
			case 84: sItem = "ps_leather_cursed-2";  break;
			case 85: sItem = "ps_paddedarmor_cursed-1";  break;
			case 86: sItem = "ps_studdedleather_cursed-1";  break;
			case 87: sItem = "ps_breastplate_cursed-1";  break;
			case 88: sItem = "ps_chainmail_cursed-1";  break;
			case 89: sItem = "ps_hidearmor_cursed-1";  break;
			case 90: sItem = "ps_scalemail_cursed-1";  break;
		}
	} else if (nTreasureLevel <= 2) {
		switch (nRandom)
		{
			case 1: sItem = "ps_clothing_sorcerersrobe";  break;
			case 2: sItem = "ps_clothing_magesrobe";  break;
			case 3: sItem = "ps_mediumarmor_chainmailspeed";  break;
			case 4: sItem = "ps_breastplate_rog";  break;
			case 5: sItem = "ps_mediumarmor_umberhulk";  break;
			case 6: sItem = "ps_splintmail_forbiddenjade";  break;
			case 7: sItem = "ps_heavyarmor_umberhulk";  break;
			case 8: sItem = "n2_pca_dragon";  break;
			case 9: sItem = "n2_pca_duelist";  break;
			case 10: sItem = "NW_MCLOTH016";  break;
			case 11: sItem = "NW_MCLOTH012";  break;
			case 12: sItem = "x2_it_pmrobe";  break;
			case 13: sItem = "nx1_pca_redwizard";  break;
			case 14: sItem = "nx1_cloth05";  break;
			case 15: sItem = "NW_MCLOTH007";  break;
			case 16: sItem = "NW_MCLOTH008";  break;
			case 17: sItem = "NW_MCLOTH010";  break;
			case 18: sItem = "X1_MCLOTH001";  break;
			case 19: sItem = "NW_MCLOTH009";  break;
			case 20: sItem = "NW_MCLOTH020";  break;
			case 21: sItem = "NW_MCLOTH021";  break;
			case 22: sItem = "mwa_hvbm_ada_3";  break;
			case 23: sItem = "mwa_hvfp_ada_4";  break;
			case 24: sItem = "mwa_hvhp_ada_4";  break;
			case 25: sItem = "n2_pca_champion";  break;
			case 26: sItem = "NW_MAARCL025";  break;
			case 27: sItem = "NW_MAARCL076";  break;
			case 28: sItem = "X0_MAARCL019";  break;
			case 29: sItem = "n2_pca_defend";  break;
			case 30: sItem = "NW_MAARCL080";  break;
			case 31: sItem = "X0_MAARCL023";  break;
			case 32: sItem = "NW_MAARCL081";  break;
			case 33: sItem = "X0_MAARCL021";  break;
			case 34: sItem = "X0_MAARCL036";  break;
			case 35: sItem = "NW_MAARCL020";  break;
			case 36: sItem = "NW_MAARCL062";  break;
			case 37: sItem = "NW_MAARCL063";  break;
			case 38: sItem = "X0_MAARCL037";  break;
			case 39: sItem = "n2_pca_warpriest";  break;
			case 40: sItem = "mwa_hvfp_wyh_3";  break;
			case 41: sItem = "mwa_hvhp_wyh_3";  break;
			case 42: sItem = "NW_MAARCL004";  break;
			case 43: sItem = "n2_pca_trickster";  break;
			case 44: sItem = "NW_MAARCL001";  break;
			case 45: sItem = "NW_MCLOTH005";  break;
			case 46: sItem = "n2_pca_assassin";  break;
			case 47: sItem = "NW_MAARCL079";  break;
			case 48: sItem = "X0_MAARCL009";  break;
			case 49: sItem = "n2_pca_hscout";  break;
			case 50: sItem = "NW_MAARCL083";  break;
			case 51: sItem = "X0_MAARCL003";  break;
			case 52: sItem = "NW_MAARCL002";  break;
			case 53: sItem = "X0_MAARCL001";  break;
			case 54: sItem = "NW_MAARCL084";  break;
			case 55: sItem = "mwa_ltlt_slh_3";  break;
			case 56: sItem = "mwa_ltsl_slh_3";  break;
			case 57: sItem = "n2_pca_sthief";  break;
			case 58: sItem = "n2_pca_sdancer";  break;
			case 59: sItem = "NW_MAARCL008";  break;
			case 60: sItem = "nx1_pca_stormlord";  break;
			case 61: sItem = "X0_MAARCL005";  break;
			case 62: sItem = "NW_MAARCL087";  break;
			case 63: sItem = "mwa_mdbp_ada_4";  break;
			case 64: sItem = "mwa_mdcm_ada_4";  break;
			case 65: sItem = "mwa_mdsm_ada_4";  break;
			case 66: sItem = "NW_MAARCL014";  break;
			case 67: sItem = "NW_MAARCL016";  break;
			case 68: sItem = "NW_MAARCL077";  break;
			case 69: sItem = "X0_MAARCL015";  break;
			case 70: sItem = "NW_MAARCL078";  break;
			case 71: sItem = "X0_MAARCL013";  break;
			case 72: sItem = "NW_MAARCL058";  break;
			case 73: sItem = "NW_MAARCL036";  break;
			case 74: sItem = "NW_MAARCL037";  break;
			case 75: sItem = "n2_pca_berserk";  break;
			case 76: sItem = "NW_MAARCL082";  break;
			case 77: sItem = "X0_MAARCL007";  break;
			case 78: sItem = "mwa_mdhd_slh_3";  break;
			case 79: sItem = "NW_MAARCL085";  break;
			case 80: sItem = "X0_MAARCL011";  break;
			case 81: sItem = "mwa_mdbp_wyh_3";  break;
			case 82: sItem = "mwa_mdsm_wyh_3";  break;
			case 83: sItem = "ps_fullplate_solar"; break;
		}
	} else {
		switch (nRandom) {
			case 1: sItem = "ps_armor_assassin";  break;
			case 2: sItem = "ps_armor_monk";  break;
			case 3: sItem = "ps_clothing_greatermagesrobe";  break;
			case 4: sItem = "ps_clothing_greatersorcerersrobe";  break;
			case 5: sItem = "ps_mediumarmor_lessergolem";  break;
			case 6: sItem = "ps_heavyarmor_deepguardian";  break;
			case 7: sItem = "NW_MCLOTH004";  break;
			case 8: sItem = "NW_MCLOTH003";  break;
			case 9: sItem = "nx1_pca_invisblade";  break;
			case 10: sItem = "NW_MCLOTH001";  break;
			case 11: sItem = "n2_mcloth001";  break;
			case 12: sItem = "NW_MCLOTH021";  break;
			case 13: sItem = "NW_MCLOTH022";  break;
			case 14: sItem = "NW_MCLOTH002";  break;
			case 15: sItem = "X0_MAARCL019";  break;
			case 16: sItem = "X0_MAARCL020";  break;
			case 17: sItem = "X0_MAARCL023";  break;
			case 18: sItem = "X0_MAARCL021";  break;
			case 19: sItem = "X0_MAARCL022";  break;
			case 20: sItem = "X0_MAARCL024";  break;
			case 21: sItem = "n2_pca_archer";  break;
			case 22: sItem = "X0_MAARCL009";  break;
			case 23: sItem = "X0_MAARCL010";  break;
			case 24: sItem = "NW_MAARCL033";  break;
			case 25: sItem = "X0_MAARCL003";  break;
			case 26: sItem = "X0_MAARCL004";  break;
			case 27: sItem = "n2_pca_nw9";  break;
			case 28: sItem = "X0_MAARCL002";  break;
			case 29: sItem = "X0_MAARCL001";  break;
			case 30: sItem = "X0_MAARCL006";  break;
			case 31: sItem = "X0_MAARCL005";  break;
			case 32: sItem = "X0_MAARCL015";  break;
			case 33: sItem = "X0_MAARCL016";  break;
			case 34: sItem = "X0_MAARCL013";  break;
			case 35: sItem = "X0_MAARCL014";  break;
			case 36: sItem = "NW_MAARCL061";  break;
			case 37: sItem = "NW_MAARCL015";  break;
			case 38: sItem = "X0_MAARCL007";  break;
			case 39: sItem = "X0_MAARCL008";  break;
			case 40: sItem = "X0_MAARCL011";  break;
			case 41: sItem = "X0_MAARCL012";  break;
			case 42: sItem = "NW_IT_NOVEL003";  break;
			case 43: sItem = "ps_fullplate_mechanusgears";  break;
			case 44: sItem = "ps_itemset_brazen1";  break;
			case 45: sItem = "ps_itemset_fallshad4";  break;
			case 46: sItem = "ps_itemset_swordsaint3";  break;
			case 47: sItem = "ps_armor_flametwin"; break;
			case 48: sItem = "ps_chainmail_devotion"; break;
			case 49: sItem = "ps_fullplate_faith"; break;
			case 50: sItem = "ps_fierytunic"; break; 
			case 51: sItem = "ps_fullplate_shiningarmor"; break; 
			case 52: sItem = "ps_leather_arcanetrickster"; break; 
			case 53: sItem = "ps_chainshirt_bladedancer"; break;
		}
	}
	return sItem;
}

//Max 20 / 14 / 10
string GetBootsFromList(int nRandom, int nTreasureLevel) {
	string sItem = "";
	if (nTreasureLevel <= 1) {
		switch (nRandom)
		{
			case 1: sItem = "ps_boots_dashingboots";  break;
			case 2: sItem = "ps_boots_kickingboots";  break;
			case 3: sItem = "ps_boots_sturdyfeetofpim";  break;
			case 4: sItem = "NW_IT_MBOOTS002";  break;
			case 5: sItem = "NW_IT_MBOOTS015";  break;
			case 6: sItem = "nw_it_mboots010";  break;
			case 7: sItem = "nw_it_mboots011";  break;
			case 8: sItem = "NW_IT_MBOOTS001";  break;
			case 9: sItem = "NW_IT_MBOOTS006";  break;
			case 10: sItem = "NW_IT_MBOOTS018";  break;
			case 11: sItem = "NW_IT_MBOOTS019";  break;
			case 12: sItem = "X0_IT_MBOOTS001";  break;
			case 13: sItem = "X0_IT_MBOOTS003";  break;
			case 14: sItem = "X0_IT_MBOOTS002";  break;
			case 15: sItem = "ps_boots_cursed-1";  break;
			case 16: sItem = "ps_boots_cursed-2";  break;
			case 17: sItem = "ps_boots_cursed-3";  break;
			case 18: sItem = "ps_boots_cursed-4";  break;
			case 19: sItem = "ps_bt_quickling_l";  break;
			case 20: sItem = "ps_bt_tap";  break;
		}
	} else if (nTreasureLevel <= 2) {
		switch (nRandom)
		{
			case 1: sItem = "ps_boots_stalwartdefender";  break;
			case 2: sItem = "ps_boots_dragonslippers";  break;
			case 3: sItem = "NW_IT_MBOOTS016";  break;
			case 4: sItem = "nw_it_mboots012";  break;
			case 5: sItem = "nw_it_mboots013";  break;
			case 6: sItem = "NW_IT_MBOOTS005";  break;
			case 7: sItem = "NW_IT_MBOOTS007";  break;
			case 8: sItem = "NW_IT_MBOOTS008";  break;
			case 9: sItem = "NW_IT_MBOOTS020";  break;
			case 10: sItem = "NW_IT_MBOOTS021";  break;
			case 11: sItem = "NW_IT_MBOOTS004";  break;
			case 12: sItem = "X0_IT_MBOOTS004";  break;
			case 13: sItem = "x2_nash_boot";  break;
			case 14: sItem = "ps_boots_minuteacceleration"; break;
		}
	} else {
		switch (nRandom) {
			case 1: sItem = "NW_IT_MBOOTS017";  break;
			case 2: sItem = "nw_it_mboots013";  break;
			case 3: sItem = "nw_it_mboots014";  break;
			case 4: sItem = "NW_IT_MBOOTS008";  break;
			case 5: sItem = "NW_IT_MBOOTS009";  break;
			case 6: sItem = "NW_IT_MBOOTS021";  break;
			case 7: sItem = "NW_IT_MBOOTS022";  break;
			case 8: sItem = "ps_itemset_brazen4";  break;
			case 9: sItem = "ps_itemset_fallshad1";  break;
			case 10: sItem = "ps_itemset_slaadskin1";  break;
		}
	}
	return sItem;
}

//Max 18 / 17 / 18
string GetCloaksFromList(int nRandom, int nTreasureLevel) {
	string sItem = "";
	if (nTreasureLevel <= 1) {
		switch (nRandom) {
			case 1: sItem = "ps_cloak_blackflame";  break;
			case 2: sItem = "X0_MAARCL030";  break;
			case 3: sItem = "NW_MAARCL057";  break;
			case 4: sItem = "NW_MAARCL104";  break;
			case 5: sItem = "NW_MAARCL055";  break;
			case 6: sItem = "NW_MAARCL088";  break;
			case 7: sItem = "nw_maarcl098";  break;
			case 8: sItem = "nw_maarcl097";  break;
			case 9: sItem = "nw_maarcl096";  break;
			case 10: sItem = "nw_maarcl099";  break;
			case 11: sItem = "X0_MAARCL025";  break;
			case 12: sItem = "X0_MAARCL026";  break;
			case 13: sItem = "NW_MAARCL030";  break;
			case 14: sItem = "NW_MAARCL031";  break;
			case 15: sItem = "NW_MAARCL092";  break;
			case 16: sItem = "X1_IT_MCLOAK001";  break;
			case 17: sItem = "ps_cloak_shadow";  break;
			case 18: sItem = "ps_cloak_cursed-1";  break;
		}
	} else if (nTreasureLevel <= 2) {
		switch (nRandom) {
			case 1: sItem = "ps_cloak_movement";  break;
			case 2: sItem = "X0_MAARCL038";  break;
			case 3: sItem = "X0_MAARCL039";  break;
			case 4: sItem = "NW_MAARCL105";  break;
			case 5: sItem = "NW_MAARCL106";  break;
			case 6: sItem = "NW_MAARCL089";  break;
			case 7: sItem = "NW_MAARCL090";  break;
			case 8: sItem = "X0_MAARCL027";  break;
			case 9: sItem = "X0_MAARCL028";  break;
			case 10: sItem = "nw_maarcl102";  break;
			case 11: sItem = "nw_maarcl101";  break;
			case 12: sItem = "nw_maarcl100";  break;
			case 13: sItem = "nw_maarcl103";  break;
			case 14: sItem = "X0_MAARCL034";  break;
			case 15: sItem = "x2_nash_cloak";  break;
			case 16: sItem = "NW_MAARCL093";  break;
			case 17: sItem = "NW_MAARCL094";  break;
		}
	} else {
		switch (nRandom) {
			case 1: sItem = "ps_cloak_finchscomforting";  break;
			case 2: sItem = "ps_cloak_elderdoom";  break;
			case 3: sItem = "X0_MAARCL032";  break;
			case 4: sItem = "X0_MAARCL033";  break;
			case 5: sItem = "X2_IT_MCLOAK004";  break;
			case 6: sItem = "X2_IT_MCLOAK005";  break;
			case 7: sItem = "NW_MAARCL090";  break;
			case 8: sItem = "NW_MAARCL091";  break;
			case 9: sItem = "X0_MAARCL029";  break;
			case 10: sItem = "X0_MAARCL028";  break;
			case 11: sItem = "NW_MAARCL094";  break;
			case 12: sItem = "NW_MAARCL095";  break;
			case 13: sItem = "X0_MAARCL035";  break;
			case 14: sItem = "ps_poly_clk_succubus";  break;
			case 15: sItem = "ps_itemset_fallshad2";  break;
			case 16: sItem = "ps_itemset_iggwilv1";  break;
			case 17: sItem = "ps_itemset_slaadskin2";  break;
			case 18: sItem = "ps_cloak_blades"; break; 
		}
	}
	return sItem;
}

//Max 33 / 27 / 28
string GetBracersFromList(int nRandom, int nTreasureLevel) {
	string sItem = "";
	if (nTreasureLevel <= 1) {
		switch (nRandom) {
			case 1: sItem = "ps_gloves_swordplaying";  break;
			case 2: sItem = "ps_gloves_healer";  break;
			case 3: sItem = "ps_gloves_lesserweaponhandling";  break;
			case 4: sItem = "ps_gloves_trappers";  break;
			case 5: sItem = "X0_IT_MBRACER001";  break;
			case 6: sItem = "NW_IT_MBRACER002";  break;
			case 7: sItem = "NW_IT_MBRACER007";  break;
			case 8: sItem = "NW_IT_MBRACER001";  break;
			case 9: sItem = "NW_IT_MBRACER003";  break;
			case 10: sItem = "X1_IT_MGLOVE001";  break;
			case 11: sItem = "NW_IT_MBRACER013";  break;
			case 12: sItem = "X0_IT_MGLOVE001";  break;
			case 13: sItem = "nw_it_mglove004";  break;
			case 14: sItem = "nw_it_mglove007";  break;
			case 15: sItem = "nw_it_mglove009";  break;
			case 16: sItem = "X0_IT_MGLOVE003";  break;
			case 17: sItem = "NW_IT_MGLOVE016";  break;
			case 18: sItem = "NW_IT_MGLOVE017";  break;
			case 19: sItem = "NW_IT_MGLOVE022";  break;
			case 20: sItem = "NW_IT_MGLOVE021";  break;
			case 21: sItem = "nw_it_mglove005";  break;
			case 22: sItem = "NW_IT_MGLOVE003";  break;
			case 23: sItem = "NW_IT_MGLOVE026";  break;
			case 24: sItem = "NW_IT_MGLOVE027";  break;
			case 25: sItem = "NW_IT_MBRACER012";  break;
			case 26: sItem = "x2_nash_glove";  break;
			case 27: sItem = "ps_gauntlets_anarchic";  break;
			case 28: sItem = "ps_gauntlets_axiomatic";  break;
			case 29: sItem = "ps_gauntlets_holy";  break;
			case 30: sItem = "ps_gauntlets_unholy";  break;
			case 31: sItem = "ps_gloves_cursed-1";  break;
			case 32: sItem = "ps_gloves_cursed-2";  break;
			case 33: sItem = "ps_gloves_cursed-3";  break;
		}
	} else if (nTreasureLevel <= 2) {
		switch (nRandom) {
			case 1: sItem = "ps_gloves_unholy";  break;
			case 2: sItem = "ps_gloves_weaponhandling";  break;
			case 3: sItem = "ps_gloves_greatertrapper";  break;
			case 4: sItem = "ps_gloves_reinforced";  break;
			case 5: sItem = "NW_IT_MBRACER008";  break;
			case 6: sItem = "NW_IT_MBRACER009";  break;
			case 7: sItem = "NW_IT_MBRACER004";  break;
			case 8: sItem = "NW_IT_MBRACER005";  break;
			case 9: sItem = "N2_IT_MGLOVE001";  break;
			case 10: sItem = "NW_IT_MGLOVE018";  break;
			case 11: sItem = "NW_IT_MGLOVE019";  break;
			case 12: sItem = "NW_IT_MGLOVE024";  break;
			case 13: sItem = "NW_IT_MGLOVE023";  break;
			case 14: sItem = "NW_IT_MGLOVE028";  break;
			case 15: sItem = "NW_IT_MGLOVE029";  break;
			case 16: sItem = "X0_IT_MGLOVE002";  break;
			case 17: sItem = "nw_it_mglove010";  break;
			case 18: sItem = "nw_it_mglove013";  break;
			case 19: sItem = "nw_it_mglove015";  break;
			case 20: sItem = "X0_IT_MGLOVE004";  break;
			case 21: sItem = "nw_it_mglove011";  break;
			case 22: sItem = "NW_IT_MGLOVE001";  break;
			case 23: sItem = "ps_gauntlets_anarchicgreater";  break;
			case 24: sItem = "ps_gauntlets_axiomaticgreater";  break;
			case 25: sItem = "ps_gauntlets_holygreater";  break;
			case 26: sItem = "ps_gauntlets_unholygreater";  break;
			case 27: sItem = "ps_bracer_spider"; break; 
		}
	} else {
		switch (nRandom) {
			case 1: sItem = "ps_bracer_gnarlthornssacrifice";  break;
			case 2: sItem = "ps_gloves_greaterweaponhandling";  break;
			case 3: sItem = "ps_bracer_redguard";  break;
			case 4: sItem = "NW_IT_MBRACER010";  break;
			case 5: sItem = "NW_IT_MBRACER006";  break;
			case 6: sItem = "X0_IT_MBRACER002";  break;
			case 7: sItem = "nx1_glove01";  break;
			case 8: sItem = "nx2_glove_str_04";  break;
			case 9: sItem = "nx2_glove_str_06";  break;
			case 10: sItem = "NW_IT_MGLOVE019";  break;
			case 11: sItem = "NW_IT_MGLOVE020";  break;
			case 12: sItem = "NW_IT_MGLOVE025";  break;
			case 13: sItem = "NW_IT_MGLOVE024";  break;
			case 14: sItem = "NW_IT_MGLOVE029";  break;
			case 15: sItem = "NW_IT_MGLOVE030";  break;
			case 16: sItem = "X2_IT_MGLOVE022";  break;
			case 17: sItem = "ps_gloves_handsofvampire";  break;
			case 18: sItem = "ps_gauntlet_stunning";  break;
			case 19: sItem = "ps_gauntlet_lightningstrike";  break;
			case 20: sItem = "ps_poly_brc_lolth";  break;
			case 21: sItem = "ps_itemset_aarcher2";  break;
			case 22: sItem = "ps_itemset_brazen3";  break;
			case 23: sItem = "ps_itemset_iggwilv2";  break;
			case 24: sItem = "ps_itemset_slaadskin3";  break;
			case 25: sItem = "ps_itemset_swordsaint2";  break;
			case 26: sItem = "ps_bracer_magus2"; break; 
			case 27: sItem = "ps_bracer_shields"; break;
			case 28: sItem = "ps_bracer_blinddevotion"; break; 
		}
	}
	return sItem;
}

//Max 12 / 10 / 15
string GetBeltsFromList(int nRandom, int nTreasureLevel) {
	string sItem = "";
	if (nTreasureLevel <= 1) {
		switch (nRandom) {
			case 1: sItem = "ps_belt_agility+1";  break;
			case 2: sItem = "ps_belt_agility+2";  break;
			case 3: sItem = "ps_belt_lesserguidinglight";  break;
			case 4: sItem = "ps_belt_encirclingscale";  break;
			case 5: sItem = "nx2_belt_str_02";  break;
			case 6: sItem = "nx2_belt_magebelt";  break;
			case 7: sItem = "nx2_belt_bpouch";  break;
			case 8: sItem = "NW_IT_MBELT005";  break;
			case 9: sItem = "nx2_belt_rogueharness";  break;
			case 10: sItem = "ps_belt_cursed-1";  break;
			case 11: sItem = "ps_belt_cursed-2";  break;
			case 12: sItem = "ps_belt_cursed-3";  break;
		}
	} else if (nTreasureLevel <= 2) {
		switch (nRandom) {
			case 1: sItem = "ps_belt_agility+3";  break;
			case 2: sItem = "ps_belt_agility+4";  break;
			case 3: sItem = "ps_belt_guidinglight";  break;
			case 4: sItem = "NW_IT_MBELT002";  break;
			case 5: sItem = "NW_IT_MBELT007";  break;
			case 6: sItem = "X0_IT_MBELT003";  break;
			case 7: sItem = "X0_IT_MBELT005";  break;
			case 8: sItem = "X0_IT_MBELT001";  break;
			case 9: sItem = "x2_belt_001";  break;
			case 10: sItem = "X0_IT_MBELT006";  break;
		}
	} else {
		switch (nRandom) {
			case 1: sItem = "ps_belt_agility+4";  break;
			case 2: sItem = "ps_belt_agility+5";  break;
			case 3: sItem = "ps_belt_greaterguidinglight";  break;
			case 4: sItem = "ps_belt_ceremonialuthgardt";  break;
			case 5: sItem = "NW_IT_MBELT007";  break;
			case 6: sItem = "NW_IT_MBELT008";  break;
			case 7: sItem = "X0_IT_MBELT008";  break;
			case 8: sItem = "X0_IT_MBELT007";  break;
			case 9: sItem = "X0_IT_MBELT004";  break;
			case 10: sItem = "ps_itemset_aarcher1";  break;
			case 11: sItem = "ps_belt_inertial"; break;
			case 12: sItem = "ps_belt_lion"; break;
			case 13: sItem = "ps_belt_raumathar"; break;
			case 14: sItem = "ps_belt_construct"; break;
			case 15: sItem = "ps_belt_faraneyth"; break;
		}
	}
	return sItem;
}

//Max 17 / 14 / 13
string GetHelmetsFromList(int nRandom, int nTreasureLevel) {
	string sItem = "";
	if (nTreasureLevel <= 1) {
		switch (nRandom) {
			case 1: sItem = "ps_helmet_blindsight";  break;
			case 2: sItem = "ps_helmet_goldencirclet";  break;
			case 3: sItem = "x2_it_adahelm";  break;
			case 4: sItem = "NW_ARMHE012";  break;
			case 5: sItem = "X0_ARMHE009";  break;
			case 6: sItem = "X0_ARMHE016";  break;
			case 7: sItem = "NW_ARMHE011";  break;
			case 8: sItem = "X0_ARMHE001";  break;
			case 9: sItem = "NW_ARMHE008";  break;
			case 10: sItem = "ps_hat_friendship";  break;
			case 11: sItem = "ps_helm_bewilderment";  break;
			case 12: sItem = "ps_helm_blindness";  break;
			case 13: sItem = "ps_helm_hopelessness";  break;
			case 14: sItem = "ps_helm_terror";  break;
			case 15: sItem = "ps_helmfarseeing";  break;
			case 16: sItem = "ps_helmet_cursed-1";  break;
			case 17: sItem = "ps_helmet_cursed-2";  break;
		}
	} else if (nTreasureLevel <= 2) {
		switch (nRandom) {
			case 1: sItem = "ps_helmet_aellonsthinkinghat";  break;
			case 2: sItem = "ps_helmet_anagrysmindmaze";  break;
			case 3: sItem = "ps_helmet_helmofdarkness";  break;
			case 4: sItem = "ps_helmet_shroudofnight";  break;
			case 5: sItem = "ps_helmet_thieveshood";  break;
			case 6: sItem = "X0_ARMHE014";  break;
			case 7: sItem = "n2_helm_finch";  break;
			case 8: sItem = "X0_ARMHE010";  break;
			case 9: sItem = "nx2_helm_int_06";  break;
			case 10: sItem = "X0_ARMHE002";  break;
			case 11: sItem = "X0_ARMHE013";  break;
			case 12: sItem = "X2_ARMHE002";  break;
			case 13: sItem = "NW_IT_NOVEL004";  break;
			case 14: sItem = "NW_ARMHE009";  break;
		}
	} else {
		switch (nRandom) 	{
			case 1: sItem = "ps_helmet_cowlofwarding";  break;
			case 2: sItem = "X0_ARMHE010";  break;
			case 3: sItem = "nx2_helm_int_06";  break;
			case 4: sItem = "X0_ARMHE012";  break;
			case 5: sItem = "N2_ARHE001";  break;
			case 6: sItem = "x2_helm_002";  break;
			case 7: sItem = "ps_helmet_actions";  break;
			case 8: sItem = "ps_itemset_brazen2";  break;
			case 9: sItem = "ps_itemset_fallshad3";  break;
			case 10: sItem = "ps_itemset_iggwilv3";  break;
			case 11: sItem = "ps_helmet_eye"; break;
			case 12: sItem = "ps_helm_chromatic"; break;
			case 13: sItem = "ps_helm_coven"; break; 
		}
	}
	return sItem;
}

//Max 37 / 23 / 13
string GetShieldsFromList(int nRandom, int nTreasureLevel) {
	string sItem = "";
	if (nTreasureLevel <= 1) {
		switch (nRandom) {
			case 1: sItem = "ps_towershield_astraldrift";  break;
			case 2: sItem = "ps_lightshield_astraldrift";  break;
			case 3: sItem = "ps_heavyshield_astraldrift";  break;
			case 4: sItem = "mwa_shhv_drk_3";  break;
			case 5: sItem = "mwa_shhv_dsk_3";  break;
			case 6: sItem = "X2_IT_IWOODSHLDL";  break;
			case 7: sItem = "NW_ASHLW001";  break;
			case 8: sItem = "NW_ASHMLW002";  break;
			case 9: sItem = "NW_ASHMLW008";  break;
			case 10: sItem = "X0_ASHMLW003";  break;
			case 11: sItem = "mwa_shhv_zal_3";  break;
			case 12: sItem = "mwa_shlt_drk_3";  break;
			case 13: sItem = "mwa_shlt_dsk_3";  break;
			case 14: sItem = "NW_ASHMSW005";  break;
			case 15: sItem = "x2_it_ironwshlds";  break;
			case 16: sItem = "NW_ASHSW001";  break;
			case 17: sItem = "NW_ASHMSW002";  break;
			case 18: sItem = "NW_ASHMSW008";  break;
			case 19: sItem = "NW_ASHMSW003";  break;
			case 20: sItem = "nw_ashmsw010";  break;
			case 21: sItem = "nw_ashmsw011";  break;
			case 22: sItem = "mwa_shtw_drk_3";  break;
			case 23: sItem = "mwa_shtw_dsk_3";  break;
			case 24: sItem = "NW_ASHMTO005";  break;
			case 25: sItem = "nw_ashmto010";  break;
			case 26: sItem = "nw_ashmto011";  break;
			case 27: sItem = "x2_it_ironwshldt";  break;
			case 28: sItem = "NW_ASHTO001";  break;
			case 29: sItem = "NW_ASHMTO002";  break;
			case 30: sItem = "NW_ASHMTO008";  break;
			case 31: sItem = "ps_shield_elements";  break;
			case 32: sItem = "ps_shield_holy";  break;
			case 33: sItem = "ps_shieldofdeflection";  break;
			case 34: sItem = "ps_heavyshield_cursed-1";  break;
			case 35: sItem = "ps_lightshield_cursed-1";  break;
			case 36: sItem = "ps_towershield_cursed-1";  break;
			case 37: sItem = "ps_towershield_cursed-2";  break;
		}
	} else if (nTreasureLevel <= 2) {
		switch (nRandom) {
			case 1: sItem = "ps_heavyshield_umberhulk";  break;
			case 2: sItem = "ps_heavyshield_silver";  break;
			case 3: sItem = "ps_lightshield_mithral";  break;
			case 4: sItem = "ps_lightshield_umberhulk";  break;
			case 5: sItem = "ps_towershield_umberhulk";  break;
			case 6: sItem = "mwa_shhv_ada_4";  break;
			case 7: sItem = "NW_ASHMLW009";  break;
			case 8: sItem = "X0_ASHMLW001";  break;
			case 9: sItem = "NW_ASHMLW005";  break;
			case 10: sItem = "NW_ASHMLW004";  break;
			case 11: sItem = "NW_ASHMLW007";  break;
			case 12: sItem = "mwa_shlt_ada_4";  break;
			case 13: sItem = "NW_ASHMSW004";  break;
			case 14: sItem = "NW_ASHMSW009";  break;
			case 15: sItem = "NW_ASHMSW006";  break;
			case 16: sItem = "X0_ASHMSW001";  break;
			case 17: sItem = "mwa_shlt_zal_3";  break;
			case 18: sItem = "mwa_shtw_ada_4";  break;
			case 19: sItem = "NW_ASHMTO003";  break;
			case 20: sItem = "X0_ASHMTO001";  break;
			case 21: sItem = "NW_ASHMTO009";  break;
			case 22: sItem = "NW_ASHMTO004";  break;
			case 23: sItem = "NW_ASHMTO007";  break;
		}
	} else {
		switch (nRandom) {
			case 1: sItem = "ps_lightshield_void";  break;
			case 2: sItem = "ps_towershield_browndragon";  break;
			case 3: sItem = "ps_towershield_chaosshield";  break;
			case 4: sItem = "NW_ASHMLW006";  break;
			case 5: sItem = "X0_ASHMLW001";  break;
			case 6: sItem = "X0_ASHMLW002";  break;
			case 7: sItem = "NW_ASHMLW003";  break;
			case 8: sItem = "X0_ASHMSW001";  break;
			case 9: sItem = "X0_ASHMSW002";  break;
			case 10: sItem = "NW_ASHMTO006";  break;
			case 11: sItem = "X0_ASHMTO002";  break;
			case 12: sItem = "X0_ASHMTO001";  break;
			case 13: sItem = "ps_heavyshield_nullifier"; break;
		}
	}
	return sItem;
}

//Max 70 / 55 / 46
string GetMagicJewelryFromList(int nRandom, int nTreasureLevel) {
	string sItem = "";
	if (nTreasureLevel <= 1) {
		switch (nRandom) {
			case 1: sItem = "ps_amulet_lesserhealth";  break;
			case 2: sItem = "ps_ring_bonering";  break;
			case 3: sItem = "ps_ring_acidresistancelesser";  break;
			case 4: sItem = "ps_ring_lessercharming";  break;
			case 5: sItem = "ps_ring_coldresistancelesser";  break;
			case 6: sItem = "ps_ring_electricresistancelesser";  break;
			case 7: sItem = "ps_ring_fireresistancelesser";  break;
			case 8: sItem = "ps_ring_sonicresistancelesser";  break;
			case 9: sItem = "ps_ring_purpledragonsring";  break;
			case 10: sItem = "ps_ring_lesserarcher";  break;
			case 11: sItem = "ps_ring_lesserbrawler";  break;
			case 12: sItem = "ps_ring_lesserswordsman";  break;
			case 13: sItem = "ps_ring_charming";  break;
			case 14: sItem = "ps_ring_diseaseresistance";  break;
			case 15: sItem = "NW_IT_MNECK001";  break;
			case 16: sItem = "NW_IT_MNECK012";  break;
			case 17: sItem = "X0_IT_MNECK001";  break;
			case 18: sItem = "nw_it_mneck024";  break;
			case 19: sItem = "nw_it_mneck025";  break;
			case 20: sItem = "X2_IT_MNECK001";  break;
			case 21: sItem = "X0_IT_MNECK005";  break;
			case 22: sItem = "NW_IT_MNECK020";  break;
			case 23: sItem = "NW_IT_MNECK023";  break;
			case 24: sItem = "X0_IT_MNECK007";  break;
			case 25: sItem = "X0_IT_MNECK002";  break;
			case 26: sItem = "X0_IT_MNECK004";  break;
			case 27: sItem = "X2_IT_MNECK005";  break;
			case 28: sItem = "NW_IT_MNECK003";  break;
			case 29: sItem = "NW_IT_MNECK007";  break;
			case 30: sItem = "NW_IT_MNECK008";  break;
			case 31: sItem = "NW_IT_MNECK021";  break;
			case 32: sItem = "NW_IT_MNECK016";  break;
			case 33: sItem = "NW_IT_MNECK006";  break;
			case 34: sItem = "NW_IT_MRING021";  break;
			case 35: sItem = "NW_IT_MRING006";  break;
			case 36: sItem = "NW_IT_MRING014";  break;
			case 37: sItem = "ps_ring_necro";  break;
			case 38: sItem = "ps_ring_nullification";  break;
			case 39: sItem = "ps_ring_summon";  break;
			case 40: sItem = "NW_IT_MRING010";  break;
			case 41: sItem = "NW_IT_MRING009";  break;
			case 42: sItem = "n2_it_mring006";  break;
			case 43: sItem = "n2_it_mring002";  break;
			case 44: sItem = "n2_it_mring003";  break;
			case 45: sItem = "X0_IT_MRING005";  break;
			case 46: sItem = "nw_it_mring024";  break;
			case 47: sItem = "nw_it_mring025";  break;
			case 48: sItem = "NW_IT_MRING012";  break;
			case 49: sItem = "NW_IT_MRING011";  break;
			case 50: sItem = "NW_IT_MRING005";  break;
			case 51: sItem = "NW_IT_MRING001";  break;
			case 52: sItem = "NW_IT_MRING008";  break;
			case 53: sItem = "NW_IT_MRING031";  break;
			case 54: sItem = "NW_IT_MRING013";  break;
			case 55: sItem = "n2_it_mring009";  break;
			case 56: sItem = "n2_it_mring008";  break;
			case 57: sItem = "n2_it_mring007";  break;
			case 58: sItem = "NW_IT_NOVEL001";  break;
			case 59: sItem = "NW_IT_MRING022";  break;
			case 60: sItem = "ps_ring_unluck";  break;
			case 61: sItem = "ps_neclase_cursed-1";  break;
			case 62: sItem = "ps_neclase_cursed-2";  break;
			case 63: sItem = "ps_neclase_cursed-3";  break;
			case 64: sItem = "ps_ring_cursed-1";  break;
			case 65: sItem = "ps_ring_cursed-2";  break;
			case 66: sItem = "ps_ring_cursed-3";  break;
			case 67: sItem = "ps_poly_mg_abylt";  break;
			case 68: sItem = "ps_ring_ultravision"; break;
			case 69: sItem = "ps_misc_hornofvalkyrie"; break;
			case 70: sItem = "ps_ring_bells"; break; 
		}
	} else if (nTreasureLevel <= 2) {
		switch (nRandom) {
			case 1: sItem = "ps_amulet_health";  break;
			case 2: sItem = "ps_amulet_protecteddalliances";  break;
			case 3: sItem = "ps_amulet_medallionthought";  break;
			case 4: sItem = "ps_ring_shieldother";  break;
			case 5: sItem = "ps_ring_acidresistance";  break;
			case 6: sItem = "ps_ring_archer";  break;
			case 7: sItem = "ps_ring_brawler";  break;
			case 8: sItem = "ps_ring_coldresistance";  break;
			case 9: sItem = "ps_ring_electricresistance";  break;
			case 10: sItem = "ps_ring_fireresistance";  break;
			case 11: sItem = "ps_ring_freedom";  break;
			case 12: sItem = "ps_ring_evasion";  break;
			case 13: sItem = "ps_ring_sonicresistance";  break;
			case 14: sItem = "ps_ring_swordsman";  break;
			case 15: sItem = "ps_ring_undeadcontrol";  break;
			case 16: sItem = "NW_IT_MNECK013";  break;
			case 17: sItem = "NW_IT_MNECK014";  break;
			case 18: sItem = "NW_IT_MNECK005";  break;
			case 19: sItem = "nw_it_mneck026";  break;
			case 20: sItem = "nw_it_mneck027";  break;
			case 21: sItem = "X2_IT_MNECK002";  break;
			case 22: sItem = "NW_IT_MNECK022";  break;
			case 23: sItem = "NW_IT_MNECK033";  break;
			case 24: sItem = "NW_IT_MNECK009";  break;
			case 25: sItem = "NW_IT_MNECK010";  break;
			case 26: sItem = "NW_IT_MNECK018";  break;
			case 27: sItem = "NW_IT_MNECK017";  break;
			case 28: sItem = "X0_IT_MRING007";  break;
			case 29: sItem = "X0_IT_MRING009";  break;
			case 30: sItem = "NW_IT_MRING023";  break;
			case 31: sItem = "x2_nash_ring";  break;
			case 32: sItem = "NW_IT_MRING015";  break;
			case 33: sItem = "NW_IT_MRING016";  break;
			case 34: sItem = "n2_it_mring004";  break;
			case 35: sItem = "n2_it_mring005";  break;
			case 36: sItem = "nw_it_mring026";  break;
			case 37: sItem = "nw_it_mring027";  break;
			case 38: sItem = "NW_IT_MRING007";  break;
			case 39: sItem = "NW_IT_MRING003";  break;
			case 40: sItem = "X0_IT_MRING011";  break;
			case 41: sItem = "NW_IT_MRING018";  break;
			case 42: sItem = "NW_IT_MRING019";  break;
			case 43: sItem = "NW_IT_MRING032";  break;
			case 44: sItem = "n2_IT_MRING001";  break;
			case 45: sItem = "n2_it_mring010";  break;
			case 46: sItem = "n2_it_mring011";  break;
			case 47: sItem = "X1_IT_MRING002";  break;
			case 48: sItem = "X1_IT_MRING001";  break;
			case 49: sItem = "x2_ring_pet";  break;
			case 50: sItem = "ps_poly_mg_abyl";  break;
			case 51: sItem = "ps_poly_mg_abyh";  break;
			case 52: sItem = "ps_amulet_negativechain"; break;
			case 53: sItem = "ps_ring_vex"; break;
			case 54: sItem = "ps_ring_bell"; break; 
			case 55: sItem = "ps_ring_wedding10"; break;
		}
	} else {
		switch (nRandom) {
			case 1: sItem = "ps_amulet_scarabgreaterprotection";  break;
			case 2: sItem = "ps_amulet_greaterhealth";  break;
			case 3: sItem = "ps_ring_acidresistancegreater";  break;
			case 4: sItem = "ps_ring_coldresistancegreater";  break;
			case 5: sItem = "ps_ring_electricresistancegreate";  break;
			case 6: sItem = "ps_ring_fireresistancegreater";  break;
			case 7: sItem = "ps_ring_sonicresistancegreater";  break;
			case 8: sItem = "ps_ring_imadrielsrespite";  break;
			case 9: sItem = "ps_ring_energyresist";  break;
			case 10: sItem = "ps_ring_ninelives";  break;
			case 11: sItem = "NW_IT_MNECK014";  break;
			case 12: sItem = "NW_IT_MNECK015";  break;
			case 13: sItem = "X0_IT_MNECK006";  break;
			case 14: sItem = "NW_IT_MNECK034";  break;
			case 15: sItem = "nx1_amulet001";  break;
			case 16: sItem = "nw_it_mneck027";  break;
			case 17: sItem = "nw_it_mneck028";  break;
			case 18: sItem = "NW_IT_MNECK010";  break;
			case 19: sItem = "NW_IT_MNECK011";  break;
			case 20: sItem = "NW_IT_MNECK019";  break;
			case 21: sItem = "NW_IT_MNECK004";  break;
			case 22: sItem = "NW_IT_MNECK002";  break;
			case 23: sItem = "NW_IT_MNECK018";  break;
			case 24: sItem = "NW_IT_MRING029";  break;
			case 25: sItem = "nx1_ring16";  break;
			case 26: sItem = "NW_IT_MRING016";  break;
			case 27: sItem = "NW_IT_MRING017";  break;
			case 28: sItem = "nw_it_mring027";  break;
			case 29: sItem = "nw_it_mring028";  break;
			case 30: sItem = "NW_IT_MRING019";  break;
			case 31: sItem = "NW_IT_MRING020";  break;
			case 32: sItem = "NW_IT_MRING033";  break;
			case 33: sItem = "nx1_ring12";  break;
			case 34: sItem = "ps_poly_mg_abyg";  break;
			case 35: sItem = "ps_poly_am_maglub";  break;
			case 36: sItem = "ps_itemset_celglory1";  break;
			case 37: sItem = "ps_itemset_celglory2";  break;
			case 38: sItem = "ps_itemset_celglory3";  break;
			case 39: sItem = "ps_amulet_mighty"; break;
			case 40: sItem = "ps_ring_zero"; break;
			case 41: sItem = "ps_ring_devil"; break; 
			case 42: sItem = "ps_amulet_crimson"; break; 
			case 43: sItem = "ps_ring_pi"; break; 
			case 44: sItem = "ps_amulet_mohoin"; break;
			case 45: sItem = "ps_amulet_Kaleido"; break; 
			case 46: sItem = "ps_ring_claw"; break; 
		}
	}
	return sItem;
}

//Max 36 / 13 / 17
string GetMiscFromList(int nRandom, int nTreasureLevel) {
	string sItem = "";
	if (nTreasureLevel <= 1) {
		switch (nRandom)
		{
			case 1: sItem = "ps_container_magicpouch";  break;
			case 2: sItem = "ps_container_lesserbag";  break;
			case 3: sItem = "ps_instrument_canaithmandolin";  break;
			case 4: sItem = "ps_instrument_dosslute";  break;
			case 5: sItem = "ps_instrument_lingeringdrum";  break;
			case 6: sItem = "ps_instrument_hauntingdrum";  break;
			case 7: sItem = "ps_instrument_fifeblasting";  break;
			case 8: sItem = "ps_instrument_lingeringflute";  break;
			case 9: sItem = "ps_instrument_fochluchanbandore";  break;
			case 10: sItem = "ps_instrument_lingeringlute";  break;
			case 11: sItem = "ps_instrument_charmlute";  break;
			case 12: sItem = "ps_instrument_macfuirmidhcithern";  break;
			case 13: sItem = "ps_misc_alchemistpoisonset";  break;
			case 14: sItem = "ps_misc_bindedfang";  break;
			case 15: sItem = "ps_misc_iounstone01";  break;
			case 16: sItem = "ps_misc_iounstone02";  break;
			case 17: sItem = "ps_misc_voodoodoll";  break;
			case 18: sItem = "ps_misc_exoticperfume";  break;
			case 19: sItem = "ps_misc_iounstone03";  break;
			case 20: sItem = "ps_misc_ghoulshand";  break;
			case 21: sItem = "ps_misc_impskull";  break;
			case 22: sItem = "ps_misc_iounstone04";  break;
			case 23: sItem = "ps_misc_iounstone05";  break;
			case 24: sItem = "ps_misc_iounstone06";  break;
			case 25: sItem = "ps_misc_iounstone07";  break;
			case 26: sItem = "X0_IT_MSMLMISC01";  break;
			case 27: sItem = "X0_IT_MSMLMISC02";  break;
			case 28: sItem = "nx2_misc_lifecoin";  break;
			case 29: sItem = "X0_IT_MTHNMISC04";  break;
			case 30: sItem = "X0_IT_MTHNMISC05";  break;
			case 31: sItem = "X0_IT_MTHNMISC06";  break;
			case 32: sItem = "X0_IT_MTHNMISC13";  break;
			case 33: sItem = "X0_IT_MSMLMISC05";  break;
			case 34: sItem = "X0_IT_MTHNMISC21";  break;
			case 35: sItem = "ps_scripture_unbinding";  break;
			case 36: sItem = "ps_rock-cursed-1";  break;
		}
	} else if (nTreasureLevel <= 2) {
		switch (nRandom) {
			case 1: sItem = "ps_container_magicbag";  break;
			case 2: sItem = "ps_container_greaterbag";  break;
			case 3: sItem = "ps_instrument_austruthflute";  break;
			case 4: sItem = "ps_misc_flameberry";  break;
			case 5: sItem = "ps_misc_iceberry";  break;
			case 6: sItem = "nx2_misc_lifecoin";  break;
			case 7: sItem = "X0_IT_MTHNMISC14";  break;
			case 8: sItem = "X0_IT_MSMLMISC03";  break;
			case 9: sItem = "X0_IT_MSMLMISC06";  break;
			case 10: sItem = "NW_IT_MSMLMISC05";  break;
			case 11: sItem = "ps_misc_magickeenscabbard"; break;
			case 12: sItem = "ps_book_otherwordly"; break; 
			case 13: sItem = "ps_misc_gemofshrapnels"; break; 
		}
	} else {
		switch (nRandom) {
			case 1: sItem = "NW_IT_CONTAIN006";  break;
			case 2: sItem = "ps_misc_lichslyrics";  break;
			case 3: sItem = "ps_misc_magicelectrifier";  break;
			case 4: sItem = "nx2_misc_lifecoin";  break;
			case 5: sItem = "ps_misc_shapersalembic"; break;
			case 6: sItem = "ps_misc_shapersdecensor"; break;
			case 7: sItem = "ps_misc_shapersretort"; break;
		}
	}
	return sItem;
}