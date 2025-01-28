#include "nwnx_scod_finesse"
#include "nwnx_scod_monkweapon"
#include "nwnx_scod_ac"

// these dae plugin commands didn't work if called during module load, they have to be called when the module
// is done loading and up and running. So I've called them from ps_onpcloaded but they only need to be called 
// once, not once per person logging in

void FirstLogin(){
	//object oMod = GetModule();
	
	// if we've already done this, bail
	//if (GetLocalInt(oMod, "FirstLogin")) return;
	
	EnableFinesse();
	EnableCreatureFinesse();
	EnableMonkNew();
	SetFeatAC();
	
	// show that we've done this
	//SetLocalInt(oMod, "FirstLogin", TRUE);
	
}






