#include "ff_safevar"

#include "ps_inc_planarlocations"
void main()
{
 object oPC = GetEnteringObject();
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

	string sPlane = "Hades";
 	string sDescrip = "";
 	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
	
  
 int iLock = PS_GetGlobalInt("GWtunnel2EnterLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("GWtunnel2EnterLock", 1); // Only allows one clean up at a time.

//  DelayCommand(300.0, ExecuteScript("ps_chest_treasure",oPC));
    
  PS_SetGlobalInt("GWtunnel2EnterLock", 0);
 }
}