#include "nwnx_sql"
string GetBioPCID(object oPC)
{
	string name = SQLEncodeSpecialChars(GetName(oPC));
	string player = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
	string sQuery;
	string userid;
		
	sQuery = "SELECT bioid FROM kemo_bios where name='"+name+"' and player='"+player+"';";
	SQLExecDirect(sQuery); SQLFetch();

	userid = SQLGetData(1);
	
	if (userid == "")
	{
	sQuery = "INSERT INTO kemo_bios (bioid, name, player, portrait) SELECT 1 + coalesce((SELECT max(bioid)"+
	" FROM kemo_bios), 0), '"+name+"', '"+player+"', 'bg_60_alpha';";
	SQLExecDirect(sQuery);

	sQuery = "SELECT bioid FROM kemo_bios where name='"+name+"' and player='"+player+"';";
	SQLExecDirect(sQuery); SQLFetch();

	userid = SQLGetData(1);
	}

	return userid;
}
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
object oPC = OBJECT_SELF; string sDB; string sPortrait; int iFilenameLength; string sQuery; string bioid;
	int iPackSize; int iPackVariant; string sPortraitTGA;
	
	bioid = GetBioPCID(oPC);

	sQuery = "SELECT portrait FROM kemo_bios where bioid='"+bioid+"';";
	SQLExecDirect(sQuery); SQLFetch();

	sPortrait = SQLGetData(1);

	if (sPortrait == "")
	{
	if (GetStringLength(sPortrait) < 2) sPortrait = "bg_60_alpha";
	}

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
	/*object oPC = OBJECT_SELF; string sDB; string sPortrait; int iFilenameLength;
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
	}*/
}

void main(string sAction, string sType, string sEntry)
{
object oPC = OBJECT_SELF;
	object oTarget = GetPlayerCurrentTarget(oPC);
	string sDB; string sBio; string sPortrait; string sPortraitTGA; string bioid; string targetid; string sQuery;
	
	if (sAction == "display")
	{
		bioid = GetBioPCID(oTarget);

		sQuery = "SELECT AES_DECRYPT(biotext,'PdSgVkYp3s5v8y/B?E(H+MbQeThWmZq4'), portrait FROM kemo_bios"+
		" where bioid='"+bioid+"';";
		SQLExecDirect(sQuery); SQLFetch();

		sBio=SQLGetData(1);
		sPortrait=SQLGetData(2);
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

			//SendMessageToPC(oTarget,"<C=gray>Someone is inspecting you. [Portrait: " + sPortrait + "]</C>");
		}
		else
		{	sPortrait = sPortrait + ".tga";
			DisplayGuiScreen(oPC,"KEMO_BIO_DISPLAY",FALSE,"kemo_bio_display.xml");
			SetGUIObjectText(oPC,"KEMO_BIO_DISPLAY","INPUT_BIOTEXT",-1,sBio);
			SetGUITexture(oPC,"KEMO_BIO_DISPLAY","KEMO_PORTRAIT",sPortrait);
			//SendMessageToPC(oTarget,"<C=gray>Someone is inspecting you.</C>");
		}
		WriteTimestampedLogEntry(GetName(oPC) + " is displaying a bio/portrait: " + sPortrait);
		
		return;
	}
	if (sAction == "preview")
	{
		CloseGUIScreen(oPC,"KEMO_BIO_EDIT");
		CloseGUIScreen(oPC,"KEMO_BIO_DISPLAY");
	
		bioid = GetBioPCID(oPC);

		sQuery = "SELECT AES_DECRYPT(biotext,'PdSgVkYp3s5v8y/B?E(H+MbQeThWmZq4'), portrait FROM kemo_bios"+
		" where bioid='"+bioid+"';";
		SQLExecDirect(sQuery); SQLFetch();

		sBio=SQLGetData(1);
		sPortrait=SQLGetData(2);
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
		
		}
		else
		{	sPortrait = sPortrait + ".tga";
			DisplayGuiScreen(oPC,"KEMO_BIO_DISPLAY",FALSE,"kemo_bio_display.xml");
			SetGUIObjectText(oPC,"KEMO_BIO_DISPLAY","INPUT_BIOTEXT",-1,sBio);
			SetGUITexture(oPC,"KEMO_BIO_DISPLAY","KEMO_PORTRAIT",sPortrait);
			
		}
		WriteTimestampedLogEntry(GetName(oPC) + " is displaying a bio/portrait: " + sPortrait);
		
		return;
	}
	if (sAction == "edit")
	{
		WriteTimestampedLogEntry(GetName(oPC) + " is editing a bio/portrait.");
		SendMessageToPC(oPC,"Players portraits available: https://www.nwn2planescape.com/portrait_gallery.php/");
		bioid = GetBioPCID(oPC);		

		sQuery = "SELECT AES_DECRYPT(biotext,'PdSgVkYp3s5v8y/B?E(H+MbQeThWmZq4'), portrait FROM kemo_bios"+
		" where bioid='"+bioid+"';";
		SQLExecDirect(sQuery); SQLFetch();

		sPortrait=SQLGetData(2);
		sPortraitTGA = sPortrait+".tga";

		DisplayGuiScreen(oPC,"KEMO_BIO_EDIT",FALSE,"kemo_bio_edit.xml");
		SetGUIObjectText(oPC,"KEMO_BIO_EDIT","INPUT_BIOTEXT",-1,SQLGetData(1));
		SetGUIObjectText(oPC,"KEMO_BIO_EDIT","PORTRAIT_INPUT_BOX",-1,sPortrait);
		SetGUITexture(oPC,"KEMO_BIO_EDIT","KEMO_PORTRAIT",sPortraitTGA);
		return;
	}
	if (sAction == "save")
	{
		WriteTimestampedLogEntry(GetName(oPC) + " is saving a bio/portrait.");
		bioid = GetBioPCID(oPC);

		if (sType == "bio")
		{
		sQuery = "UPDATE kemo_bios SET biotext=AES_ENCRYPT('"+SQLEncodeSpecialChars(sEntry)+
		"','PdSgVkYp3s5v8y/B?E(H+MbQeThWmZq4') where bioid='"+bioid+"';";
		SQLExecDirect(sQuery);
		CloseGUIScreen(oPC,"KEMO_BIO_EDIT");
		}
		if (sType == "portrait")
		{
		sQuery = "SELECT portrait FROM kemo_bios where bioid='"+bioid+"';";
		SQLExecDirect(sQuery); SQLFetch();
		
		sPortrait=SQLGetData(1);

		if (sEntry == sPortrait) return;
		if (GetStringLength(sEntry) < 2) sEntry = "bg_60_alpha";
			
		sQuery = "UPDATE kemo_bios SET portrait='"+SQLEncodeSpecialChars(sEntry)+"' where bioid='"+bioid+"';";
		SQLExecDirect(sQuery);
		CyclePortraits();
		SetGUITexture(oPC,"KEMO_BIO_EDIT","KEMO_PORTRAIT",sEntry+".tga");
		}
		return;
	}
/*	object oPC = OBJECT_SELF;
	object oTarget = GetPlayerCurrentTarget(oPC);
	string sDB; string sBio; string sPortrait; string sPortraitTGA;
	
	if (sAction == "preview")
	{
	sDB = GetSubString(GetPCPlayerName(oTarget), 0, 12) +
			"_" + GetSubString(GetFirstName(oTarget), 0, 6) +
			"_" + GetSubString(GetLastName(oTarget), 0, 9);
		sBio = GetCampaignString(sDB,"Bio");
		sPortrait = GetCampaignString(sDB,"Portrait");
			if (GetStringLength(sPortrait) < 2) sPortrait = "bg_60_alpha";
		
		if (FindSubString(sPortrait,"pack") > -1)
		{	sPortrait = GetPackPortrait(sPortrait);
			DisplayGuiScreen(oPC,"KEMO_BIO_DISPLAY",FALSE,"kemo_bio_display.xml");
			SetGUIObjectText(oPC,"KEMO_BIO_DISPLAY","INPUT_BIOTEXT",-1,sBio);
			SetGUITexture(oPC,"KEMO_BIO_DISPLAY","KEMO_PORTRAIT",sPortrait);
			DisplayGuiScreen(oPC,"KEMO_ERP",FALSE,"kemo_erp.xml");
			
		}
		else
		{	sPortrait = sPortrait + ".tga";
			DisplayGuiScreen(oPC,"KEMO_BIO_DISPLAY",FALSE,"kemo_bio_display.xml");
			SetGUIObjectText(oPC,"KEMO_BIO_DISPLAY","INPUT_BIOTEXT",-1,sBio);
			SetGUITexture(oPC,"KEMO_BIO_DISPLAY","KEMO_PORTRAIT",sPortrait);
			DisplayGuiScreen(oPC,"KEMO_ERP",FALSE,"kemo_erp.xml");
			
		}
		
		
		return;
	}
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
	}*/
}