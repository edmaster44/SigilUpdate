

/******************************************************************************
*****                         	 nwnx_craft                               *****
*****                               V 1.0                                 *****
*****                             11/29/07                                *****
******************************************************************************/


// Name     : NWNX Crafter include
// Purpose  : Various functions for accessing the Crafter plugin
// Author   : Denis-Clinton Carter
// Modified : November 29, 2007

// This file is licensed under the terms of the
// GNU GENERAL PUBLIC LICENSE (GPL) Version 2

//Thanks : 	To Papillon for his wonderfull and couldn't-live-without NWNX4
//			To Obsidian for not having made a working CopyItemAndModify function
//			To everyone at Elechos pw for taking all my life time.
//			To Tyrnis, my co-worker on Elechos scripts
//			To Drakolight for pushing me to keep on the work aroud this project.
//			To the ones who laughed saying I was dumb to think these things were actually possible


//you are stongly invited to read the read me file joined with this system for it explains how things work and some vocabulary
//and don't forget to setup your xp_craft.ini with the proper values ! 

//11/29/07 added support for color mangement


///////////////////////////////////////////////////////////////////////////////
////////////////////////////// DECLARATIONS ///////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

/*****************************************************************************/
//Constants
const string XPCraft_DATABASE_PREFIX = "VDB_xp_craft";//set it to whatever you want

/*****************************************************************************/
//Bioware Database related functions

string XPCraft_GetPCID(object oPC);

//creates and return the name of the datafile for this PC
//actually using the playre's public CD Key as a sufix to the database filename
//if you're using any kind of PC ID (ie incremental sql unique IDs), feel free to rescript this
string XPCraft_GetDatafileName(object oPC);

//destroy the given database
void XPCraft_DestroyDataFile(object oPC, string sDatafileName="");

//store the given object into a Bioware database file
//returns TRUE or FALSE whether the operation was successful or not
int XPCraft_StoreItemToCraft(object oPC, object oItem, int bSafeStore = TRUE);

//Retrieve a PC's Item from the bioware database and spawn it on the ground at oPC's location
object XPCraft_RetrieveCraftedItem(object oPC, location lSpawnLocation);

//Retrieve a PC's Item from the bioware database and equip it.
object XPCraft_RetrieveAndEquipCraftedItem(object oPC, object oOldItem, int iSlotToEquip);


/*****************************************************************************/
//Color Management (conversion functions)

struct strTint
{
	int iRed;
	int iGreen;
	int iBlue;
	int iAlpha;
};

//returns an integer directly useable by the plugin
int XPCraft_RGBAToInt(int iRed, int iGreen, int iBlue, int iAlpha = 255);

//returns an integer directly useable by the plugin
int XPCraft_strTintToInt(struct strTint strMyTint);

//returns a strTint structure
// given an int (got with a XPCraft_GetColor call)
struct strTint XPCraft_IntToTintStruct(int iColorValue);

//returns a strTint structure
// given Hue, Lum and Sat (got with the color UI)
struct strTint XPCraft_HLSToTintStruct(int iHue, int iLum, int iSat);

//part of the conversion from HLS to RGB
float XPCraft_QqhToRgb(float q1, float q2, float Hue);

/*****************************************************************************/
//Debuggin function
void XPCraft_Debug(object oPC, string sStringToDebug);


/*****************************************************************************/
//Dated Fuctions Kept for compatibility

//function skeleton for getting single props
//such as variation/modifycost or whatever...
//be carefull for that kinda things may not be suitable to every items
int XPCraft_GetItemProperty(object oPC,object oItem, string sRoadMap);


//function skeleton for modifying single props
//such as variation/modifycost or whatever... 
//be carefull for that kinda things may not be suitable to every items
int XPCraft_SetItemProperty(object oPC,object oItem, string sRoadMap, int iNewValue);



/************************************/
/* Plugin management              */
/************************************/


//get the element index inthe datafile given it's roadmap
string XPCraft_GetIndex(string sRoadMap,string sDatafileName="");

//get the value of any element given it's road map or it's index 
string XPCraft_GetValue(string sRoadMap="", int iElementIndex = 0, string sDatafileName="");

//Sets a new value for an element given it's roadmap or index
void XPCraft_SetValue(string sNewValue, string sRoadMap="", int iElementIndex = 0, string sDatafileName="");

//Sets a new color value for an item given it's red roadmap or index
//the roadmap to the "red value" of a Tint is usually of the sheme "Tintable|Tint|1|r" for tint 1, "Tintable|Tint|2|r" for tint 2
//however tis path may vary under some circompstances (build-in equipements ie HasBoot, HasGloves etc...) 
void XPCraft_SetColor(string sNewColorValue, string sRedRoadMap="", int iRedIndex = 0, string sDatafileName="");

//get the Color of any item given it's red road map or it's index 
//the roadmap to the "red value" of a Tint is usually of the sheme "Tintable|Tint|1|r" for tint 1, "Tintable|Tint|2|r" for tint 2
//however tis path may vary under some circompstances (build-in equipements ie HasBoot, HasGloves etc...) 
string XPCraft_GetColor(string sRedRoadMap="", int iRedIndex = 0, string sDatafileName="");

//forces the plugin to read the datafile instead of keeping it into memory
//any script function should end up with a call to that function
//anyway, within a function, you may not use it after each call to the plugin, 
//thus enabling to do multiple operations without reloading the file into memory each time.
//(helps saving performances)
//be aware of one last thing about the clear memory :
//if you decide to do multiple things in one function without calls to a clearmemory, 
//the datafile will be changed but the value you'll get with a "get" won't have changed till you clear mem
void XPCraft_ClearMemory();

// Invokes the Sigil xp_craft emulator.
string InvokeCraftEmulator(string Function, string Param1, int Param2, string Value);

///////////////////////////////////////////////////////////////////////////////
////////////////////////////// IMPLEMENTATIONS ////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

/*****************************************************************************/
//Bioware Database related functions

//actually using the public CD KEy of the PC to name the database file
//if you're using any kind of PC ID (ie incremental sql unique IDs), feel free to rescript this
string XPCraft_GetPCID(object oPC)
{
	return GetPCPublicCDKey(oPC);
}

//creates and return the name of the datafile for this PC
string XPCraft_GetDatafileName(object oPC)
{
	return XPCraft_DATABASE_PREFIX + XPCraft_GetPCID(oPC);
}

//destroy the given database
//arguments may be a PC or a Datafile Name
void XPCraft_DestroyDataFile(object oPC, string sDatafileName="")
{
	if(sDatafileName=="")
	{
		sDatafileName= XPCraft_GetDatafileName(oPC);
	}
	InvokeCraftEmulator("DestroyDatabase", "", 0, "");
	DestroyCampaignDatabase(sDatafileName);
}

//store the given object into a Bioware database file
//returns TRUE or FALSE whether the operation was successful or not
int XPCraft_StoreItemToCraft(object oPC, object oItem, int bSafeStore = TRUE)
{
	int bStorageSuccess = FALSE;
	
	if((oPC!=OBJECT_INVALID) && (oItem != OBJECT_INVALID))
	{
		string sDataFileName = XPCraft_GetDatafileName(oPC);
		if(bSafeStore)
		{
			XPCraft_DestroyDataFile(oPC,sDataFileName); 
		}
		bStorageSuccess = StoreCampaignObject(sDataFileName,"NO_ACCOUNT_NEEDED",oItem);
	}
	
	if(!bStorageSuccess)
	{
		XPCraft_Debug(oPC,"Unable to store " + GetName(oItem) + " as a campaign object.");
	}
	return bStorageSuccess;
}


object XPCraft_RetrieveCraftedItem(object oPC, location lSpawnLocation)
{
	string sDatafileName = XPCraft_GetDatafileName(oPC);
	
	//retrieve item from the database
	object oCampaignObject = RetrieveCampaignObject(sDatafileName,"NO_ACCOUNT_NEEDED",lSpawnLocation);

	if(oCampaignObject==OBJECT_INVALID)
	{
		XPCraft_Debug(oPC,"Unable to retrieve object from database.");	
	}

	return oCampaignObject;
}

object XPCraft_RetrieveAndEquipCraftedItem(object oPC, object oOldItem, int iSlotToEquip)
{
	object oCraftedItem;
	object oInventoryItem;
	
	object oHiddenContainer = GetLocalObject(GetModule(),"XC_HIDDEN_CONTAINER");
	if(oHiddenContainer!= OBJECT_INVALID)
	{
		oCraftedItem =  XPCraft_RetrieveCraftedItem(oPC, GetLocation(oHiddenContainer));
	}
	else
	{
		oCraftedItem =  XPCraft_RetrieveCraftedItem(oPC, GetLocation(oPC));
	}

	if(oCraftedItem!=OBJECT_INVALID)
	{//we got our modified item back=> 
		
		//XPCraft_Debug(oPC,"Item Successfully Crafted.");
		
		//destroy the old one. 
		DestroyObject(oOldItem);
		
		//Crafted Item in On The Ground (or at spawnWaypoint) => copy the new one in oPC's inventory
		oInventoryItem = CopyItem(oCraftedItem,oPC,TRUE);
		//Equip the copied Item
		AssignCommand(oPC,ActionEquipItem(oInventoryItem, iSlotToEquip));
		//cryptc: set the TSO on the new copy to make it still craftable
		SetLocalString(oInventoryItem,"TSO",GetLocalString(oPC,"TSO"));
		
		//destroy the one on the ground		
		DestroyObject(oCraftedItem);		

	}

	//cryptc: tried moving cleanup here.
	XPCraft_ClearMemory();
	
	return oInventoryItem;
}


/*******************************************************************************/
//Color management

int XPCraft_RGBAToInt(int iRed, int iGreen, int iBlue, int iAlpha = 255)
{//if outside boudaries values are given as parameters, they will be truncated.
// if you don't want that to happen, just call the function with proper arguments

//the quickest way to ensure that the value will be between 0 and 255 is to truncate to the 8 first bits
// using a "& 255"
//the operator << is used to move the bits to the left 
	return ((iRed & 255)<<24) + ((iGreen & 255)<<16) + ((iBlue & 255)<<8) + (iAlpha & 255);
}

int XPCraft_strTintToInt(struct strTint strMyTint)
{
	return XPCraft_RGBAToInt(strMyTint.iRed,strMyTint.iGreen,strMyTint.iBlue,strMyTint.iAlpha);
}

struct strTint XPCraft_IntToTintStruct(int iColorValue)
{
	struct strTint strMyTint;
	
	strMyTint.iRed = (iColorValue>>>24) & 255;
	strMyTint.iGreen = (iColorValue>>>16) & 255;
	strMyTint.iBlue = (iColorValue>>>8) & 255;
	strMyTint.iAlpha = iColorValue & 255;
	
	return strMyTint;
}

//Hue is between 0 and 360, lum and sat are between 0 and 100.
struct strTint XPCraft_HLSToTintStruct(int iHue, int iLum, int iSat)
{
	struct strTint strMyTint;
	
	float fT,fL,fS;
	fT = IntToFloat(iHue);
	fL = iLum / 100.0;
	fS = iSat / 100.0;
	
	float fRR,fG,fB, fq1,fq2;
	
	if(fL <= 0.5) fq2 = fL * (1.0 + fS);
	else 		 fq2 = fL + fS - (fL * fS);
	
	fq1 = (2 * fL) - fq2;
	
	if(fS == 0.0)
	{
		fRR = fL;
		fG = fL;
		fB = fL;
	}
	else
	{
		fRR = XPCraft_QqhToRgb(fq1,fq2,fT+120.0);
		fG = XPCraft_QqhToRgb(fq1,fq2,fT);
		fB = XPCraft_QqhToRgb(fq1,fq2,fT-120.0);
	}

	strMyTint.iRed = FloatToInt(fRR*255.0);
	strMyTint.iGreen = FloatToInt(fG*255.0);
	strMyTint.iBlue = FloatToInt(fB*255.0);
	strMyTint.iAlpha = 255;
	
	return strMyTint;
}

float XPCraft_QqhToRgb(float q1, float q2, float Hue)//Hue = T
{
	if(Hue > 360.0) 		Hue -= 360.0;
	else if(Hue < 0.0) 		Hue += 360.0;
	
	if(Hue <  60.0) 		return (q1 + ((q2 - q1) * (Hue/60.0)));
	else if(Hue < 180.0) 	return (q2);
	else if(Hue < 240.0)	return (q1 + ((q2 - q1) * ((240-Hue)/60.0)));
	else 					return (q1);
}

/*****************************************************************************/
//Debuggin functions

void XPCraft_Debug(object oPC, string sStringToDebug)
{
	WriteTimestampedLogEntry(GetName(oPC) + " : " + sStringToDebug);
	SendMessageToPC(oPC,"XPCraft : <color=steelblue>" + sStringToDebug + "</color>");
}


/*****************************************************************************/
//Dated Fuctions Kept for compatibility

//function skeleton for getting single props
//such as variation/modifycost/modelpart or whatever...
//be carefull for that kinda things may not be suitable to every items

int XPCraft_GetItemProperty(object oPC,object oItem, string sRoadMap)
{
	//checks
	if (oItem==OBJECT_INVALID)
	{
		SendMessageToPC(oPC,"Invalid Target.");
		return -1;
	}
	//check oItem is actually an item and not a creature, or any other kinda object
	if(GetItemPossessor(oItem)!=oPC)
	{
		SendMessageToPC(oPC,"Target must be one of your own items.");
		return -1;	
	}
	
	//send the item in the database
	string sDatafileName = XPCraft_GetDatafileName(oPC);
	
	int bStorageSuccess = StoreCampaignObject(sDatafileName,"NO_ACCOUNT_NEEDED",oItem);
	if(!bStorageSuccess)
	{
		SendMessageToPC(oPC,"Unable to store campaign object.");
		return -1;
	}
	
	//call craft plugin
	//return value is casted in an int to show that the plugin only deals with numéric values for the moment
	int iPropValue = StringToInt(XPCraft_GetValue( sRoadMap, 0, sDatafileName));
	
	
	//destruction of the database
	DestroyCampaignDatabase(sDatafileName);
	
	//you must always end your functions with this ClearMemory()!
	//if you don't, your next call to a get or  a set function wil occur on the file loaded into memory
	//and not on the one you want. 
	XPCraft_ClearMemory();
	return iPropValue;
}



//function skeleton for modifying single props
//such as variation/modifycost/modelparts or whatever... 
//be carefull for that kinda things may not be suitable to every items

int XPCraft_SetItemProperty(object oPC,object oItem, string sRoadMap, int iNewValue)
{
	
	int bCraftSuccess = FALSE;

	//all kind of checks
	if (oItem==OBJECT_INVALID)
	{
		SendMessageToPC(oPC,"Invalid Target.");
		return bCraftSuccess;
	}
	//check oItem is actually an item and not a creature, or any other kinda object
	if(GetItemPossessor(oItem)!=oPC)
	{
		SendMessageToPC(oPC,"Target must be one of your own items.");
		return bCraftSuccess;	
	}
	
	//send the item in the database
	string sDatafileName = XPCraft_GetDatafileName(oPC);
	
	int bStorageSuccess = StoreCampaignObject(sDatafileName,"NO_ACCOUNT_NEEDED",oItem);
	if(!bStorageSuccess)
	{
		SendMessageToPC(oPC,"Unable to store campaign object.");
		return bCraftSuccess;
	}
	
	//call craft plugin
	XPCraft_SetValue(IntToString(iNewValue), sRoadMap, 0, sDatafileName);	

	//retrieve item from the database
	//seems that a retrieve campaign object just can't pop the object into a PC's inventory
	//so spawn it on the ground and then copy it into the inventrory
	object oCampaignObject = RetrieveCampaignObject(sDatafileName,"NO_ACCOUNT_NEEDED",GetLocation(oPC));
	if(oCampaignObject==OBJECT_INVALID)
	{
		SendMessageToPC(oPC,"Unable to retrieve object from database.");	
	}
	else
	{//we got our modified item back=> destroy the old one.
		 
		DestroyObject(oItem);
		//copy the new one in oPC's inventory
		CopyItem(oCampaignObject,oPC,TRUE);		
		DestroyObject(oCampaignObject);
		
		bCraftSuccess=TRUE;
	}
	
	//destruction of the database
	DestroyCampaignDatabase(sDatafileName);
	
	//you must always end your functions with this ClearMemory()!
	//if you don't, your next call to a get or  a set function wil occur on the file loaded into memory
	//and not on the one you want. 
	XPCraft_ClearMemory();
	
	return bCraftSuccess;	
}

/************************************/
/* Plugin management                */
/************************************/


string XPCraft_GetIndex(string sRoadMap,string sDatafileName="")
{
	return InvokeCraftEmulator("GetIndex|"+ sDatafileName, sRoadMap,0, "");
//	return NWNXGetString("CRAFTER", "GetIndex|"+ sDatafileName, sRoadMap,0);
} 

string XPCraft_GetValue(string sRoadMap="", int iElementIndex = 0, string sDatafileName="")
{
	return InvokeCraftEmulator("GetValue|"+ sDatafileName, sRoadMap, iElementIndex, "");
//	return NWNXGetString("CRAFTER", "GetValue|"+ sDatafileName, sRoadMap, iElementIndex);
}

void XPCraft_SetValue(string sNewValue, string sRoadMap="", int iElementIndex = 0, string sDatafileName="")
{
	InvokeCraftEmulator("SetValue|"+ sDatafileName, sRoadMap, iElementIndex, sNewValue);
//	NWNXSetString("CRAFTER", "SetValue|"+ sDatafileName, sRoadMap, iElementIndex, sNewValue);
}

void XPCraft_SetColor(string sNewColorValue, string sRedRoadMap="", int iRedIndex = 0, string sDatafileName="")
{
	InvokeCraftEmulator("SetColor|"+ sDatafileName, sRedRoadMap, iRedIndex, sNewColorValue);
//	NWNXSetString("CRAFTER", "SetColor|"+ sDatafileName, sRedRoadMap, iRedIndex, sNewColorValue);
}

string XPCraft_GetColor(string sRedRoadMap="", int iRedIndex = 0, string sDatafileName="")
{
	return InvokeCraftEmulator("GetColor|"+ sDatafileName, sRedRoadMap, iRedIndex, "");
//	return NWNXGetString("CRAFTER", "GetColor|"+ sDatafileName, sRedRoadMap, iRedIndex);
}
void XPCraft_ClearMemory()
{
//	NWNXSetString("CRAFTER","CLEAR_MEMORY","",0,"");
}

string InvokeCraftEmulator(string Function, string Param1, int Param2, string Value)
{
	object Module = GetModule();
	string ReturnValue;

	//
	// Clear script parameters to ensure proper nesting, add script parameters and
	// invoke the craft emulator, retrieve the return value and clear the return
	// value temporary variable.
	//

	ClearScriptParams();
	AddScriptParameterString(Function);
	AddScriptParameterString(Param1);
	AddScriptParameterInt(Param2);
	AddScriptParameterString(Value);
	ExecuteScriptEnhanced("Sigil.CraftEmulator", Module, TRUE);

	ReturnValue = GetLocalString(Module, "CRAFT_EMULATOR_RET");
	DeleteLocalString(Module, "CRAFT_EMULATOR_RET");

	return ReturnValue;
}

 //Timestamp
string TimeStamp()
{
	int iMillisecond = GetTimeMillisecond();
	int iSecond  = GetTimeSecond();
	int iMinute  = GetTimeMinute();
	int iHour    = GetTimeHour();
	int iDay     = GetCalendarDay();
	int iMonth   = GetCalendarMonth();
	int iYear    = GetCalendarYear();
    
	return IntToString(iMillisecond) + IntToString(iSecond) + IntToString(iMinute) + IntToString(iHour) + IntToString(iDay) + IntToString(iMonth) + IntToString(iYear);
}