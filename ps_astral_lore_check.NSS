// Does a check for local vars with DC values on the trigger and reports the lore known.
// Could be moved to an include at some point and have checks for different types of skills
// especially things like spot and listen

// Local Vars on trigger should be stored as:
// int LoreType - an identifer that is used to check whether PC has already triggered this check
// int LoreCheckSuccessValue - the value they have to achieve to actually have some basic knowledge.
// int LoreCheckMaxValue - A max value for cycling through results (default if missing = 99)
// string LoreGenericSuccess - a string giving an intro to the check if they succeed.  eg: "You see XYZ"
// string LoreGenericFail - in they get less than the success value but more than zero they get this.
// string LoreGenericEpicFail - this string is used when the player has less than 1 as a result of their DC check.
// string DCn - where n is a number from 1 to 99 and are DC results checks and provide further info.

const string LORE_STRING_FORMAT = "<COLOR=YELLOW><i>LORE: ";

void main()
{
	object oPC = GetEnteringObject();
	object oTrigger = OBJECT_SELF;
	string sLoreType;
	
	if (GetIsPC(oPC))
	{
		// local trigger string var that is then used for the storing of local var on PC
		sLoreType = GetLocalString(oTrigger, "LoreType");
		
		// check to see if they have already made 1 lore check since reset/relog
		if (GetLocalInt(oPC, "LORECHECK_" + sLoreType) == 0)
		{
			// next time trigger is tripped this will cause bypass.
			SetLocalInt(oPC, "LORECHECK_" + sLoreType, 1);
			// make the lore check
			int iLore = GetSkillRank(SKILL_LORE, oPC, FALSE);
			int iSuccess = GetLocalInt(oTrigger, "LoreCheckSuccessValue");
			
			if (iLore < 0)
				SendMessageToPC(oPC, LORE_STRING_FORMAT + GetLocalString(oTrigger, "LoreGenericEpicFail"));
			else if (iLore < iSuccess)
				SendMessageToPC(oPC, LORE_STRING_FORMAT + GetLocalString(oTrigger, "LoreGenericFail"));
			else
			{
				SendMessageToPC(oPC, LORE_STRING_FORMAT + GetLocalString(oTrigger, "LoreGenericSuccess"));
				
				int iCount;
				int iLoreCheckMaxValue = GetLocalInt(oTrigger, "LoreCheckMaxValue");
				string sCurrentString;
				
				// no need to go through entries which they do not have lore for anyway.
				if (iLore < iLoreCheckMaxValue)
					iLoreCheckMaxValue = iLore;
				
				// just a safety/sanity check
				if (iLoreCheckMaxValue < 1)
					iLoreCheckMaxValue = 1;
					
				for (iCount = 1; iCount <= iLoreCheckMaxValue; iCount++)
				{
					sCurrentString = GetLocalString(oTrigger, "DC" + IntToString(iCount));
					if (sCurrentString != "")
						SendMessageToPC(oPC, LORE_STRING_FORMAT + sCurrentString);
				}
			}
		}
	}
}