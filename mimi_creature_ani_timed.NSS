#include "ff_safevar"

void main () {

string anim = PS_GetLocalString(OBJECT_SELF, "ANIMATION");
float speed = PS_GetLocalFloat(OBJECT_SELF, "ANIMATION_SPEED");
if (anim != "")
 PlayCustomAnimation(OBJECT_SELF, anim, FALSE, speed);

}