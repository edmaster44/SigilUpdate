

/* Script Created by Agony_Aunt/Loki for SCoD PW. Waiter who can be summoned to provide refreshments for a party*/

#include "x0_i0_position"
#include "nw_i0_generic"

const int WAITER_ACTION_WALK_TO_CLIENT = 1;
const int WAITER_ACTION_SPEAK_TO_CLIENT = 2;
const int WAITER_ACTION_WAIT = 3;
const int WAITER_ACTION_RETURN_TO_BAR = 4;
const int WAITER_IN_CONVO = 5;

const int WAITER_ACTIVE = 1;
const int WAITER_INACTIVE = 2;

const float WAITER_RADIUS = RADIUS_SIZE_COLOSSAL;

/* Waiter types - for speaking (var on template - WaiterType) must be: poshmale, poshfemale, or hiver
if new types are required then need to modify script */
void WaiterSpeakToClient(object oWaiter, object oClient)
{
	// random speech
	int iClientGender = GetGender(oClient);
	string sClientGender;
	int iWaiterGender = GetGender(oWaiter);
	string sWaiterType = GetLocalString(oWaiter, "WaiterType");
	string sSpeak;
	int iTalkVolume = TALKVOLUME_TALK;
	int iRoll;
	
	if (sWaiterType == "poshmale")
	{
		sClientGender = iClientGender == GENDER_MALE?"Sir":iClientGender == GENDER_FEMALE?"Madam":"oneself";
		
		iRoll = Random(5) + 1;
		
		switch(iRoll)
		{
			case 1: sSpeak = "Would " + sClientGender + " be needing anything?"; break;
			case 2: sSpeak = "A bottle of Enigma would surely show everyone you are a person of culture " + sClientGender + "."; break;
			case 3: sSpeak = sClientGender + " is in need of anything?";
			case 4:
					sSpeak = "*discretely whispers* " + sClientGender + " appears to have spilled some food on their clothes. *offers a napkin*";
					iTalkVolume = TALKVOLUME_WHISPER;
					break;
			case 5: sSpeak = "If i may be so bold " + sClientGender + ", may I recommend the Thalasias White? A very fine year."; break;
			default: sSpeak = "*polite cough*"; break;
		}
	}
	else if (sWaiterType == "poshfemale")
	{
		sClientGender = iClientGender == GENDER_MALE?"Sir":iClientGender == GENDER_FEMALE?"Madam":"oneself";
		
		iRoll = Random(5) + 1;
		
		switch(iRoll)
		{
			case 1: sSpeak = "Can i get " + sClientGender + " something to eat or drink?"; break;
			case 2: sSpeak = "Can i refresh your nuts " + sClientGender + "?"; break;
			case 3: sSpeak = "Can i get " + sClientGender + " something to eat or drink?"; break;
			case 4:
				sSpeak = "*discretely whispers* " + "Looks like you spilled some drink on yourself. *offers a napkin*";
				iTalkVolume = TALKVOLUME_WHISPER;
				break;
			case 5: sSpeak = "Please good " + sClientGender + ". The Amorian Red is today's special and is of especially fine vintage."; break;
			default: sSpeak = "*polite cough*"; break;
		}
	}
	else if (sWaiterType == "hiver")
	{
		iRoll = Random(5) + 1;
		
		switch(iRoll)
		{
			case 1: sSpeak = "Sausage inna bun! Get 'em while they're hot!"; break;
			case 2: sSpeak = "Grilled rat Guvner?"; break;
			case 3: sSpeak = "Ye've got some crud on yer clothes Guv. *offers a dirty rag to clean it with*"; break;
			case 4: sSpeak = "*spits on the floor* I cooked everything meself, so ye can be sure its good stuff! That's Cookie knows nowt about good food!"; break;
			case 5:
				sSpeak = "*discretely whispers* " + "Spare a copper Guvner for an old Goblin down on his luck?";
				iTalkVolume = TALKVOLUME_WHISPER;
				break;
			default: sSpeak = "*horrible cough*"; break;
		}
	}
	else
	{
		sSpeak = "Can i get you anything?";
	}
	
	SpeakString(sSpeak, iTalkVolume);
}

void WaiterMoveToClient(object oWaiter, object oTarget)
{	
	AssignCommand(oWaiter, ClearAllActions(TRUE));
	AssignCommand(oWaiter, ActionMoveToObject(oTarget, FALSE, 1.5));
}

void WaiterMoveToBar(object oWaiter)
{	
	AssignCommand(oWaiter, ClearAllActions(TRUE));
	AssignCommand(oWaiter, ActionMoveToLocation(GetLocalLocation(oWaiter, "BarLocation"), FALSE));
}

object WaiterSelectClientInLocalArea()
{
	location lSpawnLocation = GetLocalLocation(OBJECT_SELF, "SpawnLocation");
	object oLastClient = GetLocalObject(OBJECT_SELF, "LastClient");
	
	/*if (GetArea(OBJECT_SELF) != GetAreaFromLocation(lSpawnLocation))
	{
		SendMessageToPC(GetLocalObject(OBJECT_SELF, "Owner"), "Your waiter has somehow left their service area and is trying to serve clients. Please speak to it and tell it to stop");
		return OBJECT_INVALID;
	}*/
	
	// first we need to count how many valid targets.
	int iNumClients = 0;
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, WAITER_RADIUS, lSpawnLocation, FALSE, OBJECT_TYPE_CREATURE);
	object oOwner = GetLocalObject(OBJECT_SELF, "Owner");
	while (oTarget != OBJECT_INVALID)
	{
		if (oTarget != oLastClient && oTarget != OBJECT_SELF)	
		{
			iNumClients += 1;
			//SendMessageToPC(oOwner, "Found " + GetName(oTarget) + " at position " + IntToString(iNumClients));
			// and now we store all object IDs of all valid clients.
			SetLocalObject(OBJECT_SELF, "ClientListEntry" + IntToString(iNumClients), oTarget);
		}
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, WAITER_RADIUS, lSpawnLocation, FALSE, OBJECT_TYPE_CREATURE);
	}
	
	if (iNumClients == 0)
	{
		return OBJECT_INVALID;
	}
	else
	{
		// pick a client at random
		oTarget = GetLocalObject(OBJECT_SELF, "ClientListEntry" + IntToString(Random(iNumClients) + 1));
		return oTarget;
	}
}