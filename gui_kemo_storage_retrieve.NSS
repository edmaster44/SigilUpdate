// called from the kemo_storage GUI
#include "nwnx_sql"
#include "gui_kemo_storage_list_open"





void main(string sItemNumber)
{
	object oPC = OBJECT_SELF;
	location lPC = GetLocation(oPC);
	string sQuery;
	string sDB;
	string stillexists;
	
	string guildname = GetLocalString(oPC,"kemo_storage_mode_guildname");
	
	if ( GetLocalString(oPC, "kemo_storage_mode_guild") == "yes")
	{
	if (sItemNumber == GetName(oPC))
	{
		DeleteLocalString(oPC, "kemo_storage_mode_guild");
		DeleteLocalString(oPC, "kemo_storage_mode_guildname");
		DeleteLocalInt(oPC,"kemo_storage_mode_guild_accesslevel");
		ExecuteScript("gui_kemo_storage_list",oPC);	
		return;
	}
	else
	{
		SetLocalString(oPC, "kemo_storage_mode_guildname",sItemNumber);
		DeleteLocalString(oPC, "kemo_storage_mode_guild");
		ExecuteScript("gui_kemo_storage_list",oPC);		
		return;
	}
	}
	
	if(GetLocalInt(oPC,"RetrieveDelay") == 1)
	{
		SendMessageToPC(oPC,"You must wait before retrieving the next item.");
		return;
	}
	
	SetLocalInt(oPC,"RetrieveDelay",1);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","RetrieveButton",TRUE);	


	
	if (guildname == "")
	{	
		sDB = GetPCID(oPC);
		sQuery = "SELECT itemname FROM cmnsee_storage where storageid='"+sDB+"' and itemid='"+sItemNumber+"';";
		SQLExecDirect(sQuery); SQLFetch();
		stillexists = SQLGetData(1);
	
	if (stillexists == "")
	{
		SendMessageToPC(oPC,"Item no longer exists, please try again.");
		ExecuteScript("gui_kemo_storage_list",oPC);		
		return;
	}
	sQuery = "SELECT campaignstring FROM cmnsee_storage where storageid='"+sDB+"' and itemid='"+sItemNumber+"';";
	}
	else
	{
		sDB = GetGuildID(oPC, guildname);
		sQuery = "SELECT itemname FROM cmnsee_storage_guildstorage where storageid='"+sDB+"' and itemid='"+sItemNumber+"';";
		SQLExecDirect(sQuery); SQLFetch();
		stillexists = SQLGetData(1);
	
	if (stillexists == "")
	{
		SendMessageToPC(oPC,"Item no longer exists, please try again.");
		ExecuteScript("gui_kemo_storage_list",oPC);		
		return;
	}	
		sQuery = "SELECT campaignstring FROM cmnsee_storage_guildstorage where storageid='"+sDB+"' and itemid='"+sItemNumber+"';";
	}
	
	SQLSCORCOExec(sQuery);
	object oStorageItem = SQLRetrieveObject(lPC);
	
	string name = SQLEncodeSpecialChars(GetName(oPC));
	string player = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	string cdkey = SQLEncodeSpecialChars(GetPCPublicCDKey(oPC));
	string ipaddress = SQLEncodeSpecialChars(GetPCIPAddress(oPC));
	string sStackSize = IntToString(GetNumStackedItems(oStorageItem));
	string sIcon = GetStorageItemIcon(oStorageItem);
	string sItemName = GetName(oStorageItem);
	
	object oStorageCopy = CopyItem(oStorageItem,oPC,1);
	
	if(GetName(oStorageCopy) == "Veteran Token")
	{
		CreateItemOnObject("cmnsee_vet_tokens",oPC,StringToInt(sStackSize));
		DestroyObject(oStorageCopy);
	}
	
	if(GetName(oStorageCopy) == "Event Token")
	{
		CreateItemOnObject("cmnsee_event_token",oPC,StringToInt(sStackSize));
		DestroyObject(oStorageCopy);
	}	
	
	DestroyObject(oStorageItem);
	
	itemproperty iProp = GetFirstItemProperty(oStorageCopy);
	while(GetIsItemPropertyValid(iProp))
	{
	if(GetItemPropertyDurationType(iProp) == DURATION_TYPE_TEMPORARY)
	{
		RemoveItemProperty(oStorageCopy,iProp);
		SendMessageToPC(oPC,"Removed temporary item property from that item!");
	}
	iProp = GetNextItemProperty(oStorageCopy);
	}
		
	//WriteTimestampedLogEntry(GetName(oPC) + " is retrieving " + GetName(oStorageCopy) + " at the storage banker.");

	
	if (guildname != "") sQuery = "INSERT INTO cmnsee_storage_guild_history VALUES (NOW(), 'withdrawn', '"+sDB+"', "+
	" '"+SQLEncodeSpecialChars(sItemName)+"', '"+sStackSize+"', '"+name+"', '"+player+"', '"+cdkey+"', '"+ipaddress+"');";
	else sQuery = "INSERT INTO cmnsee_storage_history VALUES (NOW(), 'withdrawn', '"+sDB+"', "+
	" '"+SQLEncodeSpecialChars(sItemName)+"', '"+sStackSize+"', '"+name+"', '"+player+"', '"+cdkey+"', '"+ipaddress+"');";
	
	SQLExecDirect(sQuery);	
	
	//Remove the stored item from the slot
	if (guildname != "") sQuery = "DELETE FROM cmnsee_storage_guildstorage where storageid='"+sDB+"' and itemid='"+sItemNumber+"';";
	else sQuery = "DELETE FROM cmnsee_storage where storageid='"+sDB+"' and itemid='"+sItemNumber+"';";
	
	SQLExecDirect(sQuery);
	
			
	ExecuteScript("gui_kemo_storage_list",oPC);
}
/*void main(string sItemNumber)
{
	object oPC = OBJECT_SELF;
	location lPC = GetLocation(oPC);
	string sQuery;
	string sDB;
	string stillexists;
	
	if ( GetLocalString(oPC, "kemo_storage_mode_guild") == "yes" )
	{
	if (sItemNumber == GetName(oPC))
	{
	DeleteLocalString(oPC, "kemo_storage_mode_guild");
	DeleteLocalString(oPC, "kemo_storage_mode_guildname");
	DeleteLocalInt(oPC,"kemo_storage_mode_guild_accesslevel");
	ExecuteScript("gui_kemo_storage_list",oPC);
	return;
	}
	else
	SetLocalString(oPC, "kemo_storage_mode_guildname",sItemNumber);
	DeleteLocalString(oPC, "kemo_storage_mode_guild");
	ExecuteScript("gui_kemo_storage_list",oPC);
	return;
	}
	
	if (GetLocalString(oPC,"kemo_storage_mode_guildname") == "")
	{	
	sDB = GetPCID(oPC);
	sQuery = "SELECT itemname FROM new_storage where storageid='"+sDB+"' and itemid='"+sItemNumber+"';";
	SQLExecDirect(sQuery); SQLFetch();
	stillexists = SQLGetData(1);
	
	if (stillexists == "")
	{
	SendMessageToPC(oPC,"Item no longer exists, please try again.");
	ExecuteScript("gui_kemo_storage_list",oPC);
	return;
	}
	sQuery = "SELECT campaignstring FROM new_storage where storageid='"+sDB+"' and itemid='"+sItemNumber+"';";
	}
	
	if (GetLocalString(oPC,"kemo_storage_mode_guildname") != "")
	{
	sDB = GetGuildID(oPC, GetLocalString(oPC,"kemo_storage_mode_guildname"));
	sQuery = "SELECT itemname FROM new_storage_guildstorage where storageid='"+sDB+"' and itemid='"+sItemNumber+"';";
	SQLExecDirect(sQuery); SQLFetch();
	stillexists = SQLGetData(1);
	
	if (stillexists == "")
	{
	SendMessageToPC(oPC,"Item no longer exists, please try again.");
	ExecuteScript("new_kemo_storage_list",oPC);
	return;
	}	
	sQuery = "SELECT campaignstring FROM new_storage_guildstorage where storageid='"+sDB+"' and itemid='"+sItemNumber+"';";
	}
	
	SQLSCORCOExec(sQuery);
	object oStorageItem = SQLRetrieveObject(lPC);
	
	string name = SQLEncodeSpecialChars(GetName(oPC));
	string player = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	string cdkey = SQLEncodeSpecialChars(GetPCPublicCDKey(oPC));
	string ipaddress = SQLEncodeSpecialChars(GetPCIPAddress(oPC));
	string sStackSize = IntToString(GetNumStackedItems(oStorageItem));
	string sIcon = GetStorageItemIcon(oStorageItem);
	string sItemName = GetName(oStorageItem);
	
	object oStorageCopy = CopyItem(oStorageItem,oPC,1);
	DestroyObject(oStorageItem);
		
	WriteTimestampedLogEntry(GetName(oPC) + " is retrieving " + GetName(oStorageCopy) + " at the storage banker.");

		sQuery = "INSERT INTO new_storage_history VALUES (NOW(), 'withdrawn', '"+sDB+"', "+
	" '"+SQLEncodeSpecialChars(sItemName)+"', '"+sStackSize+"', '"+name+"', '"+player+"', '"+cdkey+"', '"+ipaddress+"');";
	
	if (GetLocalString(oPC,"kemo_storage_mode_guildname") != "")
	{
	sQuery = "INSERT INTO new_storage_guild_history VALUES (NOW(), 'withdrawn', '"+sDB+"', "+
	" '"+SQLEncodeSpecialChars(sItemName)+"', '"+sStackSize+"', '"+name+"', '"+player+"', '"+cdkey+"', '"+ipaddress+"');";
	}
	
	SQLExecDirect(sQuery);	
	
	//Remove the stored item from the slot
	sQuery = "DELETE FROM new_storage where storageid='"+sDB+"' and itemid='"+sItemNumber+"';";
	
	if (GetLocalString(oPC,"kemo_storage_mode_guildname") != "")
	{
	sDB = GetGuildID(oPC, GetLocalString(oPC,"kemo_storage_mode_guildname"));
	sQuery = "DELETE FROM new_storage_guildstorage where storageid='"+sDB+"' and itemid='"+sItemNumber+"';";
	}
	
	SQLExecDirect(sQuery);

	ExecuteScript("gui_kemo_storage_list",oPC);
}*/