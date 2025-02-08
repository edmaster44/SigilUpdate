#include "ff_safevar"


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

 int iLock = PS_GetGlobalInt("AstralShipIntEnterLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("AstralShipIntEnterLock", 1); // Only allows one clean up at a time.

  PS_SetGlobalInt("AstralShipIntEnterLock", 0);
 }
}