

#include "shinn_sava_inc"

void main () {

	object oPC = GetLastUsedBy();
	
	SendMessageToPC(oPC, "start chess!");
	
	object oHub = GetNearestObjectByTag("sava_game_hub", OBJECT_SELF);
	
	if(oHub == OBJECT_INVALID) {
		SendMessageToPC(oPC, "No hub object present in area.");
		return;	
	}
	
	int PlayerSeat = GetLocalInt(OBJECT_SELF, "Player");
	
	if(PlayerSeat == 0) {
		SendMessageToPC(oPC, "No player variable set.");
		return;
	}
	
	SetLocalObject(oHub, "PLR_"+IntToString(PlayerSeat),oPC);
	SetLocalObject(oPC, "GAME_HUB", oHub);
	SetLocalInt(oPC, "GAME_SEAT", PlayerSeat);
	
	SetUseableFlag(OBJECT_SELF, FALSE);
	
	DisplayGuiScreen(oPC,"SAVA_MAIN",FALSE,"sava_main_screen.XML",FALSE);
	
}