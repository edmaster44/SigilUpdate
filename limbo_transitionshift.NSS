#include "ff_safevar"

void SetNewPath(object oHolder, int rand)
{
	if (rand == 1)
	{
		PS_SetLocalString(oHolder, "ruinscave", "wp_limbo_earthin");
		PS_SetLocalString(oHolder, "ruinswhirlwind", "wp_limbo_airstairs");
		PS_SetLocalString(oHolder, "ruinsdive", "wp_limbo_stormcave");
		
		PS_SetLocalString(oHolder, "earthin", "wp_limbo_ruinscave");
		PS_SetLocalString(oHolder, "earthout", "wp_limbo_firecave");
		
		PS_SetLocalString(oHolder, "stormwhirlwind", "wp_limbo_hermitage");
		PS_SetLocalString(oHolder, "stormstairs", "wp_limbo_firecave");
		PS_SetLocalString(oHolder, "stormcave", "wp_limbo_earthout");
		
		PS_SetLocalString(oHolder, "firecave", "wp_limbo_earthout");
		PS_SetLocalString(oHolder, "firestairs", "wp_limbo_airstairs");
		PS_SetLocalString(oHolder, "firepit", "wp_limbo_earthcave");
		
		PS_SetLocalString(oHolder, "airstairs", "wp_limbo_stormwhirlwind");
		
		PS_SetLocalString(oHolder, "hermitageout", "wp_limbo_stormwhirlwind");
	}
	else if (rand == 2)
	{
		PS_SetLocalString(oHolder, "ruinscave", "wp_limbo_firecave");
		PS_SetLocalString(oHolder, "ruinswhirlwind", "wp_limbo_stormwhirlwind");
		PS_SetLocalString(oHolder, "ruinsdive", "wp_limbo_airstairs");
		
		PS_SetLocalString(oHolder, "earthin", "wp_limbo_hermitage");
		PS_SetLocalString(oHolder, "earthout", "wp_limbo_firecave");
		
		PS_SetLocalString(oHolder, "stormwhirlwind", "wp_limbo_ruinswhirlwind");
		PS_SetLocalString(oHolder, "stormstairs", "wp_limbo_airstairs");
		PS_SetLocalString(oHolder, "stormcave", "wp_limbo_earthin");
		
		PS_SetLocalString(oHolder, "firecave", "wp_limbo_ruinscave");
		PS_SetLocalString(oHolder, "firestairs", "wp_limbo_stormstairs");
		PS_SetLocalString(oHolder, "firepit", "wp_limbo_airstairs");
		
		PS_SetLocalString(oHolder, "airstairs", "wp_limbo_hermitage");
		
		PS_SetLocalString(oHolder, "hermitageout", "wp_limbo_earthout");
	}
	else if (rand == 3)
	{
		PS_SetLocalString(oHolder, "ruinscave", "wp_limbo_earthout");
		PS_SetLocalString(oHolder, "ruinswhirlwind", "wp_limbo_airstairs");
		PS_SetLocalString(oHolder, "ruinsdive", "wp_limbo_firestairs");
		
		PS_SetLocalString(oHolder, "earthin", "wp_limbo_stormstairs");
		PS_SetLocalString(oHolder, "earthout", "wp_limbo_ruinscave");
		
		PS_SetLocalString(oHolder, "stormwhirlwind", "wp_limbo_airstairs");
		PS_SetLocalString(oHolder, "stormstairs", "wp_limbo_earthin");
		PS_SetLocalString(oHolder, "stormcave", "wp_limbo_firecave");
		
		PS_SetLocalString(oHolder, "firecave", "wp_limbo_stormcave");
		PS_SetLocalString(oHolder, "firestairs", "wp_limbo_hermitage");
		PS_SetLocalString(oHolder, "firepit", "wp_limbo_ruinswhirlwind");
		
		PS_SetLocalString(oHolder, "airstairs", "wp_limbo_ruinswhirlwind");
		
		PS_SetLocalString(oHolder, "hermitageout", "wp_limbo_firestairs");
	}
	else if (rand == 4)
	{
		PS_SetLocalString(oHolder, "ruinscave", "wp_limbo_stormcave");
		PS_SetLocalString(oHolder, "ruinswhirlwind", "wp_limbo_firestairs");
		PS_SetLocalString(oHolder, "ruinsdive", "wp_limbo_earthcave");
		
		PS_SetLocalString(oHolder, "earthin", "wp_limbo_firecave");
		PS_SetLocalString(oHolder, "earthout", "wp_limbo_stormwhirlwind");
		
		PS_SetLocalString(oHolder, "stormwhirlwind", "wp_limbo_earthout");
		PS_SetLocalString(oHolder, "stormstairs", "wp_limbo_firestairs");
		PS_SetLocalString(oHolder, "stormcave", "wp_limbo_ruinscave");
		
		PS_SetLocalString(oHolder, "firecave", "wp_limbo_earthin");
		PS_SetLocalString(oHolder, "firestairs", "wp_limbo_ruinswhirlwind");
		PS_SetLocalString(oHolder, "firepit", "wp_limbo_airstairs");
		
		PS_SetLocalString(oHolder, "airstairs", "wp_limbo_hermitage");
		
		PS_SetLocalString(oHolder, "hermitageout", "wp_limbo_earthout");
	}
	else if (rand == 5)
	{
		PS_SetLocalString(oHolder, "ruinscave", "wp_limbo_firestairs");
		PS_SetLocalString(oHolder, "ruinswhirlwind", "limbo_blocked");
		PS_SetLocalString(oHolder, "ruinsdive", "wp_limbo_earthin");
		
		PS_SetLocalString(oHolder, "earthin", "limbo_blocked");
		PS_SetLocalString(oHolder, "earthout", "wp_limbo_firecave");
		
		PS_SetLocalString(oHolder, "stormwhirlwind", "limbo_blocked");
		PS_SetLocalString(oHolder, "stormstairs", "wp_limbo_airstairs");
		PS_SetLocalString(oHolder, "stormcave", "wp_limbo_earthin");
		
		PS_SetLocalString(oHolder, "firecave", "wp_limbo_earthout");
		PS_SetLocalString(oHolder, "firestairs", "wp_limbo_ruinscave");
		PS_SetLocalString(oHolder, "firepit", "wp_limbo_stormwhirlwind");
		
		PS_SetLocalString(oHolder, "airstairs", "wp_limbo_hermitage");
		
		PS_SetLocalString(oHolder, "hermitageout", "wp_limbo_ruinswhirlwind");
	}
	else
	{
		PS_SetLocalString(oHolder, "ruinscave", "wp_limbo_stormcave");
		PS_SetLocalString(oHolder, "ruinswhirlwind", "wp_limbo_hermitage");
		PS_SetLocalString(oHolder, "ruinsdive", "wp_limbo_stormwhirlwind");
		
		PS_SetLocalString(oHolder, "earthin", "wp_limbo_stormcave");
		PS_SetLocalString(oHolder, "earthout", "wp_limbo_firecave");
		
		PS_SetLocalString(oHolder, "stormwhirlwind", "wp_limbo_airstairs");
		PS_SetLocalString(oHolder, "stormstairs", "wp_limbo_firepit");
		PS_SetLocalString(oHolder, "stormcave", "wp_limbo_ruinscave");
		
		PS_SetLocalString(oHolder, "firecave", "wp_limbo_earthout");
		PS_SetLocalString(oHolder, "firestairs", "wp_limbo_ruinswhirlwind");
		PS_SetLocalString(oHolder, "firepit", "wp_limbo_stormstairs");
		
		PS_SetLocalString(oHolder, "airstairs", "wp_limbo_stormwhirlwind");
		
		PS_SetLocalString(oHolder, "hermitageout", "wp_limbo_earthcave");
	}
}

void main ()
{
	//object to hold variables:
	object oHolder = GetObjectByTag("limbo_transitionmanager");
	
	//timer:
	int lastTime = PS_GetLocalInt(oHolder, "lastshift");
	if (lastTime < 0)
		lastTime = 0;
	int currentTime = ((GetCalendarYear()*336)+(GetCalendarMonth()*28)+GetCalendarDay()); //days
	currentTime = ((currentTime*24)+GetTimeHour()); //hours
	currentTime = ((currentTime*60)+GetTimeMinute()); //minutes since beginning of time
	//SendMessageToPC(GetEnteringObject(), IntToString(currentTime)+" "+IntToString(lastTime));
	int dif = (currentTime-lastTime);
	//SendMessageToPC(GetEnteringObject(), "it has been "+IntToString(dif)+" minutes since you last stepped on this trigger.");
	PS_SetLocalInt(oHolder, "lastshift", currentTime);
	
	//code!
	if (dif >= 10) //ten minutes
	{
		int nRoll = d6();
		//SendMessageToPC(GetEnteringObject(), "it has been ten minutes or more!");
		SetNewPath(oHolder, nRoll);
	}
}