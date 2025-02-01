#include "ff_safevar"


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

 int iLock = PS_GetGlobalInt("usigil2EnterLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("usigil2EnterLock", 1); // Only allows one clean up at a time.

  //DelayCommand(300.0, ExecuteScript("ps_chest_treasure",oPC));
   
  PS_SetGlobalInt("usigil2EnterLock", 0);
 }
}