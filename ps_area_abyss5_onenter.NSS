

#include "ps_inc_planarlocations"
void main()
{
 object oPC = GetEnteringObject();
 string sPlane = "Abyss";
 string sDescrip = "The air grows more humid as you climb the mountain. The heat remains constant, but now seems to be generated instead by immense geysers, breaking through the rocks.";
 DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

 int iLock = GetGlobalInt("abyss5EnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("abyss5EnterLock", 1); // Only allows one clean up at a time.

  DelayCommand(30.0, ExecuteScript("ps_chest_treasure",oPC));
   
  SetGlobalInt("abyss5EnterLock", 0);
 }
}