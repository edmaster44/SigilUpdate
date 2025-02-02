#include "ff_safevar"

#include "ps_inc_planarlocations"
void main () {

	object oPC = GetEnteringObject();
	if (!GetIsPC(oPC))
		return;
		
	string sDescrip = PS_GetLocalString(GetArea(oPC), "planar_description");
	string sPlane = PS_GetLocalString(GetArea(oPC), "plane");
	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));

}