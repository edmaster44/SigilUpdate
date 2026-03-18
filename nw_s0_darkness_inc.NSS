
#include "x2_inc_spellhook"
const int DESTROY_LIGHT = 0;
const int DESTROY_DARK = 1;
const int DESTROY_BOTH = 2;
const int DESTROY_NONE = 3;
const int ELADRIN_FORM_ID = 1246;
const int CROWN_OF_FLAMES_ID =1656;

int LvDRoll(int nLightCL, int nDarkCL, int bHoly, int bAbyssal, int bForm){
	nLightCL += d20();
	nDarkCL += d20();
	if (bHoly) nLightCL += 5;
	if (bAbyssal) nDarkCL += 5;
	int nDiff = nLightCL - nDarkCL;
	if (nDiff > -5 && nDiff < 5){
		if (!bForm) return DESTROY_BOTH;
		else return DESTROY_DARK;
	}
	else if (nLightCL > nDarkCL) 
		return DESTROY_DARK;
	else {
		if (bForm) return DESTROY_NONE;
		else return DESTROY_LIGHT;
	}
	return DESTROY_NONE;
}

void LvDResultMessage(object oLightCaster, object oDarkCaster, int LvD){
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
			sLightMessage = "Your Light has failed to destroy the Darkness effect!";
			sDarkMessage = "Your Darkness effect cannot destroy the Light!";
			break;
		}
	}
	
	if (GetIsObjectValid(oLightCaster))
		SendMessageToPC(oLightCaster, sLightMessage);
	if (GetIsObjectValid(oDarkCaster))
		SendMessageToPC(oDarkCaster, sDarkMessage);
}

void DoLightVsDarkness(object oTarget){
	object oDarkCaster = GetAreaOfEffectCreator();
	struct dSpellData dDarkData = GetSpellDataForAoE("Darkness", oDarkCaster);
	int bAbyssal = (dDarkData.nId == SPELL_RACIAL_DARKNESS && 
			GetHasFeat(FEAT_OUTSIDER_BLOODLINE_FIENDISH, oDarkCaster, TRUE));
	object oLightCaster;
	int nLightId;
	int bForm = FALSE;
	int bHoly = FALSE;
	int nResult;
	// if the entering object is a stand-alone AoE, check if it's light and if so, roll to see
	// which, if either, banishes the other.
	if (GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT){
		nLightId = GetAreaOfEffectSpellId(oTarget);
		if (nLightId == SPELL_LIGHT || nLightId == SPELL_RACIAL_LIGHT){
			oLightCaster = GetAreaOfEffectCreator(oTarget);
			struct dSpellData dLightData = GetSpellDataForAoE("Light", oLightCaster, oTarget);
			bHoly = (nLightId == SPELL_RACIAL_LIGHT && GetHasFeat(FEAT_OUTSIDER_BLOODLINE_CELESTIAL, oLightCaster, TRUE));
			nResult = LvDRoll(dLightData.nCL, dDarkData.nCL, bHoly, bAbyssal, bForm);
			LvDResultMessage(oLightCaster, oDarkCaster, nResult);
			if (nResult == DESTROY_LIGHT){
				DestroyObject(oTarget, 0.1f, FALSE);
			} else if (nResult == DESTROY_DARK){
				DestroyObject(OBJECT_SELF, 0.1f, FALSE);
				return;
			} else if (nResult == DESTROY_BOTH){
				DestroyObject(oTarget, 0.1f, FALSE);
				DestroyObject(OBJECT_SELF, 0.1f, FALSE);
				return;
			}
		}
	//otherwise scan creatures and placeable for light effects on them and roll to see which, if either, 
	// banishes the other.
	} else {
		effect eFX = GetFirstEffect(oTarget);
		while (GetIsEffectValid(eFX)){
			nLightId = GetEffectSpellId(eFX);
			if (nLightId == SPELL_LIGHT || nLightId == SPELL_RACIAL_LIGHT ||
				nLightId == ELADRIN_FORM_ID || nLightId == CROWN_OF_FLAMES_ID){
					oLightCaster = GetEffectCreator(eFX);
					bForm = (nLightId == ELADRIN_FORM_ID || nLightId == CROWN_OF_FLAMES_ID);
					bHoly = ((nLightId == SPELL_RACIAL_LIGHT && GetHasFeat(FEAT_OUTSIDER_BLOODLINE_CELESTIAL, oLightCaster, TRUE)) || bForm);
					nResult = LvDRoll(PS_GetCasterLevel(oLightCaster), dDarkData.nCL, bHoly, bAbyssal, bForm);
					LvDResultMessage(oLightCaster, oDarkCaster, nResult);
					if (nResult == DESTROY_LIGHT){
						PS_RemoveEffects(oTarget, nLightId);
					} else if (nResult == DESTROY_DARK){
						DestroyObject(OBJECT_SELF, 0.1f, FALSE);
						return;
					} else if (nResult == DESTROY_BOTH){
						PS_RemoveEffects(oTarget, nLightId);
						DestroyObject(OBJECT_SELF, 0.1f, FALSE);
						return;
					}
				}
			eFX = GetNextEffect(oTarget);
		}
	}
}

void ScanForLight(object oTarget = OBJECT_INVALID){
	if (oTarget == OBJECT_INVALID){
		oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_ALL);
		while (GetIsObjectValid(oTarget)) {
			DoLightVsDarkness(oTarget);
			oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_ALL);
		}
	}
	else DoLightVsDarkness(oTarget);
}