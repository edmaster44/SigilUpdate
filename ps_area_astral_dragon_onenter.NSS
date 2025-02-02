#include "ff_safevar"

#include "ps_inc_planarlocations"
void main()
{
 object oPC = GetEnteringObject();
 string sPlane = "Astral";
 string sDescrip = "The Astral Ship drops you off on this desolate rock. You see flying draconic shapes flitting through the clouds in the distance.";
 DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

 int iLock = PS_GetGlobalInt("AstralDragonLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("AstralDragonLock", 1); // Only allows one clean up at a time.

  //DelayCommand(30.0, ExecuteScript("ps_chest_treasure",oPC));
   
  PS_SetGlobalInt("AstralDragonLock", 0);
 }
}