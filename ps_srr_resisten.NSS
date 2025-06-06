/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
Racial feat spell that handles racial energy reistance */

//#include "nw_i0_spells"
#include "x2_inc_spellhook"

void main()
{
	//SpeakString("Firing Aura");
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = GetSpellTargetObject();
	int iType = DAMAGE_TYPE_FIRE;
	int iFeat = GetSpellFeatId();
	int nId = GetSpellId();
	
	//if (iFeat == 2327) iType = DAMAGE_TYPE_FIRE;
	//else if (iFeat == 2328) iType = DAMAGE_TYPE_COLD;
	if (iFeat == 2328) iType = DAMAGE_TYPE_COLD;
	else if (iFeat == 2329) iType = DAMAGE_TYPE_ACID;
	else if (iFeat == 2330) iType = DAMAGE_TYPE_ELECTRICAL;
	else if (iFeat == 2331) iType = DAMAGE_TYPE_SONIC;
	
	PS_RemoveEffects(oTarget, nId);
    
	effect eRes = EffectDamageResistance(iType, 10);
	eRes = SupernaturalEffect(eRes);
	eRes = SetEffectSpellId(eRes, nId);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRes, oTarget);	
}