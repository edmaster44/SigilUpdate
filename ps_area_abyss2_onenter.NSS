#include "ff_safevar"

#include "ps_inc_planarlocations"
void main()
{
 object oPC = GetEnteringObject();
 string sPlane = "Abyss";
 string sDescrip = "A ramshackle fortress sits by the shores of the Lake of Molten Iron. Devils guard its walls, but the architecture is far too disorderly for them to have been the original builders.";
 DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

 int iLock = PS_GetGlobalInt("abyss2EnterLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("abyss2EnterLock", 1); // Only allows one clean up at a time.

  DelayCommand(30.0, ExecuteScript("ps_chest_treasure",oPC));
   
  PS_SetGlobalInt("abyss2EnterLock", 0);
 }
}