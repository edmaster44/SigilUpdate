/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
Racial feat spell that causes all melee attacks to do additional 1d6 fire damage */

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
		effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_COLD);
		eDmg = SupernaturalEffect(eDmg);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDmg, oTarget);
	}	
}