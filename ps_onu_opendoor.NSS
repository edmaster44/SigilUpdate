void main () {

	object oDoor = GetNearestObjectByTag(GetLocalString(OBJECT_SELF, "DoorTag"));

	if (GetLocked(oDoor)) {
		SetLocked(oDoor, FALSE);
	}
	
	DelayCommand ( 0.2f, AssignCommand( oDoor, ActionOpenDoor( oDoor ) ) );
	
}