#include "ff_safevar"


void main(int nType) {
	object oPC = ((GetPCSpeaker() == OBJECT_INVALID) ? OBJECT_SELF : GetPCSpeaker());
	PS_SetLocalInt(oPC, "SRLG_PRICE", nType);
}