#include "ff_applyeffect" 
void main()
{
	object oPC = GetLastUsedBy();
	ForceRest(oPC);
	PS_ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_X), oPC);
}