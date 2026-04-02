#include "ff_applyeffect" 
// lich phylactary gives contingecy effect on death.

void main()
{
	object oPC = GetItemActivator();
	int iHeal = GetMaxHitPoints(oPC);
	effect eRes = EffectHealOnZeroHP(oPC, iHeal);
	eRes = ExtraordinaryEffect(eRes);
	PS_ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRes, oPC);
}