#include "enft_startengine"
#include "ps_inc_planarlocations"
void main()
{
 	object oPC = GetEnteringObject();
	string sPlane = "Elemental Plane of Fire";
 	string sDescrip = "The heat is oppressive. You can practically see it radiating off the walls, and out of the ground.";
 	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
	
	if (GetIsPC(oPC))
		startEngine(oPC);
}