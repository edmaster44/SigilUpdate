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

#include "x0_i0_treasure"
#include "nwnx_sql"
#include "ps_random_item_spawn"
#include "ps_inc_cards"
const int cChestWait = 915;

void FillLimboCurrency(object oChest) {

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

void FillSpecificItem(object oChest, string sTreasure, int nType = 1)
{
	if ( sTreasure == "BOOK" )
	{
		CreateBook(oChest);
	}
	else if ( sTreasure == "JUNK" )
	{
		CreateJunk(oChest);
	}
	else if ( sTreasure == "GEM" )
	{
		CreateJunk(oChest);
		//CreateGem(oChest,OBJECT_INVALID,nType);
	}
	else if ( sTreasure == "ARCANE" )
	{
		CreateArcaneScroll(oChest,OBJECT_INVALID,nType * 5);
	}
	else if ( sTreasure == "AMMO" )
	{
		CreateAmmo(oChest,OBJECT_INVALID,nType * 5);
	}
	else if ( sTreasure == "KIT" )
	{
		CreateKit(oChest,OBJECT_INVALID,nType * 5);
	}
	else if ( sTreasure == "POTION" )
	{
		CreatePotion(oChest,OBJECT_INVALID,nType);
	}	
	else if ( sTreasure == "RANDOM" ) //recursion
	{
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
	string sItem;
	int nAmount=0;
	int i=0;
	sItem = GetLocalString(oChest,"TAG");
	if ( sItem != "" )
	{
		dbCreateItemOnObject(sItem, oChest, 1);
	}
	
	int nType = GetLocalInt(oChest,"TYPE");
	if ( nType == 0 )
		nType = 1;
		
	sItem = GetLocalString(oChest,"TREASURE1");
	nAmount = GetLocalInt(oChest,"TREASURE1N");
	if ( nAmount == 0 )
		nAmount = 1;
	for ( i = 0; i < nAmount; i++ )
	{
		FillSpecificItem(oChest, sItem, nType);
	}
	
	sItem = GetLocalString(oChest,"TREASURE2");
	nAmount = GetLocalInt(oChest,"TREASURE2N");
	if ( nAmount == 0 )
		nAmount = 1;
	for ( i = 0; i < nAmount; i++ )
	{
		FillSpecificItem(oChest, sItem, nType);
	}
}

int GetSQLTime()
{
	int utc;
	
	SQLExecDirect("SELECT UNIX_TIMESTAMP()");
	
	while (SQLFetch() != SQL_ERROR)
	{
		utc = StringToInt(SQLGetData(1));	
	}
	return utc;
}

/*int GetTime()
{
    return GetTimeSecond()+60*GetTimeMinute()+3600*GetTimeHour();
}*/

//returns an int in secs of time passed
// checking for the passage of midnight
int GetTimePassed(int iBegin, int iEnd)
{
	// if begin is smaller simple subtraction
   if(iBegin < iEnd)
   {
       return (iEnd - iBegin);
   }
   //only happens when midnight has passed
   /* Not needed anymore
   if (iBegin > iEnd)
   {
       return ( (cMidnight - iBegin) + iEnd);
       //trust me it works
   }
   */
   else
   {
       return 0;//begin == end time is zero
   }
}

//TimeStamp(object)  self explanatory no?
//the variable will be called <objecttag>_timestamp
void TimeStamp(object oObject=OBJECT_SELF, string sTimeStampVariable = "")
{
  if (sTimeStampVariable == "") sTimeStampVariable = GetTag(oObject)+"_s";
   SetLocalInt(oObject, sTimeStampVariable, GetSQLTime());
}

//CheckTimeStamp(object)  self explanatory no?
//returns the difference in time between NOW and the last timestamp
//the variable will be called <objecttag>_timestamp
int CheckTimeStamp(object oObject=OBJECT_SELF, string sTimeStampVariable = "")
{
  if (sTimeStampVariable == "") sTimeStampVariable = GetTag(oObject)+"_s";
  int iOld = GetLocalInt(oObject, sTimeStampVariable);
  int iNew = GetSQLTime();
  return GetTimePassed(iOld, iNew);
}

void CleanChest(object oChest)
{
object oItem = GetFirstItemInInventory(oChest);
if(GetIsObjectValid(oItem))
    {
    while(GetIsObjectValid(oItem))
        {
        SetPlotFlag(oItem, FALSE);
        DestroyObject(oItem);
        oItem = GetNextItemInInventory();
        }
    }
}

void main () {

	object oChest = OBJECT_SELF;

	int iChestWait = GetLocalInt(oChest,"RESPAWN");
	
	object oPC = GetLastOpenedBy();
	
	if(iChestWait == 0)
		iChestWait = cChestWait;

	//	SpeakString(IntToString(GetTime()),TALKVOLUME_SHOUT);
	//	SpeakString(IntToString(GetLocalInt(OBJECT_SELF,"TS")),TALKVOLUME_SHOUT);
				
	if(GetSQLTime()<GetLocalInt(oChest,"TS"))
		TimeStamp(oChest,"TS");

	if(GetLocalString(oChest,"LASTOPENER")==GetPCPublicCDKey(oPC))
		return;
					
	if(GetSQLTime()-GetLocalInt(oChest,"TS") > iChestWait)
	{
		SetLocalString(oChest,"LASTOPENER",GetPCPublicCDKey(oPC));	
	
		TimeStamp(oChest,"TS");
		//SpeakString("timestamping",TALKVOLUME_SHOUT);
		object oItem = GetFirstItemInInventory(oChest);
		if( GetIsObjectValid(oItem) )
		{
			CleanChest(oChest);
		}

		FillLimboCurrency(oChest);
		FillItems(oChest);
		
		if (Random(100) <= 1)
			CreateRandomDropItem(OBJECT_SELF);
		if (Random(100) <= 1) 
			CardsCreateCardOnSpawnOrChest(OBJECT_SELF);
			
		//GenerateNPCTreasure(TREASURE_TYPE_LOW, oChest, oChest);
	
	}

}