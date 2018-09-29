#include "enft_startengine"
#include "ps_inc_planarlocations"
void main()
{
 	object oPC = GetEnteringObject();
	string sPlane = "Elemental Plane of Fire";
 	string sDescrip = "The air is blistering hot, and the ground cracks beneath your step - revealing the rivers of endless fire flowing just under your feet.";
 	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
	
	if (GetIsPC(oPC))
		startEngine(oPC);
}