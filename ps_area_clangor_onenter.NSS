

#include "ps_inc_planarlocations"
void main()
{
 	object oPC = GetEnteringObject();
	string sPlane = "Acheron";
 	string sDescrip = "The walls of this structure appear forged or 'carved' from iron; you hear the tramp of heavy boots echo through the halls.";
 	DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
	
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

 int iLock = GetGlobalInt("clangorEnterLock");
 if ( iLock == 0 )
 {
  SetGlobalInt("clangorEnterLock", 1); // Only allows one clean up at a time.

  //DelayCommand(300.0, ExecuteScript("ps_chest_treasure",oPC));
   
  SetGlobalInt("clangorEnterLock", 0);
 }
}