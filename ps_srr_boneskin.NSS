/* Adaption of the special race abilities to allow for warlock palemaster bone skin  */

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
		int amount = 2;
		if (GetLevelByClass(82, oTarget) >= 4)
			amount = 4;
		else if (GetLevelByClass(82, oTarget) >= 8)
			amount = 6;
		effect eAC = EffectACIncrease(amount);
		eAC = SupernaturalEffect(eAC);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oTarget);
	}
	
}