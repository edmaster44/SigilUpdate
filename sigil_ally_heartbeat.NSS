void main()
{
	object oNPC = OBJECT_SELF;
	location lNPC = GetLocation(oNPC);
	object oPC = GetFirstObjectInShape(SHAPE_SPHERE, 100.0, lNPC, TRUE);
	while (oPC != OBJECT_INVALID)
	{
		if ((GetIsPC(oPC) == TRUE) && (GetIsDead(oPC) == FALSE)) return;
		oPC = GetNextObjectInShape(SHAPE_SPHERE, 100.0, lNPC, TRUE);
	}
	SetIsDestroyable(TRUE);
	DestroyObject(oNPC);
}