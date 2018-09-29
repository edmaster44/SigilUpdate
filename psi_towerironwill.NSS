/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
Racial feat that sets up undead state */

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
		int nHD = GetHitDice(oTarget);
		int nSR = 20 + nHD;
		
		effect eSR = EffectSpellResistanceIncrease(nSR, -1);
		
	
		
		
		eSR = ExtraordinaryEffect(eSR);
		
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSR, oTarget);
	}	
}