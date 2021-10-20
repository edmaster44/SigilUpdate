#include "ginc_param_const"
#include "nwnx_sql"
#include "gui_kemo_storage_list_open"

void main()
{
	object oPC = OBJECT_SELF;
	int iValid = 0;
	int iCounter = 0;
	string sDB;
	int accesslevel = 0;
	
	if (GetLocalString(oPC,"kemo_storage_mode_guildname") == "")
	{
	sDB = GetPCID(oPC);
	}	
	
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","KEMO_STORAGE_RETRIEVE",FALSE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","RetrieveLabelPane",FALSE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","DepositLabelPane",TRUE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","KEMO_STORAGE_DEPOSIT",TRUE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","ViewButton",FALSE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","ListButton",TRUE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","RetrieveButton",FALSE);	
	
	if (GetLocalString(oPC,"kemo_storage_mode_guildname") != "")
	{
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","RetrieveButton",TRUE);
	
	int iGuildAccess;
	string sGuildToken;
	
	SQLExecDirect("SELECT GuildToken, GuildAccess FROM guildstorage" +
	             " WHERE StoreType = 'CRAFTBANK' AND Guild='"+GetLocalString(oPC,"kemo_storage_mode_guildname")+"' ORDER BY GuildAccess DESC");

	while (SQLFetch())
	{
	sGuildToken = SQLGetData(1);
	iGuildAccess = StringToInt(SQLGetData(2));
	
	if (GetItemPossessedBy(oPC,sGuildToken)!= OBJECT_INVALID && iGuildAccess >= 6)
	{
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","RetrieveButton",FALSE);
	}
	
	}
	sDB = GetGuildID(oPC,GetLocalString(oPC,"kemo_storage_mode_guildname"));
	}
	
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","DepositButtonA",FALSE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","DepositButtonB",TRUE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","FilterPane",FALSE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","PagePane",FALSE);
	SetGUIObjectText(oPC,"KEMO_STORAGE","RetrieveButton",-1,"Retrieve");
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","PageIncreaseButton",FALSE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","PageDecreaseButton",FALSE);
	
	ClearListBox(oPC,"KEMO_STORAGE","KEMO_STORAGE_RETRIEVE");
	
	int iListTotal = GetStorageListTotal(sDB, oPC);
	string sQuery;
	
	if ( GetLocalString(oPC, "kemo_storage_mode") != "retrieve" )
	{
		SetLocalInt(oPC, "kemo_storage_page", 1);
		SetLocalString(oPC, "kemo_storage_mode", "retrieve");
	}

	string sFilter = GetStringUpperCase(GetLocalString(oPC,"StorageFilter"));
	
	int page = GetLocalInt(oPC, "kemo_storage_page");
	if (page < 1) page = 1;
	
	int resultCount = iListTotal;

	int lastItem = page * 25; // last item in current page
	int firstItem = lastItem - 25; // first item in current page

	sQuery = "SELECT itemid, itemname, icon FROM new_storage where storageid='"+sDB+"'"+
	" limit "+IntToString(firstItem)+","+IntToString(lastItem)+";";
	
	if (GetLocalString(oPC,"kemo_storage_mode_guildname") != "")
	{
	sQuery = "SELECT itemid, itemname, icon FROM new_storage_guildstorage where storageid='"+sDB+"'"+
	" limit "+IntToString(firstItem)+","+IntToString(lastItem)+";";
	}
	
	if (sFilter != "") sQuery="SELECT itemid, itemname, icon FROM new_storage where storageid='"+sDB+"'"
	+" and itemname LIKE '%"+SQLEncodeSpecialChars(sFilter)+"%' limit "+IntToString(firstItem)+","+IntToString(lastItem)+";";
	
	if (GetLocalString(oPC,"kemo_storage_mode_guildname") != "")
	{
	if (sFilter != "") sQuery="SELECT itemid, itemname, icon FROM cmnsee_storage_guildstorage where storageid='"+sDB+"'"
	+" and itemname LIKE '%"+SQLEncodeSpecialChars(sFilter)+"%' limit "+IntToString(firstItem)+","+IntToString(lastItem)+";";
	}
	
	SQLExecDirect(sQuery);

	iCounter = 0;
	
	while (SQLFetch())
	{
	AddListBoxRow( oPC,
	"KEMO_STORAGE",
	"KEMO_STORAGE_RETRIEVE",
	"RetrieveRow"+IntToString(iCounter),
	"RetrievePaneName="+SQLGetData(2)+";",
	"RetrievePaneIcon="+SQLGetData(3)+";",
	"5=" +SQLGetData(1),
	"");
	iCounter++;
	}

	int pageCount = (lastItem <= resultCount) ? 25 : resultCount - firstItem;
	
	string sItemOfTotal = "Showing item " + IntToString(firstItem + 1) + " to " + IntToString(firstItem + pageCount) + " of " + IntToString(resultCount);
	
	if (pageCount == 0 && page == 1) SetGUIObjectHidden(oPC,"KEMO_STORAGE","PagePane",TRUE);
	else SetGUIObjectText(oPC,"KEMO_STORAGE","ItemsOfTotal",-1,sItemOfTotal);
	
	SetLocalInt(oPC, "kemo_storage_list_size", resultCount);
}