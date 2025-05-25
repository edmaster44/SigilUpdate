

/************************************************************
* Include file for all functions relating to astral travel. *
* Created by Agony_Aunt for SCoD PW                         *
************************************************************/

const string ASTRAL_TRADER = "ps_astral_astraltrader_deck"; //tag of the ship placeable itself
const string ASTRAL_TRADER_RESREF = "plc_bc_shipcar3_x2";
const string ASTRAL_TRADER_CAPTAIN = "astral_captain";
const string ASTRAL_TRADER_ANNOUNCER = "astral_ship_announce"; // placeable that will make announcements.
// The bell in each area will have the same tag, so have to iterate to find.
const string ASTRAL_BELL_TAG = "astral_call_bell";
// tag of WP where ship should appear, so need to iterate to find.
const string ASTRAL_SHIP_WP = "astral_ship_wp";
// tag of deck WP where characters appear on boarding
const string ASTRAL_DECK_ARRIVAL_WP = "astral_deck_arrival_wp";
// tag of WP where players appear after leaving the ship - same for each area - iterate to find
const string ASTRAL_AREA_ARRIVAL_WP = "astral_area_arrival_wp";
// tag of Transition/Trigger on the ship for leaving
//const string ASTRAL_DECK_DEPART_TRANSITION = "astral_deck_depart";
//tag of transition/trigger in area for leaving
//const string ASTRAL_AREA_DEPART_TRANSITION = "astral_area_depart";

// resref of area boarding plank
const string ASTRAL_AREA_PLANK_RESREF = "astral_area_depart";
// wp of area boarding plank
const string ASTRAL_AREA_PLANK_WP = "astral_plank_wp";

// Variable location name of destination on transition objects.
const string ASTRAL_OBJECT_DESTINATION = "LOCATION_DESTINATION";

// these will have suffixes based on their position in the queue.
const string ASTRAL_QUEUE_DESTINATION = "AQD";
const string ASTRAL_QUEUE_TIMESTAMP = "AQT";

const int SECONDS_IN_DAY = 86400;

// How many seconds should it spend travelling between destinations?
const int ASTRAL_TRAVEL_DURATION = 120;
// How long does it stay docked?
const int ASTRAL_TRAVEL_STAY = 60;
// Notice given for ETA by captain (and possibly the call to area object/bell) prior to arrival time.
const int ASTRAL_TRAVEL_ETA_ANNOUNCE1 = 60;
// Second alert just before arrival.
const int ASTRAL_TRAVEL_ETA_ANNOUNCE2 = 10;
// Announcement prior to departure.
const int ASTRAL_TRAVEL_DEPART_ANNOUNCE = 30;

// If calling from deck then pass 0, if calling from area with a bell pass 0.
const int REQUEST_SOURCE_LOCATION_DECK = 0;
const int REQUEST_SOURCE_LOCATION_AREA = 1;

// just true/false values for status of ship in relation to docking.
// remember to include these in delay commands with appropriate timings.
const int SHIP_UNDOCKED = 0;
const int SHIP_DOCKED = 1;

// Payment values
const int PAYMENT_PRICE_GOLD = 100;
const string PAYMENT_TYPE_PLANAR_COIN = "ps_miscstack_coinage-cogcoin";
const int PAYMENT_METHOD_GOLD = 1;
const int PAYMENT_METHOD_PLANAR_COIN = 2;
const int PAYMENT_METHOD_BANKRUPT = 3;

void AstralDebug(string sDebug)
{
	SendMessageToPC(GetFirstPC(), "<COLOR=RED>DEBUG: " + sDebug);
}

object GetAstralShipObject()
{
	object oShip = GetObjectByTag(ASTRAL_TRADER, 0);
	
	////AstralDebug("Looking for Astal Ship.  Found: " + GetTag(oShip));
	
	return oShip;
}

object GetAstralShipCaptain()
{
	object oCaptain = GetObjectByTag(ASTRAL_TRADER_CAPTAIN, 0);

	////AstralDebug("Looking for Astal Captain.  Found: " + GetTag(oCaptain));
	
	return oCaptain;
}

// Captain convo or bell call will use this to set the area object for other functions.
object GetAstralAreaObjectFromTag(string sTag)
{
	object oArea = GetFirstArea();
	
	while(GetTag(oArea) != sTag && oArea != OBJECT_INVALID)
	{
		//AstralDebug("Looking for area: " + sTag + " found: <COLOR=YELLOW>" + GetTag(oArea));
		oArea = GetNextArea();
	}
	
	//AstralDebug("Looking for area with tag = " + sTag + ". Found " + GetTag(oArea));
	
	return oArea;
}

int GetIsAstralShipDocked()
{
	object oShip = GetAstralShipObject();
	if (GetLocalInt(oShip, "DOCKED_STATUS") == SHIP_DOCKED)
	{
		//AstralDebug("Checking Docked Status.  Ship Docked");
		return 1;
	}
	else
	{
		//AstralDebug("Checking Docked Status.  Ship NOT Docked");
		return 0;
	}
}

// SHIP_DOCKED = 1, SHIP_UNDOCKED = 0
void SetAstralShipDockedStatus(int iStatus)
{
	object oShip = GetAstralShipObject();
	SetLocalInt(oShip, "DOCKED_STATUS", iStatus);
}

// Function may not be needed, as we seek the object based on location of PC or other...
object GetAstralShipDockedArea()
{
	object oShip = GetAstralShipObject();
	object oArea = GetLocalObject(oShip, "DOCKED_AREA_OBJECT");
	
	//AstralDebug("Checking for docked area from local var. Ship docked area tag (from object) is: " + GetTag(oArea));
	
	return oArea;
}

// when destinations are added to the queue this should be used to handle where it is docked.
void SetAstralShipDockedArea(object oArea)
{
	object oShip = GetAstralShipObject();
	
	SetLocalObject(oShip, "DOCKED_AREA_OBJECT", oArea);
}
 
// Tests to see if a particular numbered queue entry exists.
int CheckSpecificAstralQueueExists(int iPos)
{
	object oShip = GetAstralShipObject();
	object oDest = GetLocalObject(oShip, ASTRAL_QUEUE_DESTINATION + IntToString(iPos));
	
	//AstralDebug("Checking variable <COLOR=WHITE>" + ASTRAL_QUEUE_DESTINATION + IntToString(iPos) + "<COLOR=RED> to see if destination already exists.  Found: " + GetTag(oDest));
	
	if (oDest == OBJECT_INVALID)
	{
		//AstralDebug("Checking to see if destination already exists. <COLOR=YELLOW>NOT FOUND.. but could be ok");
		return 0;
	}
	else
	{
		//AstralDebug("Checking to see if destination already exists. <COLOR=YELLOW>FOUND: " + GetTag(oDest));
		return 1;
	}
}

int GetCurrentAstralQueueLength()
{
	int iCounter = 1;

	while(CheckSpecificAstralQueueExists(iCounter) == 1)
	{
		iCounter++;
	}
	
	//AstralDebug("Checking current queue length. Queue length is: <COLOR=WHITE>" + IntToString(iCounter - 1));
	
	return iCounter - 1; //because the loop will fail on queue length + 1.
}

string AstralTimeToString(int iTime)
{
	int iHour;
	int iMin;
	int iSec;
	string sTime;
	
	iHour = iTime / (60 * 60);
	iMin = (iTime - (iHour * 60 * 60)) / 60;
	iSec = iTime - (iHour * 60 * 60) - (iMin * 60);
	
	if (iHour == 1)
		sTime = "1 Hour, ";
	else if (iHour > 1)
		sTime = IntToString(iHour) + " Hours, ";
	
	if (iMin == 1)
		sTime = sTime + "1 Minute, ";
	else if (iMin > 1)
		sTime = sTime + IntToString(iMin) + " Minutes, ";
		
	if (sTime != "")
		sTime = sTime + "and ";
	
	if (iSec == 1)
		sTime = sTime + "1 Second.";
	else
		sTime = sTime + IntToString(iSec) + " Seconds";
	
	//AstralDebug("Time being converted is: " + IntToString(iTime) + " Which converts to " + sTime);
		
	return sTime;
}

int AstralTimeStamp()
{
	int iCurrentTime = GetTimeHour() * 60 * 60 + GetTimeMinute() * 60 + GetTimeSecond();
	
	return iCurrentTime;
}

// iTime is likely to be a destination timestamp and greater than existing time unless we have (will have)
// midnight wrap around.
int AstralTimeStampDiff(int iTime)
{
	int iCurrentTime = AstralTimeStamp();
	int iTimeDiff;
	
	if (iCurrentTime > iTime)
	{
		iTimeDiff = (iTime + SECONDS_IN_DAY) - iCurrentTime;
		////AstralDebug("Comparing two times. Time in is: " + AstralTimeToString(iTime) + " and Current Time is: " + AstralTimeToString(iTime) + " and difference is " + AstralTimeToString(iTimeDiff));
		return iTimeDiff;
	}
	else
	{
		iTimeDiff = iTime - iCurrentTime;
		////AstralDebug("Comparing two times. Time in is: " + AstralTimeToString(iTime) + " and Current Time is: " + AstralTimeToString(iTime) + " and difference is " + AstralTimeToString(iTimeDiff));
		return iTimeDiff;
	}
}

int GetAstralDestinationTimeStamp(int iPos)
{
	object oShip = GetAstralShipObject();
	int iTimeStamp = GetLocalInt(oShip, ASTRAL_QUEUE_TIMESTAMP + IntToString(iPos));
	////AstralDebug("Getting time stamp for position " + IntToString(iPos) + " value is: " + AstralTimeToString(iTimeStamp));
	return iTimeStamp;
}


// Function is probably only going to be called from the Add to Queue function and iPos is always
// going to be the length of queue plus the 1 being added.
void SetAstralDestinationTimeStamp(int iPos)
{
	object oShip = GetAstralShipObject();
	int iCount;
	int iTimeTotal = 0;
	
	if (iPos > 1)
	{
		// Get the timestamp of the last existing destination and add the stay duration.
		// Which gives us the time it will leave.
		iTimeTotal = GetAstralDestinationTimeStamp(iPos - 1) - AstralTimeStamp();
		
		// Just a sanity check...
		if (iTimeTotal > 0 - ASTRAL_TRAVEL_STAY)
			iTimeTotal = iTimeTotal + ASTRAL_TRAVEL_STAY;
		else
			iTimeTotal = 1;
	}
	
	// Now to add travel time regardless of whether other desitnation exists.
	iTimeTotal = iTimeTotal + ASTRAL_TRAVEL_DURATION;
	
	iTimeTotal = iTimeTotal + AstralTimeStamp();
	
	if (iTimeTotal > SECONDS_IN_DAY)
		iTimeTotal = iTimeTotal - SECONDS_IN_DAY;
	
	////AstralDebug("Setting time to destination <COLOR=GREEN>" + IntToString(iPos) + " to <COLOR=YELLOW>" + AstralTimeToString(iTimeTotal) + " <COLOR=RED>and current time is " + AstralTimeToString(AstralTimeStamp()));
		
	SetLocalInt(oShip, ASTRAL_QUEUE_TIMESTAMP + IntToString(iPos), iTimeTotal);
}

// Return 0 if destination not in queue, otherwise the position of the entry.
int CheckAstralShipQueueForDestination(object oDestination)
{
	object oShip = GetAstralShipObject();
	int iQueueSize;
	int iCounter = 1;
	
	iQueueSize = GetCurrentAstralQueueLength();
	
	if (iQueueSize == 0)
	{
		//AstralDebug("Checking queue for destination, no queue, returning false <COLOR=WHITE>(0)");
		return 0;
	}
	else
	{
		while (iCounter <= iQueueSize)
		{
			if (GetLocalObject(oShip, ASTRAL_QUEUE_DESTINATION + IntToString(iCounter)) == oDestination)
			{
				//AstralDebug("Checking queue for destination, found match for tag: " + GetTag(oDestination) + " in position: <COLOR=GREEN>" + IntToString(iCounter));
				return iCounter;
			}
			
			iCounter++;
		}
		//AstralDebug("Checking queue for destination, iqueuesize = <COLOR=WHITE>" + IntToString(iQueueSize) + " returning false (0)");
		return 0;
	}
}

// Removes the first entry from the queue and shuffles the rest down.
void RemoveFromAstralShipQueue()
{
	object oShip = GetAstralShipObject();
	int iQueueSize = GetCurrentAstralQueueLength();
	int iCurrentPos = 1;
	
	if (iQueueSize > 0)
	{
		while (iCurrentPos < iQueueSize + 1)
		{
			SetLocalObject(oShip, ASTRAL_QUEUE_DESTINATION + IntToString(iCurrentPos), 
				GetLocalObject(oShip, ASTRAL_QUEUE_DESTINATION + IntToString(iCurrentPos + 1)));
			SetLocalInt(oShip, ASTRAL_QUEUE_TIMESTAMP + IntToString(iCurrentPos), 
				GetLocalInt(oShip, ASTRAL_QUEUE_TIMESTAMP + IntToString(iCurrentPos + 1)));	
			iCurrentPos++;
		}
		DeleteLocalObject(oShip, ASTRAL_QUEUE_DESTINATION + IntToString(iCurrentPos));
		DeleteLocalInt(oShip, ASTRAL_QUEUE_TIMESTAMP + IntToString(iCurrentPos));
	}
	//AstralDebug("Removing last entry from queue. Queue size was: " + IntToString(iQueueSize) + ". Size now: " + IntToString(GetCurrentAstralQueueLength()));
}

// was going to use the captain for announcements, but has he can be cleaned up, went for a placeable
// which of course needs adding to the ship deck.
object GetAstralShipAnnounceObject()
{
	object oAnnounce = GetObjectByTag(ASTRAL_TRADER_ANNOUNCER, 0);
	//AstralDebug("Looking for Announce object. Found: " + GetTag(oAnnounce));
	return oAnnounce;
}

// Gets the (hopefully) unique object with specified tag from area
object GetAstralObjectByTagFromArea(object oArea, string sTag)
{
	object oObject = GetFirstObjectInArea(oArea);
	
	while(GetTag(oObject) != sTag && oObject != OBJECT_INVALID)
	{
		oObject = GetNextObjectInArea(oArea);
	}
	
	//AstralDebug("Looking for specific tag: " + sTag + " in Area: " + GetTag(oArea) + ". Found: " + GetTag(oObject));
	
	return oObject;
}

void AstralAnnounce(object oAnnouncer, int iWhen, string sWhere, string sWhat)
{
	////AstralDebug("Making announcement via " + GetTag(oAnnouncer));
	if (iWhen == 0)
		AssignCommand(oAnnouncer, SpeakString(sWhat + " " + sWhere));
	else
		AssignCommand(oAnnouncer, SpeakString(AstralTimeToString(iWhen) + " " + sWhat + " " + sWhere));
}

void AstralArrival(object oDestination)
{
	object oShipWP = GetAstralObjectByTagFromArea(oDestination, ASTRAL_SHIP_WP);
	location lShipWP = GetLocation(oShipWP);
	object oPlankWP = GetAstralObjectByTagFromArea(oDestination, ASTRAL_AREA_PLANK_WP);
	location lPlankWP = GetLocation(oPlankWP);
	
	////AstralDebug("Creating ship at location: " + GetTag(oShipWP) + " in Area: " + GetTag(oDestination) + " and setting tag to: astral_ship" + ObjectToString(oDestination));
	CreateObject(OBJECT_TYPE_PLACEABLE, ASTRAL_TRADER_RESREF, lShipWP, TRUE, "astral_ship" + ObjectToString(oDestination));
	CreateObject(OBJECT_TYPE_PLACEABLE, ASTRAL_AREA_PLANK_RESREF, lPlankWP, TRUE, "astral_plank" + ObjectToString(oDestination));

	SetAstralShipDockedStatus(SHIP_DOCKED);
	SetAstralShipDockedArea(oDestination);
}

void AstralDeparture(object oDestination)
{
	object oShipCopy = GetObjectByTag("astral_ship" + ObjectToString(oDestination), 0);
	object oPlankCopy = GetObjectByTag("astral_plank" + ObjectToString(oDestination), 0);
	
	SetAstralShipDockedStatus(SHIP_UNDOCKED);
	SetAstralShipDockedArea(OBJECT_INVALID);
	RemoveFromAstralShipQueue();
	////AstralDebug("Trying to destroy: " + GetTag(oShipCopy));
	DestroyObject(oPlankCopy, 1.0, FALSE);
	DestroyObject(oShipCopy, 1.0, FALSE);
}

void AddToAstralShipQueue(object oDestination)
{
	int iPosition = GetCurrentAstralQueueLength() + 1;
	object oShip = GetAstralShipObject();
	object oShipAnnounce = GetAstralShipAnnounceObject();
	object oBell = GetAstralObjectByTagFromArea(oDestination, ASTRAL_BELL_TAG);
	string sAreaName = GetName(oDestination);
	
	SetLocalObject(oShip, ASTRAL_QUEUE_DESTINATION + IntToString(iPosition), oDestination);
	SetAstralDestinationTimeStamp(iPosition);
	
	int iDelay = AstralTimeStampDiff(GetAstralDestinationTimeStamp(iPosition));
	float fDelay = IntToFloat(iDelay);
	
	//AstralDebug("Adding to queue in position <COLOR=GREEN>" + IntToString(iPosition) + " <COLOR=RED>and delaying actions with common iDelay of " + AstralTimeToString(iDelay));
	////AstralDebug("Current queue entries look like this...");
	////AstralDebug("<COLOR=ORANGE>Queue 0: Destination = " + GetTag(GetLocalObject(oShip, ASTRAL_QUEUE_DESTINATION + "0" + " - Should not exist!!!")));
	////AstralDebug("<COLOR=ORANGE>Queue 1: Destination = " + GetTag(GetLocalObject(oShip, ASTRAL_QUEUE_DESTINATION + "1")));
	////AstralDebug("<COLOR=ORANGE>Queue 2: Destination = " + GetTag(GetLocalObject(oShip, ASTRAL_QUEUE_DESTINATION + "2")));
	////AstralDebug("<COLOR=ORANGE>Queue 3: Destination = " + GetTag(GetLocalObject(oShip, ASTRAL_QUEUE_DESTINATION + "3")));

	DelayCommand(fDelay - IntToFloat(ASTRAL_TRAVEL_ETA_ANNOUNCE1), 
		AstralAnnounce(oShipAnnounce, ASTRAL_TRAVEL_ETA_ANNOUNCE1, sAreaName, "until ship arrives at"));
	DelayCommand(fDelay - IntToFloat(ASTRAL_TRAVEL_ETA_ANNOUNCE1), 
		AstralAnnounce(oBell, ASTRAL_TRAVEL_ETA_ANNOUNCE1, sAreaName, "until ship arrives at"));
	
	DelayCommand(fDelay - IntToFloat(ASTRAL_TRAVEL_ETA_ANNOUNCE2), 
		AstralAnnounce(oShipAnnounce, ASTRAL_TRAVEL_ETA_ANNOUNCE2, sAreaName, "until ship arrives at"));
	DelayCommand(fDelay - IntToFloat(ASTRAL_TRAVEL_ETA_ANNOUNCE2), 
		AstralAnnounce(oBell, ASTRAL_TRAVEL_ETA_ANNOUNCE2, sAreaName, "until ship arrives at"));
	
	DelayCommand(fDelay, AstralAnnounce(oShipAnnounce, 0, sAreaName, "The ship has arrived at"));
	DelayCommand(fDelay, AstralAnnounce(oBell, 0, sAreaName, "The ship has arrived at"));
	DelayCommand(fDelay, AstralArrival(oDestination));
	
	DelayCommand(fDelay + IntToFloat(ASTRAL_TRAVEL_STAY) - IntToFloat(ASTRAL_TRAVEL_DEPART_ANNOUNCE), 
		AstralAnnounce(oShipAnnounce, ASTRAL_TRAVEL_ETA_ANNOUNCE2, sAreaName, "until ship departs from"));
	DelayCommand(fDelay + IntToFloat(ASTRAL_TRAVEL_STAY) - IntToFloat(ASTRAL_TRAVEL_DEPART_ANNOUNCE), 
		AstralAnnounce(oBell, ASTRAL_TRAVEL_ETA_ANNOUNCE2, sAreaName, "until ship departs from"));
	
	DelayCommand(fDelay + IntToFloat(ASTRAL_TRAVEL_STAY), 
		AstralAnnounce(oShipAnnounce, 0, sAreaName, "The ship is now departing"));
	DelayCommand(fDelay + IntToFloat(ASTRAL_TRAVEL_STAY), 
		AstralAnnounce(oBell, 0, sAreaName, "The ship is now departing"));	
	DelayCommand(fDelay + IntToFloat(ASTRAL_TRAVEL_STAY), 
		AstralDeparture(oDestination));
}


// This function has to look at the existing queue, calculate the appropriate delay and set the sequence of commands.
// Perhaps need several functions for this to call in sequence with appropriate delays.
// As will be called from ga script from convo only, pass the captain object.
void AstralShipDestinationRequest(object oDestination, object oPC, int iRequestSourceLocation)
{
	int iDestExists = CheckAstralShipQueueForDestination(oDestination);
	int iETA;
	string sETA;
	int iNewPost;
	
	object oCaptain = GetAstralShipCaptain();
	object oBell = GetAstralObjectByTagFromArea(oDestination, ASTRAL_BELL_TAG);
	
	if (iDestExists == 0) // Not in queue
	{
		AddToAstralShipQueue(oDestination);
		// just added to queue, so equals current length of queue.
		int iNewPos = GetCurrentAstralQueueLength();
		iETA = AstralTimeStampDiff(GetAstralDestinationTimeStamp(iNewPos));
		sETA = AstralTimeToString(iETA);
		//AstralDebug("Found no destination of " + GetTag(oDestination) + " already in the queue, so adding it with timestamp of " + sETA + " in position <COLOR=GREEN>" + IntToString(iNewPos));
		
		if (iRequestSourceLocation == REQUEST_SOURCE_LOCATION_DECK)
		{
			AssignCommand(oCaptain, ClearAllActions(TRUE));
			if (iNewPos == 1)
			{
				AssignCommand(oCaptain, ActionSpeakString("Ye be in luck, we can set sail for " + 
					GetName(oDestination) + " right now.  MAKE SAIL!", TALKVOLUME_TALK));
			}
			else
			{
				AssignCommand(oCaptain, ActionSpeakString("As ye will, we can set sail for " + 
					GetName(oDestination) + " after we have made our way to other rocks. Don't ye fret, we be there in " + 
					sETA, TALKVOLUME_TALK));
			}
		}
		else
		{
			if (iNewPos == 1)
			{
				AssignCommand(oBell, 
					SpeakString("*A deep sonorous tone rings from the bell, and underneath it all you can hear mystical words* A ship has been signalled. It is on its way and should arrive soon.", TALKVOLUME_TALK));
			}
			else
			{
				AssignCommand(oBell, 
					SpeakString("*A deep sonorous tone rings from the bell, and underneath it all you can hear mystical words* A ship has been signalled. It may be a while before it arrives.", TALKVOLUME_TALK));
			}
		}
	}
	else // already in queue
	{
		iETA = AstralTimeStampDiff(GetAstralDestinationTimeStamp(iDestExists));
		sETA = AstralTimeToString(iETA);
		//AstralDebug("Found existing destination in queue with an ETA of " + sETA);
		if (iRequestSourceLocation == REQUEST_SOURCE_LOCATION_DECK)
		{
			AssignCommand(oCaptain, ClearAllActions(TRUE));
			AssignCommand(oCaptain, SpeakString("Aye, ye be in luck, we already be heading there and will be arriving in " + sETA + ". Precisely!", TALKVOLUME_TALK));
		}
		else
		{
			if (iETA < ASTRAL_TRAVEL_STAY)
				AssignCommand(oBell, SpeakString("*A deep sonorous tone rings from the bell, and underneath it all you can hear mystical words* A ship has been signalled. The wait should not be long.", TALKVOLUME_TALK));
			else if (iETA < ASTRAL_TRAVEL_DURATION +  ASTRAL_TRAVEL_STAY)
				AssignCommand(oBell, SpeakString("*A deep sonorous tone rings from the bell, and underneath it all you can hear mystical words* A ship has been signalled. The wait should be bearable.", TALKVOLUME_TALK));
			else
				AssignCommand(oBell, SpeakString("*A deep sonorous tone rings from the bell, and underneath it all you can hear mystical words* A ship has been signalled. You may have to wait a while!", TALKVOLUME_TALK));
		}
	}
}

void CallAstralShip(object oPC)
{
	// first check to see if destination is already in the queue and if not add to queue (probably need to
	// return a value as well - type INT, success/fail
	
	object oDestinationArea = GetArea(oPC);
	
	if  (GetAstralShipDockedArea() == oDestinationArea)
		{
			//AstralDebug("Calling for ship to " + GetTag(oDestinationArea) + " but its already here.");
			FloatingTextStringOnCreature("The ship stands ready to be boarded. Use the plank to board." , oPC, TRUE, 5.0);
		}
	else
		{
			//AstralDebug("Calling for ship to " + GetTag(oDestinationArea) + " so calling it (assuming not already in queue).");
			AstralShipDestinationRequest(oDestinationArea, oPC, REQUEST_SOURCE_LOCATION_AREA);
		}
}

// oTransition is the object used to transition
void DisembarkAstralShip(object oPC)
{
	if (GetIsAstralShipDocked() == 1)
	{
		location oDestinationLocation = GetLocation(GetAstralObjectByTagFromArea(GetAstralShipDockedArea(), ASTRAL_AREA_ARRIVAL_WP));
		//AstralDebug("Trying to disembark.  Ship is already docked at: " + GetTag(GetAstralShipDockedArea()) + " and trying to jump to: " + GetTag(GetAstralObjectByTagFromArea(GetAstralShipDockedArea(), ASTRAL_AREA_ARRIVAL_WP)));
		AssignCommand(oPC, ClearAllActions());
		AssignCommand(oPC, JumpToLocation(oDestinationLocation));
	}
	else
	{
		//AstralDebug("Trying to leave ship.  Ship is not docked");
		FloatingTextStringOnCreature("The ship is currently not docked. It would be dangerous to disembark into the void." , oPC, TRUE, 5.0);
	}
}

void BoardAstralShip(object oPC)
{
	if (GetIsAstralShipDocked() == 1)
	{
		location oDestinationLocation = GetLocation(GetObjectByTag(ASTRAL_DECK_ARRIVAL_WP, 0));
		//AstralDebug("Trying to board ship.  Ship is docked at: " + GetTag(GetAstralShipDockedArea()) + " and trying to jump to: " + GetTag(GetObjectByTag(ASTRAL_DECK_ARRIVAL_WP, 0)));
		AssignCommand(oPC, ClearAllActions());
		AssignCommand(oPC, JumpToLocation(oDestinationLocation));
	}
	else
	{
		//AstralDebug("Trying to board ship, but ship is not currently docked");
		FloatingTextStringOnCreature("No ship is currently docked. It would be dangerous to jump off into the void." , oPC, TRUE, 5.0);
	}
}

// Remember with payments, always possible to return to Lord of Trades (or whatever the dead god is called)
// for whatever jink you have left.
int AstralCheckForGold(object oPC)
{
	if (GetGold(oPC) >= PAYMENT_PRICE_GOLD)
		return 1;
	else
		return 0;
}

object AstralCheckForPlanarCoin(object oPC, string sTag)
{
	object oCoin;
	object oItem = GetFirstItemInInventory(oPC);
	int iBreakLoop = 0;
	
   	while(GetIsObjectValid(oItem) && iBreakLoop == 0)
   	{
		// Check each item scanned to see if it is a Merkhant Belt
		if (GetTag(oItem) == PAYMENT_TYPE_PLANAR_COIN)
		{
			oCoin = oItem;
			iBreakLoop = 1;	
		}
 		oItem = GetNextItemInInventory(oPC);
   	}
	
	return oCoin;
}

int AstralCheckForTravelPrice(object oPC)
{
	int iHasGold = AstralCheckForGold(oPC);
	object oCoin = AstralCheckForPlanarCoin(oPC, PAYMENT_TYPE_PLANAR_COIN);
	
	if (iHasGold == 1)
		return 1;
	else if (oCoin != OBJECT_INVALID)
		return 1;
	else
		return 0;
}

int AstralMakeTravelPayment(object oPC, int iPaymentMethod)
{
	object oCaptain = GetAstralShipCaptain();
	int iPaymentSuccess = 0;
	
	if (iPaymentMethod == PAYMENT_METHOD_PLANAR_COIN)
	{
		object oCoin = AstralCheckForPlanarCoin(oPC, PAYMENT_TYPE_PLANAR_COIN);
		
		if (oCoin != OBJECT_INVALID)
		{
			int iSize = GetItemStackSize(oCoin);
			if (iSize > 1)
				SetItemStackSize(oCoin, iSize - 1, TRUE);
			else
				DestroyObject(oCoin, 0.0, TRUE);
				
			iPaymentSuccess = 1;
		}
		else
		{
			AssignCommand(oCaptain, ClearAllActions(TRUE));
			AssignCommand(oCaptain, SpeakString("Ey! What you trying to pull here? No cogs? Ill be putting yer name in the dead book!", TALKVOLUME_TALK));
		}
	}
	else if (iPaymentMethod == PAYMENT_METHOD_GOLD)
	{
		if (AstralCheckForGold(oPC) == 1)
		{
			AssignCommand(oCaptain, ClearAllActions(TRUE));
			AssignCommand(oCaptain, TakeGoldFromCreature(PAYMENT_PRICE_GOLD, oPC, TRUE, TRUE));
			iPaymentSuccess = 1;
		}
		else
		{
			AssignCommand(oCaptain, ClearAllActions(TRUE));
			AssignCommand(oCaptain, SpeakString("Ey! What you trying to pull here? No jink? Ill be putting yer name in the dead book!", TALKVOLUME_TALK));	
		}
	}
	else // PAYMENT_METHOD_BANKRUPT
	{
		AssignCommand(oCaptain, ClearAllActions(TRUE));
		AssignCommand(oCaptain, TakeGoldFromCreature(PAYMENT_PRICE_GOLD, oPC, TRUE, TRUE));
		iPaymentSuccess = 1; // reports success because agreed to take whatever gold for return to dead god area
	}
	
	return iPaymentSuccess;
}