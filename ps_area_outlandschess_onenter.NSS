#include "ff_safevar"


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

 int iLock = PS_GetGlobalInt("OutlandsChessEnterLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("OutlandsChessEnterLock", 1); // Only allows one clean up at a time.

//  DelayCommand(300.0, ExecuteScript("ps_chest_treasure",oPC));
   
  PS_SetGlobalInt("OutlandsChessEnterLock", 0);
 }
}