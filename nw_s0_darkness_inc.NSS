
#include "x2_inc_spellhook"
const int DESTROY_LIGHT = 0;
const int DESTROY_DARK = 1;
const int DESTROY_BOTH = 2;
const int DESTROY_NONE = 3;
const int ELADRIN_FORM_ID = 1246;
const int CROWN_OF_FLAMES_ID =1656;

int LvDRoll(int nLightCL, int nDarkCL, int bHoly){
	nLightCL += d20();
	nDarkCL += d20();
	int nDiff = nLightCL - nDarkCL;
	if (nDiff > -3 && nDiff < 3){
		if (!bHoly) return DESTROY_BOTH;
		else return DESTROY_DARK;
	}
	else if (nLightCL > nDarkCL) 
		return DESTROY_DARK;
	
	if (bHoly) return DESTROY_NONE;
	return DESTROY_LIGHT;
}

void LvDResult(object oDark, object oLight, object oDarkCaster, object oLightCaster, int LvD){
	string sLightMessage;
	string sDarkMessage;
	switch (LvD){
		case DESTROY_LIGHT:{
			sLightMessage = "The Darkness effect has dispelled your Light!";
			sDarkMessage = "Your Darkness effect has dispelled the Light!";
			break;
		}
		case DESTROY_DARK:{
			sLightMessage = "Your Light effect has dispelled the Darkness!";
			sDarkMessage = "The Light effect has dispelled your Darkness!";
			break;
		}
		case DESTROY_BOTH:{
			sLightMessage = "The Darkness and your Light have cancelled each other!";
			sDarkMessage = "The Light and your Darkness have cancelled each other!";
			break;
		}
		case DESTROY_NONE:{
			sLightMessage = "Your Holy Light has failed to destroy the Darkness effect!";
			sDarkMessage = "Your Darkness effect cannot destroy the Holy Light!";
			break;
		}
	}
	
	if (GetIsObjectValid(oLightCaster))
		SendMessageToPC(oLightCaster, sLightMessage);
	if (GetIsObjectValid(oDarkCaster))
		SendMessageToPC(oDarkCaster, sDarkMessage);
		
	if (LvD == DESTROY_LIGHT || LvD == DESTROY_BOTH)
		DestroyObject(oLight);
	if (LvD == DESTROY_DARK || LvD == DESTROY_BOTH)
		DestroyObject(oDark);
}

void DoLightVsDarkness(object oDark, object oLight){

	object oDarkCaster = GetAreaOfEffectCreator(oDark);
	struct dSpellData DarkData = GetSpellDataForAoE("Darkness", oDarkCaster);
	int nDarkId = DarkData.nId;
	int nDarkCL = DarkData.nCL;
	if (nDarkId == SPELL_RACIAL_DARKNESS && 
		GetHasFeat(FEAT_OUTSIDER_BLOODLINE_FIENDISH, oDarkCaster, TRUE))
			nDarkCL += 5;
	
	object oLightCaster = GetAreaOfEffectCreator(oLight);
	struct dSpellData LightData = GetSpellDataForAoE("Light", oLightCaster);
	int nLightId = LightData.nId;
	int nLightCL = LightData.nCL;
	int bHoly = (nLightId == ELADRIN_FORM_ID || nLightId == CROWN_OF_FLAMES_ID);
	if (bHoly || (nLightId == SPELL_RACIAL_LIGHT && 
		GetHasFeat(FEAT_OUTSIDER_BLOODLINE_CELESTIAL, oLightCaster, TRUE)))
			nLightCL += 5;
			
	int LvD = LvDRoll(nLightCL, nDarkCL, bHoly);
	
	LvDResult(oDark, oLight, oDarkCaster, oLightCaster, LvD);
	
}

void ScanForLight(){
	int nLightId;
    object oLight = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_AREA_OF_EFFECT);
    while (GetIsObjectValid(oLight)) {
		nLightId = GetAreaOfEffectSpellId(oLight);
		if (nLightId == SPELL_LIGHT || nLightId == SPELL_RACIAL_LIGHT ||
			nLightId == ELADRIN_FORM_ID || nLightId == CROWN_OF_FLAMES_ID)
				DoLightVsDarkness(OBJECT_SELF, oLight);
	
	oLight = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_AREA_OF_EFFECT);
	}
}
