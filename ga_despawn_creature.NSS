void main (string resRef) {
	
	if (resRef == "")
		DestroyObject(OBJECT_SELF);

	object oCreature = GetObjectByTag(resRef);
	if (GetIsObjectValid(oCreature))
		DestroyObject(oCreature);
}