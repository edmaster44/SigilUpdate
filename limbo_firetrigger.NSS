void main ()
{
	object oPC = GetEnteringObject();
	string sTag = GetTag(OBJECT_SELF);
	object oBridge;
	if (GetLocalInt(oPC, sTag) == 1 || GetIsDM(oPC))
		return;
	
	//rolling. . .
	int nSuccess = 0;
	int nWis = GetWillSavingThrow(oPC);
	int nRoll = d20();
	if ((nWis+nRoll) >= 20)
	{
		SendMessageToPC(oPC, "Will Roll: "+IntToString(nWis)+"+"+IntToString(nRoll)+"="+IntToString(nWis+nRoll)+" Success!");
		AssignCommand(oPC, ActionSpeakString("<i>"+GetName(oPC)+" creates a bridge over the lava through sheer willpower.</i>"));
		nSuccess = 1;
	}
	else
	{
		SetLocalInt(oPC, sTag, 1);
		SendMessageToPC(oPC, "Will Roll: "+IntToString(nWis)+"+"+IntToString(nRoll)+"="+IntToString(nWis+nRoll)+" Failure.");	
	}
	
	//particular behavior
	if (sTag == "trg_firebridge_1" && nSuccess == 1)
	{
		oBridge = GetNearestObjectByTag("br_firebridge_1");
		if (GetIsObjectValid(oBridge) == FALSE)
		{
			CreateObject(64, "bridge_firelimbo", GetLocation(GetWaypointByTag("firebridge_1")), FALSE, "br_firebridge_1");
			DestroyObject(GetNearestObjectByTag("pl_firebridge_block_1a"));
			DestroyObject(GetNearestObjectByTag("pl_firebridge_block_1b"));
		}
	}
	else if (sTag == "trg_firebridge_2" && nSuccess == 1)
	{
		oBridge = GetNearestObjectByTag("br_firebridge_2");
		if (GetIsObjectValid(oBridge) == FALSE)
		{
			CreateObject(64, "bridge_firelimbo", GetLocation(GetWaypointByTag("firebridge_2")), FALSE, "br_firebridge_2");
			DestroyObject(GetNearestObjectByTag("pl_firebridge_block_2a"));
			DestroyObject(GetNearestObjectByTag("pl_firebridge_block_2b"));
		}
	}
	else if (sTag == "trg_firebridge_3" && nSuccess == 1)
	{
		oBridge = GetNearestObjectByTag("br_firebridge_3");
		if (GetIsObjectValid(oBridge) == FALSE)
		{
			CreateObject(64, "bridge_firelimbo_2", GetLocation(GetWaypointByTag("firebridge_3")), FALSE, "br_firebridge_3");
			DestroyObject(GetNearestObjectByTag("pl_firebridge_block_3a"));
			DestroyObject(GetNearestObjectByTag("pl_firebridge_block_3b"));
		}
	}
}