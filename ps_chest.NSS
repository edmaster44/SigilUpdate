#include "ps_inc_chest"

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