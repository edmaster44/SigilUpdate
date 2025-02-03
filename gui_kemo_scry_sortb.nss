#include "gui_kemo_scry_inc"

void main()
{
	object oPC = OBJECT_SELF;
	int nTOTAL = GetLocalInt(oPC, "SCRY_TOTAL");
	int nI = 1;
	object oI;
	int nANON;
	string sROW;
	while (nI <= nTOTAL)
	{
		oI = GetLocalObject(oPC, "ScryObject_"+IntToString(nI));
		nANON = GetLocalInt(oI,"KScry_Anon");
		sROW = "ScryRow"+IntToString(nI);
		ChangeList(nANON, oPC, oI, sROW, 1);
		nI = nI + 1;
	}
}