void main ()
{
	AssignCommand(OBJECT_SELF, ActionSpeakString("<C=yellow><i>The rock walls shift and mend any attempts to break through them.</i>"));
	if (GetCurrentHitPoints(OBJECT_SELF) <= 100)
	{
		location lSelf = GetLocation(OBJECT_SELF);
		string sTag = GetTag(OBJECT_SELF);
		CreateObject(64, "door_limboearth", lSelf, FALSE, sTag);
		DestroyObject(OBJECT_SELF);
	}
}