#include "nwnx_sql"




// AES Key used for encrypting/decrypting
const string KEMO_BIO_AES = "PdSgVkYp3s5v8y/B?E(H+MbQeThWmZq4";
const string KEMO_BIO_DEFAULT_PORTRAIT = "bg_60_alpha";


// Localvars - used to track current/max portrait for packs for the prev/next buttons
const string KEMO_BIO_MAX_PORTRAIT = "KEMO_BIO_MAX_PORTRAIT";
const string KEMO_BIO_CURRENT_PORTRAIT = "KEMO_BIO_CURRENT_PORTRAIT";

// Kemo Bio View UI constants
// The xml file for the bio ui
const string KEMO_BIO_XML = "kemo_bio_display.xml";
// The name of the bio ui screen in the bio xml
const string KEMO_BIO_UI = "KEMO_BIO_DISPLAY";
// The name of the portrait element in the bio xml
const string KEMO_BIO_UI_PORTRAIT = "KEMO_PORTRAIT";
// The name of the biography element in the bio xml
const string KEMI_BIO_UI_BIOTEXT = "INPUT_BIOTEXT";
// The name of the prev/next buttons in the bio xml
const string KEMI_BIO_PREV_PORTRAIT_BUTTON = "PREV_PORTRAIT_BUTTON";
const string KEMI_BIO_NEXT_PORTRAIT_BUTTON = "NEXT_PORTRAIT_BUTTON";


// Kemo Bio Edit UI constants (some field names are shared with the viewer)
const string KEMO_BIO_EDIT_XML = "kemo_bio_edit.xml";
// The name of the bio edit ui screen
const string KEMO_BIO_EDIT_UI = "KEMO_BIO_EDIT";
// The name of the portrait input field in the bio edit xml
const string KEMO_BIO_EDIT_PORTRAIT = "PORTRAIT_INPUT_BOX";




string kemoBioGetBioID(object oPC)
{
    string name = SQLEncodeSpecialChars(GetName(oPC));
    string player = SQLEncodeSpecialChars(GetPCPlayerName(oPC));
    string sQuery = "SELECT `bioid` FROM `kemo_bios` where `name`='" + name + "' and `player`='" + player + "';";
    SQLExecDirect(sQuery);
    SQLFetch();

    string userid = SQLGetData(1);
    if(userid == "")
    {
        sQuery = "INSERT INTO `kemo_bios` (`name`, `player`, `portrait`) VALUES ('" + name + "', '" + player + "', 'bg_60_alpha');";
        SQLExecDirect(sQuery);

        sQuery = "SELECT `bioid` FROM `kemo_bios` where `name`='" + name + "' and `player`='" + player + "';";
        SQLExecDirect(sQuery); SQLFetch();

        userid = SQLGetData(1);
    }
    return userid;
}

// Portrait Pack related functions
// Gets the maximum portrait from a string with 'pack' in it
int kemoBioGetMaxPortrait(string sPortrait)
{
    return StringToInt(GetStringRight(sPortrait, 1));
}

// Gets the current portrait from a portrait string
int kemoBioGetCurrentPortrait(string sPortrait)
{
    return kemoBioGetMaxPortrait(sPortrait);
}

// returns the portrait number for a random portrait in a pack
int kemoBioGetRandomPortrait(string sPortrait)
{
    int iMax = kemoBioGetMaxPortrait(sPortrait);
    int iRand = 0;
    if(iMax > 0)
        iRand = Random(iMax + 1);
    return iRand;
}

// returns the portrait name for the specified portrait in the pack (without .tga)
string kemoBioGetPackPortrait(string sPortrait, int iPortraitNumber)
{
    // get sPortrait without the number at the end
    string sNewPortrait = GetStringLeft(sPortrait, GetStringLength(sPortrait) - 1) + IntToString(iPortraitNumber);
    return sNewPortrait;
}

// Sets the visibility of the Previous/Next buttons based on the provided values
// if iCurrentPortrait and iMaxPortraits are both 0 then both buttons will be hidden
void kemoBioUpdatePrevNextButtons(object oPC, int iCurrentPortrait=0, int iMaxPortraits=0)
{
    int iPrev = FALSE;
    int iNext = FALSE;

    if(iMaxPortraits > 0)
    { 
        if(iCurrentPortrait < iMaxPortraits)
            iNext = TRUE;
        if(iCurrentPortrait > 0)
            iPrev = TRUE;
    }
    SetGUIObjectHidden(oPC, KEMO_BIO_UI, KEMI_BIO_PREV_PORTRAIT_BUTTON, !iPrev);
    SetGUIObjectHidden(oPC, KEMO_BIO_UI, KEMI_BIO_NEXT_PORTRAIT_BUTTON, !iNext);
}

// Cycles through all the portraits in the pack & displays them on screen
// Called when editing & saving a portrait
/*void kemoBioCyclePortraits(object oPC, string sPortrait, float fDelay=1.0f)
{
    // if we get a portrait pack we want to cycle through them
    if(FindSubString(sPortrait, "pack") > -1)
    {
        int iMax = kemoBioGetMaxPortrait(sPortrait);
        int i;
        for(i=0; i <= iMax; i++)
        {
            // Get the next portrait in the sequence
            sPortrait = kemoBioGetPackPortrait(sPortrait, i);
            DelayCommand(fDelay * IntToFloat(i), kemoBioInitiatePortraitDownload(oPC, sPortrait));
        }
    }
    else
    {
        kemoBioInitiatePortraitDownload(oPC, sPortrait);
    }
}*/



// Displays the Kemo Biography for oTarget on oPC's screen
void kemoBioDisplayBio(object oPC, object oTarget, int bDisplayERP=FALSE)
{
    int iMaxPortrait = 0;
    int iCurrentPortrait = 0;

    SetGUITexture(oPC, KEMO_BIO_UI, KEMO_BIO_UI_PORTRAIT, KEMO_BIO_DEFAULT_PORTRAIT + ".tga");

    string sQuery = "SELECT AES_DECRYPT(biotext,'" + KEMO_BIO_AES + "'), portrait FROM kemo_bios WHERE bioid='" + kemoBioGetBioID(oTarget) + "';";
    SQLExecDirect(sQuery); 
    SQLFetch();
    string sBio = SQLGetData(1);
    string sPortrait = SQLGetData(2);

    if(GetStringLength(sPortrait) < 2)
        sPortrait = KEMO_BIO_DEFAULT_PORTRAIT;

    // filenames with "pack" in them are set up as series, 0-9
    // viewers will see one of the pack selected at random
    // editors specify the size of the pack by using the highest number in the
    // series: if x_pack_ has 5 pictures, type in x_pack_4 to set the range
    if(FindSubString(sPortrait, "pack") > -1)
    {
        iMaxPortrait = kemoBioGetMaxPortrait(sPortrait);
        iCurrentPortrait = kemoBioGetRandomPortrait(sPortrait);
        sPortrait = kemoBioGetPackPortrait(sPortrait, iCurrentPortrait);
    }
    // Used by Prev/Next buttons
    SetLocalInt(oPC, KEMO_BIO_MAX_PORTRAIT, iMaxPortrait);
    SetLocalString(oPC, KEMO_BIO_CURRENT_PORTRAIT, sPortrait);

    DisplayGuiScreen(oPC, KEMO_BIO_UI, FALSE, KEMO_BIO_XML);
    SetGUIObjectText(oPC, KEMO_BIO_UI, KEMI_BIO_UI_BIOTEXT, -1, sBio);
    kemoBioUpdatePrevNextButtons(oPC, iCurrentPortrait, iMaxPortrait);
    //kemoBioInitiatePortraitDownload(oPC, sPortrait);
    
}

// Displays the Kemo Biography Edit screen
void kemoBioEditBio(object oPC)
{
    SendMessageToPC(oPC, "Player Portraits are Available https://www.nwn2planescape.com/portrait_gallery.php");
   

    string sQuery = "SELECT AES_DECRYPT(biotext,'" + KEMO_BIO_AES + "'), portrait FROM kemo_bios WHERE bioid='" + kemoBioGetBioID(oPC) + "';";
    SQLExecDirect(sQuery); 
    SQLFetch();
    string sBio = SQLGetData(1);
    string sPortrait = SQLGetData(2);

    DisplayGuiScreen(oPC,KEMO_BIO_EDIT_UI, FALSE, KEMO_BIO_EDIT_XML);
    SetGUIObjectText(oPC,KEMO_BIO_EDIT_UI, KEMI_BIO_UI_BIOTEXT, -1, sBio);
    SetGUIObjectText(oPC,KEMO_BIO_EDIT_UI, KEMO_BIO_EDIT_PORTRAIT, -1, sPortrait);
    //kemoBioInitiatePortraitDownload(oPC, sPortrait);
}

// Saves the portrait to oPC's bio and updates the edit ui screen
void kemoBioSavePortrait(object oPC, string sPortrait)
{
    string sBioID = kemoBioGetBioID(oPC);
    string sQuery = "SELECT `portrait` FROM `kemo_bios` where `bioid`='" + sBioID + "';";
    SQLExecDirect(sQuery);
    SQLFetch();
    string sOldPortrait = SQLGetData(1);

    if(sPortrait == sOldPortrait) 
        return;

    if(GetStringLength(sPortrait) < 2) 
        sPortrait = KEMO_BIO_DEFAULT_PORTRAIT;

    sQuery = "UPDATE `kemo_bios` SET `portrait`='" + SQLEncodeSpecialChars(sPortrait) + "' where `bioid`='" + sBioID + "';";
    SQLExecDirect(sQuery);
   // kemoBioCyclePortraits(oPC, sPortrait);
}

// Saves the biography to oPC's bio
void kemoBioSaveBio(object oPC, string sBio)
{
    string sQuery = "UPDATE `kemo_bios` SET `biotext`=AES_ENCRYPT('" + SQLEncodeSpecialChars(sBio) + "','" + KEMO_BIO_AES + "') WHERE `bioid`='" + kemoBioGetBioID(oPC) + "';";
    SQLExecDirect(sQuery);
}

// Cycles to the next portrait in a portrait pack & updates the button states
void kemoBioNextPortrait(object oPC)
{
    // Get the portrait from the element
    string sPortrait = GetLocalString(oPC, KEMO_BIO_CURRENT_PORTRAIT);
    int iMaxPortrait = GetLocalInt(oPC, KEMO_BIO_MAX_PORTRAIT);
    int iCurrentPortrait = kemoBioGetCurrentPortrait(sPortrait);

    iCurrentPortrait++;
    if(iCurrentPortrait > iMaxPortrait)
        return;
    
    sPortrait = kemoBioGetPackPortrait(sPortrait, iCurrentPortrait);
    SetLocalString(oPC, KEMO_BIO_CURRENT_PORTRAIT, sPortrait);
    kemoBioUpdatePrevNextButtons(oPC, iCurrentPortrait, iMaxPortrait);
    //kemoBioInitiatePortraitDownload(oPC, sPortrait);
}

// Cycles to the previous portrait in a portrait pack & updates the button states
void kemoBioPrevPortrait(object oPC)
{
    // Get the portrait from the element
    string sPortrait = GetLocalString(oPC, KEMO_BIO_CURRENT_PORTRAIT);
    int iMaxPortrait = GetLocalInt(oPC, KEMO_BIO_MAX_PORTRAIT);
    int iCurrentPortrait = kemoBioGetCurrentPortrait(sPortrait);

    iCurrentPortrait--;
    if(iCurrentPortrait < 0)
        return;
    
    sPortrait = kemoBioGetPackPortrait(sPortrait, iCurrentPortrait);
    SetLocalString(oPC, KEMO_BIO_CURRENT_PORTRAIT, sPortrait);
    kemoBioUpdatePrevNextButtons(oPC, iCurrentPortrait, iMaxPortrait);
    //kemoBioInitiatePortraitDownload(oPC, sPortrait);
}


/*
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
	string sDB; string sBio; string sPortrait; string sPortraitTGA; string bioid; string targetid; string sQuery;
	
	if (sAction == "display")
	{
		bioid = GetBioPCID(oTarget);

		sQuery = "SELECT AES_DECRYPT(biotext,'" + KEMO_BIO_AES + "'), portrait FROM kemo_bios"+
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
