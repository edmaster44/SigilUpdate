#include "ff_safevar"

#include "ps_inc_planarlocations"
void main()
{
 object oPC = GetEnteringObject();
 string sPlane = "Astral";
 string sDescrip = "The Astral Ship drops you off on a largish island in the Astral sea. The structures on the island are ruinous, but still show signs of habitation.";
 DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

 int iLock = PS_GetGlobalInt("AstralGithExtLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("AstralGithExtLock", 1); // Only allows one clean up at a time.

  //DelayCommand(30.0, ExecuteScript("ps_chest_treasure",oPC));
   
  PS_SetGlobalInt("AstralGithExtLock", 0);
 }
}