
//wrapper for ApplyEffectToObject that automatically signals the spell cast event
void PS_ApplyEffectToObject(int nDurationType, effect eEffect, object oTarget, float fDuration = 0.0f, int nId = -1){

	if (nId == -1) nId = GetSpellId();
	object oCaster = OBJECT_SELF;
	if (GetIsObjectValid(GetSpellCastItem()))
		oCaster = GetItemActivator();
	else if (GetObjectType(oCaster) == OBJECT_TYPE_AREA_OF_EFFECT)
		oCaster = GetAreaOfEffectCreator();
	int bHarmful;
	if (GetIsPC(oTarget) && GetIsPC(oCaster)) bHarmful = FALSE;
	else if (GetObjectType(oTarget) != OBJECT_TYPE_CREATURE) bHarmful = FALSE;
	else if (StringToInt(Get2DAString("spells", "HostileSetting", nId)) == 1)
		bHarmful = TRUE;
	else bHarmful = FALSE;
	// Known bug: if any temp or perm affect is applied as type instant, it can NEVER be removed.
	// Hopefully this will catch some of those. A more robust approach would be to
	// create a list of every effect that should never be applied as instant, but that's
	// more work than I have time for. -FlattedFifth, April 2, 2026
	if (fDuration > 0.0 && nDurationType == DURATION_TYPE_INSTANT)
		nDurationType = DURATION_TYPE_TEMPORARY;
		
	SignalEvent(oTarget, EventSpellCastAt(oCaster, nId, bHarmful));
	ApplyEffectToObject(nDurationType, eEffect, oTarget, fDuration);
}