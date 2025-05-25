

#include "ps_inc_planarlocations"
void main()
{
 object oPC = GetEnteringObject();
 string sPlane = "Ethereal";
 string sDescrip = "";
 DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
 
 ExecuteScript("onenter_antimagic",OBJECT_SELF);
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;
  
 int iLock = GetGlobalInt("DPCREnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("DPCREnterLock", 1); // Only allows one clean up at a time.

//  DelayCommand(300.0, ExecuteScript("ps_chest_treasure",oPC));
    
  SetGlobalInt("DPCREnterLock", 0);
 }
 
}