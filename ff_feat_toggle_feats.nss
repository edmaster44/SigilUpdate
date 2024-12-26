#include "ff_combat_mods"



void main(){
	object oPC = OBJECT_SELF;
	int nId = GetSpellId();
	object oEss = PS_GetEssence(oPC);
	int nAction = -1;

	if (nId ==  MODE_DEF){
		if (GetLocalInt(oEss, DEF_STATE_ON)) nAction = DEF_OFF;
		else nAction = DEF_ON;
	} else if (nId == MODE_STRIKE){
		if (GetLocalInt(oEss, STRIKE_STATE_ON)) nAction = STRIKE_OFF;
		else nAction = STRIKE_ON;
	} else if (nId == MODE_STAFF){
		if (GetLocalInt(oEss, STAFF_STATE_ON))  nAction = STAFF_OFF;
		else nAction = STAFF_ON;
	}
	UpdateCombatMods(oPC, nAction);
}


