

#include "ps_heightadjust_includes"

void main()
{
	object oPC = GetPCSpeaker(); 
	
	if(GetSubRace(oPC) == 197 || GetSubRace(oPC) == 147|| GetSubRace(oPC) == 69  || GetSubRace(oPC) == 168 || GetSubRace(oPC) == 198 || GetSubRace(oPC) == 199 /*For the giant races, we exclude them */
		|| GetSubRace(oPC) == 200 || GetSubRace(oPC) == 220 || GetSubRace(oPC) == 237 || GetSubRace(oPC) == 238|| GetSubRace(oPC) == 201 || GetSubRace(oPC) == 202 
		|| GetSubRace(oPC) == 239|| GetSubRace(oPC) == 240  || GetSubRace(oPC) == 205 || GetSubRace(oPC) == 206 
		|| GetSubRace(oPC) == 244|| GetSubRace(oPC) == 221 || GetSubRace(oPC) == 207|| GetSubRace(oPC) == 222|| GetSubRace(oPC) == 223|| GetSubRace(oPC) == 224|| GetSubRace(oPC) == 225|| GetSubRace(oPC) == 226
		    || GetSubRace(oPC) == 227|| GetSubRace(oPC) == 228|| GetSubRace(oPC) == 230|| GetSubRace(oPC) == 231|| GetSubRace(oPC) == 232|| GetSubRace(oPC) == 234|| GetSubRace(oPC) == 235)
	{
		SendMessageToPC(oPC,"Giants and dragons and Golems cannot use this feature.");
		AssignCommand(oPC, ActionStartConversation(oPC, "", TRUE));
		return;
	}
	
	int nCount = 0;
	// if there are still no non-zero height at end of loop, alert player that height adjustments
	// cannot be done for their character
	int bHasValidAdjustment = FALSE; 

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
		
		// only add the token if the height is greater than 0
		if (StringToInt(sCM) > 0 && (StringToInt(foot) > 0 || StringToInt(inch) > 0)){
			SetCustomToken(30000+nCount, sMessage);
			bHasValidAdjustment = TRUE;
		}
		nCount++;
	}
	if (!bHasValidAdjustment)
		SendMessageToPC(oPC, "Height adjustment is not enabled for this character");
}