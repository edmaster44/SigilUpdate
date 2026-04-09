/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
Racial feat spell that handles racial regen */

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
	int iAmount = GetSpellFeatId() - 2321;
	
    if (!GetHasSpellEffect(GetSpellId(), oTarget))
	{
		effect eRegen = EffectRegenerate(iAmount, 6.0);
		eRegen = SupernaturalEffect(eRegen);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRegen, oTarget);
	}	
}