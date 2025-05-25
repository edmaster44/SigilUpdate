

void main () {

	if (GetLocalInt(OBJECT_SELF, "STOP_ANIMATION"))
		return;

	string anim = GetLocalString(OBJECT_SELF, "ANIMATION");
	if (anim != "")
		PlayCustomAnimation(OBJECT_SELF, anim, TRUE);
		
	string sSound = GetLocalString(OBJECT_SELF, "SOUND");
	if (d100() < 50) {
		PlaySound(sSound, FALSE);
	}

}