

void main()
{
	object oWP = GetLocalObject(OBJECT_SELF, "RETURN_PORTAL");
	if (oWP == OBJECT_INVALID) return;
	JumpToObject(oWP);
}