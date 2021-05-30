#include "ps_inc_time"
void main() {

	object oPC = OBJECT_SELF;
	object oOOCWP = GetWaypointByTag("wp_ooc_portal_destination");
	
	SendMessageToPC(oPC, "teleporting to OOC room");
	PS_Timestamp_UNIX(oPC, "LAST_OOC_PORTAL");
	AssignCommand(oPC, JumpToObject(oOOCWP));
	SetGUITexture(oPC, "SCREEN_DMFI_PLAYER", "OOCPORTAL", "dmfi_icon_oocportal_disabled.tga");

}