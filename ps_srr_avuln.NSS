/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
Racial feat spell that gives 100% vulnerability to acid */

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
		effect eVuln = EffectDamageImmunityDecrease(DAMAGE_TYPE_ACID, 50);
		eVuln = SupernaturalEffect(eVuln);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVuln, oTarget);
	}	
}