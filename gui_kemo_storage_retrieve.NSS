#include "ff_safevar"


// called from the kemo_storage GUI

string GetPCID(object oPC)
{
	return GetSubString(GetPCPlayerName(oPC), 0, 12)
				+ "_" + GetSubString(GetFirstName(oPC), 0, 6)
				+ "_" + GetSubString(GetLastName(oPC), 0, 9);
}

void main(string sItemNumber)
{
	object oPC = OBJECT_SELF;
	string sDB = GetPCID(oPC) + "_storage";
	location lPC = GetLocation(oPC);
	
	//Get the storage slot
	string sKey = "StorageParameters" + sItemNumber;
	string sKeyObject = "StorageObject" + sItemNumber;
	string sStorageItem = GetCampaignString(sDB,sKey);	

	object oStorageItem = RetrieveCampaignObject(sDB,sKeyObject,lPC);
	object oStorageCopy = CopyItem(oStorageItem,oPC,1);
	DestroyObject(oStorageItem);
		
	WriteTimestampedLogEntry(GetName(oPC) + " is retrieving " + GetName(oStorageCopy) + " at the storage banker.");

	//Remove the stored item from the slot
	DeleteCampaignVariable(sDB,sKey);
	DeleteCampaignVariable(sDB,sKeyObject);

	ExecuteScript("gui_kemo_storage_list",oPC);
}
/*/ called from the kemo_storage GUI
#include "nwnx_sql"
#include "gui_kemo_storage_list_open"





void main(string sItemNumber)
{
	object oPC = OBJECT_SELF;
	location lPC = GetLocation(oPC);
	string sQuery;
	string sDB;
	string stillexists;
	
	string guildname = PS_GetLocalString(oPC,"kemo_storage_mode_guildname");
	
	if ( PS_GetLocalString(oPC, "kemo_storage_mode_guild") == "yes")
	{
	if (sItemNumber == GetName(oPC))
	{
		PS_DeleteLocalString(oPC, "kemo_storage_mode_guild");
		PS_DeleteLocalString(oPC, "kemo_storage_mode_guildname");
		PS_DeleteLocalInt(oPC,"kemo_storage_mode_guild_accesslevel");
		ExecuteScript("gui_kemo_storage_list",oPC);	
		return;
	}
	else
	{
		PS_SetLocalString(oPC, "kemo_storage_mode_guildname",sItemNumber);
		PS_DeleteLocalString(oPC, "kemo_storage_mode_guild");
		ExecuteScript("gui_kemo_storage_list",oPC);		
		return;
	}
	}
	


	SetGUIObjectHidden(oPC,"KEMO_STORAGE","RetrieveButton",TRUE);	


	
	if (guildname == "")
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
	else
	{
		sDB = GetGuildID(oPC, guildname);
		sQuery = "SELECT itemname FROM new_storage_guildstorage where storageid='"+sDB+"' and itemid='"+sItemNumber+"';";
		SQLExecDirect(sQuery); SQLFetch();
		stillexists = SQLGetData(1);
	
	if (stillexists == "")
	{
		SendMessageToPC(oPC,"Item no longer exists, please try again.");
		ExecuteScript("gui_kemo_storage_list",oPC);		
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
	
	if ( PS_GetLocalString(oPC, "kemo_storage_mode_guild") == "yes" )
	{
	if (sItemNumber == GetName(oPC))
	{
	PS_DeleteLocalString(oPC, "kemo_storage_mode_guild");
	PS_DeleteLocalString(oPC, "kemo_storage_mode_guildname");
	PS_DeleteLocalInt(oPC,"kemo_storage_mode_guild_accesslevel");
	ExecuteScript("gui_kemo_storage_list",oPC);
	return;
	}
	else
	PS_SetLocalString(oPC, "kemo_storage_mode_guildname",sItemNumber);
	PS_DeleteLocalString(oPC, "kemo_storage_mode_guild");
	ExecuteScript("gui_kemo_storage_list",oPC);
	return;
	}
	
	if (PS_GetLocalString(oPC,"kemo_storage_mode_guildname") == "")
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
	
	if (PS_GetLocalString(oPC,"kemo_storage_mode_guildname") != "")
	{
	sDB = GetGuildID(oPC, PS_GetLocalString(oPC,"kemo_storage_mode_guildname"));
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
	
	if (PS_GetLocalString(oPC,"kemo_storage_mode_guildname") != "")
	{
	sQuery = "INSERT INTO new_storage_guild_history VALUES (NOW(), 'withdrawn', '"+sDB+"', "+
	" '"+SQLEncodeSpecialChars(sItemName)+"', '"+sStackSize+"', '"+name+"', '"+player+"', '"+cdkey+"', '"+ipaddress+"');";
	}
	
	SQLExecDirect(sQuery);	
	
	//Remove the stored item from the slot
	sQuery = "DELETE FROM new_storage where storageid='"+sDB+"' and itemid='"+sItemNumber+"';";
	
	if (PS_GetLocalString(oPC,"kemo_storage_mode_guildname") != "")
	{
	sDB = GetGuildID(oPC, PS_GetLocalString(oPC,"kemo_storage_mode_guildname"));
	sQuery = "DELETE FROM new_storage_guildstorage where storageid='"+sDB+"' and itemid='"+sItemNumber+"';";
	}
	
	SQLExecDirect(sQuery);

	ExecuteScript("gui_kemo_storage_list",oPC);
}*/