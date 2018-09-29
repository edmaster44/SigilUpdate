void main()
{
	object oPC = GetLastUsedBy();
	ForceRest(oPC);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_X), oPC);
}