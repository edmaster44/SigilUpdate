void main()
{
	object oFONT = OBJECT_SELF;
	string sNAME = GetName(oFONT);
	if (GetStringLeft(sNAME, 1) == "E") return;
	if (GetCurrentHitPoints(oFONT) <= 1) DestroyObject(oFONT);
}