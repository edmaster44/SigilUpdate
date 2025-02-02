/*
	ps_onunacquire001
	This is code for module trash collectors (see "ps_lib-trashcollector).
	it is intended to be included in the Module OnUnacquire script
*/

/*
	History of Changes

	27AUG2010 - ADnD'R
	1. Added check to disregard (ignored by the trash collector) the following items: any Plot items, containers,
	and items over 3000gp in value. 

	2018 - Clangeddin
	Revamped the script to make it more consistent and work everywhere.
	"ps_lib-trashcollector.nss" is no longer used, everything is here.
*/

void TrashCollectedChat(object oCollector)
{
	int nCOUNT = 0;
	object oINV = GetFirstItemInInventory(oCollector);
	while (oINV != OBJECT_INVALID)
	{
		DestroyObject(oINV);
		nCOUNT = nCOUNT + 1;
		oINV = GetNextItemInInventory(oCollector);
	}
	
	if (nCOUNT < 1) return;
	string sEmote = GetLocalString(oCollector, "EATING_TALK");
	if (sEmote == "") return;
	SpeakString(sEmote);
}

void GetTrash(object oCOLLECTOR, object oITEM)
{
	ActionMoveToObject(oITEM, TRUE);
	ActionPickUpItem(oITEM);
	AssignCommand(oCOLLECTOR, TrashCollectedChat(oCOLLECTOR));	
}

//The new system will automatically destroy items dropped on the ground if they are not picked up within 5 minutes.
void ItemDestruction(object oITEM, float fTIME, vector vERROR)
{
	if (GetItemPossessor(oITEM) != OBJECT_INVALID) return;
	if (GetPosition(oITEM) == vERROR) return; //Attempt to fix barter problem.
	if (fTIME > 0.0f) DelayCommand(6.0, ItemDestruction(oITEM, fTIME - 6.0, vERROR));
	else DestroyObject(oITEM);
}

void main()
{
	object oITEM = GetModuleItemLost();
	if (oITEM == OBJECT_INVALID) return; //fatal

	// We want to ignore certain types of items and any items worth 1000 gp or more.
	if (GetPlotFlag(oITEM) == TRUE) return;
	if (GetItemCursedFlag(oITEM) == TRUE) return;
	if (GetHasInventory(oITEM) == TRUE) return;
	if (GetGoldPieceValue(oITEM) >= 1000) return;
	
	//If there is a trash collector, we run it, otherwise we use the new system.
	vector vERROR = Vector();
	string sCOLLECTOR = GetTag(GetArea(oITEM)) + "_trasher"; 
	object oCOLLECTOR = GetObjectByTag(sCOLLECTOR);
	if (oCOLLECTOR == OBJECT_INVALID) ItemDestruction(oITEM, 300.0, vERROR);
	else AssignCommand(oCOLLECTOR, GetTrash(oCOLLECTOR, oITEM));
}