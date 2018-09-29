//should be deleted, no longer used

#include "x0_i0_treasure"

void FillGold(object oChest)
{
	int iGolddice = GetLocalInt(oChest,"GOLDDICE");
	int iGoldnr = GetLocalInt(oChest,"GOLDNR");
	int iGoldcons = GetLocalInt(oChest,"GOLDCONS");
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
		int nRandom = Random(6)+1;
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

void main()
{
	return;
//	SpeakString("chests",TALKVOLUME_SHOUT);

	object oPC = OBJECT_SELF;	
	
	if (!GetIsPC(oPC))
		return;
	
	object oArea = GetArea(OBJECT_SELF);
		
//	SpeakString("pc has entered",TALKVOLUME_SHOUT);
	
	/*	
	object oPCIterator = GetFirstPC();
	
	while (GetIsObjectValid(oPCIterator) == TRUE){
		if (GetArea(oPCIterator) == oArea && oPC != oPCIterator)
			return;
		oPCIterator = GetNextPC();
	}
	*/
	
//	SpeakString("area doesn't have other pcs",TALKVOLUME_SHOUT);
	
	object oItem = GetFirstObjectInArea(oArea);
	object oItem2 = OBJECT_INVALID;
	
	while(GetIsObjectValid(oItem)){
		int iType= GetObjectType(oItem);
		if ( iType == OBJECT_TYPE_PLACEABLE && TestStringAgainstPattern("ps_spawnchest**",GetTag(oItem)) == TRUE )
		{
//			SpeakString("found a chest",TALKVOLUME_SHOUT);
			oItem2 = GetFirstItemInInventory(oItem);
			if( !GetIsObjectValid(oItem2) ) //empty chest, fill it
			{
//				SpeakString("chest is empty, filling it " + GetTag(oItem),TALKVOLUME_SHOUT);
				FillGold(oItem);
				FillItems(oItem);
				GenerateNPCTreasure(TREASURE_TYPE_LOW, oItem, oItem);
			}
		}
		oItem = GetNextObjectInArea(oArea);
	}
}