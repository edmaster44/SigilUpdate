#include "ff_safevar"

void main () {

	if (PS_GetLocalInt(OBJECT_SELF, "STOP_ANIMATION"))
		return;

	string anim = PS_GetLocalString(OBJECT_SELF, "ANIMATION");
	if (anim != "")
		PlayCustomAnimation(OBJECT_SELF, anim, TRUE);
		
	string sSound = PS_GetLocalString(OBJECT_SELF, "SOUND");
	if (d100() < 50) {
		PlaySound(sSound, FALSE);
	}

}