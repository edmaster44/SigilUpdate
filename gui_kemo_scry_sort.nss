#include "gui_kemo_scry_inc"

void SecondStep(object oPC, int nTOTAL)
{
	int nI;
	object oI;
	int nANON;
	string sROW;
	for (nI = 1; nI <= nTOTAL; nI++)
	{
		oI = GetLocalObject(oPC, "ScryObject_"+IntToString(nI));
		nANON = GetLocalInt(oI,"KScry_Anon");
		sROW = "ScryRow"+IntToString(nI);
		ChangeList(nANON, oPC, oI, sROW, 1);
	}
}

void FirstStep(object oPC, int nTOTAL, int nORDER) 
{
	int nJ;
	int nCHECK;
	string nID_I, nID_J;
	object oI, oJ;
	int nI;
	int nGAP;
	for (nI = 2; nI <= nTOTAL; nI++)
	{
		nID_I = GetLocalString(oPC, "ScryObjectID_"+IntToString(nI));
		oI = GetLocalObject(oPC, "ScryObject_"+IntToString(nI));
		for (nJ = nI -1; nJ > 0; nJ--)
		{
			nID_J = GetLocalString(oPC, "ScryObjectID_"+IntToString(nJ));
			nCHECK = StringCompare(nID_I, nID_J);
			if (((nORDER == 1)&&(nCHECK > 0))||((nORDER == 2)&&(nCHECK < 0)))
			{
				oJ = GetLocalObject(oPC, "ScryObject_"+IntToString(nJ));
				SetLocalObject(oPC, "ScryObject_"+IntToString(nJ+1), oJ);
				SetLocalObject(oPC, "ScryObject_"+IntToString(nJ), oI);
				SetLocalString(oPC, "ScryObjectID_"+IntToString(nJ+1), nID_J);
				SetLocalString(oPC, "ScryObjectID_"+IntToString(nJ), nID_I);
			}
			else break;
		}	
	}
	DelayCommand(0.0f, SecondStep(oPC, nTOTAL));
}

void main(string sSORT)
{
	object oPC = OBJECT_SELF;
	int nTOTAL = GetLocalInt(oPC, "SCRY_TOTAL");
	int nORDER = GetLocalInt(oPC, "SCRY_SORT");
	if (nORDER != 1) SetLocalInt(oPC, "SCRY_SORT", 1);
	else SetLocalInt(oPC, "SCRY_SORT", 2);
	string sTXT;
	object oI;
	int nI;
	for (nI = 1; nI <= nTOTAL; nI++)
	{
		oI = GetLocalObject(oPC, "ScryObject_"+IntToString(nI));
		sTXT = GetSortRelevant(oPC, oI, sSORT);
		SetLocalString(oPC, "ScryObjectID_"+IntToString(nI), sTXT);
	}
	DelayCommand(0.0f, FirstStep(oPC, nTOTAL, nORDER));
}