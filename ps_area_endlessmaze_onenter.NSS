#include "ff_safevar"

#include "ps_inc_planarlocations"
void main()
{
 	object oPC = GetEnteringObject();
	string sPlane = "Abyss";
 	string sDescrip = "Tunnels stretch out before you, traveling endlessly into the darkness.";
 	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

 int iLock = PS_GetGlobalInt("abyssEndlessmazeLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("abyssEndlessmazeLock", 1); // Only allows one clean up at a time.

  DelayCommand(30.0, ExecuteScript("ps_chest_treasure",oPC));
   
  PS_SetGlobalInt("abyssEndlessmazeLock", 0);
 }
}