#include "ff_safevar"

#include "ps_inc_gemstones"

void main (string sNum) {

	object oPC = OBJECT_SELF;
	object oGem = PS_GetLocalObject(oPC, "gemrow_"+sNum);
	PS_SetLocalObject(oPC, "selected_gem", oGem);
	UpdateSelectedGem(oPC);

}