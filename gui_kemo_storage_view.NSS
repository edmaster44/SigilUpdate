#include "ff_safevar"



string GetPCID(object oPC)
{
	return GetSubString(GetPCPlayerName(oPC), 0, 12)
				+ "_" + GetSubString(GetFirstName(oPC), 0, 6)
				+ "_" + GetSubString(GetLastName(oPC), 0, 9);
}

void main(string sItemNumber)
{
	object oPC = OBJECT_SELF;
	object oStorageTable = GetNearestObjectByTag("kemo_storage_viewpoint");
	object oItem; object oCopy;
	
	string sDB = GetPCID(oPC) + "_storage";
	//Get the sale item slot
	string sKey = "StorageObject" + sItemNumber;
	WriteTimestampedLogEntry(GetName(oPC) + " is viewing an item at the storage banker.");
	oItem = RetrieveCampaignObject(sDB,sKey,GetLocation(oStorageTable));
	DelayCommand(1.0f,ActionExamine(oItem));
	DelayCommand(3.0f,DestroyObject(oItem));
}

/*#include "nwnx_sql"
#include "gui_kemo_storage_list_open"

void main(string sItemNumber)
{
	object oPC = OBJECT_SELF;
	object oStorageTable = GetNearestObjectByTag("kemo_storage_viewpoint");
	object oItem; object oCopy; string sDB; string sQuery; string stillexists;
	
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
	ExecuteScript("gui_kemo_storage_list",oPC);
	return;
	}	
	sQuery = "SELECT campaignstring FROM new_storage_guildstorage where storageid='"+sDB+"' and itemid='"+sItemNumber+"';";
	}
	
	WriteTimestampedLogEntry(GetName(oPC) + " is viewing an item at the storage banker.");
	
	SQLSCORCOExec(sQuery);
	oItem = SQLRetrieveObject(GetLocation(oStorageTable));
	DelayCommand(1.0f,ActionExamine(oItem));
	DelayCommand(3.0f,DestroyObject(oItem));
}*/