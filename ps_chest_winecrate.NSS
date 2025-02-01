#include "ff_safevar"

// v 1.01
#include "x0_i0_treasure"
#include "nwnx_sql"
#include "ps_inc_cards"
//#include "nwnx_srvadmin"

//const int cMidnight = 86400;
const int cChestWait = 915;


void FillGold(object oChest)
{
	int iGolddice = PS_GetLocalInt(oChest,"GOLDDICE");
	int iGoldnr = PS_GetLocalInt(oChest,"GOLDNR");
	int iGoldcons = PS_GetLocalInt(oChest,"GOLDCONS");
	int iGoldAmount = 0;
		
	if(iGolddice > 0 && iGoldnr > 0)
	{
//		SpeakString(IntToString(iGolddice),TALKVOLUME_SHOUT);	
//		SpeakString(IntToString(iGoldnr),TALKVOLUME_SHOUT);	
		
		int i = 0;
		for ( i = 0; i < iGoldnr; i++)
		{
			iGoldAmount =  iGoldAmount + Random(iGolddice) +1;
//			SpeakString("Total is: " + IntToString(iGoldAmount),TALKVOLUME_SHOUT);	
		}
	}	
	iGoldAmount = iGoldAmount + iGoldcons;
	
	if ( iGoldAmount > 0 )
		dbCreateItemOnObject("NW_IT_GOLD001", oChest, iGoldAmount);
		
//	SpeakString(IntToString(iGoldAmount),TALKVOLUME_SHOUT);	
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
		CreateGem(oChest,OBJECT_INVALID,nType);
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
	sItem = PS_GetLocalString(oChest,"TAG");
	if ( sItem != "" )
	{
		dbCreateItemOnObject(sItem, oChest, 1);
	}
	
	if (GetTag(oChest) == "ps_githint_chest")
	{
		if(d100() > 70)
		{
			CreateItemOnObject("astral_quest_obj", oChest);
		}
	}
	
	if (Random(200) < 1) CardsCreateCardOnSpawnOrChest(oChest);
	
	int nType = PS_GetLocalInt(oChest,"TYPE");
	if ( nType == 0 )
		nType = 1;
		
	sItem = PS_GetLocalString(oChest,"TREASURE1");
	nAmount = PS_GetLocalInt(oChest,"TREASURE1N");
	if ( nAmount == 0 )
		nAmount = 1;
	for ( i = 0; i < nAmount; i++ )
	{
		FillSpecificItem(oChest, sItem, nType);
	}
	
	sItem = PS_GetLocalString(oChest,"TREASURE2");
	nAmount = PS_GetLocalInt(oChest,"TREASURE2N");
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

void main()
{
	object oChest = OBJECT_SELF;

	int iChestWait = PS_GetLocalInt(oChest,"RESPAWN");
	
	object oPC = GetLastOpenedBy();
	
	if(iChestWait == 0)
		iChestWait = cChestWait;

	//	SpeakString(IntToString(GetTime()),TALKVOLUME_SHOUT);
	//	SpeakString(IntToString(PS_GetLocalInt(OBJECT_SELF,"TS")),TALKVOLUME_SHOUT);
				
	if(GetSQLTime()<PS_GetLocalInt(oChest,"TS"))
		TimeStamp(oChest,"TS");

	if(PS_GetLocalString(oChest,"LASTOPENER")==GetPCPublicCDKey(oPC))
		return;
					
	if(GetSQLTime()-PS_GetLocalInt(oChest,"TS") > iChestWait)
	{
		PS_SetLocalString(oChest,"LASTOPENER",GetPCPublicCDKey(oPC));	
	
		TimeStamp(oChest,"TS");
		//SpeakString("timestamping",TALKVOLUME_SHOUT);
		object oItem = GetFirstItemInInventory(oChest);
		if( GetIsObjectValid(oItem) )
		{
			CleanChest(oChest);
		}

	int randomNum = Random(4);
  switch (randomNum) {
   case 0: CreateItemOnObject("ps_qb_water", OBJECT_SELF);
   case 1: CreateItemOnObject("ps_drink_celestialwine", OBJECT_SELF);
   case 2: CreateItemOnObject("ps_gb_arborean", OBJECT_SELF);
   case 3: CreateItemOnObject("ps_valmisc_enigmabottle", OBJECT_SELF);
   default: CreateItemOnObject("ps_qb_water", OBJECT_SELF);
  }
	
	}
	
}