void main() {

	object oPC = GetLastPerceived();
	
	//Only rise if we see a PC
	if (!GetIsPC(oPC))
		return;
		
	SendMessageToPC(oPC, "On percieved fired for "+GetName(OBJECT_SELF));
		
	//make me a normal npc!
	SetCreatureScriptsToSet(OBJECT_SELF, 9); //get the default npc scripts
	
	ClearAllActions();
	string sAnim = GetLocalString(OBJECT_SELF, "TransitionAnimation");
	float fSpeed = GetLocalFloat(OBJECT_SELF, "TransitionAnimationSpeed");
	
	SendMessageToPC(oPC, sAnim+", "+FloatToString(fSpeed));
	
	PlayCustomAnimation(OBJECT_SELF, sAnim, FALSE, fSpeed);
	
	DelayCommand(1.0f, ChangeToStandardFaction(OBJECT_SELF, STANDARD_FACTION_HOSTILE));

}