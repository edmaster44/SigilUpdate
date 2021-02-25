#include "ps_inc_achievements"
void main(string sIndex) {

	object oPC = OBJECT_SELF;
	
	SendMessageToPC(oPC, "Selected: "+sIndex);
	int nIndex = StringToInt(sIndex);
	
	DisplayAchievement(oPC, nIndex);

}