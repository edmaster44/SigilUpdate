

#include "ps_inc_gemstones"

void main (string sNum) {

	object oPC = OBJECT_SELF;
	object oGem = GetLocalObject(oPC, "gemrow_"+sNum);
	SetLocalObject(oPC, "selected_gem", oGem);
	UpdateSelectedGem(oPC);

}