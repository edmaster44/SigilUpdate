#include "ff_safevar"

#include "ps_inc_planarlocations"
void main()
{
 object oPC = GetEnteringObject();
 string sPlane = "Astral";
 string sDescrip = "";
 DelayCommand(3.0f, ApplyPlanarAlignmentEffects(oPC, sPlane, sDescrip));
// if (!GetIsPC(oPC) && !GetIsDM(oPC))
//  return;

 int iLock = PS_GetGlobalInt("AstralGithIntLock");
 if ( iLock == 0 )
 {
  PS_SetGlobalInt("AstralGithIntLock", 1); // Only allows one clean up at a time.

  //DelayCommand(30.0, ExecuteScript("ps_chest_treasure",oPC));
   
  PS_SetGlobalInt("AstralGithIntLock", 0);
 }
 
 // Initialize traps on chests in area of do not already exist
 object oArea = GetArea(oPC);
 // ps_githint_chest
 
 object oPlaceable = GetFirstObjectInArea(oArea);
 int iTrapType;
 
 while (GetIsObjectValid(oPlaceable))
 {
 	if (GetTag(oPlaceable) == "ps_githint_chest")
	{
		if (!GetIsTrapped(oPlaceable))
		{
			iTrapType = Random(54) + 65;
			CreateTrapOnObject(iTrapType, oPlaceable, STANDARD_FACTION_HOSTILE, "ps_githchest_ondisarm", "ps_githchest_ontraptriggered");
		}
	}
 
 	oPlaceable = GetNextObjectInArea(oArea);
 }
}