//checks if the object with the tag sTag is valid or not
int StartingConditional(string sTag)
{
	object oPC = GetPCSpeaker();
	object oObj = GetNearestObjectByTag(sTag);
	
	return GetIsObjectValid(oObj);
}