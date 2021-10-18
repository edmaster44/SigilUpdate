// called from the kemo_storage GUI
#include "nwnx_sql"
#include "gui_kemo_storage_list_open"
#include "ps_inc_time"

void ClearForNextItem(object oPC)
{
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","RetrieveButton",FALSE);
	DeleteLocalInt(oPC,"RetrieveDelay");
}
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

	string timerid = IntToString(Random(5000));	
//	TimerStart(timerid);	
	
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
	//	TimerDelete(timerid); ClearForNextItem(oPC);		
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
	//	TimerDelete(timerid); ClearForNextItem(oPC);		
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
	
/*	-not needed 
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
	*/
//	BarcodeScan(oPC,oStorageItem,"bankwithdrawn",sDB);
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
		
	WriteTimestampedLogEntry(GetName(oPC) + " is retrieving " + GetName(oStorageCopy) + " at the storage banker.");

	
	if (guildname != "") sQuery = "INSERT INTO cmnsee_storage_guild_history VALUES (NOW(), 'withdrawn', '"+sDB+"', "+
	" '"+SQLEncodeSpecialChars(sItemName)+"', '"+sStackSize+"', '"+name+"', '"+player+"', '"+cdkey+"', '"+ipaddress+"');";
	else sQuery = "INSERT INTO cmnsee_storage_history VALUES (NOW(), 'withdrawn', '"+sDB+"', "+
	" '"+SQLEncodeSpecialChars(sItemName)+"', '"+sStackSize+"', '"+name+"', '"+player+"', '"+cdkey+"', '"+ipaddress+"');";
	
	SQLExecDirect(sQuery);	
	
	//Remove the stored item from the slot
	if (guildname != "") sQuery = "DELETE FROM new_storage_guildstorage where storageid='"+sDB+"' and itemid='"+sItemNumber+"';";
	else sQuery = "DELETE FROM cmnsee_storage where storageid='"+sDB+"' and itemid='"+sItemNumber+"';";
	
	SQLExecDirect(sQuery);
	
/*	int iTime = GetLocalInt(oPC,"STOREDELAY"); int uTime = GetUNIXTime();
	if (uTime + 10 > iTime || iTime == 0)
	{
		ExportSingleCharacter(oPC);
		SetLocalInt(oPC,"STOREDELAY",uTime+10);
	}*/
	
//	float time = TimerElapsed(timerid);
//	SendMessageToPC(oPC,"<I>Retrieving the item took . . "+FloatToString(time / 1000.0)+" seconds.");
//	TimerDelete(timerid);	
	
/*	if(time / 1000 > 2.0)
	{
		SendMessageToPC(oPC,"<I>Lag detected on retrieving... slowing down retrievals...");
		DelayCommand(5.0 + ((time / 1000) * 2.0),ClearForNextItem(oPC));
	}
	else DelayCommand(2.0 + (time / 1000),ClearForNextItem(oPC));
	*/		
	ExecuteScript("gui_kemo_storage_list",oPC);
}

/*
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
*/