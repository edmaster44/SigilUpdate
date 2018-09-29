//ps_inc_time

/*	Script by Ceremorph
	Created for use in the Sigil: City of Doors PW

	Inclusion script for all timestamping scripts
*/
#include "ps_inc_advscript"

// -------------------------------------------------------------------------------------
// Places a Unix timestamp (number of seconds since the start of 1970) on the object.
// oObject is the object to place the timestamp variable on.
// sVariable is the name of the variable for the timestamp to be stored as.
// The variable itself will be stored as an int.
// -------------------------------------------------------------------------------------
void PS_Timestamp_UNIX(object oObject, string sVariable)
{
	int nTime		= PS_GetTime();
	SetLocalInt(oObject, sVariable, nTime);
}

// ------------------------------------------------------------------------------------
// Returns how many seconds have passed since the timestamp with the name sVariable
// was placed on oObject.
// ------------------------------------------------------------------------------------
int PS_GetTimestamp_Age_Seconds(object oObject, string sVariable)
{
	int nStamp 		= GetLocalInt(oObject, sVariable);
	if (nStamp == 0)
	{	return 0;	}
	int nNow		= PS_GetTime();
	int nSeconds	= nNow - nStamp;
	if (nSeconds >= 0)
	{	return nSeconds;	}
	else return 0;
}

// ------------------------------------------------------------------------------------
// Returns how many minutes have passed since the timestamp with the name sVariable
// was placed on oObject.
// ------------------------------------------------------------------------------------
int PS_GetTimestamp_Age_Minutes(object oObject, string sVariable)
{
	int nSeconds	= PS_GetTimestamp_Age_Seconds(oObject, sVariable);
	int nMinutes	= FloatToInt(IntToFloat(nSeconds)/60);
	
	return nMinutes;
}

// ------------------------------------------------------------------------------------
// Returns how many hours have passed since the timestamp with the name sVariable
// was placed on oObject.
// ------------------------------------------------------------------------------------
int PS_GetTimestamp_Age_Hours(object oObject, string sVariable)
{
	int nSeconds	= PS_GetTimestamp_Age_Seconds(oObject, sVariable);
	int nHours		= FloatToInt(IntToFloat(nSeconds)/3600);
	
	return nHours;
}

// ------------------------------------------------------------------------------------
// Returns how many days have passed since the timestamp with the name sVariable
// was placed on oObject.
// ------------------------------------------------------------------------------------
int PS_GetTimestamp_Age_Days(object oObject, string sVariable)
{
	int nSeconds	= PS_GetTimestamp_Age_Seconds(oObject, sVariable);
	int nDays		= FloatToInt(IntToFloat(nSeconds)/86400);
	
	return nDays;
}

// ------------------------------------------------------------------------------------
// Returns how many weeks have passed since the timestamp with the name sVariable
// was placed on oObject.
// ------------------------------------------------------------------------------------
int PS_GetTimestamp_Age_Weeks(object oObject, string sVariable)
{	
	int nSeconds	= PS_GetTimestamp_Age_Seconds(oObject, sVariable);
	int nWeeks		= FloatToInt(IntToFloat(nSeconds)/604800);
	
	return nWeeks;
}

// ------------------------------------------------------------------------------------
// Returns how many months have passed since the timestamp with the name sVariable
// was placed on oObject.
// ------------------------------------------------------------------------------------
int PS_GetTimestamp_Age_Months(object oObject, string sVariable)
{
	int nSeconds	= PS_GetTimestamp_Age_Seconds(oObject, sVariable);
	int nMonths		= FloatToInt(IntToFloat(nSeconds)/2592000);
	
	return nMonths;
}

// ------------------------------------------------------------------------------------
// Returns TRUE if the timestamp with the name sVariable on oObject was placed more
// than nPassing seconds ago.
// ------------------------------------------------------------------------------------
int PS_GetHasTimePassed_Seconds(object oObject, string sVariable, int nPassing)
{	int nSeconds	= PS_GetTimestamp_Age_Seconds(oObject, sVariable);
	if (nSeconds >= nPassing)
		return TRUE;
	else return FALSE;
}

// ------------------------------------------------------------------------------------
// Returns TRUE if the timestamp with the name sVariable on oObject was placed more
// than nPassing minutes ago.
// ------------------------------------------------------------------------------------
int PS_GetHasTimePassed_Minutes(object oObject, string sVariable, int nPassing)
{	int nMinutes	= PS_GetTimestamp_Age_Minutes(oObject, sVariable);
	if (nMinutes >= nPassing)
		return TRUE;
	else return FALSE;
}

// ------------------------------------------------------------------------------------
// Returns TRUE if the timestamp with the name sVariable on oObject was placed more
// than nPassing hours ago.
// ------------------------------------------------------------------------------------
int PS_GetHasTimePassed_Hours(object oObject, string sVariable, int nPassing)
{	int nHours		= PS_GetTimestamp_Age_Hours(oObject, sVariable);
	if (nHours >= nPassing)
		return TRUE;	
	else return FALSE;
}

// ------------------------------------------------------------------------------------
// Returns TRUE if the timestamp with the name sVariable on oObject was placed more
// than nPassing days ago.
// ------------------------------------------------------------------------------------
int PS_GetHasTimePassed_Days(object oObject, string sVariable, int nPassing)
{	int nDays		= PS_GetTimestamp_Age_Days(oObject, sVariable);
	if (nDays >= nPassing)
		return TRUE;
	else return FALSE;
}

// ------------------------------------------------------------------------------------
// Returns TRUE if the timestamp with the name sVariable on oObject was placed more
// than nPassing weeks ago.
// ------------------------------------------------------------------------------------
int PS_GetHasTimePassed_Weeks(object oObject, string sVariable, int nPassing)
{	int nWeeks		= PS_GetTimestamp_Age_Weeks(oObject, sVariable);
	if (nWeeks >= nPassing)
		return TRUE;
	else return FALSE;
}

// ------------------------------------------------------------------------------------
// Returns TRUE if the timestamp with the name sVariable on oObject was placed more
// than nPassing weeks ago.
// ------------------------------------------------------------------------------------
int PS_GetHasTimePassed_Months(object oObject, string sVariable, int nPassing)
{	int nMonths		= PS_GetTimestamp_Age_Months(oObject, sVariable);
	if (nMonths >= nPassing)
		return TRUE;
	else return FALSE;
}