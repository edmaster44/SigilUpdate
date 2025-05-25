

void main()
{
	object oTrigger = OBJECT_SELF;
	object oPC = GetEnteringObject();
	if (GetIsPC(oPC) == FALSE) return;
	string M_tag = GetLocalString(oTrigger,"M_Tag");
	string WP_succ = GetLocalString(oTrigger,"WP_Success");
	string MSG_succ = GetLocalString(oTrigger,"Message_Success");
 	string WP_fail = GetLocalString(oTrigger,"WP_Fail");
	string MSG_fail = GetLocalString(oTrigger,"Message_Fail");
	
	object oWP_succ = GetWaypointByTag(WP_succ);
	object oWP_fail = GetWaypointByTag(WP_fail);
	object oBlocker = GetObjectByTag(M_tag);
	object oBlocker2 = GetObjectByTag(M_tag+"2");
	object oBlocker3 = GetObjectByTag(M_tag+"3");
	
	location lWP_succ = GetLocation(oWP_succ); 
	location lWP_fail = GetLocation(oWP_fail); 
	
	float fFacing = GetFacing(oPC);
	AssignCommand(oPC, ClearAllActions(FALSE));
	if(oBlocker != OBJECT_INVALID | oBlocker2 != OBJECT_INVALID | oBlocker3 != OBJECT_INVALID)
	{
			if(MSG_fail != "") SendMessageToPC(oPC, "<i>"+MSG_fail);
			AssignCommand(oPC, ActionJumpToLocation(lWP_fail));
	}		
	else
	{
			if(MSG_succ != "") SendMessageToPC(oPC, "<i>"+MSG_succ);
			AssignCommand(oPC, ActionJumpToLocation(lWP_succ));
	}
}