// by FlattedFifth, Jan 26, 2025
#include "ginc_vars"
#include "ginc_math"

const int SCRUB_NAMES = FALSE;
const int USE_LOCAL_ON_MOD_FOR_GLOBAL = FALSE;
const int MIN_VAR_LENGTH = 1;

/************************************************************************
				PROTOTYPES
*************************************************************************/

// Scrub the var names of all characters that are not alphanumeric or underscores
// and make sure variable names are of legal length.
// ARGS:
// oObject: If you send a pc or dm, it will scrub the essence, otherwise object itself
// bForceOnObject: If TRUE will scrub a PC or DM instead of their essence
// nIteration: Do not set this. This is a safeguard against infinite recursion
void FF_ScrubVars(object oObject, int bForceOnObject = FALSE, int nIteration = 0);

// The rest of these are wrappers for getters and setters that will scrub variable names before
// getting or setting. The wrappers for global set and get as local on module instead.

// local
int PS_GetLocalInt(object oObject, string sVarName);
int PS_GetLocalIntState(object oObject, string sVarName, int iBitFlags);
float PS_GetLocalFloat(object oObject, string sVarName);
string PS_GetLocalString(object oObject, string sVarName);
object PS_GetLocalObject(object oObject, string sVarName);
location PS_GetLocalLocation(object oObject, string sVarName);
int PS_ModifyLocalInt(object oObject, string sVarName, int iDelta);
void PS_ModifyLocalIntOnFaction(object oPC, string sVarName, int iDelta, int bPCOnly=TRUE);
void PS_SetLocalInt(object oObject, string sVarName, int nValue);
void PS_SetLocalIntState(object oObject, string sVarName, int iBitFlags, int bSet = TRUE);
void PS_SetLocalFloat(object oObject, string sVarName, float fValue);
void PS_SetLocalString(object oObject, string sVarName, string sValue);
void PS_SetLocalObject(object oObject, string sVarName, object oValue);
void PS_SetLocalLocation(object oObject, string sVarName, location lValue);
void PS_DeleteLocalInt(object oObject, string sVarName);
void PS_DeleteLocalFloat(object oObject, string sVarName);
void PS_DeleteLocalString(object oObject, string sVarName);
void PS_DeleteLocalObject(object oObject, string sVarName);
void PS_DeleteLocalLocation(object oObject, string sVarName);

// global, as local on module
int PS_GetGlobalInt(string sVarName);
float PS_GetGlobalIntAsFloat(string sVarName);
int PS_GetGlobalBool(string sVarName);
string PS_GetGlobalString(string sVarName);
float PS_GetGlobalFloat(string sVarName);
location PS_GetGlobalLocation(string sVarName);
object PS_GetGlobalObject(string sVarName);
int PS_GetGlobalArrayInt(string sVarName, int nVarNum);
string PS_GetGlobalArrayString(string sVarName, int nVarNum);
int PS_ModifyGlobalInt(string sVarName, int iDelta);
int PS_SetGlobalInt(string sVarName, int nValue);
int PS_SetGlobalBool(string sVarName, int bValue);
int PS_SetGlobalString(string sVarName, string sValue);
int PS_SetGlobalFloat(string sVarName, float fValue);
int PS_SetGlobalObject(string sVarName, object oObj);
int PS_SetGlobalLocation(string sVarName, location lValue);
void PS_SetGlobalArrayInt(string sVarName, int nVarNum, int nValue);
void PS_SetGlobalArrayString(string sVarName, int nVarNum, string nValue);
void PS_DeleteGlobalInt(string sVarName);
void PS_DeleteGlobalBool(string sVarName);
void PS_DeleteGlobalFloat(string sVarName);
void PS_DeleteGlobalString(string sVarName);
void PS_DeleteGlobalLocation(string sVarName);
void PS_DeleteGlobalObject(string sVarName);

// these four are wrappers for helpers to the functions above that were
// originally in ginc_vars.nss in the base game
string PS_GetDoneFlag(int iFlag=0);
int PS_IsMarkedAsDone(object oObject=OBJECT_SELF, int iFlag=0);
void PS_MarkAsDone(object oObject=OBJECT_SELF, int iFlag=0);
void PS_MarkAsUndone(object oObject=OBJECT_SELF, int iFlag=0);

// these four are helper functions for all of the above. 
string FF_ScrubVarName(string sString);
string FF_GetStringFingerprint(string sString);
int FF_GetAsciiValue(string sChar);
string FF_ValidChars(string sString);


/************************************************************************
					IMPLEMENTATIONS
*************************************************************************/


void FF_ScrubVars(object oObject, int bForceOnObject = FALSE, int nIteration = 0){
	if (!SCRUB_NAMES) return;
	object oHolder; 
	if (bForceOnObject) oHolder = oObject;
	else if (GetIsPC(oObject) || GetIsDM(oObject)) oHolder = GetItemPossessedBy(oObject, "ps_essence");
	else oHolder = oObject;
	
	if (!GetIsObjectValid(oHolder)) return;
	
	int nNumVars = GetVariableCount(oHolder);
	int i;
	string sVarName;
	string sLegalName;
	int nVarType;
	int nValue;
	float fValue;
	string sValue;
	location lValue;
	object oValue;
	
	for (i = 0; i < nNumVars; i++){
		sVarName = GetVariableName(oHolder, i);
		sLegalName = FF_ScrubVarName(sVarName);
		if (sVarName != sLegalName){
			nVarType = GetVariableType(oHolder, i);
			switch (nVarType){
				case VARIABLE_TYPE_INT:{
					nValue = PS_GetLocalInt(oHolder, sVarName);
					DeleteLocalInt(oHolder, sVarName);
					SetLocalInt(oHolder, sLegalName, nValue);
					break;	
				}
				case VARIABLE_TYPE_FLOAT:{
					fValue = PS_GetLocalFloat(oHolder, sVarName);
					DeleteLocalFloat(oHolder, sVarName);
					SetLocalFloat(oHolder, sLegalName, fValue);

					break;	
				}
				case VARIABLE_TYPE_STRING:{
					sValue = PS_GetLocalString(oHolder, sVarName);
					DeleteLocalString(oHolder, sVarName);
					SetLocalString(oHolder, sLegalName, sValue);
					break;
				}
				case VARIABLE_TYPE_LOCATION:{
					lValue = PS_GetLocalLocation(oHolder, sVarName);
					DeleteLocalLocation(oHolder, sVarName);
					SetLocalLocation(oHolder, sLegalName, lValue);
					break;
				}
				default:{
					oValue = PS_GetLocalObject(oHolder, sVarName);
					if (GetIsObjectValid(oValue)){
						DeleteLocalObject(oHolder, sVarName);
						SetLocalObject(oHolder, sLegalName, oValue);
					}
					break;
				}
			}
			// recurse because the vars have changed, but only if we haven't already
			// recursed more than 3k times.
			if (nIteration <= 3000){
				FF_ScrubVars(oObject, bForceOnObject, nIteration + 1);
				break;
			}
		}
	}
}

int PS_GetLocalInt(object oObject, string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	return GetLocalInt(oObject, sVarName);
}

// sets the bit flags on or off in the local int
void PS_SetLocalIntState(object oObject, string sVarName, int iBitFlags, int bSet = TRUE){
	sVarName = FF_ScrubVarName(sVarName);
	int iValue = GetLocalInt(oObject, sVarName);
	int iNewValue = SetState(iValue, iBitFlags, bSet);
	SetLocalInt(oObject, sVarName, iNewValue);
}

// returns TRUE or FALSE 
// if multiple flags, will return true if any of iBitFlags are true.
int PS_GetLocalIntState(object oObject, string sVarName, int iBitFlags){
	sVarName = FF_ScrubVarName(sVarName);
	int iValue = GetLocalInt(oObject, sVarName);
	return (GetState(iValue, iBitFlags));
}

float PS_GetLocalFloat(object oObject, string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	return GetLocalFloat(oObject, sVarName);
}

string PS_GetLocalString(object oObject, string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	return GetLocalString(oObject, sVarName);
}

object PS_GetLocalObject(object oObject, string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	return GetLocalObject(oObject, sVarName);
}

location PS_GetLocalLocation(object oObject, string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	return GetLocalLocation(oObject, sVarName);
}

void PS_SetLocalInt(object oObject, string sVarName, int nValue){
	sVarName = FF_ScrubVarName(sVarName);
	SetLocalInt(oObject, sVarName, nValue);
}

void PS_SetLocalFloat(object oObject, string sVarName, float fValue){
	sVarName = FF_ScrubVarName(sVarName);
	SetLocalFloat(oObject, sVarName, fValue);
}

void PS_SetLocalString(object oObject, string sVarName, string sValue){
	sVarName = FF_ScrubVarName(sVarName);
	SetLocalString(oObject, sVarName, sValue);
}

void PS_SetLocalObject(object oObject, string sVarName, object oValue){
	sVarName = FF_ScrubVarName(sVarName);
	SetLocalObject(oObject, sVarName, oValue);
}

void PS_SetLocalLocation(object oObject, string sVarName, location lValue){
	sVarName = FF_ScrubVarName(sVarName);
	SetLocalLocation(oObject, sVarName, lValue);
}

int PS_SetGlobalInt(string sVarName, int nValue){
	sVarName = FF_ScrubVarName(sVarName);
	if (USE_LOCAL_ON_MOD_FOR_GLOBAL){
		object oMod = GetModule();
		SetLocalInt(oMod, sVarName, nValue);
		if (GetLocalInt(oMod, sVarName) == nValue) return TRUE;
		return FALSE;
	} else {
		SetGlobalInt(sVarName, nValue);
		if (GetGlobalInt(sVarName) == nValue) return TRUE;
		return FALSE;	
	}
	return FALSE;
}

int PS_SetGlobalBool(string sVarName, int bValue){
	sVarName = FF_ScrubVarName(sVarName);
	if (USE_LOCAL_ON_MOD_FOR_GLOBAL){
		object oMod = GetModule();
		SetLocalInt(oMod, sVarName, bValue);
		if (GetLocalInt(oMod, sVarName) == bValue) return TRUE;
		return FALSE;
	} else {
		SetGlobalBool(sVarName, bValue);
		if (GetGlobalBool(sVarName) == bValue) return TRUE;
		return FALSE;
	}
	return FALSE;
}

int PS_SetGlobalString(string sVarName, string sValue){
	sVarName = FF_ScrubVarName(sVarName);
	if (USE_LOCAL_ON_MOD_FOR_GLOBAL){
		object oMod = GetModule();
		SetLocalString(oMod, sVarName, sValue);
		if (GetLocalString(oMod, sVarName) == sValue) return TRUE;
		return FALSE;
	} else {
		SetGlobalString(sVarName, sValue);
		if (GetGlobalString(sVarName) == sValue) return TRUE;
		return FALSE;
	}
	return FALSE;
}

int PS_SetGlobalFloat(string sVarName, float fValue){
	sVarName = FF_ScrubVarName(sVarName);
	if (USE_LOCAL_ON_MOD_FOR_GLOBAL){
		object oMod = GetModule();
		SetLocalFloat(oMod, sVarName, fValue);
		if (GetLocalFloat(oMod, sVarName) == fValue) return TRUE;
		return FALSE;
	} else {
		SetGlobalFloat(sVarName, fValue);
		if (GetGlobalFloat(sVarName) == fValue) return TRUE;
		return FALSE;
	}
	return FALSE;
}

int PS_GetGlobalInt(string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	if (USE_LOCAL_ON_MOD_FOR_GLOBAL)
		return GetLocalInt(GetModule(), sVarName);
	else return GetGlobalInt(sVarName);
}

int PS_GetGlobalBool(string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	if (USE_LOCAL_ON_MOD_FOR_GLOBAL)
		return GetLocalInt(GetModule(), sVarName);
	else return GetGlobalBool(sVarName);
}

string PS_GetGlobalString(string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	if (USE_LOCAL_ON_MOD_FOR_GLOBAL)
		return GetLocalString(GetModule(), sVarName);
	else return GetGlobalString(sVarName);
}

float PS_GetGlobalFloat(string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	if (USE_LOCAL_ON_MOD_FOR_GLOBAL)
		return GetLocalFloat(GetModule(), sVarName);
	else return GetGlobalFloat(sVarName);
}

void PS_DeleteLocalInt(object oObject, string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	DeleteLocalInt(oObject, sVarName);
}

void PS_DeleteLocalFloat(object oObject, string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	DeleteLocalFloat(oObject, sVarName);
}

void PS_DeleteLocalString(object oObject, string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	DeleteLocalString(oObject, sVarName);
}

void PS_DeleteLocalObject(object oObject, string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	DeleteLocalObject(oObject, sVarName);
}

void PS_DeleteLocalLocation(object oObject, string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	DeleteLocalLocation(oObject, sVarName);
}

// there is no standard nwscript function for saving global locations,
// so this is a little odd
int PS_SetGlobalLocation(string sVarName, location lValue){
	sVarName = FF_ScrubVarName(sVarName);
	if (USE_LOCAL_ON_MOD_FOR_GLOBAL){
		object oMod = GetModule();
		SetLocalLocation(oMod, sVarName, lValue);
		if (GetLocalLocation(oMod, sVarName) == lValue) return TRUE;
		return FALSE;
	} else {
		object oArea = GetAreaFromLocation(lValue);
		vector vPos = GetPositionFromLocation(lValue);
		float fFace = GetFacingFromLocation(lValue);
		SetGlobalFloat(sVarName + "x", vPos.x);
		SetGlobalFloat(sVarName + "y", vPos.y);
		SetGlobalFloat(sVarName + "z", vPos.z);
		SetGlobalFloat(sVarName + "f", fFace);
		SetGlobalString(sVarName + "a", GetTag(oArea));
		return TRUE;
	}
	return FALSE;
}

location PS_GetGlobalLocation(string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	if (USE_LOCAL_ON_MOD_FOR_GLOBAL)
		return GetLocalLocation(GetModule(), sVarName);
	else {
		float x = GetGlobalFloat(sVarName + "x");
		float y = GetGlobalFloat(sVarName + "y");
		float z = GetGlobalFloat(sVarName + "z");
		float fFace = GetGlobalFloat(sVarName + "f");
		object oArea = GetObjectByTag(GetGlobalString(sVarName + "a"));
		return Location(oArea,Vector(x,y,z),fFace);
	}
	
}

float PS_GetGlobalIntAsFloat(string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	if (USE_LOCAL_ON_MOD_FOR_GLOBAL)
		return (IntToFloat(GetLocalInt(GetModule(), sVarName)));
	else return (IntToFloat(GetGlobalInt(sVarName)));
}

int PS_ModifyGlobalInt(string sVarName, int iDelta){
	sVarName = FF_ScrubVarName(sVarName);
	int iNewVal;
	if (USE_LOCAL_ON_MOD_FOR_GLOBAL){
		object oMod = GetModule();
		iNewVal = GetLocalInt(oMod, sVarName) + iDelta;
		SetLocalInt(oMod, sVarName, iNewVal);
	} else {
		iNewVal = GetGlobalInt(sVarName) + iDelta;
		SetGlobalInt(sVarName, iNewVal);
	}
	return iNewVal;
}

int PS_ModifyLocalInt(object oObject, string sVarName, int iDelta){
	sVarName = FF_ScrubVarName(sVarName);
	int iNewVal = GetLocalInt(oObject, sVarName) + iDelta;
	SetLocalInt(oObject, sVarName, iNewVal);
	return iNewVal;
}

void PS_ModifyLocalIntOnFaction(object oPC, string sVarName, int iDelta, int bPCOnly=TRUE){
    object oPartyMem = GetFirstFactionMember(oPC, bPCOnly);
    while (GetIsObjectValid(oPartyMem)) {
		PS_ModifyLocalInt(oPartyMem, sVarName, iDelta);
        oPartyMem = GetNextFactionMember(oPC, bPCOnly);
    }
}		

// there is no global object setter or getter in nwscript, so the following
// three have to be on module regardless of constant settings at top of this file
object PS_GetGlobalObject(string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	return GetLocalObject(GetModule(), sVarName);
}

int PS_SetGlobalObject(string sVarName, object oObj){
	sVarName = FF_ScrubVarName(sVarName);
	object oMod = GetModule();
	SetLocalObject(oMod, sVarName, oObj);
	if (GetLocalObject(oMod, sVarName) == oObj) return TRUE;
	return FALSE;
}

void PS_DeleteGlobalObject(string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	DeleteLocalObject(GetModule(), sVarName);
}

// nwscript does not, for some reason, contain any method of deleting 
// global variables, so if we're not using locals on module instead
// we just set these to 0, "", 0.0f, etc.
void PS_DeleteGlobalInt(string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	if (USE_LOCAL_ON_MOD_FOR_GLOBAL)
		DeleteLocalInt(GetModule(), sVarName);
	else SetGlobalInt(sVarName, 0);
}

void PS_DeleteGlobalBool(string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	if (USE_LOCAL_ON_MOD_FOR_GLOBAL)
		DeleteLocalInt(GetModule(), sVarName);
	else SetGlobalBool(sVarName, FALSE);
}

void PS_DeleteGlobalFloat(string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	if (USE_LOCAL_ON_MOD_FOR_GLOBAL)
		DeleteLocalFloat(GetModule(), sVarName);
	else SetGlobalFloat(sVarName, 0.0f);
}

void PS_DeleteGlobalString(string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	if (USE_LOCAL_ON_MOD_FOR_GLOBAL)
		DeleteLocalString(GetModule(), sVarName);
	else SetGlobalString(sVarName, "");
}

void PS_DeleteGlobalLocation(string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	if (USE_LOCAL_ON_MOD_FOR_GLOBAL)
		DeleteLocalLocation(GetModule(), sVarName);
	else {
		SetGlobalFloat(sVarName + "x", 0.0f);
		SetGlobalFloat(sVarName + "y", 0.0f);
		SetGlobalFloat(sVarName + "z", 0.0f);
		SetGlobalFloat(sVarName + "f", 0.0f);
		SetGlobalString(sVarName + "a", "");
	}
}

void PS_MarkAsUndone(object oObject=OBJECT_SELF, int iFlag=0){
	DoneFlagSanityCheck(oObject);
	PS_SetLocalInt(oObject, PS_GetDoneFlag(iFlag), FALSE);
}

string PS_GetGlobalArrayString(string sVarName, int nVarNum){
	sVarName = FF_ScrubVarName(sVarName);
    string sFullVarName = sVarName + IntToString(nVarNum) ;
	if (USE_LOCAL_ON_MOD_FOR_GLOBAL)
		return GetLocalString(GetModule(), sFullVarName);
	else return GetGlobalString(sFullVarName);
}

void PS_SetGlobalArrayString(string sVarName, int nVarNum, string nValue){
	sVarName = FF_ScrubVarName(sVarName);
    string sFullVarName = sVarName + IntToString(nVarNum);
	if (USE_LOCAL_ON_MOD_FOR_GLOBAL)
		SetLocalString(GetModule(), sFullVarName, nValue);
	else SetGlobalString(sFullVarName, nValue);
}

int PS_GetGlobalArrayInt(string sVarName, int nVarNum){
	sVarName = FF_ScrubVarName(sVarName);
    string sFullVarName = sVarName + IntToString(nVarNum);
	if (USE_LOCAL_ON_MOD_FOR_GLOBAL)
		return GetLocalInt(GetModule(), sFullVarName);
	else return GetGlobalInt(sFullVarName);
}

void PS_SetGlobalArrayInt(string sVarName, int nVarNum, int nValue){
	sVarName = FF_ScrubVarName(sVarName);
    string sFullVarName = sVarName + IntToString(nVarNum);
	if (USE_LOCAL_ON_MOD_FOR_GLOBAL)
		SetLocalInt(GetModule(), sFullVarName, nValue);
	else SetGlobalInt(sFullVarName, nValue);
}

string PS_GetDoneFlag(int iFlag=0){
	return FF_ScrubVarName(DONE_ONCE + (iFlag==0?"":IntToString(iFlag)));
}

int PS_IsMarkedAsDone(object oObject=OBJECT_SELF, int iFlag=0){
	DoneFlagSanityCheck(oObject);
    int iDoneOnce = PS_GetLocalInt(oObject, PS_GetDoneFlag(iFlag));
	return (iDoneOnce);
}

void PS_MarkAsDone(object oObject=OBJECT_SELF, int iFlag=0){
	DoneFlagSanityCheck(oObject);
	PS_SetLocalInt(oObject, PS_GetDoneFlag(iFlag), TRUE);
}

string FF_ScrubVarName(string sString){
	if (!SCRUB_NAMES) return sString;
	string sScrubbedString = FF_ValidChars(sString);
	int nLength = GetStringLength(sScrubbedString);
	
	// if removing the invalid characers results in a string that is too short
	// or too long then get "fingerpint" from the original string
	// consisting of it's length and a hex value based on the ascii values
	if (nLength < MIN_VAR_LENGTH || nLength > 32) 
		return FF_GetStringFingerprint(sString);
	
	return sScrubbedString;
}

string FF_GetStringFingerprint(string sString){

    int nLength = GetStringLength(sString);
    int nHash = nLength;
	if (nHash < 1) nHash = 1;
	if (nLength > 0){
		int i;
		string sChar;
		int nAscii;
		for (i = 0; i < nLength; i++){
			sChar = GetSubString(sString, i, 1);
			nAscii = FF_GetAsciiValue(sChar);
			nHash = (nHash * 33) + nAscii;
		}
	}
    // return "FP" + the length of the original string and
	// the resulting ascii value "fingerprint" 
	// integer as a hex string
    return "FP" + IntToString(nLength) + IntToHexString(nHash);
   
}

int FF_GetAsciiValue(string sChar){

	if (sChar == " ") return 32;
	else if (sChar == "!") return 33;
	
    string sAsciiChars = "#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
    int nIndex = FindSubString(sAsciiChars, sChar);
    
    if (nIndex != -1) return nIndex + 35; // ascii starts at 32 for space and we're skipping up to ", which is 3rd
    else return 34; // Return 34 for ", I shouldnt think it possible that we would have any non-ascii characers
}

string FF_ValidChars(string sString){
	string sValidChars = "abcdefghijklmnopqrstuvwxyz";
	sValidChars += "ABCDEGHIJKLMNOPQRSTUVWXYZ";
	sValidChars += "_1234567890";
	string sScrubbedString = "";
	int nLength = GetStringLength(sString);
	int i;
	string sChar;
	// remove characters that are not alphanumeric or underscores
	for (i = 0; i < nLength; i++){
		sChar = GetSubString(sString, i, 1);
		if (FindSubString(sValidChars, sChar) != -1)
			sScrubbedString += sChar;
	}
	return sScrubbedString;
}

