

#include "ps_inc_chest"
#include "ps_inc_spawns"

//The standard ps_chest script. . . but with chance of monster!
//To be used only on chests which the area respawns
//Will destroy the chest and replace it with the defined creature
void main()
{
	object oChest = OBJECT_SELF;
	int iChestWait = GetLocalInt(oChest,"RESPAWN");
	int iMimic = GetLocalInt(oChest, "MIMIC_CHANCE");
	int nNoMimic = GetLocalInt(oChest, "NO_MIMIC");
	object oPC = GetLastOpenedBy();
	
	if (d100() < iMimic && nNoMimic == 0) {
		string sMimic = GetLocalString(oChest, "MIMIC_TAG");
		float nMimicLow = IntToFloat(GetLocalInt(oChest, "MIMIC_LOW_CR"));
		float nMimicHigh = IntToFloat(GetLocalInt(oChest, "MIMIC_HIGH_CR"));
  		float avg = PS_GetAvgPartylevel(oPC,PS_GetMaxPartylevel(oPC));
		int iDiff = PS_GetDifficulty(oPC);
		
		string mod = "";
		if(nMimicLow==0.0f || nMimicHigh==0.0f || iDiff == DIFFLOW)
		   mod="";
		else if(avg>nMimicLow && avg<nMimicHigh && iDiff == DIFFNORM)
		   mod="2";
		else if(avg>=nMimicHigh || iDiff == DIFFHIGH || iDiff == DIFFVERY)
		   mod="3";
		   
		int iEliteChance = 97;
		if (iDiff == DIFFHIGH)
		    iEliteChance = 95;
		else if (iDiff == DIFFVERY)
		    iEliteChance = 90;
		   
		SpawnMonster(OBJECT_SELF, sMimic, OBJECT_SELF, avg, iEliteChance, mod);
		
		SetPlotFlag(OBJECT_SELF, FALSE);
		DestroyObject(OBJECT_SELF, 0.2f);
	} else {
		//Rolled for no mimic; make sure mimic doesn't spawn for 10 minutes
		SetLocalInt(oChest, "NO_MIMIC", 1);
		DelayCommand(600.0f, DeleteLocalInt(oChest, "NO_MIMIC"));
		
		if(iChestWait == 0)
			iChestWait = cChestWait;
					
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
			
			object oItem = GetFirstItemInInventory(oChest);
			if(GetIsObjectValid(oItem)) {
				CleanChest(oChest);
			}
			
			int nType = GetLocalInt(oChest,"TYPE");
			if (nType == 0)
				nType = 1;
	
			FillChestWithGold(oChest);
			FillChestWithItems(oChest);
			GenerateTreasureItemOnTarget(oChest, nType);	
		}	
	}
}