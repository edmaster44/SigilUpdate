#include "x2_inc_spellhook" 
#include "ps_inc_functions"
#include "X0_I0_SPELLS"

struct dEvardsData{
	int nCL;
	int nDC;
	int nMeta;
	int nPML;
};

struct dEvardsData GetEvardsData(object oAOE, object oCaster);
int GetEvardsVariable(object oAOE, object oCaster, string sVar,  int nMinimum = 0);
void DoEvardsDamage(object oCaster, object oTarget, struct dEvardsData data);

int GetEvardsVariable(object oAOE, object oCaster, string sVar, int nMinimum = 0){
	int nReturn = GetLocalInt(oAOE, sVar);
	if (nReturn == 0){
		nReturn = GetLocalInt(oCaster, sVar);
		if (nReturn <= nMinimum) nReturn = nMinimum;
		SetLocalInt(oAOE, sVar, nReturn);
	}
	return nReturn;
}

struct dEvardsData GetEvardsData(object oAOE, object oCaster){

	struct dEvardsData data;
	data.nCL = GetEvardsVariable(oAOE, oCaster, "EvardsCasterLevel", 7);
	data.nDC = GetEvardsVariable(oAOE, oCaster, "EvardsSaveDC", 14);
	data.nMeta = GetEvardsVariable(oAOE, oCaster, "EvardsMetaMagic");
	data.nPML = GetEvardsVariable(oAOE, oCaster, "EvardsPML");
	return data;
}

void DoEvardsDamage(object oCaster, object oTarget, struct dEvardsData data){
	
	effect ePara = EffectParalyze(data.nDC, SAVING_THROW_FORT);
    effect eDur = EffectVisualEffect(VFX_DUR_PARALYZED);
    ePara = EffectLinkEffects(eDur, ePara);
    effect eDam;
	
    int nDamage;
    int nAC = GetAC(oTarget);
	int i;
    int nHits = d4();
	if (data.nMeta == METAMAGIC_MAXIMIZE) nHits = 4;
	else if (data.nMeta == METAMAGIC_EMPOWER) nHits += nHits / 2;
    int nRoll;
	int nAB = data.nCL + (data.nDC - 14); // AB = caster level + casting ability mod
    float fDelay;
	
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_EVARDS_BLACK_TENTACLES));
	for (i = nHits; i > 0; i--)
	{
		fDelay = GetRandomDelay(1.0, 2.2);
		nRoll = d20();
		if ((nRoll > 1 && nRoll + nAB + (data.nPML / 5) >= nAC) || nRoll == 20){
		
			nDamage = d6() + (data.nCL / 3);
			if (data.nMeta == METAMAGIC_MAXIMIZE){
				nDamage = 6 + (data.nCL / 3);
			} else if (data.nMeta == METAMAGIC_EMPOWER){
				nDamage += nDamage / 2; 
			}
			
			eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWO);
			DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
			if(!MySavingThrow(SAVING_THROW_FORT, oTarget, data.nDC, SAVING_THROW_TYPE_NONE, oCaster, fDelay)){
				DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePara, oTarget, 6.0f));
			}
		}      
	}
}


	