
// by FlattedFifth, Jan 26, 2025

#include "ginc_vars"
#include "ginc_math"


const int MIN_VAR_LENGTH = 6;

/************************************************************************
				PROTOTYPES
*************************************************************************/

// Scrub the var names of all characters that are not alphanumeric
// and make sure variable names are of legal length. Also stripping underscores
// because the game engine does that already, so if we do also we know if length
// is legal.
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
	return PS_GetLocalInt(oObject, sVarName);
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
	return PS_GetLocalFloat(oObject, sVarName);
}

string PS_GetLocalString(object oObject, string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	return PS_GetLocalString(oObject, sVarName);
}

object PS_GetLocalObject(object oObject, string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	return PS_GetLocalObject(oObject, sVarName);
}

location PS_GetLocalLocation(object oObject, string sVarName){
	sVarName = FF_ScrubVarName(sVarName);
	return PS_GetLocalLocation(oObject, sVarName);
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
	object oMod = GetModule();
	sVarName = FF_ScrubVarName(sVarName);
	SetLocalInt(oMod, sVarName, nValue);
	if (GetLocalInt(oMod, sVarName) == nValue) return TRUE;
	return FALSE;
}

int PS_SetGlobalBool(string sVarName, int bValue){
	object oMod = GetModule();
	sVarName = FF_ScrubVarName(sVarName);
	SetLocalInt(oMod, sVarName, bValue);
	if (GetLocalInt(oMod, sVarName) == bValue) return TRUE;
	return FALSE;
}

int PS_SetGlobalString(string sVarName, string sValue){
	object oMod = GetModule();
	sVarName = FF_ScrubVarName(sVarName);
	SetLocalString(oMod, sVarName, sValue);
	if (GetLocalString(oMod, sVarName) == sValue) return TRUE;
	return FALSE;
}

int PS_SetGlobalFloat(string sVarName, float fValue){
	object oMod = GetModule();
	sVarName = FF_ScrubVarName(sVarName);
	SetLocalFloat(oMod, sVarName, fValue);
	if (GetLocalFloat(oMod, sVarName) == fValue) return TRUE;
	return FALSE;
}

int PS_GetGlobalInt(string sVarName){
	object oMod = GetModule();
	sVarName = FF_ScrubVarName(sVarName);
	return PS_GetLocalInt(oMod, sVarName);
}

int PS_GetGlobalBool(string sVarName){
	object oMod = GetModule();
	sVarName = FF_ScrubVarName(sVarName);
	return PS_GetLocalInt(oMod, sVarName);
}

string PS_GetGlobalString(string sVarName){
	object oMod = GetModule();
	sVarName = FF_ScrubVarName(sVarName);
	return PS_GetLocalString(oMod, sVarName);
}

float PS_GetGlobalFloat(string sVarName){
	object oMod = GetModule();
	sVarName = FF_ScrubVarName(sVarName);
	return PS_GetLocalFloat(oMod, sVarName);
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

int PS_SetGlobalLocation(string sVarName, location lValue){
	object oMod = GetModule();
	sVarName = FF_ScrubVarName(sVarName);
	SetLocalLocation(oMod, sVarName, lValue);
	if (GetLocalLocation(oMod, sVarName) == lValue) return TRUE;
	return FALSE;
}

location PS_GetGlobalLocation(string sVarName){
	object oMod = GetModule();
	return PS_GetLocalLocation(oMod, sVarName);
	
}

float PS_GetGlobalIntAsFloat(string sVarName){
	return (IntToFloat(PS_GetGlobalInt(sVarName)));
}

int PS_ModifyGlobalInt(string sVarName, int iDelta){
	int iNewVal = PS_GetGlobalInt(sVarName) + iDelta;
	PS_SetGlobalInt(sVarName, iNewVal);
	return (iNewVal);
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

object PS_GetGlobalObject(string sVarName){
	object oMod = GetModule();
	return PS_GetLocalObject(oMod, sVarName);
}

int PS_SetGlobalObject(string sVarName, object oObj){
	object oMod = GetModule();
	PS_SetLocalObject(oMod, sVarName, oObj);
	if (PS_GetLocalObject(oMod, sVarName) == oObj) return TRUE;
	return FALSE;
}

void PS_DeleteGlobalInt(string sVarName){
	object oMod = GetModule();
	PS_DeleteLocalInt(oMod, sVarName);
}

void PS_DeleteGlobalBool(string sVarName){
	PS_DeleteGlobalInt(sVarName);
}

void PS_DeleteGlobalFloat(string sVarName){
	object oMod = GetModule();
	PS_DeleteLocalFloat(oMod, sVarName);
}

void PS_DeleteGlobalString(string sVarName){
	object oMod = GetModule();
	PS_DeleteLocalString(oMod, sVarName);
}

void PS_DeleteGlobalLocation(string sVarName){
	object oMod = GetModule();
	PS_DeleteLocalLocation(oMod, sVarName);
}

void PS_DeleteGlobalObject(string sVarName){
	object oMod = GetModule();
	PS_DeleteLocalObject(oMod, sVarName);
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

void PS_MarkAsUndone(object oObject=OBJECT_SELF, int iFlag=0){
	DoneFlagSanityCheck(oObject);
	PS_SetLocalInt(oObject, PS_GetDoneFlag(iFlag), FALSE);
}

string PS_GetGlobalArrayString(string sVarName, int nVarNum){
    string sFullVarName = sVarName + IntToString(nVarNum) ;
    return PS_GetGlobalString(sFullVarName);
}

void PS_SetGlobalArrayString(string sVarName, int nVarNum, string nValue){
    string sFullVarName = sVarName + IntToString(nVarNum) ;
    PS_SetGlobalString(sFullVarName, nValue);
}

int PS_GetGlobalArrayInt(string sVarName, int nVarNum){
    string sFullVarName = sVarName + IntToString(nVarNum) ;
    return PS_GetGlobalInt(sFullVarName);
}

void PS_SetGlobalArrayInt(string sVarName, int nVarNum, int nValue){
    string sFullVarName = sVarName + IntToString(nVarNum) ;
    PS_SetGlobalInt(sFullVarName, nValue);
}

string PS_GetDoneFlag(int iFlag=0){
	return FF_ScrubVarName(DONE_ONCE + (iFlag==0?"":IntToString(iFlag)));
}

string FF_ScrubVarName(string sString){
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
    int i;
    for (i = 0; i < nLength; i++)
    {
        string sChar = GetSubString(sString, i, 1);
        int nAscii = FF_GetAsciiValue(sChar);
        nHash = (nHash * 33) + nAscii;
    }
    // return "FP" + the length of the original string and the
	// absolute value of the resulting ascii value "fingerprint" 
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
	sValidChars += "1234567890";
	string sScrubbedString = "";
	int nLength = GetStringLength(sString);
	int i;
	string sChar;
	// remove characters that are not _ or alphanumeric
	for (i = 0; i < nLength; i++){
		sChar = GetSubString(sString, i, 1);
		if (FindSubString(sValidChars, sChar) != -1)
			sScrubbedString += sChar;
	}
	return sScrubbedString;
}



