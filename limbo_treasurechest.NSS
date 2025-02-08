#include "ff_safevar"

//**************************************************************
//Extension of ps_chest to randomly fill with xaos currency
//instead of gold
//Value of coinage controlled by the exact same variables as 
//the standard ps_chest, but will be rounded down to the nearest 
//combination of 200, 500, and 2500gp value
//**************************************************************
//05-20-18 - Mimi Fearthegn 
//Overrides the greater chance to find gems; instead we get more junk
//Should revisit when we redo loot tables
//**************************************************************
#include "ps_inc_chest"

void FillChestWithLimboCurrency(object oChest) {

	int iGolddice = PS_GetLocalInt(oChest,"GOLDDICE");
	int iGoldnr = PS_GetLocalInt(oChest,"GOLDNR");
	int iGoldcons = PS_GetLocalInt(oChest,"GOLDCONS");
	int iGoldAmount = 0;
		
	if(iGolddice > 0 && iGoldnr > 0)
	{
		int i = 0;
		for ( i = 0; i < iGoldnr; i++)
		{
			iGoldAmount =  iGoldAmount + Random(iGolddice) +1;	
		}
	}	
	iGoldAmount = iGoldAmount + iGoldcons;	
	while (iGoldAmount > 0)
	{
		if (iGoldAmount >= 2500)
		{
			CreateItemOnObject("ps_misc_coinage-xaosturd", oChest);
			iGoldAmount -= 2500;
			continue;
		}
		if (iGoldAmount >= 500)
		{
			CreateItemOnObject("ps_misc_coinage-xaosparrot", oChest);
			iGoldAmount -= 500;
			continue;
		}
		if (iGoldAmount >= 200)
		{
			CreateItemOnObject("ps_misc_coinage-xaosfish", oChest);
			iGoldAmount -= 200;
			continue;
		}
		break;
	}
}

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
		FillChestWithLimboCurrency(oChest);
		FillChestWithItems(oChest);
		GenerateTreasureItemOnTarget(oChest, nType);	
	}	
}