#include "ff_safevar"


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

 int iLock = PS_GetGlobalInt("usigil3EnterLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("usigil3EnterLock", 1); // Only allows one clean up at a time.

//  DelayCommand(30.0, ExecuteScript("ps_chest_treasure",oPC));
   
  PS_SetGlobalInt("usigil3EnterLock", 0);
 }
}