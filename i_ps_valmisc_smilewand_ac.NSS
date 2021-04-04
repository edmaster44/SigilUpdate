void main() {

	object oTarget = GetItemActivatedTarget();
	object oPC = GetItemActivator();
	
	if (WillSave(oTarget, 20, SAVING_THROW_TYPE_MIND_SPELLS, oPC) == 0) {
		SendMessageToPC(oTarget, "You suddenly feel compelled to smile.");
		SendMessageToPC(oTarget, "<Color=Red>((OOC Note: This item and ability exist for flavor only, and should only be used with the consent of everyone involved.))</Color>");
	}

}