

void main( string sName )
{
	object oObj = OBJECT_SELF; //GetOwnedCharacter(OBJECT_SELF); 
	object oSlave = GetLocalObject(oObj, "SLAVE");
	
	if ((sName != "") && (GetIsObjectValid(oSlave)))
	{
		SetFirstName(oSlave, sName);
		object oItem = GetLocalObject(oSlave, "SLAVE_CONTROLLER");
		string sTag = GetSubString(GetTag(oItem), 0, 4);
		SetTag(oItem, sTag+"_"+sName);
	}
	
	DeleteLocalObject(oObj, "SLAVE");
}