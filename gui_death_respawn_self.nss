

//#include "ginc_death"
//#include "ps_respawn"

void main()
{
	//ResurrectCreature( OBJECT_SELF );
	//SetLocalObject(GetModule(), "LAST_RESPAWN_BUTTON_PRESSER", GetLastRespawnButtonPresser());
	//ExecuteScript("ps_respawn", GetModule());	
	//object xPC = GetLastRespawnButtonPresser();
	//respawn(GetLastRespawnButtonPresser());
	
	SetLocalObject(GetModule(), "LAST_RESPAWN_BUTTON_PRESSER", OBJECT_SELF);
	ExecuteScript("ps_respawn", GetModule());
}