#include "ps_inc_functions"
#include "aaa_constants"

const int TAC_SUITE_NONE = 0;
const int TAC_SUITE_BOW = 1;
const int TAC_SUITE_CE = 2;
const int TAC_SUITE_CLEAVE = 3;
const int TAC_SUITE_PA = 4;
const int TAC_SUITE_DISARM = 5;
const int TAC_SUITE_KD = 6;
const int TAC_BONUS_ONLY = -1;

void RemoveBonusFeats(object oSkin, int nSpecificFeat = NULL);
int GetFeatFromIprp(int iprp);
int GetIsTacIprp(int iprp);
int GetTacSuiteByDamageType(int nType);
int GetTacSuiteByWeaponCategory(object oPC, object oRHAND);
int GetWeaponCanWrapAroundorHook(int nType);
int GetWeaponIsAxeOrBackSwept(int nType);
int GetWeaponIsKick(int nType);
int GetWeaponIsPolearm(int nType);
int GetWeaponIsAccurateBlade(int nType);
int GetWeaponIsSturdyBasher(int nType);
void ApplyTacticalBonusFeat(object oSkin, int nFeat);
int GetWeaponIsTwoHanded(object oPC, object oRHAND, object oLHAND);


void ApplyTacticalBonusFeat(object oSkin, int nFeat){
	int iprp = PS_GetIpBonusFeat(nFeat);
	if (iprp == 19) return; // weapon finesse is default return if not found
	itemproperty ip = ItemPropertyBonusFeat(iprp);
	AddItemProperty(DURATION_TYPE_PERMANENT, ip, oSkin);
}

void RemoveBonusFeats(object oSkin, int nSpecificFeat = NULL){
	if (nSpecificFeat != NULL){
		int iprp = PS_GetIpBonusFeat(nSpecificFeat);
		if (iprp == 19) return;
		itemproperty ip = ItemPropertyBonusFeat(iprp);
		RemoveItemProperty(oSkin, ip);
		return;
	}
	itemproperty ip = GetFirstItemProperty(oSkin);
	int nSub;
	while (GetIsItemPropertyValid(ip)){
		if (GetItemPropertyType(ip) == ITEM_PROPERTY_BONUS_FEAT){
			nSub = GetItemPropertySubType(ip);
			if (GetIsTacIprp(nSub))
				RemoveItemProperty(oSkin, ip);
		}
		ip = GetNextItemProperty(oSkin);
	}
}


int GetFeatFromIprp(int iprp){
	switch (iprp){
		case 89: return FEAT_RAPID_RELOAD;
		case 44: return FEAT_COMBAT_EXPERTISE;
		case 28: return FEAT_DISARM;
		case 2: return FEAT_CLEAVE;
		case 6: return FEAT_KNOCKDOWN;
		case 16: return FEAT_POWER_ATTACK;
		case 17: return FEAT_TWO_WEAPON_FIGHTING;
	}
	return NULL;
}

int GetIsTacIprp(int iprp){
	int nFeat = GetFeatFromIprp(iprp);
	switch (nFeat){
		case FEAT_COMBAT_EXPERTISE: return TRUE;
		case FEAT_DISARM: return TRUE;
		case FEAT_CLEAVE: return TRUE;
		case FEAT_KNOCKDOWN: return TRUE;
		case FEAT_POWER_ATTACK: return TRUE;
	}
	return FALSE;
}

int GetWeaponIsTwoHanded(object oPC, object oRHAND, object oLHAND){
	if (oLHAND != OBJECT_INVALID || oRHAND == OBJECT_INVALID) return FALSE;
	int nPCsize = GetCreatureSize(oPC);
	// cannot two hand a weapon that is smaller than you.
	if (nPCsize > IPGetWeaponSize(oRHAND)) return FALSE;
	// rapier is a special case, only small characters can two-hand them
	if (GetBaseItemType(oRHAND) == BASE_ITEM_RAPIER && nPCsize > 2) return FALSE;
	return TRUE;
}

int GetTacSuiteByWeaponCategory(object oPC, object oRHAND){
	
	if (oRHAND == OBJECT_INVALID)return TAC_SUITE_NONE;
	
	int nType = GetBaseItemType(oRHAND);
	// if it's a non-weapon item, like a mug or rake or something, no action
	if (StringToInt(Get2DAString("baseitems", "NumDice", nType)) < 1){
		return TAC_SUITE_NONE;
	} else if (IPGetIsRangedWeapon(oRHAND)){ 
		return TAC_SUITE_BOW;
	} else if (GetWeaponIsAccurateBlade(nType)){
		return TAC_SUITE_CE;
	} else if (GetWeaponIsAxeOrBackSwept(nType)){
		return TAC_SUITE_CLEAVE;
	} else if (GetWeaponIsSturdyBasher(nType)){
		return TAC_SUITE_PA;
	} else if (GetWeaponCanWrapAroundorHook(nType)){
		return TAC_SUITE_DISARM;
	} else if (GetWeaponIsPolearm(nType)){
		return TAC_SUITE_KD;
	} else if (GetWeaponIsKick(nType)){
		return TAC_SUITE_KD;
	} else {
		return GetTacSuiteByDamageType(nType);	
	}
}

int GetTacSuiteByDamageType(int nType){
	if (IPGetIsBludgeoningWeapon(OBJECT_INVALID, nType, FALSE)) return TAC_SUITE_PA;
	else if (IPGetIsSlashingWeapon(OBJECT_INVALID, nType, FALSE)) return TAC_SUITE_CLEAVE;
	else return TAC_SUITE_CE;
}

int GetWeaponCanWrapAroundorHook(int nType){
	int nRet = FALSE;
	switch (nType){
		case BASE_ITEM_WHIP: 
		case BASE_ITEM_WHIP_SCOD: 
		case BASE_ITEM_LIGHTFLAIL: 
		case BASE_ITEM_HEAVYFLAIL: 
		case BASE_ITEM_FLAIL: 
		case BASE_ITEM_TINYFLAIL:
		case BASE_ITEM_INFANTRYFLAIL:
		case BASE_ITEM_SEIGEFLAIL:
		case BASE_ITEM_KAMA: 
		case BASE_ITEM_SICKLE:
		case BASE_ITEM_CREATURETALON_TINY: 
		case BASE_ITEM_CREATURETALON_SMl: 
		case BASE_ITEM_CREATURETALON_MED: 
		case BASE_ITEM_CREATURETALON_LRG: 
		case BASE_ITEM_CREATURETALON_GIANT: 
		case BASE_ITEM_CREQ_PIERCE_SLASH_L: 
		case BASE_ITEM_CREQ_PIERCE_SLASH_M: 
		case BASE_ITEM_CREQ_PIERCE_SLASH_S:
	
			nRet = TRUE; break;
	}
	return nRet;
}
		
int GetWeaponIsAccurateBlade(int nType){
	int nRet = FALSE;
	switch (nType){
		case BASE_ITEM_STILETTO: 
		case BASE_ITEM_NINJATO: 
		case BASE_ITEM_ALLUSE_SWORD: 
		case BASE_ITEM_BASTARDSWORD: 
		case BASE_ITEM_CGIANT_SWORD: 
		case BASE_ITEM_DAGGER: 
		case BASE_ITEM_GREATSWORD: 
		case BASE_ITEM_LONGSWORD: 
		case BASE_ITEM_RAPIER: 
		case BASE_ITEM_SHORTSWORD: 
		case BASE_ITEM_SRR_GIANT_SWORD: 
		case BASE_ITEM_CREATUREBITE_TINY: 
		case BASE_ITEM_CREATUREBITE_SML: 
		case BASE_ITEM_CREATUREBITE_MED: 
		case BASE_ITEM_CREATUREBITE_LRG: 
		case BASE_ITEM_CREATUREBITE_GIANT: 
		case BASE_ITEM_CREQ_PIERCE_L: 
		case BASE_ITEM_CREQ_PIERCE_M: 
		case BASE_ITEM_CREQ_PIERCE_S: 
		case BASE_ITEM_CPIERCWEAPON:
			nRet = TRUE; break;
	}
	return nRet;
}

int GetWeaponIsAxeOrBackSwept(int nType){
	int nRet = FALSE;
	switch (nType){
		case BASE_ITEM_BATTLEAXE: 
		case BASE_ITEM_CGIANT_AXE: 
		case BASE_ITEM_DWARVENWARAXE: 
		case BASE_ITEM_GREATAXE: 
		case BASE_ITEM_HANDAXE: 
		case BASE_ITEM_KUKRI: 
		case BASE_ITEM_SRR_GIANT_AXE:
		case BASE_ITEM_SCIMITAR: 
		case BASE_ITEM_KATANA: 
		case BASE_ITEM_FALCHION: 
		case BASE_ITEM_ODACHI: 
		case BASE_ITEM_CREATURECLAW_TINY: 
		case BASE_ITEM_CREATURECLAW_SML: 
		case BASE_ITEM_CREATURECLAW_MED: 
		case BASE_ITEM_CREATURECLAW_LRG: 
		case BASE_ITEM_CREATURECLAW_GIANT: 
		case BASE_ITEM_CSLSHPRCWEAP: 
		case BASE_ITEM_CREQ_SLASH_L: 
		case BASE_ITEM_CREQ_SLASH_M: 
		case BASE_ITEM_CREQ_SLASH_S: 
		case BASE_ITEM_CSLASHWEAPON:
			nRet = TRUE; break;
	}
	return nRet;
}


int GetWeaponIsPolearm(int nType){
	int nRet = FALSE;
	switch (nType){
		case BASE_ITEM_GIANT_SPEAR: 
		case BASE_ITEM_GIANT_STAFF: 
		case BASE_ITEM_HALBERD: 
		case BASE_ITEM_QUARTERSTAFF:
		case BASE_ITEM_SHORTSPEAR: 
		case BASE_ITEM_SHORT_STAFF:
		case BASE_ITEM_SPEAR: 
		case BASE_ITEM_GIANT_SCYTHE:
		case BASE_ITEM_SCYTHE: 
			nRet = TRUE; break;
	}
	return nRet;
}

int GetWeaponIsKick(int nType){
	int nRet = FALSE;
	switch (nType){
		case BASE_ITEM_CREATUREKICK_TINY:
		case BASE_ITEM_CREATUREKICK_SML: 
		case BASE_ITEM_CREATUREKICK_MED: 
		case BASE_ITEM_CREATUREKICK_LRG:
		case BASE_ITEM_CREATUREKICK_GIANT:
		case BASE_ITEM_CREQ_PIERCE_BLUDGEON_L:
		case BASE_ITEM_CREQ_PIERCE_BLUDGEON_M: 
		case BASE_ITEM_CREQ_PIERCE_BLUDGEON_S: 
			nRet = TRUE; break;
	}
	return nRet;
}

int GetWeaponIsSturdyBasher(int nType){
	int nRet = FALSE;
	switch (nType){
		case BASE_ITEM_CLUB:
		case BASE_ITEM_DIREMACE: 
		case BASE_ITEM_GREATCLUB: 
		case BASE_ITEM_LIGHTHAMMER: 
		case BASE_ITEM_LIGHTMACE:
		case BASE_ITEM_MACE:
		case BASE_ITEM_MAUL:
		case BASE_ITEM_MORNINGSTAR:
		case BASE_ITEM_SRR_GIANT_CLUB:
		case BASE_ITEM_TRAINING_CLUB:
		case BASE_ITEM_WARHAMMER: 
		case BASE_ITEM_WARMACE:
		case BASE_ITEM_GIANT_WARMACE:
		case BASE_ITEM_CREATURESLAM_TINY:
		case BASE_ITEM_CREATURESLAM_SML:
		case BASE_ITEM_CREATURESLAM_MED: 
		case BASE_ITEM_CREATURESLAM_LRG: 
		case BASE_ITEM_CREATURESLAM_GIANT: 
		case BASE_ITEM_CREQ_BLUDGEON_L: 
		case BASE_ITEM_CREQ_BLUDGEON_M: 
		case BASE_ITEM_CREQ_BLUDGEON_S: 
		case BASE_ITEM_CBLUDGWEAPON: 
			nRet = TRUE; break;
	}
	return nRet;
}
