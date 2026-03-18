const float LOOT_COOLDOWN_HOURS = 6.0; //set to 5.5 for 5 hours and 30 mins, 5.25 for 5 hours 15 mins, etc

#include "ps_inc_chest"

string GetLocationString(object oPlaceable){
	location lLoc = GetLocation(oPlaceable);
    vector vPos = GetPositionFromLocation(lLoc);
    return GetTag(GetArea(oPlaceable)) + "_" + 
		 FloatToString(vPos.x, 5, 2) + "_" + 
		 FloatToString(vPos.y, 5, 2) + "_" + 
		 FloatToString(vPos.z, 5, 2);
}

void main()
{
	object oChest = OBJECT_SELF;
	object oPC = GetLastOpenedBy();
	string sChestLoc = GetLocationString(oChest);
	
	// Per player loot: if this PC has already opened this chest within the cooldown time hours, 
	// then bail with message.
    string sLootedTime = "LOOTED_" + sChestLoc;
	
	int nTime = PS_GetTime();
	int nTimeLooted = GetLocalInt(oPC, sLootedTime);
	int nCooldown = FloatToInt(LOOT_COOLDOWN_HOURS * 3600.0); //convert cooldown to seconds
	int nDiff = nTime - nTimeLooted; 
	if (nDiff < nCooldown){
		int nSeconds = nCooldown - nDiff;
		int nHours = nSeconds / 3600;
		int nMinutes = (nSeconds % 3600) / 60;
		string sMessage = "You have already opened this chest within the last ";
		sMessage += FloatToString(LOOT_COOLDOWN_HOURS, 2, 2) + " hour";
		if (LOOT_COOLDOWN_HOURS != 1.0) sMessage += "s";
		sMessage += ".\nYou must wait ";
		if (nHours > 0){
			sMessage += IntToString(nHours) + " hour";
			if (nHours > 1) sMessage += "s";
		}
		if (nMinutes > 0){
			if (nHours > 0) sMessage += " and ";
			sMessage += IntToString(nMinutes) + " minute";
			if (nMinutes > 1) sMessage += "s";
		}
		sMessage += " or until server reset before you can loot from this location again.";
		SendMessageToPC(oPC, sMessage);
        return;
	}
	
		
	if (CheckIfHostilesNearby(OBJECT_SELF, oPC)) {
		SendMessageToPC(oPC, "You cannot loot while hostiles are near!");
		AssignCommand(oChest, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
		return;
	}
	
	// First time this PC opens this chest: mark as looted for this player at this time
    SetLocalInt(oPC, sLootedTime, nTime);
	int nType = GetLocalInt(oChest,"TYPE");
	if (nType == 0) nType = 1;

	FillChestWithGold(oChest);
	FillChestWithItems(oChest);
	GenerateTreasureItemOnTarget(oChest, nType);		
}

//Original
/*
void main()
{
	object oChest = OBJECT_SELF;
	object oPC = GetLastOpenedBy();
	
	int iChestWait = GetLocalInt(oChest,"RESPAWN");
	if(iChestWait == 0)
		iChestWait = cChestWait;

	//SpeakString(IntToString(PS_GetTime()),TALKVOLUME_SHOUT);
	//SpeakString(IntToString(GetLocalInt(OBJECT_SELF,"TS")),TALKVOLUME_SHOUT);
				
	int nTimestamp = GetLocalInt(oChest,"TS");
	if(PS_GetTime()<GetLocalInt(oChest,"TS"))
		PS_Timestamp_UNIX(oChest,"TS");

	if(GetLocalString(oChest,"LASTOPENER")==GetPCPublicCDKey(oPC))
		return;
		
	if (CheckIfHostilesNearby(OBJECT_SELF, oPC)) {
		SendMessageToPC(oPC, "You cannot loot while hostiles are near!");
		SetLocalInt(OBJECT_SELF, "LOOT_CANCELED", 1);
		return;
	}
	
	nTimestamp = GetLocalInt(oChest,"TS");
	if((PS_GetTime()-nTimestamp) > iChestWait)
	{
		SetLocalString(oChest,"LASTOPENER",GetPCPublicCDKey(oPC));	
	
		PS_Timestamp_UNIX(oChest,"TS");
		
		//SpeakString("timestamping",TALKVOLUME_SHOUT);
		object oItem = GetFirstItemInInventory(oChest);
		if(GetIsObjectValid(oItem)) {
			CleanChest(oChest);
		}
		
		int nType = GetLocalInt(oChest,"TYPE");
		if (nType == 0)
			nType = 1;

		//SpeakString("creating treasure",TALKVOLUME_SHOUT);
		FillChestWithGold(oChest);
		FillChestWithItems(oChest);
		GenerateTreasureItemOnTarget(oChest, nType);	
	}	
}
*/