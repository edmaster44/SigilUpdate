

const int cMidnight = 86400;
const int cSaveWait = 300;

int GetTime()
{
    return GetTimeSecond()+60*GetTimeMinute()+3600*GetTimeHour();
}

//returns an int in secs of time passed
// checking for the passage of midnight
int GetTimePassed(int iBegin, int iEnd)
{
   // if begin is smaller simple subtraction
   if(iBegin < iEnd)
   {
       return (iEnd - iBegin);
   }
   //only happens when midnight has passed
   if (iBegin > iEnd)
   {
       return ( (cMidnight - iBegin) + iEnd);
       //trust me it works
   }
   else
   {
       return 0;//begin == end time is zero
   }
}

//TimeStamp(object)  self explanatory no?
//the variable will be called <objecttag>_timestamp
void TimeStamp(object oObject=OBJECT_SELF, string sTimeStampVariable = "")
{
  if (sTimeStampVariable == "") sTimeStampVariable = GetTag(oObject)+"_s";
   SetLocalInt(oObject, sTimeStampVariable, GetTime());
}

//CheckTimeStamp(object)  self explanatory no?
//returns the difference in time between NOW and the last timestamp
//the variable will be called <objecttag>_timestamp
int CheckTimeStamp(object oObject=OBJECT_SELF, string sTimeStampVariable = "")
{
  if (sTimeStampVariable == "") sTimeStampVariable = GetTag(oObject)+"_s";
  int iOld = GetLocalInt(oObject, sTimeStampVariable);
  int iNew = GetTime();
  return GetTimePassed(iOld, iNew);
}

void main()
{
	object oPC = OBJECT_SELF;
	
	if (CheckTimeStamp(oPC,"REST")>cSaveWait)
	{
		TimeStamp(oPC,"REST");
		ExportSingleCharacter(oPC);
		SendMessageToPC(oPC,"Character saved...");
	}
	else
	{
		SendMessageToPC(oPC,"Please wait a few minutes before saving...");
	}

}