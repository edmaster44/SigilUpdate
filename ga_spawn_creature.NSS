void main (string resRef, string sWP) {
	
	object oWP = GetWaypointByTag(sWP);
	object oCreature = GetObjectByTag(resRef);
	if (!GetIsObjectValid(oCreature))
	{
		CreateObject(OBJECT_TYPE_CREATURE, resRef, GetLocation(oWP));
	}
	else
	{
		SetScriptHidden(oCreature, FALSE);
	}

}