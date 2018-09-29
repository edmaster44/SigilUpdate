/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
Racial feat spell that gives 100% immunty to sonic */

// cannot make a fire or cold immunity feat, so giving 100% res as closest option.

//#include "nw_i0_spells"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = GetSpellTargetObject();

    if (!GetHasSpellEffect(GetSpellId(), oTarget))
	{
		effect eRes = EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 100);
		eRes = SupernaturalEffect(eRes);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRes, oTarget);
	}	
}