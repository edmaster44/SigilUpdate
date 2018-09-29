void main () {

string anim = GetLocalString(OBJECT_SELF, "ANIMATION");
float speed = GetLocalFloat(OBJECT_SELF, "ANIMATION_SPEED");
if (anim != "")
 PlayCustomAnimation(OBJECT_SELF, anim, FALSE, speed);

}