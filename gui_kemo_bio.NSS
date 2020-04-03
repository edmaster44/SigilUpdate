string GetPackPortrait(string sPortrait)
{
	int iFilenameLength = GetStringLength(sPortrait) - 1;
	int iPackSize = StringToInt(GetStringRight(sPortrait,1));
	int iPackVariant = Random(iPackSize+1);
	sPortrait = GetStringLeft(sPortrait,iFilenameLength);
	return sPortrait + IntToString(iPackVariant) + ".tga";
}

//cycles through each element of the current pack, once per second, when the filename is edited
void CyclePortraits()
{
	object oPC = OBJECT_SELF; string sDB; string sPortrait; int iFilenameLength;
	int iPackSize; int iPackVariant; string sPortraitTGA;
	
	sDB = GetSubString(GetPCPlayerName(oPC), 0, 12) +
		"_" + GetSubString(GetFirstName(oPC), 0, 6) + "_" + GetSubString(GetLastName(oPC), 0, 9);
	sPortrait = GetCampaignString(sDB,"Portrait");
	if (FindSubString(sPortrait,"pack") > -1)
	{
		iFilenameLength = GetStringLength(sPortrait) - 1;
		iPackSize = StringToInt(GetStringRight(sPortrait,1));
		sPortrait = GetStringLeft(sPortrait,iFilenameLength);
		iPackVariant = 0;
		while (iPackVariant <= iPackSize)
		{
			sPortraitTGA = sPortrait + IntToString(iPackVariant) + ".tga";
			DelayCommand(IntToFloat(iPackVariant)*0.5f,SetGUITexture(oPC,"KEMO_BIO_EDIT","KEMO_PORTRAIT",sPortraitTGA));
			iPackVariant++;
		}
	}
}

void main(string sAction, string sType, string sEntry)
{
	object oPC = OBJECT_SELF;
	object oTarget = GetPlayerCurrentTarget(oPC);
	string sDB; string sBio; string sPortrait; string sPortraitTGA;
	
	
	if (sAction == "display")
	{
		sDB = GetSubString(GetPCPlayerName(oTarget), 0, 12) +
			"_" + GetSubString(GetFirstName(oTarget), 0, 6) +
			"_" + GetSubString(GetLastName(oTarget), 0, 9);
		sBio = GetCampaignString(sDB,"Bio");
		sPortrait = GetCampaignString(sDB,"Portrait");
			if (GetStringLength(sPortrait) < 2) sPortrait = "bg_60_alpha";
		
		//filenames with "pack" in them are set up as series, 0-9
		//viewers will see one of the pack selected at random
		//editors specify the size of the pack by using the highest number
		//in the series: if x_pack_ has 5 pictures, type in x_pack_4 to
		//set the range
		if (FindSubString(sPortrait,"pack") > -1)
		{	sPortrait = GetPackPortrait(sPortrait);
			DisplayGuiScreen(oPC,"KEMO_BIO_DISPLAY",FALSE,"kemo_bio_display.xml");
			SetGUIObjectText(oPC,"KEMO_BIO_DISPLAY","INPUT_BIOTEXT",-1,sBio);
			SetGUITexture(oPC,"KEMO_BIO_DISPLAY","KEMO_PORTRAIT",sPortrait);
			DisplayGuiScreen(oPC,"KEMO_ERP",FALSE,"kemo_erp.xml");
			//SendMessageToPC(oTarget,"<C=gray>Someone is inspecting you. [Portrait: " + sPortrait + "]</C>");
		}
		else
		{	sPortrait = sPortrait + ".tga";
			DisplayGuiScreen(oPC,"KEMO_BIO_DISPLAY",FALSE,"kemo_bio_display.xml");
			SetGUIObjectText(oPC,"KEMO_BIO_DISPLAY","INPUT_BIOTEXT",-1,sBio);
			SetGUITexture(oPC,"KEMO_BIO_DISPLAY","KEMO_PORTRAIT",sPortrait);
			DisplayGuiScreen(oPC,"KEMO_ERP",FALSE,"kemo_erp.xml");
			//SendMessageToPC(oTarget,"<C=gray>Someone is inspecting you.</C>");
		}
		//WriteTimestampedLogEntry(GetName(oPC) + " is displaying a bio/portrait: " + sPortrait);
		
		return;
	}
	if (sAction == "edit")
	{
		//WriteTimestampedLogEntry(GetName(oPC) + " is editing a bio/portrait.");
		sDB = GetSubString(GetPCPlayerName(oPC), 0, 12) +
			"_" + GetSubString(GetFirstName(oPC), 0, 6) +
			"_" + GetSubString(GetLastName(oPC), 0, 9);
		sBio = GetCampaignString(sDB,"Bio");
		sPortrait = GetCampaignString(sDB,"Portrait");
			if (GetStringLength(sPortrait) < 2) sPortrait = "bg_60_alpha";
		sPortraitTGA = sPortrait+".tga";
		DisplayGuiScreen(oPC,"KEMO_BIO_EDIT",FALSE,"kemo_bio_edit.xml");
		SetGUIObjectText(oPC,"KEMO_BIO_EDIT","INPUT_BIOTEXT",-1,sBio);
		SetGUIObjectText(oPC,"KEMO_BIO_EDIT","PORTRAIT_INPUT_BOX",-1,sPortrait);
		SetGUITexture(oPC,"KEMO_BIO_EDIT","KEMO_PORTRAIT",sPortraitTGA);
		DisplayGuiScreen(oPC,"KEMO_ERP",FALSE,"kemo_erp.xml");
		return;
	}
	if (sAction == "save")
	{
		//WriteTimestampedLogEntry(GetName(oPC) + " is saving a bio/portrait.");
		sDB = GetSubString(GetPCPlayerName(oPC), 0, 12) +
			"_" + GetSubString(GetFirstName(oPC), 0, 6) +
			"_" + GetSubString(GetLastName(oPC), 0, 9);
		if (sType == "bio")
		{
			SetCampaignString(sDB,"Bio",sEntry);
			CloseGUIScreen(oPC,"KEMO_BIO_EDIT");
		}
		if (sType == "portrait")
		{
			
			if (sEntry == GetCampaignString(sDB,"Portrait")) return;
			if (GetStringLength(sEntry) < 2) sEntry = "bg_60_alpha";
			SetCampaignString(sDB,"Portrait",sEntry);
			CyclePortraits();
			SetGUITexture(oPC,"KEMO_BIO_EDIT","KEMO_PORTRAIT",sEntry+".tga");
		}
		return;
	}
}