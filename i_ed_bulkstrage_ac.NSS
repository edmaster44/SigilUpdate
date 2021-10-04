#include "nwnx_sql"
#include "gui_kemo_storage_list_open"


int CheckTag(object oItem)
{
	//prevents depositing certain items
	string sItemTag = GetTag(oItem);
	string name = GetName(oItem);
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
		FindSubString(sItemTag,"ps_essence") > -1 ||
		FindSubString(name,"Bag") > -1 ||
		FindSubString(name,"Pouch") > -1 ||
		FindSubString(name,"Box") > -1 ||
		FindSubString(name,"Ownership") > -1 ||
		FindSubString(name,"Spellsword") > -1 ||
		GetItemCursedFlag(oItem))
			return FALSE;
	else return TRUE;
}

void StoreItem(object oPC, object oItem, string sDB, string name, string player, string cdkey, string ipaddress)
{
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
	else if (!CheckTag(oItem)) //checks for forbidden items, prevents listing
	{
		SendMessageToPC(oPC,"You may not deposit this item.");
		return;		
	}
	else
	{
		string sStackSize = IntToString(GetNumStackedItems(oItem));
		string sIcon = GetStorageItemIcon(oItem);
		int sCategory = GetBaseItemType(oItem);
			
		string sQuery = "INSERT INTO new_storage_guildstorage (`storageid`,`itemname`,`stacksize`,`icon`,`category`,`campaignstring`,`depositedby`,`act`,`cdkey`,`ipaddress`) VALUES ('"+sDB+"', '"+SQLEncodeSpecialChars(sItemName)+"', "+
		" '"+sStackSize+"', '"+sIcon+"', '"+SQLEncodeSpecialChars(IntToString(sCategory))+"', %s, '"+name+"', '"+player+"', '"+cdkey+"', '"+ipaddress+"');";

		SQLSCORCOExec(sQuery);
		SQLStoreObject(oItem);
	//	BarcodeScan(oPC,oItem,"bankdeposited",sDB);
		DestroyObject(oItem);
		
		sQuery = "INSERT INTO new_storage_guild_history VALUES (NOW(), 'deposited', '"+sDB+"', "+
	" '"+SQLEncodeSpecialChars(sItemName)+"', '"+sStackSize+"', '"+name+"', '"+player+"', '"+cdkey+"', '"+ipaddress+"');";
	
		SQLExecDirect(sQuery);	
		SendMessageToPC(oPC,"Stored item "+sItemName+" into storage.");
	}
}

void main()
{
	object oWand = GetItemActivated();
	object oPC = GetItemActivator();
	object oTarget = GetItemActivatedTarget();
	string sDB = GetGuildID(oPC, GetLocalString(oWand,"kemo_storage_mode_guildname"));	
		
	if(!GetIsObjectValid(oTarget) || GetBaseItemType(oTarget) != BASE_ITEM_LARGEBOX)
	{
		SendMessageToPC(oPC,"Target must be a box!");
		return;
	}
	
	if(sDB == "")
	{
		SendMessageToPC(oPC,"An error occured. Aborting.");
		return;	
	}
	
	string name = SQLEncodeSpecialChars(GetName(oPC));
	string player = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	string cdkey = SQLEncodeSpecialChars(GetPCPublicCDKey(oPC));
	string ipaddress = SQLEncodeSpecialChars(GetPCIPAddress(oPC));	
	
	object oItem = GetFirstItemInInventory(oTarget);
	
	float delay=3.0;
	float delayInterval=0.2; int iCount;
	
	while (GetIsObjectValid(oItem))
	{
		DelayCommand(delay,StoreItem(oPC,oItem,sDB,name,player,cdkey,ipaddress));
		delay+=delayInterval; iCount++;
		oItem = GetNextItemInInventory(oTarget);
	}
	
	if(iCount > 0)
	{
		DelayCommand(delay, SendMessageToPC(oPC,"Stored "+IntToString(iCount)+" items into storage."));
		DelayCommand(delay, ExportSingleCharacter(oPC));
	}
}