#include "x2_inc_spellhook"



int GetAcidFogDamage(object oCaster, int nCL){
	
    int nMetaMagic = GetMetaMagicFeat();
	int nPML = GetPureMageLevels(oCaster);
	
    if (!GetIsObjectValid(GetSpellCastItem())){
		if (nCL < ITEM_MIN_CL) 
			nCL = ITEM_MIN_CL;
	}
		
	int nDamage = d4(nCL / 3) + d4(nPML / 3);
		
	if (nMetaMagic == METAMAGIC_MAXIMIZE){
		nDamage = ((nCL / 3) + (nPML / 3)) * 4;
	} else if (nMetaMagic == METAMAGIC_EMPOWER){
		nDamage += nDamage / 2;
	}
	
	return nDamage;
}