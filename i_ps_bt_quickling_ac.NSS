#include "ff_safevar"

// i_ps_bt_quickling_ac
//	Script created 10/24/2015 by Ceremorph for use in the Sigil: City of Doors PW  

void main()
{
    object oPC      = GetItemActivator();
    object oItem    = GetItemActivated();
	int iBoost		= PS_GetLocalInt(oItem,"Boost");
	int iDuration	= PS_GetLocalInt(oItem,"Duration");
	effect eQuick	= EffectMovementSpeedIncrease(iBoost);
	effect eVis 	= EffectVisualEffect(VFX_IMP_HASTE);
	float fDuration = HoursToSeconds(iDuration);

	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
	DelayCommand(0.2, AssignCommand(oPC, ClearAllActions())); // prevents an exploit
	DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eQuick,oPC, fDuration));
}