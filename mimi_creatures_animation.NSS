void main () {

	string anim = GetLocalString(OBJECT_SELF, "ANIMATION");
	if (anim != "")
		PlayCustomAnimation(OBJECT_SELF, anim, TRUE);

}