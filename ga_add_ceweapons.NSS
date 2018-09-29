// Ceremorph 1/17/2015
// Creates equippable creature weapons

void main()
{
	object oPC = GetPCSpeaker();
	
	int iSub = GetSubRace(oPC);
	string sCW1 = Get2DAString("racialsubtypes", "EqCW1", iSub);
	string sCW2 = Get2DAString("racialsubtypes", "EqCW2", iSub);
	string sCW3 = Get2DAString("racialsubtypes", "EqCW3", iSub);
	object oTemp;
	int oSize;
	

	if (sCW1 == "" && sCW2 == "" && sCW3 == "")
	{	SendMessageToPC(oPC, "<color=yellow>Sorry, but your race does not possess natural weapons.");	}
	else
	{
	///////////////////////////////////////////////////////////////////////////////////	
	// if its a Dragon (+ has the Draconic Scales Feat)		
		if(GetRacialType(oPC) == 11 && GetHasFeat(3623, oPC)) 
		{	oSize = GetCreatureSize(oPC);	// 3 = medium, 4 = large, 5 = huge
			if (oSize == 4)
			{	oTemp = CreateItemOnObject("s3_w_ldragonbite_01", oPC, 1, "", FALSE);
				SetIdentified(oTemp, TRUE);
				oTemp = CreateItemOnObject("s3_w_ldragonclaw_01", oPC, 1, "", FALSE);
				SetIdentified(oTemp, TRUE);
				oTemp = CreateItemOnObject("s3_w_ldragonclaw_01", oPC, 1, "", FALSE);
				SetIdentified(oTemp, TRUE);
				SendMessageToPC(oPC,"<color=yellow> Creature weapons have been placed in your inventory.");	}
			else if	(oSize == 5)
			{	oTemp = CreateItemOnObject("s3_w_hdragonbite_01", oPC, 1, "", FALSE);
				SetIdentified(oTemp, TRUE);
				oTemp = CreateItemOnObject("s3_w_hdragonclaw_01", oPC, 1, "", FALSE);
				SetIdentified(oTemp, TRUE);
				oTemp = CreateItemOnObject("s3_w_hdragonclaw_01", oPC, 1, "", FALSE);
				SetIdentified(oTemp, TRUE);
				SendMessageToPC(oPC,"<color=yellow> Creature weapons have been placed in your inventory.");	}
			else
			{	oTemp = CreateItemOnObject("s3_w_mdragonbite_01", oPC, 1, "", FALSE);
				SetIdentified(oTemp, TRUE);
				oTemp = CreateItemOnObject("s3_w_mdragonclaw_01", oPC, 1, "", FALSE);
				SetIdentified(oTemp, TRUE);
				oTemp = CreateItemOnObject("s3_w_mdragonclaw_01", oPC, 1, "", FALSE);
				SetIdentified(oTemp, TRUE);
				SendMessageToPC(oPC,"<color=yellow> Creature weapons have been placed in your inventory.");	}
		}       
	else
	{	if (sCW1 != "")
		{	oTemp = CreateItemOnObject(sCW1, oPC, 1, "", FALSE);
			SetIdentified(oTemp, TRUE);
			string sCW1 = GetName(oTemp);
			SendMessageToPC(oPC,"<color=yellow>" + sCW1 + "has been placed in your inventory.");	}
		if (sCW2 != "")
		{	oTemp = CreateItemOnObject(sCW2, oPC, 1, "", FALSE);
			SetIdentified(oTemp, TRUE);
			string sCW2 = GetName(oTemp);
			SendMessageToPC(oPC,"<color=yellow>" + sCW2 + "has been placed in your inventory.");	}
		if (sCW3 != "")
		{	oTemp = CreateItemOnObject(sCW3, oPC, 1, "", FALSE);
			SetIdentified(oTemp, TRUE);
			string sCW3 = GetName(oTemp);
			SendMessageToPC(oPC,"<color=yellow>" + sCW3 + "has been placed in your inventory.");	}
		}
	}
}