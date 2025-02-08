#include "ff_safevar"

/*//////////////////////////////////////////////////
//Exists just in case we ever want to implement
//Some sort of check on whether or not you can
//teleport. 
//
//For instance, in the case of Dimensional Anchor. . 
//////////////////////////////////////////////////*/

//*****************************************************
//Checks for the existence of the Dimensional Achor spell
//*****************************************************
int isAnchored(object oTarget) {
	if (PS_GetLocalInt(oTarget, "DIMENSIONAL_ACHORED") &&
		GetHasSpellEffect(14520, oTarget)) { //psion's dimensional anchor spell
		return TRUE;
	}
	else
		PS_SetLocalInt(oTarget, "DIMENSIONAL_ACHORED", FALSE);
	return FALSE;
}

int GetCanTeleport(object oTarget, object oArea) {
	return isAnchored(oTarget);
}