

#include "ps_inc_planarlocations"
void main () {

	object oPC = GetEnteringObject();
	if (!GetIsPC(oPC))
		return;
		
	string sDescrip = GetLocalString(GetArea(oPC), "planar_description");
	string sPlane = GetLocalString(GetArea(oPC), "plane");
	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
	
	string sMessage = GetLocalString(GetArea(oPC), "enter_message");
	if (sMessage != "")
		SendMessageToPC(oPC, sMessage);

}