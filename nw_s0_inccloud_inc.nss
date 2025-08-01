#include "X0_I0_SPELLS"
#include "ps_inc_functions"

int GetIncCloudDamage(object oCaster, int nCL){ 
	
	// according to description in tlk, minimum damage is 20 CL worth
	if (nCL < 20) nCL = 20;
	int nPML = GetPureMageLevels(oCaster);
	int nMetaMagic = GetMetaMagicFeat();
	int nDamage = d6(nCL / 3) + d6(nPML / 9);
 
	if (nMetaMagic == METAMAGIC_MAXIMIZE)
		nDamage = ((nCL / 3) * 6) + ((nPML / 9) * 6);
	
	if (nMetaMagic == METAMAGIC_EMPOWER)
		nDamage += nDamage / 2;
	
	return nDamage;
}