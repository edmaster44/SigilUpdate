
#include "ps_astral_inc"
#include "ps_inc_planarlocations"

void main()
{
 object oPC = GetEnteringObject();
 string sPlane = "Astral";
 string sDescrip = "";
 DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

 int iLock = GetGlobalInt("AstralShipIntEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("AstralShipIntEnterLock", 1); // Only allows one clean up at a time.

  SetGlobalInt("AstralShipIntEnterLock", 0);
 }
}