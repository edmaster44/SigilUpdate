/////////////////////////////////////////////////////////
// Auto-Close Door / Lock Door
/////////////////////////////////////////////////////////
void main()

{
	//	Get the float for the duration of the time to pass before the door is closed and locked
	float fDelay	= GetLocalFloat(OBJECT_SELF, "delay");

	DelayCommand(fDelay,ActionCloseDoor(OBJECT_SELF));
	DelayCommand(fDelay,SetLocked(OBJECT_SELF,TRUE));
}
// End