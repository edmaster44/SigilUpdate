#include "ff_safevar"

//////////////////////////////////////////////////////////////////////
// ps_golem_death													//
// Created by Ceremorph for Sigil:City of Doors persistant world	//
// July 19, 2015, Reviewed by Clangeddin 28/12/2017												//
//////////////////////////////////////////////////////////////////////
// if a golem dies in combat, its control device is destroyed. 

void main()
{
    //Declare major variables
    object oGolem = OBJECT_SELF;
	object oPC = GetMaster(oGolem);
	object oKiller = GetLastKiller();
	string sName = GetName(oGolem);
	string sMSG = "Your " + sName + " collapses to the ground and deactivates itself.";
	//string sSPEAK = "Heavily damaged, the golem drops to the ground and deactivates itself.";
	
	//does not destroy the device if golem is killed by another golem or player
	object oDevice = PS_GetLocalObject(oGolem, "ControlObject");
	if (oDevice == OBJECT_INVALID)
	{
		SendMessageToPC(oPC, sMSG);
		ExecuteScript("nw_c2_default7", oGolem);
		return;
	}
	if (GetIsPC(oKiller) == TRUE)
	{
		SendMessageToPC(oPC, sMSG);
		ExecuteScript("nw_c2_default7", oGolem);
		return;
	}
	if (GetIsOwnedByPlayer(oKiller) == TRUE)
	{
		SendMessageToPC(oPC, sMSG);
		ExecuteScript("nw_c2_default7", oGolem);
		return;
	}
	if (GetHasFeat(2806, oPC, TRUE) == TRUE) //Golem Master with Abiding Masterwork does not lose their golem control device.
	{
		SendMessageToPC(oPC, sMSG);
		ExecuteScript("nw_c2_default7", oGolem);
		return;
	}				
	if (GetSubRace(oKiller) == 25)
	{
		
		SendMessageToPC(oPC, sMSG);
		ExecuteScript("nw_c2_default7", oGolem);
		return;				
	}
	else
	{
		DestroyObject(oDevice);
		sMSG = "As your " + sName + " is destroyed, its control device crumbles to dust";
		//sSPEAK = "The golem drops to the ground and is utterly destroyed";
		return;
	}
}