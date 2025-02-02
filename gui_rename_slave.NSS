#include "ff_safevar"

void main( string sName )
{
	object oObj = OBJECT_SELF; //GetOwnedCharacter(OBJECT_SELF); 
	object oSlave = PS_GetLocalObject(oObj, "SLAVE");
	
	if ((sName != "") && (GetIsObjectValid(oSlave)))
	{
		SetFirstName(oSlave, sName);
		object oItem = PS_GetLocalObject(oSlave, "SLAVE_CONTROLLER");
		string sTag = GetSubString(GetTag(oItem), 0, 4);
		SetTag(oItem, sTag+"_"+sName);
	}
	
	PS_DeleteLocalObject(oObj, "SLAVE");
}