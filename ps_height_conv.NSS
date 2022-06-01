#include "ps_heightadjust_includes"

void main()
{
	object oPC = GetPCSpeaker(); 
	
	if(GetSubRace(oPC) == 96)
	{
		SendMessageToPC(oPC,"Giants cannot use this feature.");
		AssignCommand(oPC, ActionStartConversation(oPC, "", TRUE));
		return;
	}
	
	int nCount = 1;

	int iLoop = GetCMDifference(oPC); nCount = 0;
	float iMin = GetCMMin(oPC); string sMin = FloatToString(iMin);
	string cm; string foot; string inch; string sMessage; string sCM;
	
	SetLocalInt(oPC,"heightmax",iLoop);
	
	while (iLoop + 1 > nCount)
	{
		if(nCount == 0) cm = sMin;
		else
		{
			SQLExecDirect("select "+sMin+" + ("+IntToString(nCount)+" * 2.54);");
			SQLFetch();
			cm = SQLGetData(1);
		}

		SQLExecDirect("select floor("+cm+"/(12*2.54)) as foot , round(("+cm+" mod (12*2.54))/2.54) as inch, round("+cm+",2);");
		SQLFetch();	
	
		foot = SQLGetData(1); inch = SQLGetData(2); sCM = SQLGetData(3);
		
		if(inch == "12") 
		{
			inch = "0";
			foot = IntToString(StringToInt(foot) + 1);
		}
	
		sMessage = foot+"'"+inch+" ("+sCM+" cm)";
		
		SetCustomToken(30000+nCount, sMessage);
		nCount++;
	}
}