

#include "x2_inc_spellhook"
const int DESTROY_LIGHT = 0;
const int DESTROY_DARK = 1;
const int DESTROY_BOTH = 2;
const int HOLY_LIGHT = 3;
const int ELADRIN_FORM_ID = 1246;
const int CROWN_OF_FLAMES_ID =1656;

int LvDRoll(int nLightCL, int nDarkCL){
	nLightCL += d20();
	nDarkCL += d20();
	int nDiff = nLightCL - nDarkCL;
	if (nDiff > -3 && nDiff < 3) return DESTROY_BOTH;
	else if (nLightCL > nDarkCL) return DESTROY_DARK;
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
		case HOLY_LIGHT:{
			sLightMessage = "Your Holy Light has obliterated the Darkness effect!";
			sDarkMessage = "Your Darkness effect has been obliterated by Holy Light!";
			break;
		}
	}
	
	if (GetIsObjectValid(oLightCaster))
		SendMessageToPC(oLightCaster, sLightMessage);
	if (GetIsObjectValid(oDarkCaster))
		SendMessageToPC(oDarkCaster, sDarkMessage);
		
	if (LvD == DESTROY_LIGHT || LvD == DESTROY_BOTH)
		DestroyObject(oLight);
	if (LvD == DESTROY_DARK || LvD == DESTROY_BOTH || LvD == HOLY_LIGHT){
		DestroyObject(oDark);
		return;
	}
}

void main(){
    object oDark = OBJECT_SELF;
	object oDarkCaster = GetAreaOfEffectCreator(oDark);
	struct dSpellData DarkData = GetSpellDataForAoE("Darkness", oDarkCaster);
	int nDarkId = DarkData.nId;
	int nDarkCL = DarkData.nCL;
	
	object oLightCaster;
	struct dSpellData LightData;
	int nLightId;
	int nLightCL;
	int LvD;
	
    // Scan for Light spell AoEs
	object oLight = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_AREA_OF_EFFECT);
    while (GetIsObjectValid(oLight)) {
		
		nLightId = GetAreaOfEffectSpellId(oLight);
		if (nLightId == SPELL_LIGHT || nLightId == SPELL_RACIAL_LIGHT ||
			nLightId == ELADRIN_FORM_ID || nLightId == CROWN_OF_FLAMES_ID){
			
			oLightCaster = GetAreaOfEffectCreator(oLight);
			LightData = GetSpellDataForAoE("Light", oLightCaster);
			nLightCL = LightData.nCL;
			if (nLightId == SPELL_RACIAL_LIGHT &&
				GetHasFeat(FEAT_OUTSIDER_BLOODLINE_CELESTIAL, oLightCaster, TRUE)) 
					nLightCL += 5;
			

			if (nDarkId == SPELL_RACIAL_DARKNESS && 
				GetHasFeat(FEAT_OUTSIDER_BLOODLINE_FIENDISH, oDarkCaster, TRUE))
					nDarkCL += 5;
					
			if (nLightId == ELADRIN_FORM_ID || nLightId == CROWN_OF_FLAMES_ID)
				LvD = HOLY_LIGHT;
			else LvD = LvDRoll(nLightCL, nDarkCL);
			
			LvDResult(oDark, oLight, oDarkCaster, oLightCaster, LvD);
			
			
		}
		
		oLight = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_AREA_OF_EFFECT);
	}
}
