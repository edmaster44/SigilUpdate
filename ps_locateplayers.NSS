#include "ps_inc_functions"
#include "nwnx_sql"

/* Table scryer

charid default 0
level
areaname

SELECT areaname,count(*),avg(level),max(level),min(level),group_concat(distinct level) FROM `scryer` group by areaname

areaname  count(*)  avg(level)  max(level)  min(level)  group_concat(distinct level)  
test 2 7.5000 10 5 10,5 
test2 1 15.0000 15 15 15 
test3 3 20.3333 30 4 4,30,27 


*/

int isWithinRange(string sToken,int nLevel)
{
	// MAXPARTYRANGE
	string sNextChar = "";
	string sCurrent = "";
	
	int i = 0;
	while(i < GetStringLength(sToken))
	{
		sNextChar = GetSubString(sToken,i,1);
		
		if(sNextChar == ",")
		{
			if(nLevel <= StringToInt(sCurrent) + MAXPARTYRANGE && nLevel >= StringToInt(sCurrent) - MAXPARTYRANGE)
				return 1;
				
			sCurrent = "";
		}
		else
		{
			sCurrent += sNextChar;
		}
		
		i++;
	}

	//check last value
	if(nLevel <= StringToInt(sCurrent) + MAXPARTYRANGE && nLevel >= StringToInt(sCurrent) - MAXPARTYRANGE)
		return 1;
		
	return 0;
}

void main()
{
	object oPCScryer = OBJECT_SELF;
	int nScryerLevel = PS_GetLevel(oPCScryer);
	int nLastScry= -1;
	
	object oArea;
	string sAreaName="";
	int nLevel=0;
	int nID=0;
	object oPC = GetFirstPC();
	int nCount=0;
	//check if the scryer table needs to be updated
	
	string sScryerTime = "SELECT ifnull(TIME_TO_SEC(TIMEDIFF(NOW(),MAX(scantime))),999) as diff FROM scryer;";
	SQLExecDirect(sScryerTime);
	if (SQLFetch() != SQL_ERROR) 
	{
		 nLastScry = StringToInt(SQLGetData(1));
		 if (nLastScry>300)
		 {
			nLastScry = -1;
		 }
	}
	
	if (nLastScry==-1)
	{
		SQLExecDirect("TRUNCATE TABLE scryer;");
		SQLExecDirect("DELETE FROM scryer;");
		
		while (GetIsObjectValid(oPC) == TRUE)
		{
			if(!GetIsDM(oPC))
			{
				oArea = GetArea(oPC);
				if(oArea != OBJECT_INVALID)	
				{
					nID = GetLocalInt(oPC,"ID");
					nLevel = PS_GetLevel(oPC);
					sAreaName = SQLEncodeSpecialChars(GetName(oArea));
					SQLExecDirect("SELECT scryopt from characterdata where id=" + IntToString(nID) + ";");
					if (SQLFetch() != SQL_ERROR) 
					{
						int opt = StringToInt(SQLGetData(1));
						if (opt==0)
						{
							SQLExecDirect("INSERT INTO scryer (scantime,charid,level,areaname) VALUES (NOW(), "+IntToString(nID)+", "+IntToString(nLevel)+", '"+sAreaName+"');");
						}
					}
				}
				else
				{
					nID = 0;
					nLevel = 100;
					sAreaName = "(In Transition)";
					SQLExecDirect("INSERT INTO scryer (scantime,charid,level,areaname) VALUES (NOW(), "+IntToString(nID)+", "+IntToString(nLevel)+", '"+sAreaName+"');");
				}

				nCount+=1;			
			}
			oPC = GetNextPC();
		}
	}
	SQLExecDirect("SELECT areaname,count(*),min(level),max(level),group_concat(distinct level) FROM `scryer` group by areaname order by areaname;");

	if( nLastScry==-1 )
		SendMessageToPC(oPCScryer,"<C=GOLD>** Scrying Characters on SCoD: **");
	else
		SendMessageToPC(oPCScryer,"<C=GOLD>** Scrying Characters on SCoD: (scry info is " + IntToString(nLastScry) + " seconds old) **");			

	string sPlayers = "";
	
	while (SQLFetch() != SQL_ERROR) { 
		
		if(StringToInt(SQLGetData(2)) < 3)
			sPlayers = "A berk or two in ";
		else if(StringToInt(SQLGetData(2)) < 5)
			sPlayers = "A small group in ";
		else
			sPlayers = "A large group in ";
		
	
		if(nScryerLevel <= StringToInt(SQLGetData(3)) + MAXPARTYRANGE && nScryerLevel >= StringToInt(SQLGetData(4)) - MAXPARTYRANGE)
		{
			//green
			SendMessageToPC(oPCScryer,"<C=GREEN>"+sPlayers+SQLGetData(1));
		}
		else if(isWithinRange(SQLGetData(5),nScryerLevel)) //just one player in range would kick in above
		{
			//yellow
			SendMessageToPC(oPCScryer,"<C=YELLOW>"+sPlayers+SQLGetData(1));
		}
		else
		{
			//red
			SendMessageToPC(oPCScryer,"<C=RED>"+sPlayers+SQLGetData(1));
		}
	}
	SendMessageToPC(oPCScryer,"<C=GOLD>***********************************");
}