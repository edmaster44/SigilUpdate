void main () {

	object oPC = GetEnteringObject();
	if (!GetIsPC(oPC))
		return;
		
	object oCipher = GetNearestObjectByTag("ps_npc_carncipher");
	object oWP = GetWaypointByTag("wp_carn_cipherstep");
	
	AssignCommand(oCipher, ActionSpeakString("Stay behind the mats."));
	AssignCommand(oPC, ActionJumpToObject(oWP, FALSE));

}