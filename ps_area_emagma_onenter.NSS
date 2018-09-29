#include "enft_startengine"
#include "ps_inc_planarlocations"
void main()
{
 	object oPC = GetEnteringObject();
	string sPlane = "Para-Elemental Plane of Magma";
 	string sDescrip = "The air is oppressively hot, and smells strongly of sulphur. It hurts to breathe. The ground is blackened, and cracks occasionally beneath your feet, revealing the red-hot semi-liquid which makes up the majority of the para-elemental plane of magma.";
 	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
	
	if (GetIsPC(oPC))
		startEngine(oPC);
}