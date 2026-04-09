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
		int iAC = GetSpellId() - 1261; // 1262 is the first of the 10 entries in spells.2da that grant the AC bonus
		effect eAC = EffectACIncrease(iAC, AC_NATURAL_BONUS);
		eAC = ExtraordinaryEffect(eAC);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oTarget); // check to see if AC bug is caused by permanent and supernatural effect was causing problem after polymorph.
	}	
}