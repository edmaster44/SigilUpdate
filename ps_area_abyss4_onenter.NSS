#include "ff_safevar"


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

 int iLock = PS_GetGlobalInt("abyss4EnterLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("abyss4EnterLock", 1); // Only allows one clean up at a time.

  DelayCommand(30.0, ExecuteScript("ps_chest_treasure",oPC));
   
  PS_SetGlobalInt("abyss4EnterLock", 0);
 }
}