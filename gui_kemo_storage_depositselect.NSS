#include "nwnx_sql"
#include "gui_kemo_storage_list_open"
#include "ps_inc_time"



object GetItemFromList(object oPC, string sItemNumber)
{
	string sStorageVar = "TempStorageObject" + sItemNumber;
	return GetLocalObject(oPC,sStorageVar);
}

int CheckTag(object oItem)
{
	//prevents depositing certain items
	string sItemTag = GetTag(oItem);
	if (FindSubString(sItemTag,"i_consent") > -1 ||
		FindSubString(sItemTag,"it_slave") > -1 ||
		FindSubString(sItemTag,"slavepapers") > -1 ||
		FindSubString(sItemTag,"it_giftbox") > -1 ||
		FindSubString(sItemTag,"contain") > -1 ||
		FindSubString(sItemTag,"bag") > -1 ||
		FindSubString(sItemTag,"pouch") > -1 ||
		FindSubString(sItemTag,"i_slave") > -1 ||
		FindSubString(sItemTag,"i_elig_") > -1 ||
		FindSubString(sItemTag,"badge") > -1 ||
		FindSubString(sItemTag,"master") > -1 ||
		FindSubString(GetName(oItem),"Bag") > -1 ||
		FindSubString(GetName(oItem),"Pouch") > -1 ||
		FindSubString(GetName(oItem),"Box") > -1 ||
		FindSubString(GetName(oItem),"Ownership") > -1 ||
		FindSubString(GetName(oItem),"Spellsword") > -1 ||
		GetItemCursedFlag(oItem))
			return FALSE;
	else return TRUE;
}

void ClearForNextItem(object oPC)
{
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","DepositButtonB",FALSE);
	DeleteLocalInt(oPC,"DepositDelay");
}

void main (string sItemNumber)
{
	object oPC = OBJECT_SELF;
	string sQuery;
	WriteTimestampedLogEntry(GetName(oPC) + " is selecting an item to deposit at the storage banker.");

	if(GetLocalInt(oPC,"DepositDelay") == 1)
	{
		SendMessageToPC(oPC,"You must wait before depositing the next item.");
		return;
	}
	
	SetLocalInt(oPC,"DepositDelay",1);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","DepositButtonB",TRUE);

	string timerid = IntToString(Random(5000));	
	//TimerStart(timerid);
		
	object oItem = GetItemFromList(oPC, sItemNumber); //find the sale item from the list
	if (!GetIsObjectValid(oItem)) return;
	
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
	
	string sDB;
	string guildname = GetLocalString(oPC,"kemo_storage_mode_guildname");

	if (guildname == "") sDB = GetPCID(oPC);
	else sDB = GetGuildID(oPC, guildname);

	string sItemName = GetName(oItem);

	if (FindSubString(sItemName,";") > -1)
	{
		DeleteLocalObject(oPC,"TempStorageObject" + sItemNumber);
		SendMessageToPC(oPC,"You may not deposit items with semicolons in their names.");
		/*TimerDelete(timerid); */ClearForNextItem(oPC);
		return;		
	}
	else if (!CheckTag(oItem)) //checks for forbidden items, prevents listing
	{
		DeleteLocalObject(oPC,"TempStorageObject" + sItemNumber);
		SendMessageToPC(oPC,"You may not deposit this item.");
		/*TimerDelete(timerid); */ ClearForNextItem(oPC);
		return;		
	}
	else
	{
		string sStackSize = IntToString(GetNumStackedItems(oItem));
		string sIcon = GetStorageItemIcon(oItem);
		int sCategory = GetBaseItemType(oItem);
	
		string name = SQLEncodeSpecialChars(GetName(oPC));
		string player = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
		string cdkey = SQLEncodeSpecialChars(GetPCPublicCDKey(oPC));
		string ipaddress = SQLEncodeSpecialChars(GetPCIPAddress(oPC));	
			
		if (guildname == "") sQuery = "INSERT INTO new_storage (`storageid`,`itemname`,`stacksize`,`icon`,`category`,`campaignstring`) VALUES ('"+sDB+"', '"+SQLEncodeSpecialChars(sItemName)+"', "+
		" '"+sStackSize+"', '"+sIcon+"', '"+SQLEncodeSpecialChars(IntToString(sCategory))+"', %s);";
		else sQuery = "INSERT INTO new_storage_guildstorage (`storageid`,`itemname`,`stacksize`,`icon`,`category`,`campaignstring`,`depositedby`,`act`,`cdkey`,`ipaddress`) VALUES ('"+sDB+"', '"+SQLEncodeSpecialChars(sItemName)+"', "+
		" '"+sStackSize+"', '"+sIcon+"', '"+SQLEncodeSpecialChars(IntToString(sCategory))+"', %s, '"+name+"', '"+player+"', '"+cdkey+"', '"+ipaddress+"');";
		
		SQLSCORCOExec(sQuery);
		SQLStoreObject(oItem);
		//BarcodeScan(oPC,oItem,"bankdeposited",sDB);
		DestroyObject(oItem);
	
		if (guildname != "") sQuery = "INSERT INTO new_storage_guild_history VALUES (NOW(), 'deposited', '"+sDB+"', "+
		" '"+SQLEncodeSpecialChars(sItemName)+"', '"+sStackSize+"', '"+name+"', '"+player+"', '"+cdkey+"', '"+ipaddress+"');";
		else sQuery = "INSERT INTO new_storage_history VALUES (NOW(), 'deposited', '"+sDB+"', "+
		" '"+SQLEncodeSpecialChars(sItemName)+"', '"+sStackSize+"', '"+name+"', '"+player+"', '"+cdkey+"', '"+ipaddress+"');";
	
		SQLExecDirect(sQuery);	
			
		int iTime = GetLocalInt(oPC,"STOREDELAY"); int uTime = PS_GetTimestamp_Age_Seconds(oPC,timerid);
		if (uTime + 10 > iTime || iTime == 0)
		{
			ExportSingleCharacter(oPC);
			SetLocalInt(oPC,"STOREDELAY",uTime+10);
		}
			
		// if a new last sales slot, add to the total number of sales slots
		//if (GetCampaignInt(sDB,"StorageListTotal") < iCounter) SetCampaignInt(sDB,"StorageListTotal",iCounter);
		DelayCommand(1.0f,ExecuteScript("gui_kemo_storage_deposit",oPC));
		
		int time = PS_GetTimestamp_Age_Seconds(oPC,timerid);
		
		SendMessageToPC(oPC,"<I>Depositing the item took . . "+FloatToString(time / 1000.0)+" seconds.");
		//TimerDelete(timerid);
}
}