void main() {

	object oPC = GetEnteringObject();
	
	string sName = GetLocalString(OBJECT_SELF, "INT_ONE_NAME");
	int nValue = GetLocalInt(OBJECT_SELF, "INT_ONE_VALUE");
	
	SendMessageToPC(oPC, "adding "+sName+", "+IntToString(nValue)); 
	SetLocalInt(oPC, sName, nValue);

}