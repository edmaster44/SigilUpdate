void main() {

	object oPC = GetExitingObject();
	
	string sName = GetLocalString(OBJECT_SELF, "INT_ONEX_NAME");
	int nValue = GetLocalInt(OBJECT_SELF, "INT_ONEX_VALUE");
	
	SetLocalInt(oPC, sName, nValue);

}