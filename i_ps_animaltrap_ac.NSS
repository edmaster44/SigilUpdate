

void CreateTrap(object oPC, string sPlaceable, location lLoc, string sScript) {
	object oTrap = CreateObject(OBJECT_TYPE_PLACEABLE, sPlaceable, lLoc);
	SetLocalObject(oTrap, "creator", oPC);
	DelayCommand(6.0f, ExecuteScript(sScript, oTrap));
}

int CheckForTraps(object oPC, float fDistance) {

	object oObj = GetFirstObjectInShape(SHAPE_SPHERE, fDistance, GetLocation(oPC), FALSE, OBJECT_TYPE_PLACEABLE);
	while (GetIsObjectValid(oObj)) {
		if (GetTag(oObj) == "plc_trap_largeanimal" || GetTag(oObj) == "plc_trap_medanimal" || GetTag(oObj) == "plc_trap_smallanimal" || GetTag(oObj) == "obj_notrapzone")
			return TRUE;
		oObj = GetNextObjectInShape(SHAPE_SPHERE, fDistance, GetLocation(oPC), FALSE, OBJECT_TYPE_PLACEABLE|OBJECT_TYPE_CREATURE);
	}
	return FALSE;
}

void main () {

	object oItem = GetItemActivated();
	object oPC = GetItemActivator();
	location lLoc = GetLocation(oPC);
	
	string sPlaceable = GetLocalString(oItem, "trapPlaceable");
	string sScript = GetLocalString(oItem, "trapScript");
	if (CheckForTraps(oPC, 15.0f)) {
		SendMessageToPC(oPC, "<Color=DarkOliveGreen>Traps cannot be placed next to each other, or too close to NPCs. Move and try again.</Color>");
		SetItemCharges(oItem, GetItemCharges(oItem)+1);
		return;
	} else {
		AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0f, 3.0f));
		DelayCommand(2.5f, CreateTrap(oPC, sPlaceable, lLoc, sScript));
		DelayCommand(2.8f, SendMessageToPC(oPC, "<Color=DarkOliveGreen>The trap is set. Now to wait out of sight for the prey. . .")); 
	}

}