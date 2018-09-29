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
	
    if (!GetHasSpellEffect(GetSpellId(), oTarget) && GetHasFeat(21346) == TRUE && !GetHasFeat(21347) && !GetHasFeat(21348) && !GetHasFeat(21409))
	{
		int nAstCon = FeatAdd(OBJECT_SELF, 21347, TRUE, TRUE, FALSE);
		int nConRep = FeatAdd(OBJECT_SELF, 21348, TRUE, TRUE, FALSE);
		int nProg = FeatAdd(OBJECT_SELF, 21409, TRUE, TRUE, FALSE);
		
		nAstCon == TRUE;
		nConRep == TRUE;
		nProg == TRUE;
	}	
}