#include "ff_safevar"

#include "gm_include"
#include "dmfi_inc_inc_com"

void main () {
	object oPC = GetEnteringObject();
	//House never did what I wanted it to. Boo!
	/*if (PS_GetLocalInt(oPC, "gambling") == 0) {
		int nAmt = GetHouse();
		SetHouse(nAmt+50000);
		PS_SetLocalInt(oPC, "gambling", 1);
	}*/
	
	//DMFI_GetNetWorth
	if (PS_GetLocalInt(oPC, "fw_mynetworth") > 0)
		return;
	PS_SetLocalInt(oPC, "fw_mynetworth", 999999999);
	int nGold = DMFI_GetNetWorth(oPC);
	PS_SetLocalInt(oPC, "fw_mynetworth", nGold);
	
}