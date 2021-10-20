#include "nwnx_sql"
#include "gui_kemo_storage_list_open"

void main(string sItemNumber)
{
	object oPC = OBJECT_SELF;
	object oStorageTable = GetNearestObjectByTag("kemo_storage_viewpoint");
	object oItem; object oCopy; string sDB; string sQuery; string stillexists;
	
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
}