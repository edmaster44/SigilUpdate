//--------------------------------//
// Shows HP of Target    		  //
// Clangeddin 2015				  //
//--------------------------------//


void main()
{
	object oPC = OBJECT_SELF;
	object oTARGET = GetPlayerCurrentTarget(oPC);
	int nMIN = GetCurrentHitPoints(oTARGET);
	int nMAX = GetMaxHitPoints(oTARGET);
	SetGUIObjectText(oPC, "SCREEN_TARGETED_OBJECT", "HP_TEXT", -1, IntToString(nMIN) + "/" + IntToString(nMAX));
}