#include "x2_inc_spellhook"

int GetBladeBarrierDamage(int nCL){
	
	if (nCL > 15) nCL = 15;
	int nMetaMagic = GetMetaMagicFeat();
   
	int nDamage = d6(nCL);
	if (nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = nCL * 6;
	else if (nMetaMagic == METAMAGIC_EMPOWER) nDamage += (nDamage / 2);
	
	return nDamage;
}