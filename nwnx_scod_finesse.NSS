#include "nwnx_dae"
#include "aaa_constants"


void EnableCreatureFinesse(){

// Characters shouldn't get finesse with a weapon, even a creature weapon, that they
// need Monkey Grip to wield.
//feat 3218 = tiny, small and medium creature weapons, given to all chars w/ cr weap prof
//feat 3259 = large creature weapons, given to medium and large chars w/ cr weap prof
//feat 3260 = huge creature weapons, given only to large chars w/ cr weap prof
// These feats are given to chars in ff_update_feats if they have creature weap prof and are
// appropriate size
	
	// tiny, small, medium
  	dae_CreateFinesseRule(176,3218,TRUE);
	dae_CreateFinesseRule(173,3218,TRUE);
    dae_CreateFinesseRule(163,3218,TRUE);
    dae_CreateFinesseRule(164,3218,TRUE);
    dae_CreateFinesseRule(165,3218,TRUE);
	dae_CreateFinesseRule(170,3218,TRUE);
    dae_CreateFinesseRule(169,3218,TRUE);
	dae_CreateFinesseRule(160,3218,TRUE);
    dae_CreateFinesseRule(161,3218,TRUE);
    dae_CreateFinesseRule(162,3218,TRUE);
	dae_CreateFinesseRule(172,3218,TRUE);
	dae_CreateFinesseRule(177,3218,TRUE);
	dae_CreateFinesseRule(180,3218,TRUE);
	dae_CreateFinesseRule(181,3218,TRUE);
	dae_CreateFinesseRule(182,3218,TRUE);
	dae_CreateFinesseRule(183,3218,TRUE);
	dae_CreateFinesseRule(184,3218,TRUE);
	dae_CreateFinesseRule(186,3218,TRUE);
	dae_CreateFinesseRule(188,3218,TRUE);
	dae_CreateFinesseRule(190,3218,TRUE);
	dae_CreateFinesseRule(192,3218,TRUE);
	dae_CreateFinesseRule(193,3218,TRUE);
	dae_CreateFinesseRule(194,3218,TRUE);
	dae_CreateFinesseRule(197,3218,TRUE);
	dae_CreateFinesseRule(198,3218,TRUE);
	dae_CreateFinesseRule(199,3218,TRUE);
	
	//large
	dae_CreateFinesseRule(166,3259,TRUE);
    dae_CreateFinesseRule(167,3259,TRUE);
    dae_CreateFinesseRule(168,3259,TRUE);
	dae_CreateFinesseRule(171,3259,TRUE);
    dae_CreateFinesseRule(174,3259,TRUE);
	dae_CreateFinesseRule(178,3259,TRUE);
    dae_CreateFinesseRule(179,3259,TRUE);
	dae_CreateFinesseRule(185,3259,TRUE);
	dae_CreateFinesseRule(195,3259,TRUE);
	dae_CreateFinesseRule(200,3259,TRUE);
	
	//huge
	dae_CreateFinesseRule(187,3260,TRUE);
	dae_CreateFinesseRule(189,3260,TRUE);
	dae_CreateFinesseRule(191,3260,TRUE);
	dae_CreateFinesseRule(196,3260,TRUE);
	dae_CreateFinesseRule(201,3260,TRUE);
	
	dae_LogFinesseRules();


}
void EnableFinesse()
{/*creature weapons
		case 160:
		case 161:
		case 162:
		case 163:
		case 164:
		case 165:
		case 170:
		case 173:
*/
	//whips
    dae_CreateFinesseRule(202, 42, TRUE);
    dae_CreateFinesseRule(111, 42, TRUE);
	
	dae_CreateFinesseRule(88, 42, TRUE); // tiny flail 1d4
	dae_CreateFinesseRule(116, 42, TRUE); // small flail 1d6
	dae_CreateFinesseRule(85, 42, TRUE); // ninjato
	dae_CreateFinesseRule(86, 42, TRUE); // stiletto
 
	// This feat is applied if the conditions are correct in ff_feat_tactical_weapon_inc
	dae_CreateFinesseRule(BASE_ITEM_ODACHI, FEAT_KENJUTSU, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_SCIMITAR, FEAT_KENJUTSU, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_KATANA, FEAT_KENJUTSU, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_FALCHION, FEAT_KENJUTSU, TRUE);
	
	// This feat is applied if the conditions are correct in ff_feat_tactical_weapon_inc
	dae_CreateFinesseRule(BASE_ITEM_GIANT_SPEAR, FEAT_BOJUTSU, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_GIANT_STAFF, FEAT_BOJUTSU, TRUE); 
	dae_CreateFinesseRule(BASE_ITEM_HALBERD, FEAT_BOJUTSU, TRUE); 
	dae_CreateFinesseRule(BASE_ITEM_QUARTERSTAFF, FEAT_BOJUTSU, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_SHORTSPEAR, FEAT_BOJUTSU, TRUE); 
	dae_CreateFinesseRule(BASE_ITEM_SHORT_STAFF, FEAT_BOJUTSU, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_SPEAR, FEAT_BOJUTSU, TRUE); 
	dae_CreateFinesseRule(BASE_ITEM_GIANT_SCYTHE, FEAT_BOJUTSU, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_SCYTHE, FEAT_BOJUTSU, TRUE); 

	
	//Giant finesse. falchion and all medium weapons (but not hand and a half, ie, bastard sword, dwarf axe, and maul)
	// are finesseable for large characters. Large characters get the giant finesse feat (21920) in ps_inc_equipment.
	dae_CreateFinesseRule(BASE_ITEM_ALLUSE_SWORD, FEAT_GIANT_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_BATTLEAXE, FEAT_GIANT_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_CLUB, FEAT_GIANT_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_FALCHION, FEAT_GIANT_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_KATANA, FEAT_GIANT_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_LIGHTFLAIL, FEAT_GIANT_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_LONGSWORD, FEAT_GIANT_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_MACE, FEAT_GIANT_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_MORNINGSTAR, FEAT_GIANT_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_SCIMITAR, FEAT_GIANT_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_SHORTSPEAR, FEAT_GIANT_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_SHORT_STAFF, FEAT_GIANT_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_TRAINING_CLUB, FEAT_GIANT_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_WARHAMMER, FEAT_GIANT_FINESSE, TRUE);
	
	
	//dervish
	dae_CreateFinesseRule(BASE_ITEM_ALLUSE_SWORD, FEAT_DERVISH_SLASHING_BLADES, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_GREATAXE,FEAT_DERVISH_SLASHING_BLADES,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_GREATSWORD,FEAT_DERVISH_SLASHING_BLADES,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_SCIMITAR,FEAT_DERVISH_SLASHING_BLADES,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_KATANA,FEAT_DERVISH_SLASHING_BLADES,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_BASTARDSWORD,FEAT_DERVISH_SLASHING_BLADES,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_LONGSWORD,FEAT_DERVISH_SLASHING_BLADES,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_FALCHION,FEAT_DERVISH_SLASHING_BLADES,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_BATTLEAXE,FEAT_DERVISH_SLASHING_BLADES,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_DWARVENWARAXE,FEAT_DERVISH_SLASHING_BLADES,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_ODACHI, FEAT_DERVISH_SLASHING_BLADES, TRUE);
	
/*Khayal*/	
	
	dae_CreateFinesseRule(BASE_ITEM_GREATAXE,FEAT_KHAYAL_FINESSE,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_GREATSWORD,FEAT_KHAYAL_FINESSE,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_SCIMITAR,FEAT_KHAYAL_FINESSE,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_KATANA,FEAT_KHAYAL_FINESSE,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_BASTARDSWORD,FEAT_KHAYAL_FINESSE,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_LONGSWORD,FEAT_KHAYAL_FINESSE,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_FALCHION,FEAT_KHAYAL_FINESSE,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_BATTLEAXE,FEAT_KHAYAL_FINESSE,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_DWARVENWARAXE,FEAT_KHAYAL_FINESSE,TRUE);	
	dae_CreateFinesseRule(BASE_ITEM_SCYTHE,FEAT_KHAYAL_FINESSE,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_FLAIL,FEAT_KHAYAL_FINESSE,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_QUARTERSTAFF,FEAT_KHAYAL_FINESSE,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_SPEAR,FEAT_KHAYAL_FINESSE,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_HALBERD,FEAT_KHAYAL_FINESSE,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_WARMACE,FEAT_KHAYAL_FINESSE,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_WARHAMMER,FEAT_KHAYAL_FINESSE,TRUE);
	dae_CreateFinesseRule(BASE_ITEM_ODACHI, FEAT_KHAYAL_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_SHORT_STAFF, FEAT_KHAYAL_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_ODACHI, FEAT_KHAYAL_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_NINJATO, FEAT_KHAYAL_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_STILETTO, FEAT_KHAYAL_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_MAUL, FEAT_KHAYAL_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_TINYFLAIL, FEAT_KHAYAL_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_GIANT_SPEAR, FEAT_KHAYAL_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_GIANT_STAFF, FEAT_KHAYAL_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_GIANT_SCYTHE, FEAT_KHAYAL_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_SRR_GIANT_SWORD, FEAT_KHAYAL_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_SRR_GIANT_AXE, FEAT_KHAYAL_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_SRR_GIANT_CLUB, FEAT_KHAYAL_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_GIANT_WARMACE, FEAT_KHAYAL_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_SHORTSPEAR, FEAT_KHAYAL_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_FLAIL, FEAT_KHAYAL_FINESSE, TRUE);
	dae_CreateFinesseRule(BASE_ITEM_HEAVYFLAIL, FEAT_KHAYAL_FINESSE, TRUE);
	
	

/*White List	
	nwnx_bg_CreateFinesseRule(BASE_ITEM_SHORTSWORD);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_DAGGER);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_KUKRI);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_SICKLE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_RAPIER);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_LIGHTHAMMER);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_HANDAXE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_MACE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_KAMA);*/


}