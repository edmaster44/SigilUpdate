void C_PlayCustomAnimation(object oObject, string sAnimationName, int nLooping, float fSpeed = 1.0f)
{
  PlayCustomAnimation(oObject, sAnimationName, nLooping, fSpeed);
}

void main()
{
	int bOpened = GetLocalInt(OBJECT_SELF,"Open");
	string sDestination = GetLocalString(OBJECT_SELF, "DestinationTag");
	object oPC = GetLastUsedBy();
	if (bOpened == TRUE)
	{
		/*float fOffset = 0.0;
	    object oTarget = GetNearestObjectByTag("Z_PLC_TRAPDOOR");
		AssignCommand(oTarget, DelayCommand(fOffset,PlayAnimation(ANIMATION_PLACEABLE_CLOSE)));
		SetLocalInt(OBJECT_SELF, "Open", FALSE);
		SetFirstName(OBJECT_SELF, "Open trapdoor");*/
		AssignCommand(oPC, ActionJumpToObject(GetObjectByTag(sDestination)));

		
	}
	else
	{
		float fOffset = 0.0;
	    object oTarget = OBJECT_SELF;
		C_PlayCustomAnimation(oPC, "disableground", 0, 1.0);
		float fDelay = 5.0;
		DelayCommand(fDelay - 0.5, AssignCommand(oPC, PlaySound("as_dr_woodlgop1")));
		DelayCommand(fDelay - 0.5, AssignCommand(oTarget, DelayCommand(fOffset,PlayAnimation(ANIMATION_PLACEABLE_OPEN))));
		
		SetLocalInt(OBJECT_SELF, "Open", TRUE);
		SetFirstName(OBJECT_SELF, "Climb down");

	}
	
}	