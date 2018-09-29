#include "nwnx_sql"
#include "event_window_includes"

void main(string title, string description, string fdmonth, string fdday, string fdyear, string tdmonth, string tdday, string tdyear, string ftime, string totime, string atlimit0, string atlimit1, string slocation, string eventid, string editorsave)
{
    string name=SQLEncodeSpecialChars(GetName(oPC));
    string account=SQLEncodeSpecialChars(GetPCPlayerName(oPC));
    string error;
    string goodornot;
	string success;
   
    if (title == "")
    {
    DisplayMessageBox(oPC,0,"Please insert a title to the message!","","",FALSE,"SCREEN_MESSAGEBOX_DEFAULT",0,"",0,"");
    return;
    }

    if ((fdmonth == "")||(fdday == "")||(fdyear == "")||(tdmonth == "")||(tdday == "")||(tdyear == "")||
        (fdmonth == "0")||(fdday == "0")||(fdyear == "0")||(tdmonth == "0")||(tdday == "0")||(tdyear == "0")||
	(fdmonth == "0")||(fdday == "0")||(fdyear == "0")||(tdmonth == "0")||(tdday == "0")||(tdyear == "0"))
    {
    DisplayMessageBox(oPC,0,"Please insert a valid date!","","",FALSE,"SCREEN_MESSAGEBOX_DEFAULT",0,"",0,"");
    return;
    }

    if ((atlimit0 == "0")||(atlimit1 == "0"))
    {
    DisplayMessageBox(oPC,0,"Attendance limit can't be 0!","","",FALSE,"SCREEN_MESSAGEBOX_DEFAULT",0,"",0,"");
    return;
    }

    if (StringToInt(atlimit0) > StringToInt(atlimit1))
    {
    DisplayMessageBox(oPC,0,"Max attendance limit more than minimum!","","",FALSE,"SCREEN_MESSAGEBOX_DEFAULT",0,"",0,"");
    return;
    }

	string sQuery="SELECT CASE WHEN COALESCE (DAY(CONCAT('"+fdyear+"', '-', '"
	+fdmonth+"', '-', '"+fdday+"')), 0) = 0 THEN 'Invalid from date!' WHEN COALESCE (DAY(CONCAT('"
	+tdyear+"', '-', '"+tdmonth+"', '-', '"+tdday+"')), 0) = 0 THEN 'Invalid to date!' WHEN CURDATE() > STR_TO_DATE(CONCAT('"
	+fdyear+"', '-', '"+fdmonth+"', '-', '"+fdday+"'), '%Y-%m-%d') THEN 'From date is older than today!' WHEN STR_TO_DATE(CONCAT('"
	+tdyear+"', '-', '"+tdmonth+"', '-', '"+tdday+"'), '%Y-%m-%d') < STR_TO_DATE(CONCAT('"+fdyear+"', '-', '"
	+fdmonth+"', '-', '"+fdday+"'), '%Y-%m-%d') THEN 'To date is older than the from date!' WHEN ISNULL (TIME_FORMAT('"
	+ftime+"', '%H:i%')) THEN 'Invalid from time! Use format 15:00.' WHEN ISNULL (TIME_FORMAT('"
	+totime+"', '%H:i%')) THEN 'Invalid to time! Use format 15:00.' WHEN TIME_FORMAT('"
	+ftime+"', '%H:%i') > '24:00' THEN 'To time cant be greater than 24 hours!' WHEN TIME_FORMAT('"
	+totime+"', '%H:%i') > '24:00' THEN 'From time cant be greater than 24 hours!' WHEN TIME_FORMAT('"
	+totime+"', '%H:%i') < TIME_FORMAT('"+ftime+"', '%H:%i') THEN 'To time is older than from time!'"
	+" WHEN STR_TO_DATE(CONCAT('"+tdyear+"', '-', '"+tdmonth+"', '-', '"+tdday+"', ' ','"+totime+"'), '%Y-%m-%d %H:%i') < NOW() then 'From date and time is set in the past!'"
	+" ELSE 'good' END;";
    
	SQLExecDirect(sQuery);
	SQLFetch();
    goodornot = SQLGetData(1);
	
    if (goodornot == "good")
	{
	
	if (editorsave == "save")
	{
	SQLExecDirect("SELECT COALESCE(MAX(eventid), 0) + 1 FROM event_planner");
	SQLFetch();
    eventid = SQLGetData(1);
	
    sQuery = "INSERT INTO `event_planner` VALUES ('"+eventid+"', '"+SQLEncodeSpecialChars(title)+"', '"
	+SQLEncodeSpecialChars(description)+"', STR_TO_DATE(CONCAT('"+fdyear+"', '-', '"+fdmonth+"', '-', '"
	+fdday+"', ' ','"+ftime+"'), '%Y-%m-%d %H:%i'), STR_TO_DATE(CONCAT('"+tdyear+"', '-', '"
	+tdmonth+"', '-', '"+tdday+"', ' ','"+totime+"'), '%Y-%m-%d %H:%i'), '"+SQLEncodeSpecialChars(slocation)+"', '"
	+name+"', '"+account+"');";
	success = "Event created successfully!";
	WriteTimestampedLogEntry(name+"("+account+") created event "+title+" with ID #"+eventid+" successfully."); 	
	}
	
	else if (editorsave == "edit")
	{
	sQuery = "UPDATE event_planner SET Title = '"+SQLEncodeSpecialChars(title)+
	"', Description = '"+SQLEncodeSpecialChars(description)+"', StartTime = STR_TO_DATE(CONCAT('"
	+fdyear+"', '-', '"+fdmonth+"', '-', '"+fdday+"', ' ','"+ftime+"'), '%Y-%m-%d %H:%i'), EndTime = STR_TO_DATE(CONCAT('"
	+tdyear+"', '-', '"	+tdmonth+"', '-', '"+tdday+"', ' ','"+totime+"'), '%Y-%m-%d %H:%i'), Location = '"
	+SQLEncodeSpecialChars(slocation)+"' WHERE eventid = '"+eventid+"';";
	success = "Event updated successfully!";
	WriteTimestampedLogEntry(name+"("+account+") editted event "+title+" with ID #"+eventid+" successfully."); 	
	}
	
    SQLExecDirect(sQuery); 
	
	CloseGUIScreen(oPC,"EVENT_WINDOW_CREATE");
	CloseGUIScreen(oPC,"EVENT_WINDOW_VIEW");		
	UpdateEventWindow(oPC);
	
	if (success == "")
	{
	success == "Create/Edit Failed!";
	}
			
	DisplayMessageBox(oPC,0,success,"","",FALSE,"SCREEN_MESSAGEBOX_DEFAULT",0,"",0,"");
	}
    else
	{
    DisplayMessageBox(oPC,0,goodornot,"","",FALSE,"SCREEN_MESSAGEBOX_DEFAULT",0,"",0,"");
    return;
	}
	}