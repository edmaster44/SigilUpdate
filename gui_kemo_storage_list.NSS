#include "ginc_param_const"
#include "nwnx_sql"
#include "gui_kemo_storage_list_open"


void main()
{
	object oPC = OBJECT_SELF;

	string sDB = GetPCID(oPC) + "_storage";

	int iListTotal = GetStorageListTotal(sDB);
	string sItem; string sName;
	
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","KEMO_STORAGE_RETRIEVE",FALSE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","RetrieveLabelPane",FALSE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","DepositLabelPane",TRUE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","KEMO_STORAGE_DEPOSIT",TRUE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","ViewButton",FALSE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","ListButton",TRUE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","RetrieveButton",FALSE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","DepositButtonA",FALSE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","DepositButtonB",TRUE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","FilterPane",FALSE);
	SetGUIObjectHidden(oPC,"KEMO_STORAGE","PagePane",FALSE);

	ClearListBox(oPC,"KEMO_STORAGE","KEMO_STORAGE_RETRIEVE");

	if ( GetLocalString(oPC, "kemo_storage_mode") != "retrieve" )
	{
		SetLocalInt(oPC, "kemo_storage_page", 1);
		SetLocalString(oPC, "kemo_storage_mode", "retrieve");
	}

	string sFilter = GetStringUpperCase(GetLocalString(oPC,"StorageFilter"));
	
	int page = GetLocalInt(oPC, "kemo_storage_page");
	if (page < 1) page = 1;
	
	int resultCount = 0;

	int lastItem = page * 25; // last item in current page
	int firstItem = lastItem - 25; // first item in current page
	
	// if we don't want to filter, search for the later added ;
	if (sFilter == "") sFilter = ";";
	
	int iCounter = 0;
	while (++iCounter <= iListTotal)
	{
		sItem = GetCampaignString(sDB,"StorageParameters" + IntToString(iCounter));
		// if there is an item here, display; if not, skip
		if (sItem == "") continue;

		// sName = GetStringParam(sItem,0,";");
		// GetStringParam is too intensive
		sName = GetSubString(sItem,0,FindSubString(sItem,";"));
		// Search over all pages and filter the results into pages. Add ; to the name because it's unique.
		if (FindSubString(";" + GetStringUpperCase(sName),sFilter) > -1)
		{
			if (resultCount >= firstItem && resultCount < lastItem)
			{
				AddListBoxRow( oPC,
	               "KEMO_STORAGE",
				   "KEMO_STORAGE_RETRIEVE",
				   "RetrieveRow" + IntToString(iCounter),
				   "RetrievePaneName=     "+sName+" ("+GetStringParam(sItem,1,";")+");",
				   "RetrievePaneIcon=" + GetStringParam(sItem,2,";"),
				   "5=" + IntToString(iCounter),
				   "");
			} // end if
			resultCount++;
		} // end if
	} // end while

	int pageCount = (lastItem <= resultCount) ? 25 : resultCount - firstItem;
	
	string sItemOfTotal = "Showing item " + IntToString(firstItem + 1) + " to " + IntToString(firstItem + pageCount) + " of " + IntToString(resultCount);
	
	if (pageCount == 0 && page == 1) SetGUIObjectHidden(oPC,"KEMO_STORAGE","PagePane",TRUE);
	else SetGUIObjectText(oPC,"KEMO_STORAGE","ItemsOfTotal",-1,sItemOfTotal);
	
	SetLocalInt(oPC, "kemo_storage_list_size", resultCount);
}