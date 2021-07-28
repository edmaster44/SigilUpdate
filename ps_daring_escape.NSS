
#include "nwn2_inc_spells"
#include "x2_inc_spellhook"

void main()
{
    if (!X2PreSpellCastCode())
    {   // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    
    object oTarget = GetSpellTargetObject();
	
    // Does not stack with itself
    if (!GetHasSpellEffect(GetSpellId(), oTarget) ) {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    
        //Apply the VFX impact and effects
		int nLvl = GetLevelByClass(CLASS_TYPE_SWASHBUCKLER, oTarget);
		int nRounds = 5 + (nLvl == 30 ? 4 : nLvl / 6);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedIncrease(50), oTarget, RoundsToSeconds(nRounds));
    }
}