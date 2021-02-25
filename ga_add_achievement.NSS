#include "ps_inc_achievements"

void main(int nAchievement) {

	object oPC = GetPCSpeaker();
	
	AddAchievement(oPC, nAchievement);

}