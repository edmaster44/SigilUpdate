//************************************************************
//ga_destroy_gracefulexit
//Makes the target walk somewhere nearby and destroy self
//More graceful than just disappearing!
//Defaults to OBJECT_SELF if no creature tag supplied
//Must be called from a conversation
//************************************************************
//If you want to have the creature move to a waypoint before disappearing, 
//use ga_move_exit
//************************************************************
#include "ps_inc_faction"
#include "ginc_param_const"
#include "ginc_var_ops"

void main(string sCreatureTag = "", int shouldRun = FALSE) {

    object oCreature = GetTarget(sCreatureTag, TARGET_OBJECT_SELF);
	object oPC = GetPCSpeaker();
	
	location lLoc = FindHenchSpawnPoint(oPC);
	
	DelayCommand(0.25f, AssignCommand(oCreature, ActionForceMoveToLocation(lLoc, shouldRun)));
	
	DestroyObject(oCreature, 1.25f);

}