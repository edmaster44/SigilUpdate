#include "ff_safevar"

#include "shinn_sava_inc"

void main () {

	object oPC = GetLastUsedBy();
	
	SendMessageToPC(oPC, "start chess!");
	
	object oHub = GetNearestObjectByTag("sava_game_hub", OBJECT_SELF);
	
	if(oHub == OBJECT_INVALID) {
		SendMessageToPC(oPC, "No hub object present in area.");
		return;	
	}
	
	int PlayerSeat = PS_GetLocalInt(OBJECT_SELF, "Player");
	
	if(PlayerSeat == 0) {
		SendMessageToPC(oPC, "No player variable set.");
		return;
	}
	
	PS_SetLocalObject(oHub, "PLR_"+IntToString(PlayerSeat),oPC);
	PS_SetLocalObject(oPC, "GAME_HUB", oHub);
	PS_SetLocalInt(oPC, "GAME_SEAT", PlayerSeat);
	
	SetUseableFlag(OBJECT_SELF, FALSE);
	
	DisplayGuiScreen(oPC,"SAVA_MAIN",FALSE,"sava_main_screen.XML",FALSE);
	
}