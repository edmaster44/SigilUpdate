void main()
{

	SpeakString("Here I am!", TALKVOLUME_SHOUT);
	location lLoc = GetItemActivatedTargetLocation();
	object oItem = GetItemActivated();
	
	CreateObject(OBJECT_TYPE_PLACEABLE, "plc_boxofdistractions", lLoc);
	DestroyObject(oItem);

}