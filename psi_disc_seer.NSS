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
	
    if (!GetHasSpellEffect(GetSpellId(), oTarget) && GetHasFeat(21361) == TRUE && !GetHasFeat(21362) && !GetHasFeat(21363) && !GetHasFeat(21409))
	{
		int nAstCon = FeatAdd(OBJECT_SELF, 21362, TRUE, TRUE, FALSE);
		int nConRep = FeatAdd(OBJECT_SELF, 21363, TRUE, TRUE, FALSE);
		int nProg = FeatAdd(OBJECT_SELF, 21409, TRUE, TRUE, FALSE);
		
		nAstCon == TRUE;
		nConRep == TRUE;
		nProg == TRUE;
	}	
}