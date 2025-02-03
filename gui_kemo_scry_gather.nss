#include "gui_kemo_scry_inc"

void main()
{
	object oPC = OBJECT_SELF;
	int nANON;
	string sROW;
	int nTOT = 0;
	int nVIS = 0;
	ClearListBox(oPC,"KEMO_SCRY_PANEL","KEMO_SCRY_LIST");
	object oLIST = GetFirstPC();
	while (oLIST!=OBJECT_INVALID)
	{
		nTOT = nTOT + 1;
		nANON = GetLocalInt(oLIST,"KScry_Anon");
		if ((GetFirstName(oLIST) != "") && (nANON != 1 || GetIsDM(oPC)))
		{
			nVIS = nVIS + 1;
			SetLocalObject(oPC, "ScryObject_"+IntToString(nVIS), oLIST);
			sROW = "ScryRow"+IntToString(nVIS);
			ChangeList(nANON, oPC, oLIST, sROW, 0);			
		}
		oLIST = GetNextPC();
	}
	string sTOTAL = "Showing " + IntToString(nVIS) + " out of " + IntToString(nTOT);
	SetGUIObjectText(oPC,"KEMO_SCRY_PANEL","KEMO_SCRY_TOTALS",-1,sTOTAL);
	SetLocalInt(oPC, "SCRY_TOTAL", nVIS);
}