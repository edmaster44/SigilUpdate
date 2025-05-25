

//ps_inc_time

/*	Script by Ceremorph
	Created for use in the Sigil: City of Doors PW

	Inclusion script for all timestamping scripts
*/
#include "ps_inc_advscript"
#include "nwnx_sql"

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

// ------------------------------------------------------------------------------------
// Returns Unix Timestamp
// ------------------------------------------------------------------------------------
int GetRealTime()
{
	int utc;
	
	SQLExecDirect("SELECT UNIX_TIMESTAMP()");
	
	while (SQLFetch() != SQL_ERROR)
	{
		utc = StringToInt(SQLGetData(1));	
	}
	return utc;
}


// ------------------------------------------------------------------------------------
// Time Structs, previously in ps_servertime
// ------------------------------------------------------------------------------------
struct TimeFields {
	int Year;
	int Month;
	int Day;
	int Weekday; // [0, 6] -> [Sun, Sat]
	int Hour;
	int Minute;
	int Second;
};

struct TimeFields TimeToTimeFields(int Time)
{
	int ed;
	int z;
	int era;
	int doe;
	int yoe;
	int y;
	int doy;
	int mp;
	int d;
	int m;
	struct TimeFields Tf;

	//
	// This implements the civil_from_day algorithm from this page:
	//
	// http://howardhinnant.github.io/date_algorithms.html
	//

	Tf.Hour = (Time / (60 * 60)) % 24;
	Tf.Minute = (Time / 60) % 60;
	Tf.Second = Time % 60;

	ed = (Time / (60 * 60 * 24));
	z = ed + 719468;
	era = (z >= 0 ? z : z - 146096) / 146097;
	doe = z - era * 146097;                                 // [0, 146096]
	yoe = (doe - doe/1460 + doe/36524 - doe/146096) / 365;  // [0, 399]
	y = yoe + era * 400;
	doy = doe - (365*yoe + yoe/4 - yoe/100);                // [0, 365]
	mp = (5*doy + 2)/153;                                   // [0, 11]
	d = doy - (153*mp+2)/5 + 1;                             // [1, 31]
	m = mp + (mp < 10 ? 3 : -9);                            // [1, 12]

	Tf.Year = y + (m <= 2);
	Tf.Month = m;
	Tf.Day = d;

	//
	// This implements the weekday_from_days algorithm.
	//

	Tf.Weekday = (ed >= -4 ? (ed + 4) % 7 : (ed + 5) % 7 + 6);

	return Tf;
}

// ------------------------------------------------------------------------------------
//Checking if this is server reset time
// ------------------------------------------------------------------------------------
int GetIsServerResetTime(object oPC = OBJECT_INVALID) {

    object oMod = GetModule();
    int nBoottime = GetLocalInt(oMod, "boottime");
	int nHour = 60*60;
	
	SQLExecDirect("SELECT UNIX_TIMESTAMP()");
	
	while (SQLFetch() != SQL_ERROR) { 
		int utc = StringToInt(SQLGetData(1));
		struct TimeFields timeStruct = TimeToTimeFields(utc);
		
		if (GetIsObjectValid(oPC)) DelayCommand(22.0f, SendMessageToPC(oPC, "Current hour: "+IntToString(timeStruct.Hour)));
		
		int iDelay = GetLocalInt(oMod, "delaycount");
		iDelay *= nHour; // so we now check to see if a DM has delayed reboot with widget, 1 hour per delay.
		
		//Reset should take place between 4-6AM EST
		if (timeStruct.Hour >= 9 && timeStruct.Hour <= 11) {
			int nextValidResetTime = (nBoottime + (nHour * 3) + iDelay);
			struct TimeFields resetTime = TimeToTimeFields(nextValidResetTime);
			
			if (utc > (nBoottime + (nHour * 3) + iDelay)) {
				if (GetIsObjectValid(oPC)) DelayCommand(23.0f, SendMessageToPC(oPC, IntToString(timeStruct.Hour)+" > "+IntToString(resetTime.Hour)));
				return TRUE;
			} else {
				if (GetIsObjectValid(oPC)) DelayCommand(23.0f, SendMessageToPC(oPC, IntToString(timeStruct.Hour)+" <= "+IntToString(resetTime.Hour)));
				return FALSE;
			}
		}
		
		if (utc > nBoottime + 86400 + iDelay) {
			int nextValidResetTime = (nBoottime + 86400 + iDelay);
			struct TimeFields resetTime = TimeToTimeFields(nextValidResetTime);
			
			if (GetIsObjectValid(oPC)) DelayCommand(23.0f, SendMessageToPC(oPC, IntToString(timeStruct.Hour)+" > "+IntToString(resetTime.Hour)));
			return TRUE;
		}
		
	}
	
	return FALSE;

}