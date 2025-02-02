#include "ff_safevar"

void main () {

	object oDoor = GetNearestObjectByTag(PS_GetLocalString(OBJECT_SELF, "DoorTag"));

	if (GetLocked(oDoor)) {
		SetLocked(oDoor, FALSE);
	}
	
	DelayCommand ( 0.2f, AssignCommand( oDoor, ActionOpenDoor( oDoor ) ) );
	
	if (PS_GetLocalInt(OBJECT_SELF, "CloseSelf") > 0) {
		DelayCommand ( 60.0f, AssignCommand( oDoor, ActionCloseDoor( oDoor ) ) );
	}
	
}