

#include "gui_kemo_scry_inc"

void main() 
{
	object oPC = OBJECT_SELF;
	int nTOTAL = GetLocalInt(oPC, "SCRY_TOTAL");
	int nORDER = GetLocalInt(oPC, "SCRY_SORT");
	int nJ;
	int nCHECK;
	string nID_I, nID_J;
	object oI, oJ;
	int nI = 2;
	while (nI <= nTOTAL)
	{
		nID_I = GetLocalString(oPC, "ScryObjectID_"+IntToString(nI));
		oI = GetLocalObject(oPC, "ScryObject_"+IntToString(nI));
		nJ = nI - 1;
		while (nJ > 0)
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
				nJ = nJ - 1;
			}
			else break;
		}	
		nI = nI + 1;
	}
	DelayCommand(0.0f, ExecuteScript("gui_kemo_scry_sortb", oPC));
}