#include "ff_safevar"

/* Makes a placeable (tag defined in variable) usable */
/* When the PC crosses the trigger, and (optionally) makes a skill roll */
/* Will only trigger once per PC */
/*****************************/
/* 12-26-20 - Mimi Fearthegn */
/*****************************/
#include "ps_inc_training"

void main() {

	object oPC = GetEnteringObject();
	
	if (!GetIsPC(oPC))
		return;
		
	int nSkill = PS_GetLocalInt(OBJECT_SELF, "SKILL_ID");
	int nDC = PS_GetLocalInt(OBJECT_SELF, "SKILL_DC");
	string sPlac = PS_GetLocalString(OBJECT_SELF, "PLACEABLE_TAG");
	string sMessage = PS_GetLocalString(OBJECT_SELF, "SUCCESS_MESSAGE");
	
	object oPlaceable = GetNearestObjectByTag(sPlac);
	
	if (!GetIsObjectValid(oPlaceable))
		return;
		
	//We've succeeded at opening this before
	if (PS_GetLocalInt(oPC, sPlac) == 2) {
		SetUseableFlag(oPlaceable, TRUE);
		DelayCommand(300.0f, SetUseableFlag(oPlaceable, FALSE)); //five minutes, turn this off
		return;
	}
	
	//We've failed at opening this before
	if (PS_GetLocalInt(oPC, sPlac) == 1) {
		return;
	}
	
	if (nSkill > 0) {
	
		if (GetIsTrainingSkillSuccessful(oPC, nSkill, nDC)) {
		
			PS_SetLocalInt(oPC, sPlac, 2);
			SetUseableFlag(oPlaceable, TRUE);
			DelayCommand(300.0f, SetUseableFlag(oPlaceable, FALSE)); //five minutes, turn this off
		
		} else {
		
			PS_SetLocalInt(oPC, sPlac, 1);
			
		}
	
	} else {
		PS_SetLocalInt(oPC, sPlac, 2);
		SetUseableFlag(oPlaceable, TRUE);
		DelayCommand(300.0f, SetUseableFlag(oPlaceable, FALSE)); //five minutes, turn this off
	}

}