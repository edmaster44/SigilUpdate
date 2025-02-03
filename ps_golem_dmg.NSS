//gb_golem_dmg	

//Damge script for trolls, making them un-killable by anything but fire or acid.

//DBR 6/1/6
// DBR 7/12/06 - bugfix, made sure the damaged event fires even if down to 1HP.
// MDiekmann 6/28/07 - Added command to clear combat round flag so trolls will attack players after resurrecting
#include "nw_i0_generic"


void GolemDeath()
{
	object oGolem = OBJECT_SELF;
	object oPC = GetMaster(oGolem);
	object oKiller = GetLastDamager();
	string sName = GetName(oGolem);
	string sMSG = "Your " + sName + " collapses to the ground and deactivates itself.";
	//string sSPEAK = "Heavily damaged, the golem drops to the ground and deactivates itself.";
	
	//does not destroy the device if golem is killed by another golem or player
	object oDevice = GetLocalObject(oGolem, "ControlObject");
	if (oDevice == OBJECT_INVALID)
	{
		SendMessageToPC(oPC, sMSG);
	}
	if (GetIsPC(oKiller) == TRUE)
	{
		SendMessageToPC(oPC, sMSG);
	}
	if (GetIsOwnedByPlayer(oKiller) == TRUE)
	{
		SendMessageToPC(oPC, sMSG);
	}
	if (GetLocalInt(oDevice, "AbidingMasterwork") == 1) //Golem Master with Abiding Masterwork does not lose their golem control device.
	{
		SendMessageToPC(oPC, sMSG);
	}				
	if (GetSubRace(oKiller) == 25)
	{
		
		SendMessageToPC(oPC, sMSG);				
	}
	
	DestroyObject(oDevice);
	sMSG = "As your " + sName + " is destroyed, its control device crumbles to dust";
	//sSPEAK = "The golem drops to the ground and is utterly destroyed";
}

void main()
{

	//If I'm down, put out a fake "weapon ineffective" message.
	if (GetLocalInt(OBJECT_SELF,"gb_troll_dmg_down")==1)
	{
		FloatingTextStrRefOnCreature(4725,GetLastDamager(),FALSE);	
	}
	else if (GetCurrentHitPoints()<=1)//If I've been beaten down, but am not in a knocked down state, put me in one.
	{	
		int nDuration = 1;		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectKnockdown(),OBJECT_SELF,IntToFloat(nDuration));		
		SetLocalInt(OBJECT_SELF,"gb_troll_dmg_down",1);
		DelayCommand(IntToFloat(nDuration+1),GolemDeath());
		DelayCommand(IntToFloat(nDuration+2), ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDeath(),OBJECT_SELF));
		return;
	}
	//otherwise, heal 1HP so that the onDamageevent does fire again.
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(1),OBJECT_SELF);
	
	ExecuteScript("nw_c2_default6",OBJECT_SELF);
}