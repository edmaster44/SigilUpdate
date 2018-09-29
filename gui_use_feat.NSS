void main(string nFeatID)
{
	//SendMessageToPC(OBJECT_SELF, "Trying to use feat ID "+nFeatID);
	if (GetPlayerCurrentTarget(OBJECT_SELF) == OBJECT_INVALID) ActionUseFeat(StringToInt(nFeatID), OBJECT_SELF);
	else ActionUseFeat(StringToInt(nFeatID), GetPlayerCurrentTarget(OBJECT_SELF));
}