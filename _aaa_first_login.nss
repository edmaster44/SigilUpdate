#include "ff_safevar"

#include "nwnx_scod_finesse"
#include "nwnx_scod_monkweapon"
#include "nwnx_scod_ac"

// these dae plugin commands didn't work if called during module load, they have to be called when the module
// is done loading and up and running. So I've called them from ps_onpcloaded but they only need to be called 
// once, not once per person logging in

void FirstLogin(){

	// call Dae's plugin functions
	EnableFinesse();
	EnableCreatureFinesse();
	EnableMonkNew();
	SetFeatAC();
	
	// now copy the variable set in the toolset to a local variable set on the 
	// module with fully legal variable name. If we've already done this, bail
	if (PS_GetGlobalString("X2_S_UD_SPELLSCRIPT") == "antimagic_spell_cast") return;
	PS_SetGlobalString("X2_S_UD_SPELLSCRIPT", "antimagic_spell_cast");

	
}






