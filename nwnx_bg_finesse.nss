#include "nwnx_bg"
#include "aaa_constants"

void EnableCreatureFinesse(){

  	nwnx_bg_CreateFinesseRule(160,3218,TRUE);
    nwnx_bg_CreateFinesseRule(161,3218,TRUE);
    nwnx_bg_CreateFinesseRule(162,3218,TRUE);
    nwnx_bg_CreateFinesseRule(163,3218,TRUE);
    nwnx_bg_CreateFinesseRule(164,3218,TRUE);
    nwnx_bg_CreateFinesseRule(165,3218,TRUE);
	nwnx_bg_CreateFinesseRule(166,3218,TRUE);
    nwnx_bg_CreateFinesseRule(167,3218,TRUE);
    nwnx_bg_CreateFinesseRule(168,3218,TRUE);
    nwnx_bg_CreateFinesseRule(169,3218,TRUE);
    nwnx_bg_CreateFinesseRule(170,3218,TRUE);
	nwnx_bg_CreateFinesseRule(171,3218,TRUE);
    nwnx_bg_CreateFinesseRule(172,3218,TRUE);
    nwnx_bg_CreateFinesseRule(173,3218,TRUE);
    nwnx_bg_CreateFinesseRule(174,3218,TRUE);
	nwnx_bg_LogFinesseRules();


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

    nwnx_bg_CreateFinesseRule(202);
	
	nwnx_bg_CreateFinesseRule(BASE_ITEM_GREATAXE,FEAT_DERVISH_SLASHING_BLADES,TRUE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_GREATSWORD,FEAT_DERVISH_SLASHING_BLADES,TRUE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_SCIMITAR,FEAT_DERVISH_SLASHING_BLADES,TRUE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_KATANA,FEAT_DERVISH_SLASHING_BLADES,TRUE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_BASTARDSWORD,FEAT_DERVISH_SLASHING_BLADES,TRUE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_LONGSWORD,FEAT_DERVISH_SLASHING_BLADES,TRUE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_FALCHION,FEAT_DERVISH_SLASHING_BLADES,TRUE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_BATTLEAXE,FEAT_DERVISH_SLASHING_BLADES,TRUE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_DWARVENWARAXE,FEAT_DERVISH_SLASHING_BLADES,TRUE);
	
/*Khayal*/	
	
	nwnx_bg_CreateFinesseRule(BASE_ITEM_GREATAXE,FEAT_KHAYAL_FINESSE,TRUE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_GREATSWORD,FEAT_KHAYAL_FINESSE,TRUE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_SCIMITAR,FEAT_KHAYAL_FINESSE,TRUE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_KATANA,FEAT_KHAYAL_FINESSE,TRUE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_BASTARDSWORD,FEAT_KHAYAL_FINESSE,TRUE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_LONGSWORD,FEAT_KHAYAL_FINESSE,TRUE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_FALCHION,FEAT_KHAYAL_FINESSE,TRUE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_BATTLEAXE,FEAT_KHAYAL_FINESSE,TRUE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_DWARVENWARAXE,FEAT_KHAYAL_FINESSE,TRUE);
	
	nwnx_bg_CreateFinesseRule(BASE_ITEM_SCYTHE,FEAT_KHAYAL_FINESSE,TRUE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_FLAIL,FEAT_KHAYAL_FINESSE,TRUE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_QUARTERSTAFF,FEAT_KHAYAL_FINESSE,TRUE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_SPEAR,FEAT_KHAYAL_FINESSE,TRUE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_HALBERD,FEAT_KHAYAL_FINESSE,TRUE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_WARMACE,FEAT_KHAYAL_FINESSE,TRUE);
	nwnx_bg_CreateFinesseRule(BASE_ITEM_WARHAMMER,FEAT_KHAYAL_FINESSE,TRUE);
	
	
	
	

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