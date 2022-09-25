#include "nwnx_bg"


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
  	nwnx_bg_CreateFinesseRule(160,FEAT_INVALID,TRUE);
    nwnx_bg_CreateFinesseRule(161,FEAT_INVALID,TRUE);
    nwnx_bg_CreateFinesseRule(162,FEAT_INVALID,TRUE);
    nwnx_bg_CreateFinesseRule(163,FEAT_INVALID,TRUE);
    nwnx_bg_CreateFinesseRule(164,FEAT_INVALID,TRUE);
    nwnx_bg_CreateFinesseRule(165,FEAT_INVALID,TRUE);
    nwnx_bg_CreateFinesseRule(170,FEAT_INVALID,TRUE);
    nwnx_bg_CreateFinesseRule(173,FEAT_INVALID,TRUE);
    nwnx_bg_CreateFinesseRule(202,FEAT_INVALID,FALSE);
	
	nwnx_bg_LogFinesseRules();

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