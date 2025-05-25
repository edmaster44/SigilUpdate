

void SetNewPath(object oHolder, int rand)
{
	if (rand == 1)
	{
		SetLocalString(oHolder, "ruinscave", "wp_limbo_earthin");
		SetLocalString(oHolder, "ruinswhirlwind", "wp_limbo_airstairs");
		SetLocalString(oHolder, "ruinsdive", "wp_limbo_stormcave");
		
		SetLocalString(oHolder, "earthin", "wp_limbo_ruinscave");
		SetLocalString(oHolder, "earthout", "wp_limbo_firecave");
		
		SetLocalString(oHolder, "stormwhirlwind", "wp_limbo_hermitage");
		SetLocalString(oHolder, "stormstairs", "wp_limbo_firecave");
		SetLocalString(oHolder, "stormcave", "wp_limbo_earthout");
		
		SetLocalString(oHolder, "firecave", "wp_limbo_earthout");
		SetLocalString(oHolder, "firestairs", "wp_limbo_airstairs");
		SetLocalString(oHolder, "firepit", "wp_limbo_earthcave");
		
		SetLocalString(oHolder, "airstairs", "wp_limbo_stormwhirlwind");
		
		SetLocalString(oHolder, "hermitageout", "wp_limbo_stormwhirlwind");
	}
	else if (rand == 2)
	{
		SetLocalString(oHolder, "ruinscave", "wp_limbo_firecave");
		SetLocalString(oHolder, "ruinswhirlwind", "wp_limbo_stormwhirlwind");
		SetLocalString(oHolder, "ruinsdive", "wp_limbo_airstairs");
		
		SetLocalString(oHolder, "earthin", "wp_limbo_hermitage");
		SetLocalString(oHolder, "earthout", "wp_limbo_firecave");
		
		SetLocalString(oHolder, "stormwhirlwind", "wp_limbo_ruinswhirlwind");
		SetLocalString(oHolder, "stormstairs", "wp_limbo_airstairs");
		SetLocalString(oHolder, "stormcave", "wp_limbo_earthin");
		
		SetLocalString(oHolder, "firecave", "wp_limbo_ruinscave");
		SetLocalString(oHolder, "firestairs", "wp_limbo_stormstairs");
		SetLocalString(oHolder, "firepit", "wp_limbo_airstairs");
		
		SetLocalString(oHolder, "airstairs", "wp_limbo_hermitage");
		
		SetLocalString(oHolder, "hermitageout", "wp_limbo_earthout");
	}
	else if (rand == 3)
	{
		SetLocalString(oHolder, "ruinscave", "wp_limbo_earthout");
		SetLocalString(oHolder, "ruinswhirlwind", "wp_limbo_airstairs");
		SetLocalString(oHolder, "ruinsdive", "wp_limbo_firestairs");
		
		SetLocalString(oHolder, "earthin", "wp_limbo_stormstairs");
		SetLocalString(oHolder, "earthout", "wp_limbo_ruinscave");
		
		SetLocalString(oHolder, "stormwhirlwind", "wp_limbo_airstairs");
		SetLocalString(oHolder, "stormstairs", "wp_limbo_earthin");
		SetLocalString(oHolder, "stormcave", "wp_limbo_firecave");
		
		SetLocalString(oHolder, "firecave", "wp_limbo_stormcave");
		SetLocalString(oHolder, "firestairs", "wp_limbo_hermitage");
		SetLocalString(oHolder, "firepit", "wp_limbo_ruinswhirlwind");
		
		SetLocalString(oHolder, "airstairs", "wp_limbo_ruinswhirlwind");
		
		SetLocalString(oHolder, "hermitageout", "wp_limbo_firestairs");
	}
	else if (rand == 4)
	{
		SetLocalString(oHolder, "ruinscave", "wp_limbo_stormcave");
		SetLocalString(oHolder, "ruinswhirlwind", "wp_limbo_firestairs");
		SetLocalString(oHolder, "ruinsdive", "wp_limbo_earthcave");
		
		SetLocalString(oHolder, "earthin", "wp_limbo_firecave");
		SetLocalString(oHolder, "earthout", "wp_limbo_stormwhirlwind");
		
		SetLocalString(oHolder, "stormwhirlwind", "wp_limbo_earthout");
		SetLocalString(oHolder, "stormstairs", "wp_limbo_firestairs");
		SetLocalString(oHolder, "stormcave", "wp_limbo_ruinscave");
		
		SetLocalString(oHolder, "firecave", "wp_limbo_earthin");
		SetLocalString(oHolder, "firestairs", "wp_limbo_ruinswhirlwind");
		SetLocalString(oHolder, "firepit", "wp_limbo_airstairs");
		
		SetLocalString(oHolder, "airstairs", "wp_limbo_hermitage");
		
		SetLocalString(oHolder, "hermitageout", "wp_limbo_earthout");
	}
	else if (rand == 5)
	{
		SetLocalString(oHolder, "ruinscave", "wp_limbo_firestairs");
		SetLocalString(oHolder, "ruinswhirlwind", "limbo_blocked");
		SetLocalString(oHolder, "ruinsdive", "wp_limbo_earthin");
		
		SetLocalString(oHolder, "earthin", "limbo_blocked");
		SetLocalString(oHolder, "earthout", "wp_limbo_firecave");
		
		SetLocalString(oHolder, "stormwhirlwind", "limbo_blocked");
		SetLocalString(oHolder, "stormstairs", "wp_limbo_airstairs");
		SetLocalString(oHolder, "stormcave", "wp_limbo_earthin");
		
		SetLocalString(oHolder, "firecave", "wp_limbo_earthout");
		SetLocalString(oHolder, "firestairs", "wp_limbo_ruinscave");
		SetLocalString(oHolder, "firepit", "wp_limbo_stormwhirlwind");
		
		SetLocalString(oHolder, "airstairs", "wp_limbo_hermitage");
		
		SetLocalString(oHolder, "hermitageout", "wp_limbo_ruinswhirlwind");
	}
	else
	{
		SetLocalString(oHolder, "ruinscave", "wp_limbo_stormcave");
		SetLocalString(oHolder, "ruinswhirlwind", "wp_limbo_hermitage");
		SetLocalString(oHolder, "ruinsdive", "wp_limbo_stormwhirlwind");
		
		SetLocalString(oHolder, "earthin", "wp_limbo_stormcave");
		SetLocalString(oHolder, "earthout", "wp_limbo_firecave");
		
		SetLocalString(oHolder, "stormwhirlwind", "wp_limbo_airstairs");
		SetLocalString(oHolder, "stormstairs", "wp_limbo_firepit");
		SetLocalString(oHolder, "stormcave", "wp_limbo_ruinscave");
		
		SetLocalString(oHolder, "firecave", "wp_limbo_earthout");
		SetLocalString(oHolder, "firestairs", "wp_limbo_ruinswhirlwind");
		SetLocalString(oHolder, "firepit", "wp_limbo_stormstairs");
		
		SetLocalString(oHolder, "airstairs", "wp_limbo_stormwhirlwind");
		
		SetLocalString(oHolder, "hermitageout", "wp_limbo_earthcave");
	}
}

void main ()
{
	//object to hold variables:
	object oHolder = GetObjectByTag("limbo_transitionmanager");
	
	//timer:
	int lastTime = GetLocalInt(oHolder, "lastshift");
	if (lastTime < 0)
		lastTime = 0;
	int currentTime = ((GetCalendarYear()*336)+(GetCalendarMonth()*28)+GetCalendarDay()); //days
	currentTime = ((currentTime*24)+GetTimeHour()); //hours
	currentTime = ((currentTime*60)+GetTimeMinute()); //minutes since beginning of time
	//SendMessageToPC(GetEnteringObject(), IntToString(currentTime)+" "+IntToString(lastTime));
	int dif = (currentTime-lastTime);
	//SendMessageToPC(GetEnteringObject(), "it has been "+IntToString(dif)+" minutes since you last stepped on this trigger.");
	SetLocalInt(oHolder, "lastshift", currentTime);
	
	//code!
	if (dif >= 10) //ten minutes
	{
		int nRoll = d6();
		//SendMessageToPC(GetEnteringObject(), "it has been ten minutes or more!");
		SetNewPath(oHolder, nRoll);
	}
}