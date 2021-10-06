// called from kemo_storage_conv
#include "nwnx_sql"
#include "gui_kemo_storage_list_open"


/*string GetPCID(object oPC)
{
	return GetSubString(GetPCPlayerName(oPC), 0, 12)
				+ "_" + GetSubString(GetFirstName(oPC), 0, 6)
				+ "_" + GetSubString(GetLastName(oPC), 0, 9);
}*/
int CheckName(object oPC, string sGuild)
{
	int nCount = 1;

	while (nCount < 10)
	{
	string gName = GetLocalString(oPC,"guildbank-name"+IntToString(nCount));
	if(gName == sGuild) return FALSE;
	nCount++;
	}
	
	return TRUE;	
}
void GuildStorage(object oPC)
{
	int iValid = 0;
	int iCounter = 0;
	SetLocalInt(oPC, "kemo_storage_page", 1);
		
	DeleteLocalString(oPC,"kemo_storage_mode_guildname");
	DeleteLocalString(oPC,"kemo_storage_mode_guild");
	DeleteLocalString(oPC,"kemo_temp_guildname");
	DeleteLocalString(oPC,"kemo_temp_accesslevel");
	DeleteLocalInt(oPC,"DelayPage");
	DeleteLocalInt(oPC,"DepositDelay");
	DeleteLocalInt(oPC,"RetrieveDelay");
	
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","KEMO_STORAGE_RETRIEVE",FALSE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","RetrieveLabelPane",FALSE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","DepositLabelPane",TRUE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","KEMO_STORAGE_DEPOSIT",TRUE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","ViewButton",TRUE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","ListButton",TRUE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","RetrieveButton",FALSE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","DepositButtonA",TRUE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","DepositButtonB",TRUE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","FilterPane",TRUE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","PagePane",FALSE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","PageIncreaseButton",TRUE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","PageDecreaseButton",TRUE);
	
	ClearListBox(oPC,"KEMO_STORAGE","KEMO_STORAGE_RETRIEVE");
	
	SQLExecDirect("SELECT Guild, GuildToken, GuildAccess FROM guildstorage" +
	             " WHERE StoreType = 'CRAFTBANK' ORDER BY Guild,GuildAccess DESC");
	
	AddListBoxRow( oPC,
	"KEMO_STORAGE",
	"KEMO_STORAGE_RETRIEVE",
	"RetrieveRow"+IntToString(iCounter),
	"RetrievePaneName="+GetName(oPC)+";",
	"RetrievePaneIcon=it_bagholding.tga;",
	"5="+GetName(oPC),
	"");			 
				 			 
	while (SQLFetch() == SQL_SUCCESS)
	{
		string sGuild = SQLGetData(1);
		string sGuildToken = SQLGetData(2);
		int iGuildAccess = StringToInt(SQLGetData(3));
		
		if (sGuild != "")
		{
		if (GetItemPossessedBy(oPC,sGuildToken)!= OBJECT_INVALID)
		{
		AddListBoxRow( oPC,
		"KEMO_STORAGE",
		"KEMO_STORAGE_RETRIEVE",
		"RetrieveRow"+IntToString(iCounter),
		"RetrievePaneName="+sGuild+";",
		"RetrievePaneIcon="+GetStorageItemIconByTag(sGuildToken)+";",
		"5=" +SQLGetData(1),
		"");
		}
		
		iCounter++;
		iValid++;
		}
	}
	
	DeleteLocalString(oPC, "kemo_temp_guildname");
	DeleteLocalInt(oPC, "kemo_temp_accesslevel");
	
	if (iValid == 0)
	{
	DeleteLocalString(oPC,"kemo_storage_mode_guild");
	ExecuteScript("gui_kemo_storage_list",oPC);
	return;
	}
	SetLocalString(oPC, "kemo_storage_mode_guild","yes");
	SetGUIObjectText(oPC,"KEMO_STORAGE","ItemsOfTotal",-1,"Please select which guild.");
	SetGUIObjectText(oPC,"KEMO_STORAGE","RetrieveButton",-1,"Select guild.");
}
void main()
{
	object oPC = GetPCSpeaker();
	SendMessageToPC(oPC,"Opening Kemo Storage" );
	DisplayGuiScreen(oPC,"STORAGE_NEW",FALSE,"storage_new.xml");

	/*object oPC = GetPCSpeaker();
	string sDB = GetPCID(oPC) + "_storage";
	
	if (d20() == 1) PackCampaignDatabase(sDB); // packs database 5% of the time

	//DisplayGuiScreen(oPC,"KEMO_STORAGE",FALSE,"kemo_storage.xml");
	//ClearListBox(oPC,"KEMO_STORAGE","KEMO_STORAGE_RETRIEVE");
//	ExecuteScript("gui_kemo_storage_list",oPC); */
}