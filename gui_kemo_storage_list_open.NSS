#include "ginc_param_const"
#include "nwnx_sql"



string GetStorageItemIcon(object oItem)
{
	string sIcon = Get2DAString("nwn2_icons","ICON",GetItemIcon(oItem));
	return sIcon == "" ? "temp0.tga" : sIcon + ".tga";
}

string GetStorageItemIconByTag(string oItem)
{
	string sIcon = Get2DAString("nwn2_icons","ICON",GetItemIcon(GetObjectByTag(oItem)));
	return sIcon == "" ? "temp0.tga" : sIcon + ".tga";
}

string GetOldPCID(object oPC)
{
	return GetSubString(GetPCPlayerName(oPC), 0, 12)
				+ "_" + GetSubString(GetFirstName(oPC), 0, 6)
				+ "_" + GetSubString(GetLastName(oPC), 0, 9);
}

int GetStorageListTotal(string sDB, object oPC)
{
	string sQuery = "SELECT COUNT(*) FROM new_storage where storageid='"+sDB+"';";
	
	if (GetLocalString(oPC,"kemo_storage_mode_guildname") != "")
	{
	sQuery = "SELECT COUNT(*) FROM new_storage_guildstorage where storageid='"+sDB+"';";
	}	
	
	SQLExecDirect(sQuery); SQLFetch();

	int iListTotal = StringToInt(SQLGetData(1));
	
	return iListTotal;
}

void ConvertStorage(object oPC, string userid)
{
	string sDB = GetOldPCID(oPC) + "_storage";
	string nDB = userid;
	object oStorageTable = GetNearestObjectByTag("kemo_storage_viewpoint");
	int iListTotal = GetCampaignInt(sDB,"StorageListTotal"); // length of sale item list
	int iCounter = iListTotal; int iListTotalNew = iListTotal; string sQuery;
	
	string sKey; string sItem; string sKeyObject; string sStorageItem; string availnum;
	object oItem; string sStackSize; string sIcon; string sItemName;
	string sKeyParameters; object oItemCopy; int sCategory;
	
	while (iCounter >= 1)
	{
	sKeyParameters = "StorageParameters" + IntToString(iCounter);
	sKey = "StorageObject" + IntToString(iCounter);

	oItem = RetrieveCampaignObject(sDB,sKey,GetLocation(oStorageTable));
	
	if (GetIsObjectValid(oItem))
	{
	CloseGUIScreen(oPC,"KEMO_STORAGE");
	sQuery="SELECT itemid + 1 available_id FROM new_storage t WHERE storageid='"+nDB+"'"+
	" and NOT EXISTS(SELECT * FROM new_storage WHERE itemid = t.itemid + 1 and"+
	" storageid = '"+nDB+"') ORDER BY itemid LIMIT 1";

	SQLExecDirect(sQuery); SQLFetch();
	availnum = SQLGetData(1);
	
	SendMessageToPC(oPC,"Converting item # " +IntToString(iCounter)+ " to new storage. Please wait.");
		
	sStackSize = IntToString(GetNumStackedItems(oItem));
	sIcon = GetStorageItemIcon(oItem);
	sCategory = GetBaseItemType(oItem);
	sItemName = GetName(oItem);

	sQuery = "INSERT INTO new_storage VALUES ('"+nDB+"', '"+IntToString(iCounter)+"', '"+SQLEncodeSpecialChars(sItemName)+"', "+
	" '"+sStackSize+"', '"+sIcon+"', '"+SQLEncodeSpecialChars(IntToString(sCategory))+"', %s);";
	SQLSCORCOExec(sQuery);
	SQLStoreObject(oItem);
	
	DestroyObject(oItem);
	
	DeleteCampaignVariable(sDB,sKey);
	DeleteCampaignVariable(sDB,sKeyParameters);

	if (sItem != "")
	{
	iCounter = 0;
	}
	}
	iCounter--;
	}
	SendMessageToPC(oPC,"All done, you may access the storage bank again.");
	
	sQuery = "UPDATE new_storage_users SET converted = '1' WHERE id='"+userid+"';";
	SQLExecDirect(sQuery);
	return;
}

string GetPCID(object oPC)
{
	string name = SQLEncodeSpecialChars(GetName(oPC));
	string player = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	string sQuery;
	string userid;
		
	sQuery = "SELECT id FROM new_storage_users where name='"+name+"' and player='"+player+"'";
	SQLExecDirect(sQuery); SQLFetch();

	userid = SQLGetData(1);
	
	if (userid == "")
	{
	sQuery = "INSERT INTO new_storage_users (id, name, player) SELECT 1 + coalesce((SELECT max(id)"+
	" FROM new_storage_users), 0), '"+name+"', '"+player+"';";
	SQLExecDirect(sQuery);

	sQuery = "SELECT id FROM new_storage_users where name='"+name+"' and player='"+player+"';";
	SQLExecDirect(sQuery); SQLFetch();
	userid = SQLGetData(1);
	
	ConvertStorage(oPC,userid);
	}
	return userid;
}

string GetGuildID(object oPC, string guild)
{
	string sQuery;
	string userid;
	string guildname = SQLEncodeSpecialChars(guild);
		
	sQuery = "SELECT id FROM new_storage_guild where guildname='"+guildname+"';";
	SQLExecDirect(sQuery); SQLFetch();

	userid = SQLGetData(1);
	
	if (userid == "")
	{
	sQuery = "INSERT INTO new_storage_guild (id, guildname) SELECT 1 + coalesce((SELECT max(id)"+
	" FROM new_storage_guild), 0), '"+guildname+"';";
	SQLExecDirect(sQuery);

	sQuery = "SELECT id FROM new_storage_guild where guildname='"+guildname+"';";
	SQLExecDirect(sQuery); SQLFetch();
	userid = SQLGetData(1);
	}
	return userid;
}

int GetGuildAccessLevel(object oPC, string guild)
{
	SQLExecDirect("SELECT GuildToken, GuildAccess FROM guildstorage" +
	             " WHERE StoreType = 'CRAFTBANK' AND Guild='"+SQLEncodeSpecialChars(guild)+"' ORDER BY GuildAccess DESC");
	SQLFetch();
	int iGuildAccess;
	string sGuildToken;

	while (SQLFetch() == SQL_SUCCESS)
	{
	sGuildToken = SQLGetData(2);
	iGuildAccess = StringToInt(SQLGetData(3));
	
	if (GetItemPossessedBy(oPC,sGuildToken)!= OBJECT_INVALID && iGuildAccess >= 6) return 6;
	}
	return -1;	
}