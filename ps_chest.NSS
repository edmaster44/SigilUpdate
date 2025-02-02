#include "ff_safevar"

#include "ps_inc_chest"

void main()
{
	object oChest = OBJECT_SELF;
	object oPC = GetLastOpenedBy();
	
	int iChestWait = PS_GetLocalInt(oChest,"RESPAWN");
	if(iChestWait == 0)
		iChestWait = cChestWait;

	//SpeakString(IntToString(PS_GetTime()),TALKVOLUME_SHOUT);
	//SpeakString(IntToString(PS_GetLocalInt(OBJECT_SELF,"TS")),TALKVOLUME_SHOUT);
				
	int nTimestamp = PS_GetLocalInt(oChest,"TS");
	if(PS_GetTime()<PS_GetLocalInt(oChest,"TS"))
		PS_Timestamp_UNIX(oChest,"TS");

	if(PS_GetLocalString(oChest,"LASTOPENER")==GetPCPublicCDKey(oPC))
		return;
		
	if (CheckIfHostilesNearby(OBJECT_SELF, oPC)) {
		SendMessageToPC(oPC, "You cannot loot while hostiles are near!");
		PS_SetLocalInt(OBJECT_SELF, "LOOT_CANCELED", 1);
		return;
	}
	
	nTimestamp = PS_GetLocalInt(oChest,"TS");
	if((PS_GetTime()-nTimestamp) > iChestWait)
	{
		PS_SetLocalString(oChest,"LASTOPENER",GetPCPublicCDKey(oPC));	
	
		PS_Timestamp_UNIX(oChest,"TS");
		
		//SpeakString("timestamping",TALKVOLUME_SHOUT);
		object oItem = GetFirstItemInInventory(oChest);
		if(GetIsObjectValid(oItem)) {
			CleanChest(oChest);
		}
		
		int nType = PS_GetLocalInt(oChest,"TYPE");
		if (nType == 0)
			nType = 1;

		//SpeakString("creating treasure",TALKVOLUME_SHOUT);
		FillChestWithGold(oChest);
		FillChestWithItems(oChest);
		GenerateTreasureItemOnTarget(oChest, nType);	
	}	
}