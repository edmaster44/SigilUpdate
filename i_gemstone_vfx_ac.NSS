#include "ff_safevar"

void main () {

	object oPC = GetItemActivator();
	object oItem = GetItemActivated();
	object oTarget = GetItemActivatedTarget();
	location lLoc = GetItemActivatedTargetLocation();
	
	int nNoDestroy = PS_GetLocalInt(oItem, "DoNotDestroy");
	
	string sEffect = PS_GetLocalString(oItem, "VFX");
	if (sEffect == "")
		return;
		
	float fDur = PS_GetLocalFloat(oItem, "Duration");
	int nDuration = DURATION_TYPE_INSTANT;
	if (fDur > 0.0f)
		nDuration = DURATION_TYPE_TEMPORARY;
		
	effect eEffect = EffectNWN2SpecialEffectFile(sEffect);
	
	if (GetIsObjectValid(oTarget)) {
		ApplyEffectToObject(nDuration, eEffect, oTarget, fDur);
	} else if (GetIsLocationValid(lLoc)) {
		ApplyEffectAtLocation(nDuration, eEffect, lLoc, fDur);
	}
	
	if (!nNoDestroy)
		DestroyObject(oItem);
	
	//removing this because gemstone gravel now has a purpose
	//CreateItemOnObject("gemstone_gravel", oPC);

}