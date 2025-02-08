#include "ff_safevar"


void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;


 int iLock = PS_GetGlobalInt("usigilwereratEnterLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("usigilwereratEnterLock", 1); // Only allows one clean up at a time.

  DelayCommand(30.0, ExecuteScript("ps_chest_treasure",oPC));
   
  PS_SetGlobalInt("usigilwereratEnterLock", 0);
 }
}