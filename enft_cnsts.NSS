float freezeTime = TurnsToSeconds(1);  // One game hour
float heatTime = 60.0f;
float magmaTime = 30.0f;
float saltTime = HoursToSeconds(1);  // One game hour
float warmDistance = 5.0f;  // Distance to get warmed by object
float coolDistance = 5.0f;
float hydrateDistance = 5.0f;  // Distance to get cooled by object
float slagsTime = 60.0f;

// 10 ResRef slots for equiped items that protects on from extreme heat or cold.
// Only items that provide inherent, physical protection from the elements
// should have their ResRefs listed here.  Items that protect against both heat
// and cold should take up a slot in both the heat protection and cold
// protection areas.  An empty slot should be given a ResRef of "*" and not an
// empty string as an empty string is returned for equipment slots that have no
// equipment.  A ResRef of "*" is used because no ResRef can use the "*"
// character.
string heatProtection1 = "enfti_dsrtcloak";
string heatProtection2 = "*";
string heatProtection3 = "*";
string heatProtection4 = "*";
string heatProtection5 = "*";
string heatProtection6 = "*";
string heatProtection7 = "*";
string heatProtection8 = "*";
string heatProtection9 = "*";
string heatProtection10 = "*";
string coldProtection1 = "enfti_hhc";
string coldProtection2 = "enfti_icecloak";
string coldProtection3 = "*";
string coldProtection4 = "*";
string coldProtection5 = "*";
string coldProtection6 = "*";
string coldProtection7 = "*";
string coldProtection8 = "*";
string coldProtection9 = "*";
string coldProtection10 = "*";
string saltProtection1 = "ps_i_breathingsalt";
string saltProtection2 = "*";

int TimeStampT()
{
	int iCurrentTime = GetTimeHour() * 60 * 60 + GetTimeMinute() * 60 + GetTimeSecond();
	
	return iCurrentTime;
}

//Sanity check to make sure the script doesn't run too many times on the same PC
int CanRunEnvironmentLoop(string sTime, float timeDelay) {
	
	int lastRun = GetLocalInt(OBJECT_SELF, sTime);
	float diff = IntToFloat(abs(TimeStampT()-lastRun));
	if (diff < timeDelay)
		return FALSE;
	else
		SetLocalInt(OBJECT_SELF, sTime, TimeStampT());
		
	return TRUE;
}