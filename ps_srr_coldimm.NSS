/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
Racial feat spell that gives 100% vulnerability to cold */

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

    if (!GetHasSpellEffect(GetSpellId(), oTarget))
	{
		effect eRes = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 100);
		eRes = SupernaturalEffect(eRes);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRes, oTarget);
	}	
}