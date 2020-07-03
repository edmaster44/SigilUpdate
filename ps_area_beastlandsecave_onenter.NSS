#include "ps_inc_planarlocations"
void main()
{
 object oPC = GetEnteringObject();
 
 string sPlane = "Beastlands";
 string sDescrip = "";
 DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
 
}