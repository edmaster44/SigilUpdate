//***************************************************************************
//	If the PC is searching in the area, then they might find something!
// Mimi Fearthegn
// 6/30/19
//***************************************************************************
#include "ps_inc_time"

void RevealObject(object oSelf, object oPC) {

	string sWP 		= GetLocalString(oSelf, "WaypointToSpawn");
	string sObj 	= GetLocalString(oSelf, "ResrefToSpawn");
	string sMessage = GetLocalString(oSelf, "MessageToSend");
	object oWP 		= GetWaypointByTag(sObj);
	
	int nDC = GetLocalInt(oSelf, "SkillDC");
	
	if (GetIsSkillSuccessful(oPC, SKILL_SEARCH, nDC, TRUE)) {
	
		if (sMessage != "") 
			SendMessageToPC(oPC, sMessage);
			
		CreateObject(OBJECT_TYPE_PLACEABLE, sObj, GetLocation(oWP));
	}

}

void main()
{
	object oPC = GetEnteringObject();
	
	int nTime = GetLocalInt(OBJECT_SELF, "RespawnTime");
	
	if (!GetIsPC(oPC)) 
		return;
	
	//if (PS_GetTimestamp_Age_Seconds(OBJECT_SELF, "LastSearch") < nTime)
	//	return;
		
	float fRand1 = IntToFloat(Random(3));
	float fRand2 = IntToFloat(Random(10))/10.0f;
	
	float fDelay = fRand1+fRand2;
	DelayCommand(fDelay, RevealObject(OBJECT_SELF, oPC));
		
	PS_Timestamp_UNIX(OBJECT_SELF, "LastSearch");
}