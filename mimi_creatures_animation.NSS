#include "ff_safevar"

void main () {

	string anim = PS_GetLocalString(OBJECT_SELF, "ANIMATION");
	if (anim != "")
		PlayCustomAnimation(OBJECT_SELF, anim, TRUE);

}