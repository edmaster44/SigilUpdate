

/*#include "nwnx_sql"
#include "ps_inc_time"


const string SCREENNAME = "STORAGE_NEW";
const int MaxRows = 35;



void GetRecentlyStoredItems(object oPC, string sFilter = "");
string GetObjectTypeString(int iType);
void DisableButtons(object oPC, int iMode);
void EnableButtons(object oPC, int iMode);
string GetGuildID(object oPC, string guild);
string GetPCID(object oPC);

string GetStorageItemIconByTag(string oItem)
{
	string sIcon = Get2DAString("nwn2_icons","ICON",GetItemIcon(GetObjectByTag(oItem)));
	return sIcon == "" ? "temp0.tga" : sIcon + ".tga";
}

void PopulateGuildBox(object oPC, string sGuild, int iCounter, string sGuildToken, int iGuildAccess)
{
	string svariable = "15="+GetGuildID(oPC,sGuild)+";16=guild;17="+IntToString(iGuildAccess);				
			
	AddListBoxRow( oPC,
	SCREENNAME,
	"GuildListings",
	"RetrieveRow"+IntToString(iCounter),
	"RetrievePaneName="+sGuild+";",
	"RetrievePaneIcon="+GetStorageItemIconByTag(sGuildToken)+";",
	""+svariable+"",				
	"");
}

void PopulateGuildStorage(object oPC)
{
	int iValid, iCounter, iGuildAccess; string sGuild, sGuildToken;
	
	DisableButtons(oPC,1);	
	SetGUIObjectHidden(oPC,SCREENNAME,"GuildPane",FALSE);	
	ClearListBox(oPC,SCREENNAME,"GuildListings");
	ClearListBox(oPC,SCREENNAME,"TUTORIAL_LISTBOX");
	SetGUIObjectText(oPC,SCREENNAME,"FilterText",-1,"");
				
	string name = GetName(oPC);	
	string svariable = "15="+GetPCID(oPC)+";16=personal";
				 
	AddListBoxRow( oPC,
	SCREENNAME,
	"GuildListings",
	"RetrieveRow"+IntToString(iCounter),
	"RetrievePaneName="+name+";",
	"RetrievePaneIcon=it_bagholding.tga;",
	""+svariable+"",	
	"");			 

	SQLExecDirect("SELECT `Guild`, `GuildToken`, `GuildAccess` FROM `guildstorage`" +
	             " WHERE `StoreType` = 'CRAFTBANK' ORDER BY `Guild`,`GuildAccess` DESC");					 			 
	while (SQLFetch())
	{
		sGuild = SQLGetData(1);
		sGuildToken = SQLGetData(2);
		iGuildAccess = StringToInt(SQLGetData(3));
		
		if (sGuild != "")
		{
			if (GetItemPossessedBy(oPC,sGuildToken)!= OBJECT_INVALID)
			{
				DelayCommand(0.1f,PopulateGuildBox(oPC,sGuild,iCounter,sGuildToken,iGuildAccess));
				iValid++;
			}
		
			iCounter++;
		}
	}
	
	
	if (iValid == 0) EnableButtons(oPC,1);
}

void DoEverything(object oPC)
{
	int iLoop;
	while(255 > iLoop)
	{
		SQLExecDirect("UPDATE `new_storage` SET `category`='"+SQLEncodeSpecialChars(GetObjectTypeString(iLoop))+"' WHERE `category`='"+IntToString(iLoop)+"';");
		SQLExecDirect("UPDATE `new_storage_guildstorage` SET `category`='"+SQLEncodeSpecialChars(GetObjectTypeString(iLoop))+"' WHERE `category`='"+IntToString(iLoop)+"';");	
		SendMessageToPC(oPC,"Doing category: "+IntToString(iLoop));
		iLoop++;
	}
}

string GetObjectTypeString(int iType)
{
	string sType;
	switch (iType)
	{
		case 0: case 1: case 2: case 3: case 4: case 5: case 6:
		case 7: case 8: case 9: case 10: case 11: case 12: case 13: sType = "weapon"; break;
		case 14: sType = "armor"; break;
		case 15: sType = "misc"; break;
		case 16: case 17: sType = "armor"; break;
		case 18: sType = "weapon"; break;
		case 19: sType = "jewelry"; break;
		case 20: sType = "weapon"; break;
		case 21: sType = "misc"; break;
		case 22: sType = "weapon"; break;
		case 24: sType = "misc"; break;
		case 25: sType = "weapon"; break;
		case 26: sType = "armor"; break;
		case 27: case 28: sType = "weapon"; break;
		case 29:  sType = "misc"; break;
		case 31: case 32: case 33: sType = "weapon"; break;
		case 34: sType = "misc"; break;
		case 35: sType = "weapon"; break;
		case 36: sType = "armor"; break;
		case 37: case 38: case 40: case 41: case 42: sType = "weapon"; break;
		case 43: sType = "misc"; break;
		case 44: case 45: case 46: case 47: sType = "weapon"; break;
		case 50: case 51: sType = "weapon"; break;
		case 52: sType = "jewelry"; break;
		case 53: sType = "weapon"; break;
		case 54: sType = "misc"; break;
		case 55: sType = "weapon"; break;
		case 56: case 57: sType = "armor"; break;
		case 58: case 59: case 60: case 61: sType = "weapon"; break;
		case 62: sType = "misc"; break;
		case 63: sType = "weapon"; break;
		case 64: case 66: case 68: sType = "misc"; break;
		case 65: case 138: sType = "key"; break;
		case 69: case 70: case 71: case 72: sType = "weapon"; break;
		case 74: sType = "book"; break;
		case 77: sType = "craft"; break;
		case 78: sType = "armor"; break;
		case 79: case 80: sType = "misc"; break;
		case 81: sType = "weapon"; break;
		case 101: case 102: case 103: sType = "craft"; break;
		case 104: case 105: case 106: sType = "misc"; break;
		case 108: sType = "weapon"; break;
		case 109: case 110: sType = "craft"; break;
		case 111: case 113: case 114: case 116:
		case 119: case 120: case 124: case 126: sType = "weapon"; break;
		case 128: case 129: case 132: sType = "misc"; break;
		case 140: case 141: case 142: sType = "weapon"; case 202: case 205: break;
		case 212: case 127: sType = "gathering"; break;
		case 39: case 49: case 75: sType = "consumable"; break;
		default: sType = "invalid"; break;
	}

	return sType;
}

void SetBoxInfoText(object oPC)
{
	string sText;
	string sText1 = "<C=gold>To retrieve items in storage:</C> left double click";
	string sText2 = "<C=gold>To examine items in storage:</C> right double click";
	string sText3 = "<C=gold>To store bags or other items:</C> drag items into icon below";	
	string sText4 = "<C=gold>Found any bugs?</C> Make a bug report ticket on the forum";	
		
	sText = sText1 + "\n\n" + sText2 + "\n\n" + sText3 + "\n\n" +sText4;
	
	SetGUIObjectText(oPC,SCREENNAME,"ScreenText",-1,sText);
}

void DisableButtons(object oPC, int iMode)
{
	if(iMode == 1) //EVERYTHING
	{
		SetGUIObjectDisabled(oPC,SCREENNAME,"CloseButton",TRUE);
		SetGUIObjectDisabled(oPC,SCREENNAME,"StorePlane",TRUE);
		SetGUIObjectDisabled(oPC,SCREENNAME,"TUTORIAL_SIDEBAR",TRUE);
		SetGUIObjectDisabled(oPC,SCREENNAME,"TUTORIAL_LISTBOX",TRUE);
		SetGUIObjectHidden(oPC,SCREENNAME,"StorageGrid",TRUE);
		SetGUIObjectDisabled(oPC,SCREENNAME,"NextAndPrevPane",TRUE);	
		SetGUIObjectDisabled(oPC,SCREENNAME,"BUTTON_CONTAINER",TRUE);	
		SetGUIObjectDisabled(oPC,SCREENNAME,"MinimizeButton",TRUE);			
		SetGUIObjectDisabled(oPC,SCREENNAME,"UnMinimizeButton",TRUE);						
	}
}

void EnableButtons(object oPC, int iMode)
{
	if(iMode == 1) //EVERYTHING
	{
		SetGUIObjectDisabled(oPC,SCREENNAME,"CloseButton",FALSE);
		SetGUIObjectDisabled(oPC,SCREENNAME,"StorePlane",FALSE);
		SetGUIObjectDisabled(oPC,SCREENNAME,"TUTORIAL_SIDEBAR",FALSE);
		SetGUIObjectDisabled(oPC,SCREENNAME,"TUTORIAL_LISTBOX",FALSE);
		SetGUIObjectHidden(oPC,SCREENNAME,"StorageGrid",FALSE);
		SetGUIObjectDisabled(oPC,SCREENNAME,"NextAndPrevPane",FALSE);	
		SetGUIObjectHidden(oPC,SCREENNAME,"GuildPane",TRUE);
		SetGUIObjectDisabled(oPC,SCREENNAME,"BUTTON_CONTAINER",FALSE);
		SetGUIObjectDisabled(oPC,SCREENNAME,"MinimizeButton",FALSE);			
		SetGUIObjectDisabled(oPC,SCREENNAME,"UnMinimizeButton",FALSE);							
	}	
}

void HideButtons(object oPC, int mode)
{
	if(mode == 4) //Prev button only
	{
		SetGUIObjectHidden(oPC,SCREENNAME,"PREV_BUTTON",TRUE);		
	}
	else if(mode == 5) //Next button only
	{
		SetGUIObjectHidden(oPC,SCREENNAME,"NEXT_BUTTON",TRUE);		
	}
	else if(mode == 6) //Next + prev button
	{
		SetGUIObjectHidden(oPC,SCREENNAME,"NEXT_BUTTON",TRUE);
		SetGUIObjectHidden(oPC,SCREENNAME,"PREV_BUTTON",TRUE);		
	}
}

void ShowButtons(object oPC, int mode)
{
	if(mode == 4) //Prev button only
	{
		SetGUIObjectHidden(oPC,SCREENNAME,"PREV_BUTTON",FALSE);		
	}
	else if(mode == 5) //Next button only
	{
		SetGUIObjectHidden(oPC,SCREENNAME,"NEXT_BUTTON",FALSE);		
	}
	else if(mode == 6) //Next + prev button
	{
		SetGUIObjectHidden(oPC,SCREENNAME,"NEXT_BUTTON",FALSE);
		SetGUIObjectHidden(oPC,SCREENNAME,"PREV_BUTTON",FALSE);		
	}
}

string GetStorageItemIcon(object oItem)
{
	string sIcon = Get2DAString("nwn2_icons","ICON",GetItemIcon(oItem));
	return sIcon == "" ? "temp0.tga" : sIcon + ".tga";
}

void ClearForNextItem(object oPC, int mode = 0)
{
	if(mode == 1)
	{
		SetGUIObjectHidden(oPC,SCREENNAME,"BAG_STORAGE",TRUE);
		SetGUIObjectDisabled(oPC,SCREENNAME,"TUTORIAL_LISTBOX",FALSE);	
		SetCommandable(TRUE,oPC);	
		DeleteLocalInt(oPC,"NoRetrieveItems");
	}
	else if(mode == 2)
	{
		SetGUIObjectHidden(oPC,SCREENNAME,"BAG_STORAGE",TRUE);	
		SetCommandable(TRUE,oPC);
		
		DeleteLocalObject(oPC,"LastStoredItem");
		DeleteLocalInt(oPC,"LastStoredID");
		DeleteLocalInt(oPC,"NoStoreItems");
	}
	else
	{
		SetGUIObjectHidden(oPC,SCREENNAME,"StorageGrid",FALSE);
		DeleteLocalObject(oPC,"LastStoredItem");
		DeleteLocalInt(oPC,"LastStoredID");
		DeleteLocalInt(oPC,"NoStoreItems");
		SetGUIObjectHidden(oPC,SCREENNAME,"BAG_STORAGE",TRUE);
		SetCommandable(TRUE,oPC);
	}
}

string GetPCID(object oPC)
{
	string sID = GetLocalString(oPC,"StorageID");

	if(sID != "") return sID;

	string name = SQLEncodeSpecialChars(GetName(oPC));
	string player = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	string sQuery; string userid;
		
	sQuery = "SELECT `id` FROM `new_storage_users` where `name`='"+name+"' and `player`='"+player+"';";
	SQLExecDirect(sQuery); SQLFetch();

	userid = SQLGetData(1);
	
	if (userid == "")
	{
		sQuery = "INSERT INTO `new_storage_users` (`name`, `player`, `converted`) VALUES ('"+name+"', '"+player+"', '1');";
		SQLExecDirect(sQuery);

		sQuery = "SELECT `id` FROM `new_storage_users` where `name`='"+name+"' and `player`='"+player+"';";
		SQLExecDirect(sQuery); SQLFetch();
		userid = SQLGetData(1);
	}
	
	SetLocalString(oPC,"StorageID",userid);
	
	return userid;
}

string GetGuildID(object oPC, string guild)
{
	string sQuery; string userid;
	string guildname = SQLEncodeSpecialChars(guild);
		
	sQuery = "SELECT `id` FROM `new_storage_guild` where `guildname`='"+guildname+"';";
	SQLExecDirect(sQuery); SQLFetch();

	userid = SQLGetData(1);
	
	if (userid == "")
	{
		sQuery = "INSERT INTO `new_storage_guild` VALUES (`guildname`) ('"+guildname+"');";
		SQLExecDirect(sQuery);

		sQuery = "SELECT `id` FROM `new_storage_guild` where `guildname`='"+guildname+"';";
		SQLExecDirect(sQuery); SQLFetch();
		userid = SQLGetData(1);
	}
	
	return userid;
}

int CheckTag(object oItem)
{
	//prevents depositing certain items
	string sItemTag = GetTag(oItem);
	if (!GetIsObjectValid(oItem) ||
		GetObjectType(oItem) != OBJECT_TYPE_ITEM ||
		FindSubString(sItemTag,"i_consent") > -1 ||
		FindSubString(sItemTag,"it_slave") > -1 ||
		FindSubString(sItemTag,"slavepapers") > -1 ||
		FindSubString(sItemTag,"it_giftbox") > -1 ||
		FindSubString(sItemTag,"contain") > -1 ||
		FindSubString(sItemTag,"bag") > -1 ||
		FindSubString(sItemTag,"pouch") > -1 && GetBaseItemType(oItem) != BASE_ITEM_LARGEBOX ||
		FindSubString(sItemTag,"i_slave") > -1 ||
		FindSubString(sItemTag,"i_elig_") > -1 ||
		FindSubString(sItemTag,"badge") > -1 ||
		FindSubString(sItemTag,"master") > -1 ||
		FindSubString(GetName(oItem),"Bag") > -1 ||
		FindSubString(GetName(oItem),"Pouch") > -1 && GetBaseItemType(oItem) != BASE_ITEM_LARGEBOX ||
		FindSubString(GetName(oItem),"Box") > -1 ||
		FindSubString(GetName(oItem),"Ownership") > -1 ||
		FindSubString(GetName(oItem),"Spellsword") > -1 ||
		GetItemCursedFlag(oItem))
			return FALSE;
	else return TRUE;
}

void AddRecentDepositedListBoxRow(object oPC, string sItemName, string sItemID, string sIcon, string sStacksize, string sCategory)
{	
	string sOriginalItemName = sItemName;		
	if(GetStringLength(sItemName) > 28) sItemName = GetStringLeft(sItemName,28)+"...";
		
	if(StringToInt(sStacksize) > 1) sItemName = sItemName + " ("+sStacksize+")";
		
	string texts;
	
	texts = "ROW_TEXT=" + sItemName + ";";
	string textures = "ROW_ICON=" + sIcon;
	
	int iRow = GetLocalInt(oPC,"StorageRow");
	
	string svariable = "1="+sItemID+";2="+sItemName+";3=Row_"+IntToString(iRow)+";4="+sOriginalItemName;

	AddListBoxRow(oPC,SCREENNAME, "TUTORIAL_LISTBOX", "Row_" + IntToString(iRow), texts, textures, ""+svariable+"", "");	
	SetLocalInt(oPC,"StorageRow",iRow+1);
}

void GetRecentlyStoredItems(object oPC, string sFilter = "")
{
	string sID;
	
	int guildid = GetLocalInt(oPC,"storage_guildid"); int guildmode;	
	if (guildid > 0)
	{
		sID = IntToString(guildid);
		guildmode = 1;
	}
	else sID = GetPCID(oPC);
	
	ClearListBox(oPC,SCREENNAME,"TUTORIAL_LISTBOX");
		
	DeleteLocalInt(oPC,"NoRetrieveItems");
	
	if(sFilter == "") sFilter = GetLocalString(oPC,"StorageFilter");	
	if(sFilter != "")
	{
		if(sFilter != GetLocalString(oPC,"StoragePrevFilter")) DeleteLocalInt(oPC,"StoragePage");
		SetLocalString(oPC,"StoragePrevFilter",sFilter);
		sFilter = "AND `itemname` LIKE '%"+SQLEncodeSpecialChars(sFilter)+"%'";
	}
	else DeleteLocalString(oPC,"StoragePrevFilter");
	
	int page = GetLocalInt(oPC,"StoragePage");
	if (page < 1)
	{
		SetLocalInt(oPC,"StoragePage",1);
		page = 1;	
	}
	
	int lastItem = page * MaxRows;
	int firstItem = lastItem - MaxRows;
	if(firstItem < 0) firstItem = 0;

	string sLimit = "LIMIT "+IntToString(firstItem)+","+IntToString(lastItem);
	string sOrderBy;
	
	if(GetLocalInt(oPC,"StorageSortOrder") == 1) sOrderBy = "ORDER BY `ITEMNAME`";
	else sOrderBy = "ORDER BY `TIMESTAMP` DESC";
	
	string sAdditionalFilter;
	int iFilterType = GetLocalInt(oPC,"StorageFilterType");
	if(iFilterType == 1) sAdditionalFilter = " AND `category`='armor'";
	else if(iFilterType == 2) sAdditionalFilter = " AND `category`='weapon'";
	else if(iFilterType == 3) sAdditionalFilter = " AND `category`='gathering'";
	else if(iFilterType == 4) sAdditionalFilter = " AND `category`='key'";
	else if(iFilterType == 5) sAdditionalFilter = " AND `category`='consumable'";
	else if(iFilterType == 6) sAdditionalFilter = " AND `category`='book'";
	else if(iFilterType == 7) sAdditionalFilter = " AND `category`='jewelry'";
					
	string storagetype;
	if(guildmode == 0) storagetype = SQLEncodeSpecialChars("`new_storage`");
	else storagetype = SQLEncodeSpecialChars("`new_storage_guildstorage`");
			
	SQLExecDirect("SELECT COUNT(`itemname`) FROM (SELECT `itemname` FROM "+storagetype+" WHERE `storageid`='"+sID+"' "+sAdditionalFilter+" "+sFilter+" "+sOrderBy+" LIMIT "+IntToString(lastItem+1)+",999) AS a;");
	SQLFetch();
	
	int iRemaining = StringToInt(SQLGetData(1));	
	
	string sItemName; string sItemID; string sIcon; string sStacksize; string sCategory;
	SQLExecDirect("SELECT `itemname`,`itemid`,`icon`,`stacksize`,`category` FROM "+storagetype+" WHERE `storageid`='"+sID+"' "+sAdditionalFilter+" "+sFilter+" "+sOrderBy+" "+sLimit+";");
	while(SQLFetch())
	{
		sItemName = SQLGetData(1);
		sItemID = SQLGetData(2);
		sIcon = SQLGetData(3);
		sStacksize = SQLGetData(4);
		
		AddRecentDepositedListBoxRow(oPC,sItemName,sItemID,sIcon,sStacksize,sCategory);
	}	
	
	if(page == 1 && iRemaining > 0)
	{
		HideButtons(oPC,4);
		ShowButtons(oPC,5);
	}
	else if(page > 1 && iRemaining == 0)
	{
		HideButtons(oPC,5);
		ShowButtons(oPC,4);		
	}
	else if(page > 1 && iRemaining > 0) ShowButtons(oPC,6);	
	else HideButtons(oPC,6);
}

void StoreItem(object oPC, object oItem, int iBox = 0)
{	
	if(!GetIsObjectValid(oItem) || !GetIsObjectValid(oPC)) return;
	
	string timerid = IntToString(Random(5000));	
	PS_Timestamp_UNIX(oPC,timerid);
	
	itemproperty iProp = GetFirstItemProperty(oItem);
	while(GetIsItemPropertyValid(iProp))
	{
		if(GetItemPropertyDurationType(iProp) == DURATION_TYPE_TEMPORARY)
		{
			RemoveItemProperty(oItem,iProp);
			SendMessageToPC(oPC,"Removed temporary item property from that item!");
		}
		iProp = GetNextItemProperty(oItem);
	}
	
	SetPlotFlag(oItem,FALSE);

	string sDB;
	int guildid = GetLocalInt(oPC,"storage_guildid"); int guildmode;

	if (guildid > 0)
	{
		sDB = IntToString(guildid);
		guildmode = 1;
	}
	else sDB = GetPCID(oPC);

	string sItemName = GetName(oItem); string sQuery;

	if (FindSubString(sItemName,";") > -1)
	{
		SendMessageToPC(oPC,"You may not deposit items with semicolons in their names.");
		PS_Timestamp_UNIX(oPC,timerid); ClearForNextItem(oPC);
		return;		
	}
	else if (!CheckTag(oItem) && iBox == 0) //checks for forbidden items, prevents listing
	{
		SendMessageToPC(oPC,"You may not deposit this item.");
		PS_Timestamp_UNIX(oPC,timerid); ClearForNextItem(oPC);
		return;		
	}
	else
	{
		string sStackSize = IntToString(GetNumStackedItems(oItem));
		string sIcon = SQLEncodeSpecialChars(GetStorageItemIcon(oItem));
		string sCategory = SQLEncodeSpecialChars(GetObjectTypeString(GetBaseItemType(oItem)));
	
		string name = SQLEncodeSpecialChars(GetName(oPC));
		string player = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
		string cdkey = SQLEncodeSpecialChars(GetPCPublicCDKey(oPC));
		string ipaddress = SQLEncodeSpecialChars(GetPCIPAddress(oPC));	
			
		if (guildmode == 1) sQuery = "INSERT INTO new_storage_guildstorage` (`storageid`,`itemname`,`stacksize`,`icon`,`category`,`campaignstring`,`depositedby`,`act`,`cdkey`,`ipaddress`,`timestamp`) VALUES ('"+sDB+"', '"+SQLEncodeSpecialChars(sItemName)+"', "+
		" '"+sStackSize+"', '"+sIcon+"', '"+sCategory+"', %s, '"+name+"', '"+player+"', '"+cdkey+"', '"+ipaddress+"', NOW());";
		else sQuery = "INSERT INTO new_storage (`storageid`,`itemname`,`stacksize`,`icon`,`category`,`campaignstring`,`timestamp`) VALUES ('"+sDB+"', '"+SQLEncodeSpecialChars(sItemName)+"', "+
		" '"+sStackSize+"', '"+sIcon+"', '"+sCategory+"', %s, NOW());";	
		
		SQLSCORCOExec(sQuery);
		SQLStoreObject(oItem);
	//	BarcodeScan(oPC,oItem,"bankdeposited",sDB);
		
		DestroyObject(oItem);
	
		SetLocalObject(oPC,"LastStoredItem",oItem);
		SetLocalInt(oPC,"LastStoredID",ObjectToInt(oItem));
		
		if (guildmode == 1) sQuery = "INSERT INTO new_storage_guild_history VALUES (NOW(), 'deposited', '"+sDB+"', "+
		" '"+SQLEncodeSpecialChars(sItemName)+"', '"+sStackSize+"', '"+name+"', '"+player+"', '"+cdkey+"', '"+ipaddress+"');";
		else sQuery = "INSERT INTO new_storage_history VALUES (NOW(), 'deposited', '"+sDB+"', "+
		" '"+SQLEncodeSpecialChars(sItemName)+"', '"+sStackSize+"', '"+name+"', '"+player+"', '"+cdkey+"', '"+ipaddress+"');";
	
		SQLExecDirect(sQuery);	
			
		int iTime = GetLocalInt(oPC,"STOREDELAY"); int uTime = GetRealTime();
	
		
//		SendMessageToPC(oPC,"<I>Depositing the item took . . "+FloatToString(time / 1000.0)+" seconds.");
		
		PS_Timestamp_UNIX(oPC,timerid);(timerid);
	/*	int time = PS_GetTimestamp_Age_Seconds(oPC,timerid);
		if(time / 1000 > 2.0)
		{
			SendMessageToPC(oPC,"<I>Lag detected on depositing... slowing down deposits...");
			DelayCommand(5.0 + ((time / 1000) * 2.0),ClearForNextItem(oPC));
		}*/
	/*	else DelayCommand(1.5 + (time / 1000),(ClearForNextItem(oPC)); 
		
		GetRecentlyStoredItems(oPC);
	}
}

void StoreBagItem(object oPC, object oItem, string sDB, string name, string player, string cdkey, string ipaddress, int guildmode, int iCount, int iMax)
{
	if(!GetIsObjectValid(oItem) || !GetIsObjectValid(oPC)) return;
	
	int iCounter = 1;

	itemproperty iProp = GetFirstItemProperty(oItem);
	while(GetIsItemPropertyValid(iProp))
	{
	if(GetItemPropertyDurationType(iProp) == DURATION_TYPE_TEMPORARY)
	{
		RemoveItemProperty(oItem,iProp);
		SendMessageToPC(oPC,"Removed temporary item property from that item!");
	}
	iProp = GetNextItemProperty(oItem);
	}
		
	string sItemName = GetName(oItem);

	if (FindSubString(sItemName,";") > -1)
	{
		SendMessageToPC(oPC,"You may not deposit items with semicolons in their names.");
		return;
	}
	else if (!CheckTag(oItem) && GetBaseItemType(oItem) != BASE_ITEM_LARGEBOX) //checks for forbidden items, prevents listing
	{
		SendMessageToPC(oPC,"You may not deposit this item.");
		return;	
	}
	else
	{
		string sStackSize = IntToString(GetNumStackedItems(oItem));
		string sIcon = GetStorageItemIcon(oItem);
		int sCategory = GetBaseItemType(oItem);
		
		string timerid = IntToString(Random(5000));	
		PS_Timestamp_UNIX(oPC,timerid);
		
		string sQuery;
			
		if (guildmode == 0) sQuery = "INSERT INTO new_storage (`storageid`,`itemname`,`stacksize`,`icon`,`category`,`campaignstring`,`timestamp`) VALUES ('"+sDB+"', '"+SQLEncodeSpecialChars(sItemName)+"', "+
		" '"+sStackSize+"', '"+sIcon+"', '"+SQLEncodeSpecialChars(IntToString(sCategory))+"', %s, NOW());";
		else sQuery = "INSERT INTO new_storage_guildstorage (`storageid`,`itemname`,`stacksize`,`icon`,`category`,`campaignstring`,`depositedby`,`act`,`cdkey`,`ipaddress`,`timestamp`) VALUES ('"+sDB+"', '"+SQLEncodeSpecialChars(sItemName)+"', "+
		" '"+sStackSize+"', '"+sIcon+"', '"+SQLEncodeSpecialChars(IntToString(sCategory))+"', %s, '"+name+"', '"+player+"', '"+cdkey+"', '"+ipaddress+"', NOW());";

		SQLSCORCOExec(sQuery);
		SQLStoreObject(oItem);
		DestroyObject(oItem);
		
		if (guildmode == 0) sQuery = "INSERT INTO new_storage_guild_history VALUES (NOW(), 'deposited', '"+sDB+"', "+
		" '"+SQLEncodeSpecialChars(sItemName)+"', '"+sStackSize+"', '"+name+"', '"+player+"', '"+cdkey+"', '"+ipaddress+"');";
		else sQuery = "INSERT INTO new_storage_history VALUES (NOW(), 'deposited', '"+sDB+"', "+
		" '"+SQLEncodeSpecialChars(sItemName)+"', '"+sStackSize+"', '"+name+"', '"+player+"', '"+cdkey+"', '"+ipaddress+"');";
	
		SQLExecDirect(sQuery);	
		
		SetGUIObjectText(oPC,SCREENNAME,"BAG_STORAGE_ITEM_NAME",-1,"Stored: "+sItemName);
		SetGUIObjectText(oPC,SCREENNAME,"BAG_STORAGE_PROGRESS",-1,"Storing item: "+IntToString(iCount+1)+" out of "+IntToString(iMax));			
		//SendMessageToPC(oPC,"Stored item "+sItemName+" into storage.");
	}
}

void ProcessBag(object oPC, object oTarget)
{
	string sDB;
	int guildid = GetLocalInt(oPC,"storage_guildid"); int guildmode;

	if (guildid > 0)
	{
		sDB = IntToString(guildid);
		guildmode = 1;
	}
	else sDB = GetPCID(oPC);
		
	if(!GetIsObjectValid(oTarget) || GetBaseItemType(oTarget) != BASE_ITEM_LARGEBOX)
	{
		SendMessageToPC(oPC,"Target must be a box!");
		return;
	}
	else if(sDB == "")
	{
		SendMessageToPC(oPC,"An error occured. Aborting.");
		return;	
	}
	
	SetCommandable(FALSE,oPC);
	DisableButtons(oPC,1);
		
	string name = SQLEncodeSpecialChars(GetName(oPC));
	string player = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	string cdkey = SQLEncodeSpecialChars(GetPCPublicCDKey(oPC));
	string ipaddress = SQLEncodeSpecialChars(GetPCIPAddress(oPC));	
	
	object oItem = GetFirstItemInInventory(oTarget);
	
	float delay=3.0;
	float delayInterval=1.0; int iCount;
		
	while (GetIsObjectValid(oItem))
	{
		iCount++;
		oItem = GetNextItemInInventory(oTarget);
	}
	
	if(iCount == 0)
	{
		SendMessageToPC(oPC,"Nothing to store in this bag, so will store it instead.");
		StoreItem(oPC,oTarget,1);
		EnableButtons(oPC,1); ClearForNextItem(oPC,2);
		return;
	}

	int iMax = iCount; iCount = 0; string timerid;

	SetGUIObjectHidden(oPC,SCREENNAME,"BAG_STORAGE",FALSE);
	SetGUIObjectText(oPC,SCREENNAME,"BAG_STORAGE_ITEM_NAME",-1,"Bag storing beginning shortly . . .");
	SetGUIObjectText(oPC,SCREENNAME,"BAG_STORAGE_PROGRESS",-1,"Storing item: 0 out of "+IntToString(iMax));			

	oItem = GetFirstItemInInventory(oTarget);
	
	while (GetIsObjectValid(oItem))
	{
		timerid = IntToString(Random(5000));	
	//	TimerStart(timerid); float time;
	
		StoreBagItem(oPC,oItem,sDB,name,player,cdkey,ipaddress,guildmode,iCount,iMax);
		
	//	timerid = PS_GetHasTimePassed_Seconds(oPC,timerid,TRUE);
	/*	if(time / 1000 > 10.0) 
		{
			EnableButtons(oPC,1);
			SendMessageToPC(oPC,"Excessive lag detected: aborting bag storing.");
			TimerDelete(timerid);		
			ClearForNextItem(oPC,2);
			return;
		}
		
		iCount++;// TimerDelete(timerid);
		oItem = GetNextItemInInventory(oTarget);
	}

	oItem = GetFirstItemInInventory(oTarget); int iRemaining;	
	while (GetIsObjectValid(oItem))
	{
		iRemaining++;
		oItem = GetNextItemInInventory(oTarget);
	}
	
//	if(iRemaining > 0) DelayCommand(1.0f,StoreItem(oPC,oTarget,1));
//	else SendMessageToPC(oPC,"Unable to store bag because items still remain in it.");
	
	if(iCount > 0)
	{
		SendMessageToPC(oPC,"Stored "+IntToString(iCount)+" items into storage.");
		ExportSingleCharacter(oPC);
		GetRecentlyStoredItems(oPC);
	}
	else
	{
		SendMessageToPC(oPC,"An error occured, aborting.");
		GetRecentlyStoredItems(oPC);
	}	
	
	DelayCommand(1.0f,ClearForNextItem(oPC,2));
	DelayCommand(1.0f,EnableButtons(oPC,1));
//	TimerDelete(timerid);
}

void TryAndDestroyBadItem(object oItem)
{
	int iMax = 3; //3 tries
	int iLoop;
	
	while(GetIsObjectValid(oItem) && iMax > iLoop)
	{
		SetPlotFlag(oItem,FALSE);
		SetStolenFlag(oItem,FALSE);
		DestroyObject(oItem,0.0,TRUE);
		iLoop++;
	}
	
	if(GetIsObjectValid(oItem))
	{
		SetLocalInt(oItem,"DestroyOnPickup",1);
		DelayCommand(1.5,DestroyObject(oItem,0.0,TRUE));
	}
}

void DestroyNearestItemOnGroundNearPC(object oPC)
{
	location lTarget = GetLocation(oPC);
	
	object oItem = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, FALSE, OBJECT_TYPE_ITEM);
	while(GetIsObjectValid(oItem))
	{
		TryAndDestroyBadItem(oItem);
		oItem = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, FALSE, OBJECT_TYPE_ITEM);
	}
}

void AttemptToRetrieveObject(object oPC, object oStorageItem, string sDB, string sItemNumber, string sRow, int guildmode, string timerid, int checkmode = 0)
{
	string sQuery1, sQuery2;

	if(!GetIsObjectValid(oStorageItem))
	{
		if(checkmode < 2) //Attempts twice to try and retrieve object.
		{
			SendMessageToPC(oPC,"Failed to retrieve object. Trying again.");
			checkmode = checkmode + 1;
			
			DelayCommand(0.25f,AttemptToRetrieveObject(oPC,oStorageItem,sDB,sItemNumber,sRow,guildmode,timerid,checkmode));
			return;
		}
		else
		{
			TryAndDestroyBadItem(oStorageItem);
			
			//DelayCommand(1.5f,DestroyNearestItemOnGroundNearPC(oPC));	
			SetGUIObjectDisabled(oPC,SCREENNAME,"TUTORIAL_LISTBOX",FALSE);	
			SendMessageToPC(oPC,"Error occured retrieving item. Aborting. If this item was duplicated please dispose of it as this generates a log message. Debug item name: "+GetName(oStorageItem));
			GetRecentlyStoredItems(oPC);
			return;
		}
	}	

	if(GetPlotFlag(oStorageItem)) SetPlotFlag(oStorageItem,FALSE);	
	
	object oStorageCopy = CopyItem(oStorageItem,GetWaypointByTag("wp_itemstorage"),1);
	string sItemName = GetName(oStorageItem);
	string sStackSize = IntToString(GetNumStackedItems(oStorageItem));
		
	if(!GetIsObjectValid(oStorageCopy))
	{
		TryAndDestroyBadItem(oStorageCopy);
		TryAndDestroyBadItem(oStorageItem);		
				
		DelayCommand(2.0f,DestroyNearestItemOnGroundNearPC(oPC));			
			
		SetGUIObjectDisabled(oPC,SCREENNAME,"TUTORIAL_LISTBOX",FALSE);	
		SendMessageToPC(oPC,"Error occured retrieving/copying item. Aborting. If this item was duplicated please dispose of it as this generates a log message.");
		GetRecentlyStoredItems(oPC);				
		return;
	}	
/*	else if(sItemName == "Veteran Token")
	{
		CreateItemOnObject("cmnsee_vet_tokens",oPC,StringToInt(sStackSize));
		DestroyObject(oStorageCopy);
	}
	else if(sItemName == "Event Token")
	{
		CreateItemOnObject("cmnsee_event_token",oPC,StringToInt(sStackSize));
		DestroyObject(oStorageCopy);
	}	
	
	object oStorageCopyNew = CopyItem(oStorageCopy,oPC,1);
	sItemName = GetName(oStorageCopyNew);
	sStackSize = IntToString(GetNumStackedItems(oStorageCopyNew));	
		
	string name = SQLEncodeSpecialChars(GetName(oPC));
	string player = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	string cdkey = SQLEncodeSpecialChars(GetPCPublicCDKey(oPC));
	string ipaddress = SQLEncodeSpecialChars(GetPCIPAddress(oPC));
	string sIcon = GetStorageItemIcon(oStorageItem);
		
//	BarcodeScan(oPC,oStorageItem,"bankwithdrawn",sDB);
	DestroyObject(oStorageItem); DestroyObject(oStorageCopy);
	
	itemproperty iProp = GetFirstItemProperty(oStorageCopyNew);
	while(GetIsItemPropertyValid(iProp))
	{
	if(GetItemPropertyDurationType(iProp) == DURATION_TYPE_TEMPORARY)
	{
		RemoveItemProperty(oStorageCopy,iProp);
		SendMessageToPC(oPC,"Removed temporary item property from that item!");
	}
	iProp = GetNextItemProperty(oStorageCopyNew);
	}
			
	if (guildmode == 1) sQuery1 = "INSERT INTO `new_storage_guild_history` VALUES (NOW(), 'withdrawn', '"+sDB+"', "+
	" '"+SQLEncodeSpecialChars(sItemName)+"', '"+sStackSize+"', '"+name+"', '"+player+"', '"+cdkey+"', '"+ipaddress+"');";
	else sQuery1 = "INSERT INTO `new_storage_history` VALUES (NOW(), 'withdrawn', '"+sDB+"', "+
	" '"+SQLEncodeSpecialChars(sItemName)+"', '"+sStackSize+"', '"+name+"', '"+player+"', '"+cdkey+"', '"+ipaddress+"');";
	
	SQLExecDirect(sQuery1);	
	
	//Remove the stored item from the slot
	if (guildmode == 1) sQuery1 = "DELETE FROM `new_storage_guildstorage` where `storageid`='"+sDB+"' and `itemid`='"+sItemNumber+"';";
	else sQuery1 = "DELETE FROM `new_storage` where `storageid`='"+sDB+"' and `itemid`='"+sItemNumber+"';";
	
	SQLExecDirect(sQuery1);
	
//	int iTime = GetLocalInt(oPC,"STOREDELAY"); int uTime = GetUNIXTime();
	
		ExportSingleCharacter(oPC);
	//	SetLocalInt(oPC,"STOREDELAY",uTime+10);
	
	
//	float time = TimerElapsed(timerid);
//	SendMessageToPC(oPC,"<I>Retrieving the item took . . "+FloatToString(time / 1000.0)+" seconds.");
//	TimerDelete(timerid);	
	
/*	if(time / 1000 > 2.0)
	{
		SendMessageToPC(oPC,"<I>Lag detected on retrieving... slowing down retrievals...");
		DelayCommand(5.0 + ((time / 1000) * 2.0),ClearForNextItem(oPC,1));
	} 
//	else DelayCommand(time / 1000,ClearForNextItem(oPC,1));
	
	RemoveListBoxRow(oPC,SCREENNAME,"TUTORIAL_LISTBOX",sRow);
}

void RetrieveObject(object oPC, string sItemNumber, string sRow)
{
	location lPC = GetLocation(GetWaypointByTag("wp_itemstorage"));
	string sQuery1; string sQuery2;
	
	if(GetLocalInt(oPC,"storage_noguildwithdraw") == 1)
	{
		SendMessageToPC(oPC,"Sorry, you don't have access to withdraw with this guild token.");
		return;
	}
	
	SetLocalInt(oPC,"NoRetrieveItems",1);
	
	SetGUIObjectDisabled(oPC,SCREENNAME,"TUTORIAL_LISTBOX",TRUE);	
	
	string sDB;
	int guildid = GetLocalInt(oPC,"storage_guildid"); int guildmode;

	if (guildid > 0)
	{
		sDB = IntToString(guildid);
		guildmode = 1;
	}
	else sDB = GetPCID(oPC);
	
	string timerid = IntToString(Random(5000));	
//	TimerStart(timerid);	
	
	if (guildmode == 0)
	{
		sQuery1 = "SELECT `itemname` FROM `new_storage` WHERE `storageid`='"+sDB+"' and `itemid`='"+sItemNumber+"';";
		sQuery2 = "SELECT `campaignstring` FROM `new_storage` WHERE `storageid`='"+sDB+"' and `itemid`='"+sItemNumber+"';";		
	}
	else
	{
		sQuery1 = "SELECT `itemname` FROM `new_storage_guildstorage` WHERE `storageid`='"+sDB+"' and `itemid`='"+sItemNumber+"';";
		sQuery2 = "SELECT `campaignstring` FROM `new_storage_guildstorage` WHERE `storageid`='"+sDB+"' and `itemid`='"+sItemNumber+"';";		
	}

	if(sDB == "")
	{
		SetGUIObjectDisabled(oPC,SCREENNAME,"TUTORIAL_LISTBOX",FALSE);	
		SendMessageToPC(oPC,"Unable to find storage ID. Aborting.");
		return;
	}
	
	SQLExecDirect(sQuery1); SQLFetch();
	if(SQLGetData(1) == "")
	{
		SendMessageToPC(oPC,"Item doesn't exist any more or could not be retrieved. Aborting.");
		GetRecentlyStoredItems(oPC);
		SetGUIObjectDisabled(oPC,SCREENNAME,"TUTORIAL_LISTBOX",FALSE);	
		return;
	}
	
	SQLSCORCOExec(sQuery2);
	
	object oStorageItem = SQLRetrieveObject(lPC);
	
	AttemptToRetrieveObject(oPC, oStorageItem, sDB, sItemNumber, sRow, guildmode, timerid);
}

void AttemptToStoreItem(object oPC, int iLoop = 0)
{
	object oItem = GetLocalObject(oPC,"LAST_DRAGGED_ITEM");
	int oID = GetLocalInt(oPC,"LastDraggedID");
			
	SetGUIObjectHidden(oPC,SCREENNAME,"StorageGrid",TRUE);
	SetLocalInt(oPC,"NoStoreItems",1);
	
	if(GetLocalInt(oPC,"LastStoredID") != oID && GetIsObjectValid(oItem))
	{
		if(GetBaseItemType(oItem) == BASE_ITEM_LARGEBOX) ProcessBag(oPC,oItem);
		else StoreItem(oPC,oItem);
	}
	else if(iLoop == 3)
	{
		SendMessageToPC(oPC,"An error occured. Aborting.");
		ClearForNextItem(oPC);
	}
	else DelayCommand(0.5f,AttemptToStoreItem(oPC,iLoop+1));
}

void ClearVariables(object oPC)
{
	ClearForNextItem(oPC);
	DeleteLocalInt(oPC,"NoStoreItems");
	DeleteLocalInt(oPC,"StorageRow");
	DeleteLocalInt(oPC,"StoragePage");	
	DeleteLocalString(oPC,"StoragePrevFilter");
	DeleteLocalString(oPC,"StorageFilter");	
	DeleteLocalString(oPC,"StorageID");	
	DeleteLocalInt(oPC,"StorageSortOrder");	
	DeleteLocalInt(oPC,"StorageID");
	DeleteLocalInt(oPC,"StorageFilterType");
	DeleteLocalInt(oPC,"storage_guildid");		
	DeleteLocalInt(oPC,"storage_noguildwithdraw");	
	DeleteLocalInt(oPC,"NoRetrieveItems");	
}

void DoFilter(object oPC, string sFilter)
{
	if(sFilter == "")
	{
		DeleteLocalString(oPC,"StorageFilter");
		GetRecentlyStoredItems(oPC);
	}
	else if(GetStringLength(sFilter) < 3) SendMessageToPC(oPC,"Filter search must be atleast 3 characters.");
	else
	{
		SetLocalString(oPC,"StorageFilter",sFilter);
		GetRecentlyStoredItems(oPC,sFilter);
	}
}

void ExamineItem(object oPC, string sItemNumber)
{
	object oItem; object oCopy; string sQuery1; string sQuery2;
		
	string sDB;
	int guildid = GetLocalInt(oPC,"storage_guildid"); int guildmode;

	if (guildid > 0)
	{
		sDB = IntToString(guildid);
		guildmode = 1;
	}
	else sDB = GetPCID(oPC);

	if(sDB == "")
	{
		SendMessageToPC(oPC,"Unable to find storage ID. Aborting.");
		return;
	}

	if (guildmode  == 0)
	{
		sQuery1 = "SELECT `itemname` FROM `new_storage` WHERE `storageid`='"+sDB+"' and `itemid`='"+sItemNumber+"';";
		sQuery2 = "SELECT `campaignstring` FROM `new_storage` WHERE `storageid`='"+sDB+"' and `itemid`='"+sItemNumber+"';";		
	}
	else
	{
		sQuery1 = "SELECT `itemname` FROM `new_storage_guildstorage` WHERE `storageid`='"+sDB+"' and `itemid`='"+sItemNumber+"';";
		sQuery2 = "SELECT `campaignstring` FROM `new_storage_guildstorage` WHERE `storageid`='"+sDB+"' and `itemid`='"+sItemNumber+"';";		
	}	
		
	SQLExecDirect(sQuery1);
	if(SQLFetch() != SQL_SUCCESS)
	{
		SendMessageToPC(oPC,"Error occured examining item. Aborting.");
		GetRecentlyStoredItems(oPC);
		return;
	}
	
	SQLSCORCOExec(sQuery2);
	oItem = SQLRetrieveObject(GetLocation(oPC));
	
	if(!GetIsObjectValid(oItem))
	{
		DestroyObject(oItem);
		SendMessageToPC(oPC,"Error occured examining item. Aborting.");
		GetRecentlyStoredItems(oPC);
		return;
	}
	
	DelayCommand(0.5f,ActionExamine(oItem));
	DelayCommand(1.5f,DestroyObject(oItem));
}

void DoIconFilter(object oPC, int iMode)
{
	if(iMode == 1) DeleteLocalInt(oPC,"StorageSortOrder");
	else if(iMode == 2) SetLocalInt(oPC,"StorageSortOrder",1);
	else if(iMode == 3) DeleteLocalInt(oPC,"StorageFilterType");
	else if(iMode == 4) SetLocalInt(oPC,"StorageFilterType",1);
	else if(iMode == 5) SetLocalInt(oPC,"StorageFilterType",2);
	else if(iMode == 6) SetLocalInt(oPC,"StorageFilterType",3);			
	else if(iMode == 7) SetLocalInt(oPC,"StorageFilterType",4);	
	else if(iMode == 8) SetLocalInt(oPC,"StorageFilterType",5);	
	else if(iMode == 9) SetLocalInt(oPC,"StorageFilterType",6);	
	else if(iMode == 10) SetLocalInt(oPC,"StorageFilterType",7);	
							
	DeleteLocalInt(oPC,"StoragePage");
	
	GetRecentlyStoredItems(oPC);
}

void DoMinimize(object oPC)
{
	CloseGUIScreen(oPC,SCREENNAME);
	DisplayGuiScreen(oPC,"STORAGE_MINIMIZED",FALSE,"storage_minimized.xml");
}

void DoUnMinimize(object oPC)
{
	CloseGUIScreen(oPC,"STORAGE_MINIMIZED");
	DisplayGuiScreen(oPC,SCREENNAME,FALSE,"storage_new.xml");
}

void main(string sMode, string sObjectID, string sRow, string sNoWithdraw)
{
	object oPC = OBJECT_SELF;
	
//	SendMessageToPC(oPC,"Debug mode: "+sMode);
//	SendMessageToPC(oPC,"Debug objectid: "+sObjectID);	
//	SendMessageToPC(oPC,"Debug row: "+sRow);	
//	SendMessageToPC(oPC,"Debug withdraw status: "+sNoWithdraw);
		
	object oItem;
	
	int StoragePage = GetLocalInt(oPC,"StoragePage");
	string sStorageFilter = GetLocalString(oPC,"StoragePrevFilter");
	
//	SendMessageToPC(oPC,"Debug: Previous Filter "+sStorageFilter);
		
	if(sMode == "INIT") 
	{
		ClearVariables(oPC);
		//GetRecentlyStoredItems(oPC);
		//GetPCID(oPC);
		SetBoxInfoText(oPC);
		PopulateGuildStorage(oPC);
	}
	else if(sMode == "LOADSTORAGETYPE")
	{
		SetGUIObjectHidden(oPC,SCREENNAME,"GuildPane",TRUE);
		EnableButtons(oPC,1);

		if(sRow == "guild")
		{
			SetLocalInt(oPC,"storage_guildid",StringToInt(sObjectID));
			if(StringToInt(sNoWithdraw) < 6) SetLocalInt(oPC,"storage_noguildwithdraw",1);
			GetRecentlyStoredItems(oPC);
		}
		else GetRecentlyStoredItems(oPC);
	}
	else if(sMode == "DROPITEM")
	{
		if(GetLocalInt(oPC,"NoStoreItems") == 1)
		{
			SendMessageToPC(oPC,"Please wait for last item to finish storing.");
			return;
		}
		AttemptToStoreItem(oPC);
	}  
	else if(sMode == "RETRIEVE")
	{
		if(GetLocalInt(oPC,"NoRetrieveItems") == 1)
		{
			SendMessageToPC(oPC,"Please wait for last item to finish retrieving.");
			return;
		}		
		RetrieveObject(oPC,sObjectID,sRow);
	}
	else if(sMode == "FILTER")
	{
		if(sStorageFilter != sObjectID) DeleteLocalInt(oPC,"StoragePage");
		DoFilter(oPC,sRow);
	}
	else if(sMode == "NEXT")                                                          
	{
		if(sStorageFilter != sObjectID) DeleteLocalInt(oPC,"StoragePage");
		else SetLocalInt(oPC,"StoragePage",StoragePage+1);
		GetRecentlyStoredItems(oPC,sRow);
	}
	else if(sMode == "PREV")
	{
		if(sStorageFilter != sObjectID) DeleteLocalInt(oPC,"StoragePage");
		else SetLocalInt(oPC,"StoragePage",StoragePage-1);
		GetRecentlyStoredItems(oPC,sRow);
	}	
	else if(sMode == "EXAMINE") ExamineItem(oPC,sObjectID);
	else if(sMode == "SETICONFILTER") DoIconFilter(oPC,StringToInt(sObjectID));
	else if(sMode == "REFRESH")
	{
		DeleteLocalInt(oPC,"StoragePage");
		GetRecentlyStoredItems(oPC);
	}
	else if(sMode == "DOEVERYTHING") DoEverything(oPC);
	else if(sMode == "DOMINIMIZE") DoMinimize(oPC);	
	else if(sMode == "DOUNMINIMIZE") DoUnMinimize(oPC);		
}
*/