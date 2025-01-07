

#include "nw_s2_light_inc"

void main(){

	object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
	int nDur = PS_GetCasterLevel(oCaster);

	int nId = GetSpellId();
	int bDivineLight = FALSE;
	int nRace = GetSubRace(oCaster);
	if (nId == SPELL_RACIAL_LIGHT){
		nDur = GetTotalLevels(oCaster, TRUE); 
		if (nRace == 13 || nRace == 203) bDivineLight = TRUE;
	}
	
	if (GetMetaMagicFeat() == METAMAGIC_EXTEND) nDur *= 2;
	
	float fDur = HoursToSeconds(nDur);
	
	if (GetIsObjectValid(oTarget))
		ApplyLight(oCaster, oTarget, nId, fDur, bDivineLight);
}