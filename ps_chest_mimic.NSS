// The standard ps_chest script. . . but with chance of monster!
#include "x0_i0_treasure"
#include "nwnx_sql"
#include "ps_inc_cards"
#include "ps_inc_spawns"
const int cChestWait = 915;

void FillGold(object oChest)
{
	SpeakString("filling gold", TALKVOLUME_SHOUT);
	int iGolddice = GetLocalInt(oChest,"GOLDDICE");
	int iGoldnr = GetLocalInt(oChest,"GOLDNR");
	int iGoldcons = GetLocalInt(oChest,"GOLDCONS");
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
	
	if ( iGoldAmount > 0 )
		dbCreateItemOnObject("NW_IT_GOLD001", oChest, iGoldAmount);
		
}

void FillSpecificItem(object oChest, string sTreasure, int nType = 1)
{
	if ( sTreasure == "BOOK" ) {
		CreateBook(oChest);
	} else if ( sTreasure == "JUNK" ) {
		CreateJunk(oChest);
	} else if ( sTreasure == "GEM" ) {
		CreateGem(oChest,OBJECT_INVALID,nType);
	} else if ( sTreasure == "ARCANE" ) {
		CreateArcaneScroll(oChest,OBJECT_INVALID,nType * 5);
	} else if ( sTreasure == "AMMO" ) {
		CreateAmmo(oChest,OBJECT_INVALID,nType * 5);
	} else if ( sTreasure == "KIT" ) {
		CreateKit(oChest,OBJECT_INVALID,nType * 5);
	} else if ( sTreasure == "POTION" ) {
		CreatePotion(oChest,OBJECT_INVALID,nType);
	} else if ( sTreasure == "RANDOM" )  {
		int nRandom = Random(7)+1;
		switch (nRandom)
		{
        	case 1: FillSpecificItem(oChest,"BOOK",nType); break;
           	case 2: FillSpecificItem(oChest,"JUNK",nType); break;
            case 3: FillSpecificItem(oChest,"GEM",nType); break;
            case 4: FillSpecificItem(oChest,"ARCANE",nType); break;
            case 5: FillSpecificItem(oChest,"AMMO",nType); break;
			case 6: FillSpecificItem(oChest,"KIT",nType); break;
			case 7: FillSpecificItem(oChest,"POTION",nType); break;
        }
	}
}

void FillItems(object oChest)
{
	SpeakString("filling items", TALKVOLUME_SHOUT);
	string sItem;
	int nAmount=0;
	int i=0;
	sItem = GetLocalString(oChest,"TAG");
	if ( sItem != "" ) {
		dbCreateItemOnObject(sItem, oChest, 1);
	}
	
	if (Random(200) < 1) CardsCreateCardOnSpawnOrChest(oChest);
	
	int nType = GetLocalInt(oChest,"TYPE");
	if ( nType == 0 )
		nType = 1;
		
	sItem = GetLocalString(oChest,"TREASURE1");
	nAmount = GetLocalInt(oChest,"TREASURE1N");
	if ( nAmount == 0 )
		nAmount = 1;
	for ( i = 0; i < nAmount; i++ ) {
		FillSpecificItem(oChest, sItem, nType);
	}
	
	sItem = GetLocalString(oChest,"TREASURE2");
	nAmount = GetLocalInt(oChest,"TREASURE2N");
	if ( nAmount == 0 )
		nAmount = 1;
	for ( i = 0; i < nAmount; i++ ) {
		FillSpecificItem(oChest, sItem, nType);
	}
}

int GetSQLTime()
{
	int utc;
	SQLExecDirect("SELECT UNIX_TIMESTAMP()");
	while (SQLFetch() != SQL_ERROR) {
		utc = StringToInt(SQLGetData(1));	
	}
	return utc;
}

//TimeStamp(object)  self explanatory no?
//the variable will be called <objecttag>_timestamp
void TimeStampSQL(object oObject=OBJECT_SELF, string sTimeStampVariable = "")
{
  if (sTimeStampVariable == "") sTimeStampVariable = GetTag(oObject)+"_s";
   SetLocalInt(oObject, sTimeStampVariable, GetSQLTime());
}

void CleanChest(object oChest)
{
	SpeakString("cleaning chest", TALKVOLUME_SHOUT);
	object oItem = GetFirstItemInInventory(oChest);
	if(GetIsObjectValid(oItem)) {
	    while(GetIsObjectValid(oItem))  {
	        SetPlotFlag(oItem, FALSE);
	        DestroyObject(oItem);
	        oItem = GetNextItemInInventory();
        }
    }
}

void main()
{
	object oChest = OBJECT_SELF;
	int iChestWait = GetLocalInt(oChest,"RESPAWN");
	int iMimic = GetLocalInt(oChest, "MIMIC_CHANCE");
	object oPC = GetLastOpenedBy();
	SpeakString("opening chest", TALKVOLUME_SHOUT);
	
	if (d100() < iMimic) {
		string sMimic = GetLocalString(oChest, "MIMIC_TAG");
		float nMimicLow = IntToFloat(GetLocalInt(oChest, "MIMIC_LOW_CR"));
		float nMimicHigh = IntToFloat(GetLocalInt(oChest, "MIMIC_HIGH_CR"));
  		float avg = PS_GetAvgPartylevel(oPC,PS_GetMaxPartylevel(oPC));
		int iDiff = PS_GetDifficulty(oPC);
		SpeakString("spawning mimic "+sMimic, TALKVOLUME_SHOUT);
		
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
		DestroyObject(OBJECT_SELF, 0.1f);
	} else {
		SpeakString("spawning treasure", TALKVOLUME_SHOUT);
		if(iChestWait == 0)
			iChestWait = cChestWait;
					
		int lastStamped = GetLocalInt(oChest,"TS");
		int currentTime = GetSQLTime();
		SpeakString("last stamped: "+IntToString(lastStamped)+" vs. now "+IntToString(currentTime)+" vs. wait: "+IntToString(iChestWait), TALKVOLUME_SHOUT);
		if(currentTime<lastStamped)
			TimeStampSQL(oChest,"TS");
	
		if(GetLocalString(oChest,"LASTOPENER")==GetPCPublicCDKey(oPC))
			return;
						
		if(currentTime-lastStamped > iChestWait) {
		
			SpeakString("creating treasure", TALKVOLUME_SHOUT);
			SetLocalString(oChest,"LASTOPENER", GetPCPublicCDKey(oPC));	
		
			TimeStampSQL(oChest,"TS");
			object oItem = GetFirstItemInInventory(oChest);
			if( GetIsObjectValid(oItem) ) {
				CleanChest(oChest);
			}
	
			FillGold(oChest);
			FillItems(oChest);
			GenerateNPCTreasure(TREASURE_TYPE_LOW, oChest, oChest);
		
		}
	}
}