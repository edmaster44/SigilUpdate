#include "ps_inc_gemstones"

void PlayWorkAnimation(object oPC) {

	PlayCustomAnimation(oPC, "disablefront", TRUE, 1.0f);
	
}

void main () {

	object oPC = GetLastUsedBy();
	ClearAllActions();
	InitializeGemstoneBox();
	
	DisplayGuiScreen(oPC, sGemScreen, TRUE, xmlGemFile);
	
	object oFront = GetWaypointByTag("wp_gembench_front");
	if (GetIsObjectValid(oFront) && GetArea(oFront) == GetArea(oPC))
		AssignCommand(oPC, ActionForceMoveToLocation(GetLocation(oFront)));
	DelayCommand(0.5f, PlayWorkAnimation(oPC));
	
	RegenerateGemList(oPC);
	InitializeGemstoneBox();

}